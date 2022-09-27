function New-VaultOrgCollection {
    <#
    .SYNOPSIS
    Creates Bitwarden Vault Org Collections
    
    .DESCRIPTION
    Calls POST /object/org-collection to create new org collections
    
    .PARAMETER OrgCollection
    Full item object in pscustoobject or json format

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline, Mandatory = $true)]
        $OrgCollection
    )

    $OrgCollectionValid = $false

    if ($OrgCollection.GetType().Name -eq 'pscustomobject') {
        $Body = $OrgCollection | ConvertTo-Json -Depth 10
        $OrgCollectionValid = $true
    }
    elseif (Test-Json -Json $OrgCollection) {
        $Body = $OrgCollection
        $OrgCollectionValid = $true
    }
    
    if (-not $OrgCollectionValid) { 
        Write-Error "Input validation failed for 'OrgCollection', valid types are pscustomobject or JSON string and and id property must be specified"
        return
    }
    
    $VaultApi = @{
        Method   = 'POST'
        Endpoint = 'object/org-collection'
        Body     = $Body
    }
    
    $Request = Invoke-VaultApi @VaultApi

    if ($Request.success) {
        if ($Request.data) {
            $Request.data
        }
    }
    else {
        Write-Host $Request.message
        $Request.success
    }
}
