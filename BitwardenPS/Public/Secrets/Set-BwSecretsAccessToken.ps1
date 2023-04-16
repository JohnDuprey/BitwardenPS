function Set-BwSecretsAccessToken {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        $AccessToken,
        [switch]$Unset
    )

    # Set session variable for cli commands
    if ($PSCmdlet.ShouldProcess('BWS_ACCESS_TOKEN')) {
        if ($Unset.IsPresent) {
            [Environment]::SetEnvironmentVariable('BWS_ACCESS_TOKEN', '')
        } else {
            [Environment]::SetEnvironmentVariable('BWS_ACCESS_TOKEN', $AccessToken)
        }
    }
}
