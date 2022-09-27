function Get-VaultItems {
    <#
    .SYNOPSIS
    Gets Bitwarden Vault Items
    
    .DESCRIPTION
    Calls /list/object/items 
    
    .PARAMETER Id
    Item guid
    
    .PARAMETER OrganizationId
    Organization Guid
    
    .PARAMETER CollectionId
    Collection Guid
    
    .PARAMETER FolderId
    Folder Guid
    
    .PARAMETER Search
    Search terms
    
    .PARAMETER Url
    Search for matching Urls
    
    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    Param(
        [Parameter(ParameterSetName = 'Single', Mandatory = $true)]
        $Id,
        [Parameter(ParameterSetName = 'Single')]
        [switch]$AsCredential,

        [Parameter(ParameterSetName = 'List')]
        $OrganizationId = '',
        [Parameter(ParameterSetName = 'List')]
        $CollectionId = '',
        [Parameter(ParameterSetName = 'List')]
        $FolderId = '',
        [Parameter(ParameterSetName = 'List')]
        $Search = '',
        [Parameter(ParameterSetName = 'List')]
        $Url = ''
    )

    switch ($PSCmdlet.ParameterSetName) {
        'List' {
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
        }
        elseif ($Request.data) {
            if ($AsCredential) {
                [securestring]$Password = ConvertTo-SecureString -String $Request.data.login.password -AsPlainText -Force
                New-Object System.Management.Automation.PSCredential ($Request.data.login.username, $Password)
            }
            else {
                $Request.data
            }
        }
    }
    else {
        Write-Host $Request.message
        $Request.success
    }
}
