function Get-BwVaultItem {
    <#
    .SYNOPSIS
    Gets Bitwarden Vault Items

    .DESCRIPTION
    Calls /list/object/items or /object/item/{id} to retrieve vault items

    .PARAMETER Id
    Item guid

    .PARAMETER AsCredential
    Returns login property as credential object

    .PARAMETER OrganizationId
    Organization Guid

    .PARAMETER Organization
    Name of organization

    .PARAMETER CollectionId
    Collection Guid

    .PARAMETER Collection
    Name of collection

    .PARAMETER FolderId
    Folder Guid

    .PARAMETER Search
    Search terms

    .PARAMETER Url
    Search for matching Urls

    .PARAMETER Trash
    Show deleted items

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Scope = 'Function')]
    [CmdletBinding(DefaultParameterSetName = 'List')]
    Param(
        [Parameter(ParameterSetName = 'Single', Mandatory = $true)]
        $Id,

        [Parameter(ParameterSetName = 'Single')]
        [switch]$AsCredential,

        [Parameter(ParameterSetName = 'List')]
        $OrganizationId = '',

        [Parameter(ParameterSetName = 'List')]
        $Organization = '',

        [Parameter(ParameterSetName = 'List')]
        $CollectionId = '',

        [Parameter(ParameterSetName = 'List')]
        $Collection,

        [Parameter(ParameterSetName = 'List')]
        $FolderId = '',

        [Parameter(ParameterSetName = 'List')]
        $Search = '',

        [Parameter(ParameterSetName = 'List')]
        $Url = '',

        [Parameter(ParameterSetName = 'List')]
        [switch]$Trash
    )

    switch ($PSCmdlet.ParameterSetName) {
        'List' {
            if ($Collection) {
                if (!$script:VaultCollections) {
                    Get-VaultCollections | Out-Null
                }
                $CollectionObj = $script:VaultCollections | Where-Object { $_.name -eq $Collection }
                $CollectionId = $CollectionObj.id
                Write-Verbose "Collection: $Collection ($CollectionId)"
            }

            if ($Organization) {
                if (!$script:VaultOrgs) {
                    Get-VaultOrgs | Out-Null
                }
                $OrgObj = $script:VaultOrgs | Where-Object { $_.name -eq $Organization }
                $OrganizationId = $OrgObj.id
                Write-Verbose "Organization: $Organization ($OrganizationId)"
            }

            $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

            $Endpoint = 'list/object/items'
            if ($Search -ne '') {
                $QueryParams.Add('search', $Search) | Out-Null
            }
            if ($OrganizationId -ne '') {
                $QueryParams.Add('organizationid', $OrganizationId) | Out-Null
            }
            if ($CollectionId -ne '') {
                $QueryParams.Add('collectionid', $CollectionId) | Out-Null
            }
            if ($FolderId -ne '') {
                $QueryParams.Add('folderid', $FolderId) | Out-Null
            }
            if ($Url -ne '') {
                $QueryParams.Add('url', $Url) | Out-Null
            }
            if ($Trash) {
                $QueryParams.Add('trash', $true) | Out-Null
            }

            $VaultApi = @{
                Endpoint    = $Endpoint
                QueryParams = $QueryParams
            }
        }
        'Single' {
            $Endpoint = 'object/item/{0}' -f $Id

            $VaultApi = @{
                Endpoint = $Endpoint
            }
        }
    }

    $Request = Invoke-VaultApi @VaultApi

    if ($Request.success) {
        if ($Request.data.data) {
            $Request.data.data
        } elseif ($Request.data) {
            if ($AsCredential) {
                [securestring]$Password = ConvertTo-SecureString -String $Request.data.login.password -AsPlainText -Force
                New-Object System.Management.Automation.PSCredential ($Request.data.login.username, $Password)
            } else {
                $Request.data
            }
        }
    } else {
        Write-Verbose $Request.message
        $Request.success
    }
}
