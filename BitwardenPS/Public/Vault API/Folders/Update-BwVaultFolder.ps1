function Update-BwVaultFolder {
    <#
    .SYNOPSIS
    Updates Bitwarden Vault Folder

    .DESCRIPTION
    PUT /object/folder/{id}

    .PARAMETER Id
    Item guid

    .PARAMETER Name
    Name of folder

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        $Id,
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        $Name
    )

    Process {
        $Body = @{
            name = $Name
        } | ConvertTo-Json

        $Endpoint = 'object/folder/{0}' -f $Id

        $VaultApi = @{
            Method   = 'Put'
            Endpoint = $Endpoint
            Body     = $Body
        }

        if ($PSCmdlet.ShouldProcess($Id)) {
            $Request = Invoke-VaultApi @VaultApi

            if ($Request.success) {
                if ($Request.data) {
                    $Request.data
                }
            } else {
                Write-Verbose $Request.message
                $Request.success
            }
        }
    }
}
