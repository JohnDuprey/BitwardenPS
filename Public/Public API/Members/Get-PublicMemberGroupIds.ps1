function Get-PublicMemberGroupIds {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Id
    )

    $Endpoint = 'public/members/{0}/group-ids' -f $Id
    Invoke-PublicApi -Endpoint $Endpoint
}