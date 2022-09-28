function Sync-Vault {
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
    Write-Host $Request.data.title
    $Request
}