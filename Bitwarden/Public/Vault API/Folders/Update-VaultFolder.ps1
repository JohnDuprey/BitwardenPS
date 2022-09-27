function Update-VaultItem {
    <#
    .SYNOPSIS
    Updates Bitwarden Vault Folder
    
    .DESCRIPTION
    PUT /object/folder/{id} 
    
    .PARAMETER Id
    Item guid
    
    .PARAMETER Name
    Name of folder

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Id,
        [Parameter(Mandatory = $true)]
        $Name
    )

    $Body = @{
        name = $Name
    } | ConvertTo-Json

    $Endpoint = 'object/folder/{0}' -f $Id

    $VaultApi = @{
        Method   = 'Put'
        Endpoint = $Endpoint
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
