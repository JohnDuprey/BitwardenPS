function Get-BwPublicMembers {
    [CmdletBinding()]
    Param(
        $Id = ''
    )
    $Endpoint = 'public/members'
    if ($Id -ne '') {
        $Endpoint = '{0}/{1}' -f $Endpoint, $Id
    }
    Invoke-PublicApi -Endpoint $Endpoint
}
