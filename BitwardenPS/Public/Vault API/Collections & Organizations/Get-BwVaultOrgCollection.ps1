function Get-BwVaultOrgCollection {
    <#
    .SYNOPSIS
    Gets Bitwarden Vault Org Collections

    .DESCRIPTION
    Calls /list/object/org-collections or /object/org-collection/{id}

    .PARAMETER Id
    Guid of Collection

    .PARAMETER OrganizationId
    Guid of Organization

    .PARAMETER Search
    Search parameters

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    Param(
        [Parameter(ParameterSetName = 'Single', Mandatory = $true)]
        $Id,

        [Parameter(ParameterSetName = 'Single', Mandatory = $true)]
        [Parameter(ParameterSetName = 'List', Mandatory = $true)]
        $OrganizationId,

        [Parameter(ParameterSetName = 'List')]
        $Search = ''
    )

    $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    $QueryParams.Add('organizationid', $OrganizationId) | Out-Null

    switch ($PSCmdlet.ParameterSetName) {
        'List' {
            $Endpoint = 'list/object/org-collections'

            if ($Search -ne '') {
                $QueryParams.Add('search', $Search) | Out-Null
            }

        }
        'Single' {
            $Endpoint = 'object/org-collection/{0}' -f $Id
        }
    }
    $Request = Invoke-VaultApi -Endpoint $Endpoint -QueryParams $QueryParams

    if ($Request.success) {
        if ($Request.data.data) {
            $Request.data.data
        } elseif ($Request.data) {
            $Request.data
        }
    } else {
        Write-Verbose $Request.message
        $Request.success
    }
}
