function Get-VaultFolder {
    <#
    .SYNOPSIS
    Gets Bitwarden Vault Folder
    
    .DESCRIPTION
    Calls /list/object/folders or /object/folder/{id} to retrieve vault folders
    
    .PARAMETER Id
    Folder guid
    
    .PARAMETER Search
    Search terms
    
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
            $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

            $Endpoint = 'list/object/folders'
            if ($Search -ne '') {
                $QueryParams.Add('search', $Search) | Out-Null
            }
            $VaultApi = @{
                Endpoint    = $Endpoint
                QueryParams = $QueryParams
            }
        }   
        'Single' {
            $Endpoint = 'object/folder/{0}' -f $Id

            $VaultApi = @{
                Endpoint = $Endpoint
            }
        } 
    }
    
    $Request = Invoke-VaultApi @VaultApi

    if ($Request.success) {
        if ($Request.data.data) {
            $Request.data.data
        }
        elseif ($Request.data) {
            $Request.data
        }
    }
    else {
        Write-Host $Request.message
        $Request.success
    }
}
