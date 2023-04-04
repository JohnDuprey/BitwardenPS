function New-BwVaultOrgCollection {
    <#
    .SYNOPSIS
    Creates Bitwarden Vault Org Collections

    .DESCRIPTION
    Calls POST /object/org-collection to create new org collections

    .PARAMETER OrgCollection
    Full item object in PSCustomObject or json format

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory = $true)]
        $OrganizationId,

        [Parameter(ValueFromPipeline, Mandatory = $true)]
        $OrgCollection
    )

    Process {
        $OrgCollectonValid = $false

        if ($OrgCollection.GetType().Name -eq 'pscustomobject') {
            if ($OrgCollection.organizationId) { $OrganizationId = $OrgCollection.organizationId }
            $Body = $OrgCollection | ConvertTo-Json -Depth 10
            $OrgCollectonValid = $true
        } elseif (Test-Json -Json $OrgCollection) {
            $Object = $OrgCollection | ConvertFrom-Json
            if ($Object.organizationId) {
                $OrganizationId = $Object.organizationId
            }
            $Body = $OrgCollection
            $OrgCollectonValid = $true
        }

        if (-not $OrganizationId -or -not $OrgCollectonValid) {
            Write-Error "Input validation failed for 'OrgCollection', valid types are pscustomobject or JSON string. An OrganizationId and an Id property must be specified"
            return
        }

        $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        $QueryParams.Add('organizationid', $OrganizationId) | Out-Null

        $VaultApi = @{
            Method      = 'POST'
            Endpoint    = 'object/org-collection'
            Body        = $Body
            QueryParams = $QueryParams
        }

        if ($PSCmdlet.ShouldProcess($OrgCollection.name)) {
            $Request = Invoke-VaultApi @VaultApi

            if ($Request.success) {
                if ($Request.data) {
                    $Request.data
                }
            } else {
                Write-Verbose $Request.message
                $Request.success
            }
        }
    }
}
