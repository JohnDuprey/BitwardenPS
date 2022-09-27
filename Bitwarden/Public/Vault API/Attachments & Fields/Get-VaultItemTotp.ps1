function Get-VaultItemTotp {
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
        [Parameter(Mandatory = $true)]
        $Id
    )

    $Request = Invoke-VaultApi -Endpoint ('object/totp/{0}' -f $Id)
    if ($Request.success) {
        $Request.data.data
    }
    else {
        $Request
    } 
}
