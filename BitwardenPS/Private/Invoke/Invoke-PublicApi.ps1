function Invoke-PublicApi {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Endpoint,
        [ValidateSet('Get', 'Put', 'Post', 'Delete')]
        $Method = 'Get',
        $Body = ''
    )

    if (!$script:BwPublicApi) {
        Write-Error 'Not connected to Bitwarden Public API'
        return $false
    }

    $Uri = 'https://{0}/{1}' -f $script:BwPublicApi.Server, $Endpoint

    $Headers = @{
        Authorization  = ('Bearer {0}' -f $script:BwPublicApi.Token)
        'Content-Type' = 'application/json'
    }

    if ($Method -eq 'Post') {
        if ($Body -ne '') {
            $RestMethod.Body = $Body
        }
    }

    $RestMethod = @{
        Uri     = $Uri
        Method  = $Method
        Headers = $Headers
    }

    Write-Verbose ($RestMethod | ConvertTo-Json)
    $Response = Invoke-RestMethod @RestMethod -SkipHttpErrorCheck
    if ($Response.data) {
        $Response.data
    } else {
        $Response
    }
}