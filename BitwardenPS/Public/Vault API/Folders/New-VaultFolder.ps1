function New-VaultFolder {
    <#
    .SYNOPSIS
    Creates Bitwarden Folder
    
    .DESCRIPTION
    Calls POST /object/folder to create new folders
    
    .PARAMETER Name
    Name of the folder

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        $Folder
    )

    $FolderValid = $false

    if ($Folder.GetType().Name -eq 'pscustomobject') {
        $Body = $Folder | ConvertTo-Json -Depth 10
        $FolderValid = $true
    }
    elseif (Test-Json -Json $Folder) {
        $Body = $Folder
        $FolderValid = $true
    }
    
    if (-not $FolderValid) { 
        Write-Error "Input validation failed for 'Folder', valid types are pscustomobject or JSON string"
        return
    }
    
    $VaultApi = @{
        Method   = 'POST'
        Endpoint = 'object/folder'
        Body     = $Body
    }
    
    $Request = Invoke-VaultApi @VaultApi

    if ($Request.success) {
        if ($Request.data) {
            $Request.data
        }
    }
    else {
        Write-Host $Request.message
        $Request.success
    }
}
