function Set-BwSecretsAccessToken {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        $AccessToken
    )

    # Set session variable for cli commands
    if ($PSCmdlet.ShouldProcess('BWS_ACCESS_TOKEN')) {
        [Environment]::SetEnvironmentVariable('BWS_ACCESS_TOKEN', $AccessToken)
    }
}