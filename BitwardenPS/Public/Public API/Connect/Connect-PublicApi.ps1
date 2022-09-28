function Connect-PublicApi {
    <#
    .SYNOPSIS
    Connects to Bitwarden Public API
    
    .DESCRIPTION
    Generates OAuth token to interact with public API
    
    .PARAMETER Credentials
    Client ID and Secret in PSCredential object
    
    .PARAMETER Server
    Bitwarden identity server hostname, default identity.bitwarden.com
    
    #>
    [CmdletBinding()]
    Param(
        [pscredential]$Credentials = (Get-Credential -Message 'Enter ClientID and Secret'),
        $Server = 'identity.bitwarden.com'
    )

    if ($Server -eq 'identity.bitwarden.com') {
        $ApiServer = 'api.bitwarden.com'
        $Uri = 'https://{0}/connect/token' -f $Server
    }
    else {
        $ApiServer = $Server
        $Uri = 'https://{0}/identity/connect/token' -f $Server
    }
    $AuthRequest = @{
        Uri         = $Uri
        ContentType = 'application/x-www-form-urlencoded' 
        Body        = @{
            grant_type    = 'client_credentials'
            scope         = 'api.organization'
            client_id     = $Credentials.GetNetworkCredential().UserName
            client_secret = $Credentials.GetNetworkCredential().Password
        }
    }
    
    $Response = Invoke-RestMethod @AuthRequest -Method Post -SkipHttpErrorCheck

    if ($Response) {
        Write-Verbose 'Connected to the Bitwarden Public API'
        $script:BwPublicApi = @{
            Token  = $Response.access_token
            Server = $ApiServer
        }
        $true
    }
    else {
        Write-Error $Response
        $false
    }
    
}
