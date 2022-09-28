function New-Send {
    <#
    .SYNOPSIS
    Creates Bitwarden Send
    
    .DESCRIPTION
    Calls POST /object/send to create a new send
    
    .PARAMETER OrgCollection
    Full item object in pscustoobject or json format

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(DefaultParameterSetName = 'SendParams')]
    Param(
        [Parameter(ParameterSetName = 'SendParams', Mandatory = $true)]
        $Name,
        [Parameter(ParameterSetName = 'SendParams')]
        $Notes = '',
        [Parameter(ParameterSetName = 'SendParams')]
        $SendPass = '',
        [Parameter(ParameterSetName = 'SendParams', Mandatory = $true)]
        $Text,
        [Parameter(ParameterSetName = 'SendParams')]
        [int]$Days = 7,
        [Parameter(ParameterSetName = 'SendParams')]
        [int]$MaxAccessCount = 3,
        [Parameter(ParameterSetName = 'SendParams')]
        [switch]$HideText,
        [Parameter(ParameterSetName = 'SendParams')]
        [switch]$HideEmail,
        [Parameter(ParameterSetName = 'FullObject', ValueFromPipeline, Mandatory = $true)]
        $Send
    )

    $SendValid = $false
    switch ($PSCmdlet.ParameterSetName) { 
        'FullObject' {
            if ($Send.GetType().Name -eq 'pscustomobject') {
                $Body = $Send | ConvertTo-Json -Depth 10
                $SendValid = $true
            }
            elseif (Test-Json -Json $Send) {
                $Body = $Send
                $SendValid = $true
            }    
            if (-not $SendValid) { 
                Write-Error "Input validation failed for 'Send', valid types are pscustomobject or JSON string"
                return
            }
        }
        'SendParams' {
            $Send = [pscustomobject]@{
                name           = $Name
                notes          = $Notes
                type           = 0
                text           = @{
                    text   = $Text
                    hidden = $HideText.IsPresent
                }
                file           = $null
                maxAccessCount = $MaxAccessCount
                deletionDate   = (Get-Date).AddDays($Days).ToUniversalTime()
                expirationDate = (Get-Date).AddDays($Days).ToUniversalTime()
                hideEmail      = $HideEmail.IsPresent
                disabled       = $false
                
            }
            if ($SendPass) { $Send.password = $SendPass }

            $Body = $Send | ConvertTo-Json
            Write-Verbose $Body
        }
    }


    $VaultApi = @{
        Method   = 'POST'
        Endpoint = 'object/send'
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
