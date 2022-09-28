function Get-VaultOrgMembers {
    <#
    .SYNOPSIS
    Gets Bitwarden Vault Org Collections
    
    .DESCRIPTION
    Calls /list/object/org-members

    .PARAMETER OrganizationId
    Guid of Organization

    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $OrganizationId
    )

    $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    $QueryParams.Add('organizationid', $OrganizationId) | Out-Null

    $Endpoint = 'list/object/org-members'
    $Request = Invoke-VaultApi -Endpoint $Endpoint -QueryParams $QueryParams

    if ($Request.success) {
        if ($Request.data.data) {
            $Request.data.data
        }
    }
    else {
        Write-Host $Request.message
        $Request.success
    }
}
