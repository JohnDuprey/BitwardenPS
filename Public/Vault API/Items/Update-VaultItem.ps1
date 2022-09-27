function Update-VaultItem {
    <#
    .SYNOPSIS
    Updates Bitwarden Vault Items
    
    .DESCRIPTION
    PUT /object/item/{id} 
    
    .PARAMETER Id
    Item guid
    
    .PARAMETER Body
    Body of updated item
    
    .PARAMETER Item
    Full item from pipeline

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(DefaultParameterSetName = 'BodyUpdate')]
    Param(
        [Parameter(ParameterSetName = 'BodyUpdate', Mandatory = $true)]
        $Id,

        [Parameter(ParameterSetName = 'BodyUpdate')]
        [Parameter(ValueFromPipeline, ParameterSetName = 'FullObject')]
        $Item
    )

    if ($Item.GetType().Name -eq 'pscustomobject') {
        $Body = $Item | ConvertTo-Json -Depth 10
    }
    elseif (Test-Json -Json $Item) {
        $Body = $Item
    }
    else { 
        Write-Error "Input validation failed for 'Item', valid types are pscustomobject or JSON string"
        return
    }

    $Endpoint = 'object/item/{0}' -f $Item.id

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
