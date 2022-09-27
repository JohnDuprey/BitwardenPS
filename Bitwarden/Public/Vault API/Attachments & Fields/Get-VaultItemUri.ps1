function Get-VaultItemUri {
    <#
    .SYNOPSIS
    Returns URI of a vault item
    
    .DESCRIPTION
    Calls /object/uri/{id} endpoint to retrieve URI
    
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

    $Request = Invoke-VaultApi -Endpoint ('object/uri/{0}' -f $Id)
    if ($Request.success) {
        $Request.data.data
    }
    else {
        Write-Host $Request.message
        $Request.success
    } 
}
