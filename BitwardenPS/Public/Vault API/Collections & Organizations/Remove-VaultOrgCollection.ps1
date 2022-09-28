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
        [Parameter(Mandatory = $true)]
        $Id,
        [Parameter(Mandatory = $true)]
        $OrganizationId
    )
    
    $Endpoint = 'object/org-collection/{0}' -f $Id

    $VaultApi = @{
        Method   = 'Delete'
        Endpoint = $Endpoint
    }
    
    Invoke-VaultApi @VaultApi
}
