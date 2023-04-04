function New-BwVaultItem {
    <#
    .SYNOPSIS
    Creates Bitwarden Vault Items

    .DESCRIPTION
    Calls POST /object/item to create vault items

    .PARAMETER Item
    Full item object in pscustoobject or json format

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        $Item
    )

    Process {
        $ItemValid = $false

        if ($Item.GetType().Name -eq 'pscustomobject') {
            $Body = $Item | ConvertTo-Json -Depth 10
            $ItemValid = $true
        } elseif (Test-Json -Json $Item) {
            $Body = $Item
            $ItemValid = $true
        }

        if (-not $ItemValid) {
            Write-Error "Input validation failed for 'Item', valid types are pscustomobject or JSON string and and id property must be specified"
            return
        }

        $VaultApi = @{
            Method   = 'POST'
            Endpoint = 'object/item'
            Body     = $Body
        }

        if ($PSCmdlet.ShouldProcess($Item.name)) {
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
