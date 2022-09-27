function Remove-VaultAttachment {
    <#
    .SYNOPSIS
    Deletes Bitwarden Vault Attachments
    
    .DESCRIPTION
    Calls DELETE /object/item/{id} to move items to the trash
    
    .PARAMETER Id
    Attachment id

    .PARAMETER ItemId
    Item Guid
    
    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Id,
        [Parameter(Mandatory = $true)]
        $ItemId
    )
    
    $Endpoint = 'object/attachment/{0}' -f $Id
    $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    $QueryParams.Add('itemid', $ItemId) | Out-Null

    $VaultApi = @{
        Method      = 'Delete'
        Endpoint    = $Endpoint
        Body        = $Body
        QueryParams = $QueryParams
    }
    
    Invoke-VaultApi @VaultApi
}
