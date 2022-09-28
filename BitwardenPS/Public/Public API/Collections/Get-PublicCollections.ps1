function Get-PublicCollections {
    [CmdletBinding()]
    Param(
        $Id = ''
    )
    $Endpoint = 'public/collections'

    if ($Id -ne '') {
        $Endpoint = '{0}/{1}' -f $Endpoint, $Id
    }
    Invoke-PublicApi -Endpoint $Endpoint
}