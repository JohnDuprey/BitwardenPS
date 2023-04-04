function Start-BwRestServer {
    <#
    .SYNOPSIS
    Starts Bitwarden REST server

    .DESCRIPTION
    Uses `bw serve` to run local REST server

    .PARAMETER Port
    Port to run server on, default 8087

    .PARAMETER Hostname
    Hostname to run server on, default localhost

    .LINK
    https://bitwarden.com/help/cli/#serve

    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    [cmdletbinding()]
    Param(
        $Port = 8087,
        $Hostname = 'localhost'
    )

    try {
        if (!$script:BwRestServer) {
            $BwServe = Get-Process bw -ErrorAction SilentlyContinue
            $TestPort = Test-Connection -IPv4 -TargetName $Hostname -TcpPort $Port
            if ($BwServe -and $TestPort) {
                Write-Verbose 'REST server already running'
                $RunningCli = $BwServe
                $script:BwRestServer = [PSCustomObject]@{
                    PID      = $BwServe.Id
                    Port     = $Port
                    Hostname = $Hostname
                }
            } else {
                $RunningCli = $false
            }
        } else {
            $RunningCli = Get-Process -PID $script:BwRestServer.PID -ErrorAction SilentlyContinue
        }
    } catch {
        Stop-RestServer
        $RunningCli = $false
    }

    if (-not $RunningCli) {
        $Arguments = @(
            'serve'
            "--port $Port"
            "--hostname $Hostname"
        )
        try {
            $bw = Get-Command bw
            if (!$bw) {
                Write-Error 'Bitwarden CLI is not installed, visit https://bitwarden.com/help/cli/#download-and-install for more information.'
                return $false
            }
            Write-Verbose 'Starting REST server'
            $Proc = Start-Process -FilePath $bw.Path -ArgumentList $Arguments -NoNewWindow -PassThru -ErrorAction Stop

            do {
                $VaultRest = Test-Connection -IPv4 -TargetName $Hostname -TcpPort $Port
                Start-Sleep -Milliseconds 200
            } while (-not $VaultRest)

            $script:BwRestServer = [PSCustomObject]@{
                PID      = $Proc.Id
                Port     = $Port
                Hostname = $Hostname
            }
            $script:BwRestServer
        } catch {
            Write-Error "Could not start REST server. Exception: $($_.Exception.Message)"
        }
    }
}
