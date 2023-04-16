$VaultCollectionCompleter = {
    param (
        $CommandName,
        $ParamName,
        $Collection,
        $CommandAst,
        $fakeBoundParameters
    )
    if (!$script:VaultCollections) {
        Get-BwVaultCollections | Out-Null
    }

    $Collection = $Collection -replace "'", ''
    ($script:VaultCollections).name | Where-Object { $_ -match "$Collection" } | ForEach-Object { "'$_'" }
}

Register-ArgumentCompleter -CommandName Get-BwVaultItem -ParameterName Collection -ScriptBlock $VaultCollectionCompleter