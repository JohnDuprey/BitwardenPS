function Restore-VaultItem {
    <#
    .SYNOPSIS
    Restores deleted Bitwarden Vault Items
    
    .DESCRIPTION
    PUT /restore/item/{id} 
    
    .PARAMETER Id
    Item guid
    
    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        $Id
    )
    
    Process {
        $Endpoint = 'restore/item/{0}' -f $Id

        $VaultApi = @{
            Method   = 'Post'
            Endpoint = $Endpoint
            Body     = $Body
        }
    
        if ($PSCmdlet.ShouldProcess($Id)) {
            Invoke-VaultApi @VaultApi
        }
    }
}
