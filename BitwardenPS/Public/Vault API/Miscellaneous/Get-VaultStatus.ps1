function Get-VaultStatus {
    <#
    .SYNOPSIS
    Returns REST server status
    
    .DESCRIPTION
    Calls /status endpoint to check if vault is logged in

    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [cmdletbinding()]
    Param()
    $Request = Invoke-VaultApi -Endpoint 'status'
    $Request.data.template
}
