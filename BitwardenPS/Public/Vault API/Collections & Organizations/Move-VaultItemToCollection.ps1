function Move-VaultItemToCollection {
    <#
    .SYNOPSIS
    Moves Bitwarden Vault Item to Collection
    
    .DESCRIPTION
    Calls /move/{itemid}/{organizationid} 
    
    .PARAMETER ItemId
    Guid of Item

    .PARAMETER OrganizationId
    Guid of Organization

    .PARAMETER CollectionIds
    List of CollectionIds

    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $true)]
        $ItemId,
        [Parameter(Mandatory = $true)]
        $OrganizationId,
        [Parameter(Mandatory = $true)]
        [string[]]$CollectionIds
    )

    $Endpoint = 'move/{0}/{1}' -f $ItemId, $OrganizationId
    $Body = @($CollectionIds) | ConvertTo-Json

    $VaultApi = @{
        Endpoint = $Endpoint
        Body     = $Body
        Method   = 'Post'
    }

    if ($PSCmdlet.ShouldProcess($ItemId)) {
        Invoke-VaultApi @VaultApi

        if ($Request.success) {
            $Request.data
        }
        else {
            Write-Host $Request.message
            $Request.success
        } 
    }
}
