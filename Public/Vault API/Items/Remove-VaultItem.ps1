function Remove-VaultItem {
    <#
    .SYNOPSIS
    Updates Bitwarden Vault Items
    
    .DESCRIPTION
    PUT /object/item/{id} 
    
    .PARAMETER Id
    Item guid
    
    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Id
    )
    
    $Endpoint = 'object/item/{0}' -f $Id

    $VaultApi = @{
        Method   = 'Delete'
        Endpoint = $Endpoint
        Body     = $Body
    }
    
    Invoke-VaultApi @VaultApi
}
