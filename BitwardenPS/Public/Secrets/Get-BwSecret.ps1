function Get-BwSecret {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Id')]
        $Id
    )

    $Arguments = switch ($PSCmdlet.ParameterSetName) {
        'List' {
            @(
                'list'
                'secrets'
            )
        }
        'Id' {
            'get'
            'secret'
            $Id
        }
    }
    Invoke-BwsCli -Arguments $Arguments
}