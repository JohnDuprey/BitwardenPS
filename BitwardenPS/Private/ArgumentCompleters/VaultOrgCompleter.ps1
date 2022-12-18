$VaultOrgCompleter = {
    param (
        $CommandName,
        $ParamName,
        $Organization,
        $CommandAst,
        $fakeBoundParameters
    )
    if (!$script:VaultCollections) {
        Get-BwVaultOrgs | Out-Null
    }

    $Organization = $Organization -replace "'", ''
    ($script:VaultOrgs).name | Where-Object { $_ -match "$Organization" } | ForEach-Object { "'$_'" }
}

Register-ArgumentCompleter -CommandName Get-BwVaultItem -ParameterName Organization -ScriptBlock $VaultOrgCompleter