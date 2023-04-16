function Get-BwVaultOrgs {
    <#
    .SYNOPSIS
    Gets Bitwarden Vault Organizations

    .DESCRIPTION
    Calls /list/object/organizations

    .PARAMETER Search
    Organization name to search for

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        $Search = ''
    )

    $Endpoint = 'list/object/organizations'
    $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    if ($Search -ne '') {
        $QueryParams.Add('search', $Search) | Out-Null
    }
    $Request = Invoke-VaultApi -Endpoint $Endpoint -QueryParams $QueryParams

    if ($Request.success) {
        $Request.data.data
        $script:VaultOrgs = $Request.data.data
    } else {
        Write-Verbose $Request.message
        $Request.success
    }

}
