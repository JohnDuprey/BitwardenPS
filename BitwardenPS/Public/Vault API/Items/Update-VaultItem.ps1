function Update-VaultItem {
    <#
    .SYNOPSIS
    Updates Bitwarden Vault Items
    
    .DESCRIPTION
    PUT /object/item/{id} 
    
    .PARAMETER Id
    Item guid
    
    .PARAMETER Item
    Full item object in pscustoobject or json format

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(DefaultParameterSetName = 'BodyUpdate', SupportsShouldProcess)]
    Param(
        [Parameter(ParameterSetName = 'BodyUpdate', Mandatory = $true)]
        $Id,

        [Parameter(ParameterSetName = 'BodyUpdate')]
        [Parameter(ValueFromPipeline = $true, ParameterSetName = 'FullObject')]
        $Item
    )

    Process {
        $ItemValid = $false

        if ($Item.GetType().Name -eq 'pscustomobject') {
            $Body = $Item | ConvertTo-Json -Depth 10
            $Id = $Item.id
            $ItemValid = $true
        }
        elseif (Test-Json -Json $Item) {
            $Object = $Item | ConvertFrom-Json
            $Id = $Object.id
            $Body = $Item
            $ItemValid = $true
        }
    
        if (-not $Id -or -not $ItemValid) { 
            Write-Error "Input validation failed for 'Item', valid types are pscustomobject or JSON string and and id property must be specified"
            return
        }

        $Endpoint = 'object/item/{0}' -f $Id

        $VaultApi = @{
            Method   = 'Put'
            Endpoint = $Endpoint
            Body     = $Body
        }
    
        if ($PSCmdlet.ShouldProcess($Id)) {
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
    }
}
