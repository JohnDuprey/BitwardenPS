function Get-VaultItemNotes {
    <#
    .SYNOPSIS
    Returns Notes of a vault item
    
    .DESCRIPTION
    Calls /object/notes/{id} endpoint to retrieve notes
    
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

    $Request = Invoke-VaultApi -Endpoint ('object/notes/{0}' -f $Id)
    if ($Request.success) {
        $Request.data.data
    }
    else {
        Write-Host $Request.message
        $Request.success
    } 
}
