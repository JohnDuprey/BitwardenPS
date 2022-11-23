function Unlock-Vault {
    <#
    .SYNOPSIS
    Unlocks Bitwarden Vault
    
    .DESCRIPTION
    Calls the /unlock endpoint to open the vault
    
    .PARAMETER Credential
    Vault credential object for the master password

    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [CmdletBinding()]
    Param(
        [PSCredential]$Credential = (Get-Credential -UserName 'Master Password' )
    )

    $Body = @{
        password = $Credential.GetNetworkCredential().Password 
    } | ConvertTo-Json -Compress

    $Request = Invoke-VaultApi -Endpoint 'unlock' -Method 'Post' -Body $Body
    
    # Set session variable for cli commands
    [Environment]::SetEnvironmentVariable('BW_SESSION', $Request.data.raw)

    if ($Request.success) {
        Write-Verbose $Request.data.title
    }
    else {
        Write-Verbose $Request.message
    }
    $Request.success
}