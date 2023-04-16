function Send-BwPublicMemberInvite {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Id
    )
    $Endpoint = 'public/members/{0}/reinvite' -f $id

    Invoke-PublicApi -Endpoint $Endpoint -Method Post
}