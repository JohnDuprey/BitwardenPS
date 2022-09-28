function Invoke-VaultApi {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Endpoint,
        [ValidateSet('Get', 'Put', 'Post', 'Delete')]
        $Method = 'Get',
        $QueryParams = '',
        $Body = '',
        $ContentType = 'application/json',
        $OutFile = ''
    )

    Start-BwRestServer

    Write-Verbose ($script:BwRestServer | ConvertTo-Json)
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
        $headers.'Content-Type' = $ContentType
        if ($Body -ne '') {
            $RestMethod.Body = $Body
        }
        $RestMethod.Headers = $Headers
    }
    Write-Verbose ($Headers | ConvertTo-Json)

    if ($OutFile) {
        Invoke-WebRequest @RestMethod -OutFile $OutFile
    }
    else {
        Invoke-RestMethod @RestMethod -SkipHttpErrorCheck
    }
}
