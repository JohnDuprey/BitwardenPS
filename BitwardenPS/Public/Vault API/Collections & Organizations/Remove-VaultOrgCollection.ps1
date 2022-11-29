function Remove-VaultOrgCollection {
    <#
    .SYNOPSIS
    Deletes Bitwarden Org Collections Items
    
    .DESCRIPTION
    Calls DELETE /object/org-collection/{id} to move organization collections to the trash, this does not delete the items inside
    
    .PARAMETER Id
    OrgCollection guid
    
    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        $Id,
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        $OrganizationId
    )
    
    Process {
        $Endpoint = 'object/org-collection/{0}' -f $Id
        $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        $QueryParams.Add('organizationid', $OrganizationId) | Out-Null
        $VaultApi = @{
            Method      = 'Delete'
            Endpoint    = $Endpoint
            QueryParams = $QueryParams
        }
    
        Invoke-VaultApi @VaultApi
    }
}
