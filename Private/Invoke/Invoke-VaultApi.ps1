function Invoke-VaultApi {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Endpoint,
        [ValidateSet('Get', 'Put', 'Post', 'Delete')]
        $Method = 'Get',
        $QueryParams = '',
        $Body = ''
    )

    if (!$script:BwRestServer.Hostname) {
        $Server = Start-BwRestServer
        do {
            $OldProgPref = $global:ProgressPreference
            $global:ProgressPreference = 'SilentlyContinue'
            $VaultRest = Test-NetConnection -ComputerName $Server.Hostname -Port $Server.Port -InformationLevel Quiet -WarningAction SilentlyContinue
            Start-Sleep -Seconds 1
        } while (-not $VaultRest)
        $global:ProgressPreference = $OldProgPref
    }

    $Uri = 'http://{0}:{1}/{2}' -f $script:BwRestServer.Hostname, $script:BwRestServer.Port, $Endpoint

    if ($QueryParams -ne '') {
        $UriBuilder = [System.UriBuilder]$Uri
        $UriBuilder.Query = $QueryParams.ToString()
        $Uri = $UriBuilder.Uri.OriginalString  
    }

    Write-Verbose $Uri
    $Headers = @{
        'Accept' = 'application/json'
    }
    $RestMethod = @{
        Uri    = $Uri
        Method = $Method
    }

    if ($Method -eq 'Post' -or $Method -eq 'Put') {
        $headers.'Content-Type' = 'application/json'
        if ($Body -ne '') {
            $RestMethod.Body = $Body
        }
        $RestMethod.Headers = $Headers
    }
    Invoke-RestMethod @RestMethod -SkipHttpErrorCheck
}
