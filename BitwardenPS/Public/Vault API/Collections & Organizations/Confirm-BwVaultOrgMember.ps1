function Confirm-BwVaultOrgMember {
    <#
    .SYNOPSIS
    Gets Bitwarden Vault Org Collections

    .DESCRIPTION
    Calls /list/object/org-members

    .PARAMETER Id
    Guid of Org Member

    .PARAMETER OrganizationId
    Guid of Organization

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        $Id,
        [Parameter(Mandatory = $true)]
        $OrganizationId
    )

    Process {
        $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        $QueryParams.Add('organizationid', $OrganizationId) | Out-Null

        $Endpoint = 'confirm/org-member/{0}' -f $Id
        if ($PSCmdlet.ShouldProcess($Id)) {
            Invoke-VaultApi -Endpoint $Endpoint -QueryParams $QueryParams
        }
    }
}
