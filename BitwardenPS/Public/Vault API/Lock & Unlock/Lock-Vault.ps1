function Lock-Vault {
    <#
    .SYNOPSIS
    Locks Bitwarden Vault
    
    .DESCRIPTION
    Calls the /lock endpoint to clean up session

    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [cmdletbinding()]
    Param()
    $Request = Invoke-VaultApi -Endpoint 'lock' -Method Post
    [Environment]::SetEnvironmentVariable('BW_SESSION', $null)
    Write-Host $Request.data.title
}
