function Get-VaultItemPassword {
    <#
    .SYNOPSIS
    Returns password of a vault item
    
    .DESCRIPTION
    Calls /object/password/{id} endpoint to retrieve password
    
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

    $Request = Invoke-VaultApi -Endpoint ('object/password/{0}' -f $Id)
    if ($Request.success) {
        $Request.data.data
    }
    else {
        Write-Host $Request.message
        $Request.success
    } 
}