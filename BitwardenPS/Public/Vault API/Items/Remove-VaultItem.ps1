function Remove-VaultItem {
    <#
    .SYNOPSIS
    Deletes Bitwarden Vault Items
    
    .DESCRIPTION
    Calls DELETE /object/item/{id} to move items to the trash
    
    .PARAMETER Id
    Item guid
    
    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        $Id
    )
    Process {
        $Endpoint = 'object/item/{0}' -f $Id

        $VaultApi = @{
            Method   = 'Delete'
            Endpoint = $Endpoint
        }
    
        Invoke-VaultApi @VaultApi
    }
}
