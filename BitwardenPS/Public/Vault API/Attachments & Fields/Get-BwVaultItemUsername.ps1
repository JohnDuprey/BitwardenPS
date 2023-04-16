function Get-BwVaultItemUsername {
    <#
    .SYNOPSIS
    Returns username of a vault item

    .DESCRIPTION
    Calls /object/username/{id} endpoint to retrieve username

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
        $Request = Invoke-VaultApi -Endpoint ('object/username/{0}' -f $Id)
        if ($Request.success) {
            $Request.data.data
        } else {
            Write-Verbose $Request.message
            $Request.success
        }
    }
}
