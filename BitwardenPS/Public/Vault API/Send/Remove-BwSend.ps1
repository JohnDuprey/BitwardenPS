function Remove-BwSend {
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
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        $Id
    )

    process {
        $Endpoint = 'object/send/{0}' -f $Id

        $VaultApi = @{
            Method   = 'Delete'
            Endpoint = $Endpoint
        }

        if ($PSCmdlet.ShouldProcess($Id)) {
            Invoke-VaultApi @VaultApi
        }
    }
}
