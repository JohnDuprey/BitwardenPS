function Get-BwVaultItemTotp {
    <#
    .SYNOPSIS
    Returns TOTP of a vault item

    .DESCRIPTION
    Calls /object/totp/{id} endpoint to retrieve TOTP

    .PARAMETER Id
    Item guid

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [cmdletbinding()]
    Param(
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        $Id
    )
    Process {
        $Request = Invoke-VaultApi -Endpoint ('object/totp/{0}' -f $Id)
        if ($Request.success) {
            $Request.data.data
        } else {
            Write-Verbose $Request.message
            $Request.success
        }
    }
}
