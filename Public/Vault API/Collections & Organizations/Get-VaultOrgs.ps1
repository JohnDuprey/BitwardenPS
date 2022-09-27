function Get-VaultOrgs {
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
    if ($Search -ne '') {
        $Endpoint = '{0}?search={1}' -f $Endpoint, $Search
    }
    $Request = Invoke-VaultApi -Endpoint $Endpoint

    if ($Request.success) {
        $Request.data.data
    }
    else {
        Write-Host $Request.message
        $Request.success
    }

}
