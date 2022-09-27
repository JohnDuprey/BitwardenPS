function New-Password {
    <#
    .SYNOPSIS
    Creates a new password
    
    .DESCRIPTION
    Calls the /generate endpoint to create a new password
    
    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [cmdletbinding()]
    Param()
    $Request = Invoke-VaultApi -Endpoint 'generate'
    if ($Request) {
        $Request.data.data | ConvertTo-SecureString -AsPlainText -Force
    }
    else {
        Write-Error 'Unable to generate password'
    }
}