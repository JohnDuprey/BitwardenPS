function Remove-Send {
    <#
    .SYNOPSIS
    Deletes Bitwarden Send
    
    .DESCRIPTION
    Calls DELETE /object/send/{id} to move items to the trash
    
    .PARAMETER Id
    Send guid
    
    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Id
    )
    
    $Endpoint = 'object/send/{0}' -f $Id

    $VaultApi = @{
        Method   = 'Delete'
        Endpoint = $Endpoint
    }
    
    Invoke-VaultApi @VaultApi
}
