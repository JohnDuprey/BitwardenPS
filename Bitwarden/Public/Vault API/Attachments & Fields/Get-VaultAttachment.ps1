function Get-VaultAttachment {
    <#
    .SYNOPSIS
    Gets Bitwarden Vault Attachments
    
    .DESCRIPTION
    Calls Get /object/attachment/{id} to download attachments
    
    .PARAMETER Id
    Attachment id
    
    .PARAMETER ItemId
    Item Guid

    .PARAMETER FilePath
    Path to save file
    
    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Id,
        [Parameter(Mandatory = $true)]
        $ItemId,
        $FilePath = ''
    )

    $Endpoint = 'object/attachment/{0}' -f $Id
    $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    $QueryParams.Add('itemid', $ItemId) | Out-Null

    $VaultApi = @{
        Endpoint    = $Endpoint
        QueryParams = $QueryParams
    }

    if ($FilePath) {
        $VaultApi.OutFile = $FilePath
    }

    Invoke-VaultApi @VaultApi
}
