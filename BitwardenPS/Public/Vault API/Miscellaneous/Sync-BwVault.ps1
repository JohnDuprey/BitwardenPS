function Sync-BwVault {
    <#
    .SYNOPSIS
    Syncs local Bitwarden vault with server

    .DESCRIPTION
    Calls /sync endpoint to synchronize local vault

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [cmdletbinding()]
    Param()
    $Request = Invoke-VaultApi -Endpoint 'sync' -Method Post
    $Request.data
}
