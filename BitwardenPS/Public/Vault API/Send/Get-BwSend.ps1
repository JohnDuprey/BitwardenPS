function Get-BwSend {
    <#
    .SYNOPSIS
    Gets Bitwarden Sends

    .DESCRIPTION
    Calls /list/object/send or /object/send/{id}

    .PARAMETER Id
    Guid of Collection

    .PARAMETER Search
    Search parameters

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    Param(
        [Parameter(ParameterSetName = 'Single', Mandatory = $true)]
        $Id,

        [Parameter(ParameterSetName = 'List')]
        $Search = ''
    )

    switch ($PSCmdlet.ParameterSetName) {
        'List' {
            $Endpoint = 'list/object/send'
            $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
            if ($Search -ne '') {
                $QueryParams.Add('search', $Search) | Out-Null
            }

        }
        'Single' {
            $Endpoint = 'object/send/{0}' -f $Id
        }
    }
    $Request = Invoke-VaultApi -Endpoint $Endpoint -QueryParams $QueryParams

    if ($Request.success) {
        if ($Request.data.data) {
            $Request.data.data
        } elseif ($Request.data) {
            $Request.data
        }
    } else {
        Write-Verbose $Request.message
        $Request.success
    }
}
