function Get-PublicGroups {
    [CmdletBinding()]
    Param(
        $Id = ''
    )
    $Endpoint = 'public/groups'
    if ($Id -ne '') {
        $Endpoint = '{0}/{1}' -f $Endpoint, $Id
    }
    Invoke-PublicApi -Endpoint $Endpoint
}