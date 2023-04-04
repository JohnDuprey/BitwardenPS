function Get-VaultTemplate {
    <#
    .SYNOPSIS
    Returns vault template object
    
    .DESCRIPTION
    Calls /template/{type} endpoint

    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('item', 'item.field', 'item.login', 'item.login.uri', 'item.card', 'item.identity', 'item.securenote', 'folder', 'collection', 'item-collections', 'org-collection')]
        $Type
    )

    #API method not available yet
    #Invoke-VaultApi -Endpoint ('template/{0}' -f $Type)

    $Arguments = @(
        'get'
        'template'
        $Type
    )

    Invoke-VaultCli -Arguments $Arguments
}
