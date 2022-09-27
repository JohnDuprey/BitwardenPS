function Invoke-Cli {
    <#
    .SYNOPSIS
    Runs Bitwarden Cli commands
    
    .DESCRIPTION
    Calls bw command

    #>
    [cmdletbinding()]
    Param(
        $Arguments
    )

    $bw = Get-Command bw
    if (!$bw) {
        Write-Error 'Bitwarden CLI is not installed'
        return $false
    }

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $bw.Path
    $pinfo.RedirectStandardError = $false
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $Arguments
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    $stdout = $p.StandardOutput.ReadToEnd()
    $stdout | ConvertFrom-Json
}
