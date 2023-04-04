function Get-BwVaultCollections {
    <#
    .SYNOPSIS
    Gets Bitwarden Vault Collections

    .DESCRIPTION
    Calls /list/object/collections

    .PARAMETER Search
    Organization name to search for

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        $Search = ''
    )

    $Endpoint = 'list/object/collections'
    $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    if ($Search -ne '') {
        $QueryParams.Add('search', $Search) | Out-Null
    }
    $Request = Invoke-VaultApi -Endpoint $Endpoint -QueryParams $QueryParams

    if ($Request.success) {
        $Request.data.data
        $script:VaultCollections = $Request.data.data
    } else {
        Write-Verbose $Request.message
        $Request.success
    }

}
