function Stop-RestServer {
    <#
    .SYNOPSIS
    Stops Bitwarden REST server

    .DESCRIPTION
    Stops bw process if found running

    .LINK
    https://bitwarden.com/help/cli/#serve

    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    [cmdletbinding()]
    Param()

    $RunningCli = Get-Process bw -ErrorAction SilentlyContinue
    if ($RunningCli) {
        Write-Verbose 'Stopping REST server'
        $RunningCli | Stop-Process
        $script:BwRestServer = $null
    }
}
