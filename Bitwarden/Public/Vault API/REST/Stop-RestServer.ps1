function Stop-RestServer {
    <#
    .SYNOPSIS
    Stops Bitwarden REST server
    
    .DESCRIPTION
    Stops bw process if found running
    
    .LINK
    https://bitwarden.com/help/cli/#serve
    
    #>
    [cmdletbinding()]
    Param()
    
    $RunningCli = Get-Process bw -ErrorAction SilentlyContinue
    if ($RunningCli) {
        Write-Host 'Stopping REST server'
        $RunningCli | Stop-Process
    }
    
}
