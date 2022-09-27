function Update-Send {
    <#
    .SYNOPSIS
    Updates Bitwarden Send
    
    .DESCRIPTION
    PUT /object/send/{id} 
    
    .PARAMETER Id
    Send guid
    
    .PARAMETER Send
    Full Send object in pscustoobject or json format

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(DefaultParameterSetName = 'BodyUpdate')]
    Param(
        [Parameter(ParameterSetName = 'BodyUpdate', Mandatory = $true)]
        $Id,

        [Parameter(ParameterSetName = 'BodyUpdate')]
        [Parameter(ValueFromPipeline, ParameterSetName = 'FullObject')]
        $Send
    )

    $SendValid = $false

    if ($Send.GetType().Name -eq 'pscustomobject') {
        $Body = $Send | ConvertTo-Json -Depth 10
        $Id = $Send.id
        $SendValid = $true
    }
    elseif (Test-Json -Json $Send) {
        $Object = $Send | ConvertFrom-Json
        $Id = $Object.id
        $Body = $Send
        $SendValid = $true
    }
    
    if (-not $Id -or -not $SendValid) { 
        Write-Error "Input validation failed for 'Item', valid types are pscustomobject or JSON string and and id property must be specified"
        return
    }

    $Endpoint = 'object/send/{0}' -f $Id

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
