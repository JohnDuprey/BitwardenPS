function Get-BwPublicEvents {
    <#
    .SYNOPSIS
    Gets Bitwarden events

    .DESCRIPTION
    Calls the /public/events endpoint to retrieve audit trail

    #>
    [CmdletBinding()]
    Param()

    $EventMsg = [PSCustomObject]@{
        '1000' = 'Logged In'
        '1001' = 'Changed account password'
        '1002' = 'Enabled/updated two-step login'
        '1003' = 'Disabled two-step login'
        '1004' = 'Recovered account from two-step login'
        '1005' = 'Login attempted failed with incorrect password'
        '1006' = 'Login attempt failed with incorrect two-step login'
        '1007' = 'User exported their individual vault items'
        '1008' = 'User updated a password issued through Admin Password Reset'
        '1009' = 'User migrated their decryption key with Key Connector'
        '1100' = 'Created item item-identifier'
        '1101' = 'Edited item item-identifier'
        '1102' = 'Permanently Deleted item item-identifier'
        '1103' = 'Created attachment for item item-identifier'
        '1104' = 'Deleted attachment for item item-identifier'
        '1105' = 'Shared item item-identifier'
        '1106' = 'Edited collections for item item-identifier'
        '1107' = 'Viewed item item-identifier'
        '1108' = 'Viewed password for item item-identifier'
        '1109' = 'Viewed hidden field for item item-identifier'
        '1110' = 'Viewed security code for item item-identifier'
        '1111' = 'Copied password for item item-identifier'
        '1112' = 'Copied hidden field for item item-identifier'
        '1113' = 'Copied security code for item item-identifier'
        '1114' = 'Auto-filled item item-identifier'
        '1115' = 'Sent item item-identifier to trash'
        '1116' = 'Restored item item-identifier'
        '1117' = 'Viewed Card Number for item item-identifier'
        '1300' = 'Created collection collection-identifier'
        '1301' = 'Edited collection collection-identifier'
        '1302' = 'Deleted collection collection-identifier'
        '1400' = 'Created group group-identifier'
        '1401' = 'Edited group group-identifier'
        '1402' = 'Deleted group group-identifier'
        '1500' = 'Invited user user-identifier'
        '1501' = 'Confirmed user user-identifier'
        '1502' = 'Edited user user-identifier'
        '1503' = 'Removed user user-identifier'
        '1504' = 'Edited groups for user user-identifier'
        '1505' = 'Unlinked SSO'
        '1506' = 'user-identifier enrolled in Master Password Reset'
        '1507' = 'user-identifier withdrew from Master Password Reset'
        '1508' = 'Master Password was reset for user-identifier'
        '1509' = 'Reset SSO link for user user-identifier'
        '1510' = 'user-identifer logged in using SSO for the first time'
        '1511' = 'Revoked organization access for user-identifier'
        '1512' = 'Restores organization access for user-identifier'
        '1600' = 'Edited organization settings'
        '1601' = 'Purged organization vault'
        '1603' = 'Organization Vault access by a managing Provider'
        '1604' = 'Organization enabled SSO'
        '1605' = 'Organization disabled SSO'
        '1606' = 'Organization enabled Key Connector'
        '1607' = 'Organization disabled Key Connector'
        '1608' = 'Families Sponsorships synced'
        '1700' = 'Updated a Policy'
    }

    $Endpoint = 'public/events'
    $Events = Invoke-PublicApi -Endpoint $Endpoint
    $Members = Get-PublicMembers
    $Groups = Get-PublicGroups

    foreach ($Event in $Events) {
        if ($Event.groupId) { $GroupName = ($Groups | Where-Object { $_.id -eq $Event.groupId }).name }
        if ($Event.memberId) { $MemberEmail = ($Members | Where-Object { $_.userId -eq $Event.memberId }).email }
        $ActingUser = ($Members | Where-Object { $_.userId -eq $Event.actingUserId }).email
        $TypeId = $Event.type
        $Message = $EventMsg.$TypeId -replace 'item-identifier', $Event.itemId -replace 'collection-identifier', $Event.collectionId -replace 'group-identifier', $GroupName -replace 'member-identifier', $MemberEmail -replace 'user-identifier', $ActingUser

        [PSCustomObject]@{
            message      = $Message
            type         = $Event.type
            itemId       = $Event.itemId
            collectionId = $Event.collectionId
            groupId      = $Event.groupId
            policyId     = $Event.policyId
            memberId     = $Event.memberId
            actingUserId = $Event.actingUserId
            actingUser   = $ActingUser
            date         = $Event.date
            ipAddress    = $Event.ipAddress
        }
    }
}