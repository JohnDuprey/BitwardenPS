function Update-BwVaultOrgCollection {
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
    [CmdletBinding(DefaultParameterSetName = 'BodyUpdate', SupportsShouldProcess)]
    Param(
        [Parameter(ParameterSetName = 'BodyUpdate', Mandatory = $true)]
        $Id,
        [Parameter(ParameterSetName = 'BodyUpdate', Mandatory = $true)]
        $OrganizationId,

        [Parameter(ParameterSetName = 'BodyUpdate')]
        [Parameter(ValueFromPipeline = $true, ParameterSetName = 'FullObject')]
        $OrgCollection
    )

    Process {
        $OrgCollectonValid = $false

        if ($OrgCollection.GetType().Name -eq 'pscustomobject') {
            if ($OrgCollection.id) { $Id = $OrgCollection.id }
            if ($OrgCollection.organizationId) { $OrganizationId = $OrgCollection.organizationId }
            $Body = $OrgCollection | ConvertTo-Json -Depth 10
            $OrgCollectonValid = $true
        } elseif (Test-Json -Json $OrgCollection) {
            $Object = $OrgCollection | ConvertFrom-Json
            if ($Object.id) {
                $Id = $Object.id
            }
            $Body = $OrgCollection
            $OrgCollectonValid = $true
        }

        if (-not $Id -or -not $OrganizationId -or -not $OrgCollectonValid) {
            Write-Error "Input validation failed for 'OrgCollection', valid types are pscustomobject or JSON string. An OrganizationId and an Id property must be specified"
            return
        }

        Write-Verbose $Body
        $Endpoint = 'object/org-collection/{0}' -f $Id
        $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        $QueryParams.Add('organizationid', $OrganizationId) | Out-Null

        $VaultApi = @{
            Method      = 'Put'
            Endpoint    = $Endpoint
            Body        = $Body
            QueryParams = $QueryParams
        }

        if ($OrgCollection) {
            $ProcessObject = '{0} ({1})' -f $OrgCollection.name, $Id
        } else {
            $ProcessObject = $Id
        }

        if ($PSCmdlet.ShouldProcess($ProcessObject)) {
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
