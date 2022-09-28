function Update-VaultOrgCollection {
    <#
    .SYNOPSIS
    Updates Bitwarden Vault Items
    
    .DESCRIPTION
    PUT /object/item/{id} 
    
    .PARAMETER Id
    Item guid
    
    .PARAMETER Item
    Full item object in pscustoobject or json format

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(DefaultParameterSetName = 'BodyUpdate')]
    Param(
        [Parameter(ParameterSetName = 'BodyUpdate', Mandatory = $true)]
        $Id,

        [Parameter(ParameterSetName = 'BodyUpdate')]
        [Parameter(ValueFromPipeline = $true, ParameterSetName = 'FullObject')]
        $OrgCollection
    )

    Process {
        $OrgCollectonValid = $false

        if ($OrgCollection.GetType().Name -eq 'pscustomobject') {
            $Body = $OrgCollection | ConvertTo-Json -Depth 10
            if ($OrgCollection.id) { $Id = $Item.id }
            $OrgCollectonValid = $true
        }
        elseif (Test-Json -Json $OrgCollection) {
            $Object = $OrgCollection | ConvertFrom-Json
            if ($Object.id) {
                $Id = $Object.id
            }
            $Body = $OrgCollection
            $OrgCollectonValid = $true
        }
    
        if (-not $Id -or -not $OrgCollectonValid) { 
            Write-Error "Input validation failed for 'OrgCollection', valid types are pscustomobject or JSON string and and id property must be specified"
            return
        }

        $Endpoint = 'object/org-collection/{0}' -f $Id

        $VaultApi = @{
            Method   = 'Put'
            Endpoint = $Endpoint
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
}
