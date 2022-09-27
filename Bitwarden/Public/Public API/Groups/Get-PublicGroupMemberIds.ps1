function Get-PublicGroupMemberIds {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Id
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Id
    )

    $Endpoint = 'public/groups/{0}/member-ids' -f $Id
    Invoke-PublicApi -Endpoint $Endpoint
}