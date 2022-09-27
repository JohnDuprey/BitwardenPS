#Region '.\Private\Invoke\Invoke-PublicApi.ps1' 0
function Invoke-PublicApi {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Endpoint,
        [ValidateSet('Get', 'Put', 'Post', 'Delete')]
        $Method = 'Get',
        $Body = ''
    )

    if (!$script:BwPublicApi) {
        Write-Error 'Not connected to Bitwarden Public API'
        return $false
    }

    $Uri = 'https://{0}/{1}' -f $script:BwPublicApi.Server, $Endpoint

    $Headers = @{
        Authorization  = ('Bearer {0}' -f $script:BwPublicApi.Token)
        'Content-Type' = 'application/json'
    }

    if ($Method -eq 'Post') {
        if ($Body -ne '') {
            $RestMethod.Body = $Body
        }
    }

    $RestMethod = @{
        Uri     = $Uri
        Method  = $Method
        Headers = $Headers
    }

    Write-Verbose ($RestMethod | ConvertTo-Json)
    $Response = Invoke-RestMethod @RestMethod -SkipHttpErrorCheck
    if ($Response.data) {
        $Response.data
    }
    else {
        $Response
    }
}
#EndRegion '.\Private\Invoke\Invoke-PublicApi.ps1' 44
#Region '.\Private\Invoke\Invoke-VaultApi.ps1' 0
function Invoke-VaultApi {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Endpoint,
        [ValidateSet('Get', 'Put', 'Post', 'Delete')]
        $Method = 'Get',
        $QueryParams = '',
        $Body = '',
        $ContentType = 'application/json'
    )

    if (!$script:BwRestServer.Hostname) {
        Start-BwRestServer | Out-Null
    }

    $Uri = 'http://{0}:{1}/{2}' -f $script:BwRestServer.Hostname, $script:BwRestServer.Port, $Endpoint

    if ($QueryParams -ne '') {
        $UriBuilder = [System.UriBuilder]$Uri
        $UriBuilder.Query = $QueryParams.ToString()
        $Uri = $UriBuilder.Uri.OriginalString  
    }

    Write-Verbose $Uri

    $Headers = @{
        'Accept' = 'application/json'
    }
    $RestMethod = @{
        Uri    = $Uri
        Method = $Method
    }

    if ($Method -eq 'Post' -or $Method -eq 'Put') {
        $headers.'Content-Type' = $ContentType
        if ($Body -ne '') {
            $RestMethod.Body = $Body
        }
        $RestMethod.Headers = $Headers
    }
    Write-Verbose ($Headers | ConvertTo-Json)
    Invoke-RestMethod @RestMethod -SkipHttpErrorCheck
}
#EndRegion '.\Private\Invoke\Invoke-VaultApi.ps1' 45
#Region '.\Private\Invoke\Invoke-VaultCli.ps1' 0
function Invoke-VaultCli {
    <#
    .SYNOPSIS
    Runs Bitwarden Cli commands
    
    .DESCRIPTION
    Calls bw command

    #>
    [cmdletbinding()]
    Param(
        $Arguments
    )

    $bw = Get-Command bw
    if (!$bw) {
        Write-Error 'Bitwarden CLI is not installed'
        return $false
    }

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $bw.Path
    $pinfo.RedirectStandardError = $false
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $Arguments
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    $stdout = $p.StandardOutput.ReadToEnd()
    $stdout | ConvertFrom-Json
}
#EndRegion '.\Private\Invoke\Invoke-VaultCli.ps1' 34
#Region '.\Public\Public API\Collections\Get-PublicCollections.ps1' 0
function Get-PublicCollections {
    [CmdletBinding()]
    Param(
        $Id = ''
    )
    $Endpoint = 'public/collections'

    if ($Id -ne '') {
        $Endpoint = '{0}/{1}' -f $Endpoint, $Id
    }
    Invoke-PublicApi -Endpoint $Endpoint
}
#EndRegion '.\Public\Public API\Collections\Get-PublicCollections.ps1' 13
#Region '.\Public\Public API\Connect\Connect-PublicApi.ps1' 0
function Connect-PublicApi {
    <#
    .SYNOPSIS
    Connects to Bitwarden Public API
    
    .DESCRIPTION
    Generates OAuth token to interact with public API
    
    .PARAMETER Credentials
    Client ID and Secret in PSCredential object
    
    .PARAMETER Server
    Bitwarden identity server hostname, default identity.bitwarden.com
    
    #>
    [CmdletBinding()]
    Param(
        [pscredential]$Credentials = (Get-Credential -Message 'Enter ClientID and Secret'),
        $Server = 'identity.bitwarden.com'
    )

    if ($Server -eq 'identity.bitwarden.com') {
        $ApiServer = 'api.bitwarden.com'
        $Uri = 'https://{0}/connect/token' -f $Server
    }
    else {
        $ApiServer = $Server
        $Uri = 'https://{0}/identity/connect/token' -f $Server
    }
    $AuthRequest = @{
        Uri         = $Uri
        ContentType = 'application/x-www-form-urlencoded' 
        Body        = @{
            grant_type    = 'client_credentials'
            scope         = 'api.organization'
            client_id     = $Credentials.GetNetworkCredential().UserName
            client_secret = $Credentials.GetNetworkCredential().Password
        }
    }
    
    $Response = Invoke-RestMethod @AuthRequest -Method Post -SkipHttpErrorCheck

    if ($Response) {
        Write-Verbose 'Connected to the Bitwarden Public API'
        $script:BwPublicApi = @{
            Token  = $Response.access_token
            Server = $ApiServer
        }
        $true
    }
    else {
        Write-Error $Response
        $false
    }
    
}
#EndRegion '.\Public\Public API\Connect\Connect-PublicApi.ps1' 57
#Region '.\Public\Public API\Events\Get-PublicEvents.ps1' 0
function Get-PublicEvents {
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
#EndRegion '.\Public\Public API\Events\Get-PublicEvents.ps1' 99
#Region '.\Public\Public API\Groups\Get-PublicGroupMemberIds.ps1' 0
function Get-PublicGroupMemberIds {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Id
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Id
    )

    $Endpoint = 'public/groups/{0}/member-ids' -f $Id
    Invoke-PublicApi -Endpoint $Endpoint
}
#EndRegion '.\Public\Public API\Groups\Get-PublicGroupMemberIds.ps1' 27
#Region '.\Public\Public API\Groups\Get-PublicGroups.ps1' 0
function Get-PublicGroups {
    [CmdletBinding()]
    Param(
        $Id = ''
    )
    $Endpoint = 'public/groups'
    if ($Id -ne '') {
        $Endpoint = '{0}/{1}' -f $Endpoint, $Id
    }
    Invoke-PublicApi -Endpoint $Endpoint
}
#EndRegion '.\Public\Public API\Groups\Get-PublicGroups.ps1' 12
#Region '.\Public\Public API\Members\Get-PublicMemberGroupIds.ps1' 0
function Get-PublicMemberGroupIds {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Id
    )

    $Endpoint = 'public/members/{0}/group-ids' -f $Id
    Invoke-PublicApi -Endpoint $Endpoint
}
#EndRegion '.\Public\Public API\Members\Get-PublicMemberGroupIds.ps1' 11
#Region '.\Public\Public API\Members\Get-PublicMembers.ps1' 0
function Get-PublicMembers {
    [CmdletBinding()]
    Param(
        $Id = ''
    )
    $Endpoint = 'public/members'
    if ($Id -ne '') {
        $Endpoint = '{0}/{1}' -f $Endpoint, $Id
    }
    Invoke-PublicApi -Endpoint $Endpoint
}
#EndRegion '.\Public\Public API\Members\Get-PublicMembers.ps1' 12
#Region '.\Public\Public API\Members\Send-PublicMemberInvite.ps1' 0
function Send-PublicMemberInvite {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Id
    )
    $Endpoint = 'public/members/{0}/reinvite' -f $id

    Invoke-PublicApi -Endpoint $Endpoint -Method Post
}
#EndRegion '.\Public\Public API\Members\Send-PublicMemberInvite.ps1' 11
#Region '.\Public\Vault API\Attachments & Fields\New-VaultAttachment.ps1' 0
function New-VaultAttachment {
    <#
    .SYNOPSIS
    Creates attachment in vault
    
    .DESCRIPTION
    POSTS multipart form data to /attachment
    
    .PARAMETER ItemId
    Item guid
    
    .PARAMETER Content
    String contents of file
    
    .PARAMETER FileName
    Name of file to create
    
    .PARAMETER Path
    Path to file instead of string contents
    
    #>
    [cmdletbinding(DefaultParameterSetName = 'Content')]
    Param (
        [parameter(Mandatory = $true)]
        $ItemId,

        [parameter(ParameterSetName = 'Content', Mandatory = $True)]
        [string]$Content,
        [parameter(ParameterSetName = 'Content', Mandatory = $True)]
        [string]$FileName,

        [validatescript({ Test-Path -PathType Leaf -Path $_ })]
        [parameter(ParameterSetName = 'File', Mandatory = $True)]
        [string]$Path
    )
    Process {
        $MultipartContent = [System.Net.Http.MultipartFormDataContent]::new()
        $FileHeader = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new('form-data')
        $FileHeader.Name = 'file'
        
        if ($Content) {
            $ByteArray = [System.Text.Encoding]::UTF8.GetBytes($Content)
            $FileStream = New-Object -TypeName 'System.IO.MemoryStream' -ArgumentList (, $ByteArray)
        }
        else {
            $FileName = Split-Path -Path $Path -Leaf
            $FileStream = [System.IO.FileStream]::new($Path, [System.IO.FileMode]::Open)
        }
        
        $FileContent = [System.Net.Http.StreamContent]::new($FileStream)
        $FileHeader.FileName = $FileName
        $FileContent.Headers.ContentDisposition = $fileHeader
        $FileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse('multipart/form-data')
        $MultipartContent.Add($FileContent)

        $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        $QueryParams.Add('itemid', $ItemId) | Out-Null

        try {
            $response = Invoke-VaultApi -Endpoint 'attachment' -QueryParams $QueryParams -Method Post -Body $MultipartContent -ContentType 'multipart/form-data'
        }
        catch {
            Write-Error "Upload attachment failed: $_"
            throw $_
        }
        finally {
            $fileStream.Close()
        }
        $response
    }
}
#EndRegion '.\Public\Vault API\Attachments & Fields\New-VaultAttachment.ps1' 72
#Region '.\Public\Vault API\Collections & Organizations\Get-VaultOrg.ps1' 0
function Get-VaultOrg {
    <#
    .SYNOPSIS
    Gets Bitwarden Vault Organizations
    
    .DESCRIPTION
    Calls /list/object/organizations 
    
    .PARAMETER Search
    Organization name to search for

    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [CmdletBinding()]
    Param(
        $Search = ''
    )
    $Endpoint = 'list/object/organizations'
    $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    if ($Search -ne '') {
        $QueryParams.Add('search', $Search) | Out-Null
    }
    $Request = Invoke-VaultApi -Endpoint $Endpoint -QueryParams $QueryParams

    if ($Request.success) {
        $Request.data.data
    }
    else {
        Write-Host $Request.message
        $Request.success
    }

}
#EndRegion '.\Public\Vault API\Collections & Organizations\Get-VaultOrg.ps1' 36
#Region '.\Public\Vault API\Items\Get-VaultItem.ps1' 0
function Get-VaultItem {
    <#
    .SYNOPSIS
    Gets Bitwarden Vault Items
    
    .DESCRIPTION
    Calls /list/object/items or /object/item/{id} to retrieve vault items
    
    .PARAMETER Id
    Item guid

    .PARAMETER AsCredential
    Returns login property as credential object
    
    .PARAMETER OrganizationId
    Organization Guid
    
    .PARAMETER CollectionId
    Collection Guid
    
    .PARAMETER FolderId
    Folder Guid
    
    .PARAMETER Search
    Search terms
    
    .PARAMETER Url
    Search for matching Urls
    
    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    Param(
        [Parameter(ParameterSetName = 'Single', Mandatory = $true)]
        $Id,
        [Parameter(ParameterSetName = 'Single')]
        [switch]$AsCredential,

        [Parameter(ParameterSetName = 'List')]
        $OrganizationId = '',
        [Parameter(ParameterSetName = 'List')]
        $CollectionId = '',
        [Parameter(ParameterSetName = 'List')]
        $FolderId = '',
        [Parameter(ParameterSetName = 'List')]
        $Search = '',
        [Parameter(ParameterSetName = 'List')]
        $Url = ''
    )

    switch ($PSCmdlet.ParameterSetName) {
        'List' {
            $QueryParams = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

            $Endpoint = 'list/object/items'
            if ($Search -ne '') {
                $QueryParams.Add('search', $Search) | Out-Null
            }
            if ($OrganizationId -ne '') {
                $QueryParams.Add('organizationid', $OrganizationId) | Out-Null
            }
            if ($CollectionId -ne '') {
                $QueryParams.Add('collectionid', $CollectionId) | Out-Null
            }
            if ($FolderId -ne '') {
                $QueryParams.Add('folderid', $FolderId) | Out-Null
            }
            if ($Url -ne '') {
                $QueryParams.Add('url', $Url) | Out-Null
            }

            $VaultApi = @{
                Endpoint    = $Endpoint
                QueryParams = $QueryParams
            }
        }   
        'Single' {
            $Endpoint = 'object/item/{0}' -f $Id

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
            if ($AsCredential) {
                [securestring]$Password = ConvertTo-SecureString -String $Request.data.login.password -AsPlainText -Force
                New-Object System.Management.Automation.PSCredential ($Request.data.login.username, $Password)
            }
            else {
                $Request.data
            }
        }
    }
    else {
        Write-Host $Request.message
        $Request.success
    }
}
#EndRegion '.\Public\Vault API\Items\Get-VaultItem.ps1' 109
#Region '.\Public\Vault API\Items\New-VaultItem.ps1' 0
function New-VaultItem {
    <#
    .SYNOPSIS
    Creates Bitwarden Vault Items
    
    .DESCRIPTION
    Calls POST /object/item to create vault items
    
    .PARAMETER Item
    Full item object in pscustoobject or json format

    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline, Mandatory = $true)]
        $Item
    )

    $ItemValid = $false

    if ($Item.GetType().Name -eq 'pscustomobject') {
        $Body = $Item | ConvertTo-Json -Depth 10
        $ItemValid = $true
    }
    elseif (Test-Json -Json $Item) {
        $Body = $Item
        $ItemValid = $true
    }
    
    if (-not $ItemValid) { 
        Write-Error "Input validation failed for 'Item', valid types are pscustomobject or JSON string and and id property must be specified"
        return
    }
    
    $VaultApi = @{
        Method   = 'POST'
        Endpoint = 'object/item'
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
#EndRegion '.\Public\Vault API\Items\New-VaultItem.ps1' 56
#Region '.\Public\Vault API\Items\Remove-VaultItem.ps1' 0
function Remove-VaultItem {
    <#
    .SYNOPSIS
    Deletes Bitwarden Vault Items
    
    .DESCRIPTION
    Calls DELETE /object/item/{id} to move items to the trash
    
    .PARAMETER Id
    Item guid
    
    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Id
    )
    
    $Endpoint = 'object/item/{0}' -f $Id

    $VaultApi = @{
        Method   = 'Delete'
        Endpoint = $Endpoint
        Body     = $Body
    }
    
    Invoke-VaultApi @VaultApi
}
#EndRegion '.\Public\Vault API\Items\Remove-VaultItem.ps1' 32
#Region '.\Public\Vault API\Items\Restore-VaultItem.ps1' 0
function Restore-VaultItem {
    <#
    .SYNOPSIS
    Restores deleted Bitwarden Vault Items
    
    .DESCRIPTION
    PUT /restore/item/{id} 
    
    .PARAMETER Id
    Item guid
    
    .LINK
    https://bitwarden.com/help/vault-management-api/

    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $Id
    )
    
    $Endpoint = 'restore/item/{0}' -f $Id

    $VaultApi = @{
        Method   = 'Post'
        Endpoint = $Endpoint
        Body     = $Body
    }
    
    Invoke-VaultApi @VaultApi
}
#EndRegion '.\Public\Vault API\Items\Restore-VaultItem.ps1' 32
#Region '.\Public\Vault API\Items\Update-VaultItem.ps1' 0
function Update-VaultItem {
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
        [Parameter(ValueFromPipeline, ParameterSetName = 'FullObject')]
        $Item
    )

    $ItemValid = $false

    if ($Item.GetType().Name -eq 'pscustomobject') {
        $Body = $Item | ConvertTo-Json -Depth 10
        $Id = $Item.id
        $ItemValid = $true
    }
    elseif (Test-Json -Json $Item) {
        $Object = $Item | ConvertFrom-Json
        $Id = $Object.id
        $Body = $Item
        $ItemValid = $true
    }
    
    if (-not $Id -or -not $ItemValid) { 
        Write-Error "Input validation failed for 'Item', valid types are pscustomobject or JSON string and and id property must be specified"
        return
    }

    $Endpoint = 'object/item/{0}' -f $Id

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
#EndRegion '.\Public\Vault API\Items\Update-VaultItem.ps1' 68
#Region '.\Public\Vault API\Lock & Unlock\Lock-Vault.ps1' 0
function Lock-Vault {
    <#
    .SYNOPSIS
    Locks Bitwarden Vault
    
    .DESCRIPTION
    Calls the /lock endpoint to clean up session

    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [cmdletbinding()]
    Param()
    $Request = Invoke-VaultApi -Endpoint 'lock' -Method Post
    [Environment]::SetEnvironmentVariable('BW_SESSION', $null)
    Write-Host $Request.data.title
}
#EndRegion '.\Public\Vault API\Lock & Unlock\Lock-Vault.ps1' 19
#Region '.\Public\Vault API\Lock & Unlock\Unlock-Vault.ps1' 0
function Unlock-Vault {
    <#
    .SYNOPSIS
    Unlocks Bitwarden Vault
    
    .DESCRIPTION
    Calls the /unlock endpoint to open the vault
    
    .PARAMETER Credential
    Vault credential object for the master password

    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [CmdletBinding()]
    Param(
        [PSCredential]$Credential = (Get-Credential -UserName 'Master Password' )
    )

    $Body = @{
        password = $Credential.GetNetworkCredential().Password 
    } | ConvertTo-Json -Compress

    $Request = Invoke-VaultApi -Endpoint 'unlock' -Method 'Post' -Body $Body
    
    # Set session variable for cli commands
    [Environment]::SetEnvironmentVariable('BW_SESSION', $Request.data.raw)

    Write-Host $Request.data.title
    $Request.success
}
#EndRegion '.\Public\Vault API\Lock & Unlock\Unlock-Vault.ps1' 33
#Region '.\Public\Vault API\Miscellaneous\Get-VaultStatus.ps1' 0
function Get-VaultStatus {
    <#
    .SYNOPSIS
    Returns REST server status
    
    .DESCRIPTION
    Calls /status endpoint to check if vault is logged in

    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [cmdletbinding()]
    Param()
    $Request = Invoke-VaultApi -Endpoint 'status'
    $Request.data.template
}
#EndRegion '.\Public\Vault API\Miscellaneous\Get-VaultStatus.ps1' 18
#Region '.\Public\Vault API\Miscellaneous\Get-VaultTemplate.ps1' 0
function Get-VaultTemplate {
    <#
    .SYNOPSIS
    Returns vault template object
    
    .DESCRIPTION
    Calls /template/{type} endpoint

    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('item', 'item.field', 'item.login', 'item.login.uri', 'item.card', 'item.identity', 'item.securenote', 'folder', 'collection', 'item-collections', 'org-collection')]
        $Type
    )

    #API method not available yet
    #Invoke-VaultApi -Endpoint ('template/{0}' -f $Type)

    $Arguments = @(
        'get'
        'template'
        $Type
    )

    Invoke-VaultCli -Arguments $Arguments
}
#EndRegion '.\Public\Vault API\Miscellaneous\Get-VaultTemplate.ps1' 31
#Region '.\Public\Vault API\Miscellaneous\New-Password.ps1' 0
function New-Password {
    <#
    .SYNOPSIS
    Creates a new password
    
    .DESCRIPTION
    Calls the /generate endpoint to create a new password
    
    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [cmdletbinding()]
    Param()
    $Request = Invoke-VaultApi -Endpoint 'generate'
    if ($Request) {
        $Request.data.data | ConvertTo-SecureString -AsPlainText -Force
    }
    else {
        Write-Error 'Unable to generate password'
    }
}
#EndRegion '.\Public\Vault API\Miscellaneous\New-Password.ps1' 23
#Region '.\Public\Vault API\Miscellaneous\Sync-Vault.ps1' 0
function Sync-Vault {
    <#
    .SYNOPSIS
    Syncs local Bitwarden vault with server
    
    .DESCRIPTION
    Calls /sync endpoint to synchronize local vault

    .LINK
    https://bitwarden.com/help/vault-management-api/
    
    #>
    [cmdletbinding()]
    Param()
    $Request = Invoke-VaultApi -Endpoint 'sync' -Method Post
    Write-Host $Request.data.title
    $Request
}
#EndRegion '.\Public\Vault API\Miscellaneous\Sync-Vault.ps1' 19
#Region '.\Public\Vault API\REST\Start-RestServer.ps1' 0
function Start-RestServer {
    <#
    .SYNOPSIS
    Starts Bitwarden REST server
    
    .DESCRIPTION
    Uses `bw serve` to run local REST server
    
    .PARAMETER Port
    Port to run server on, default 8087
    
    .PARAMETER Hostname
    Hostname to run server on, default localhost

    .LINK
    https://bitwarden.com/help/cli/#serve
    
    #>
    [cmdletbinding()]
    Param(
        $Port = 8087,
        $Hostname = 'localhost'
    )

    $RunningCli = Get-Process bw -ErrorAction SilentlyContinue
    if ($RunningCli -and -not $script:BwRestServer) {
        $RunningCli | Stop-Process
    }

    $Arguments = @(
        'serve'
        "--port $Port"
        "--hostname $Hostname"    
    )

    try {
        $bw = Get-Command bw
        if (!$bw) {
            Write-Error 'Bitwarden CLI is not installed'
            return $false
        }
        $Proc = Start-Process -FilePath $bw.Path -ArgumentList $Arguments -NoNewWindow -PassThru -ErrorAction Stop
        
        $OldProgPref = $global:ProgressPreference
        $global:ProgressPreference = 'SilentlyContinue'
        
        do {
            $VaultRest = Test-NetConnection -ComputerName $Hostname -Port $Port -InformationLevel Quiet -WarningAction SilentlyContinue
            Start-Sleep -Seconds 1
        } while (-not $VaultRest)

        $global:ProgressPreference = $OldProgPref

        $script:BwRestServer = [PSCustomObject]@{
            PID      = $Proc.Id
            Port     = $Port
            Hostname = $Hostname
        }
        $script:BwRestServer
    }
    catch {
        Write-Error 'Could not start REST server'
    }
}
#EndRegion '.\Public\Vault API\REST\Start-RestServer.ps1' 65
#Region '.\Public\Vault API\REST\Stop-RestServer.ps1' 0
function Stop-RestServer {
    <#
    .SYNOPSIS
    Stops Bitwarden REST server
    
    .DESCRIPTION
    Stops bw process if found running
    
    .LINK
    https://bitwarden.com/help/cli/#serve
    
    #>
    [cmdletbinding()]
    Param()
    
    $RunningCli = Get-Process bw -ErrorAction SilentlyContinue
    if ($RunningCli) {
        Write-Host 'Stopping REST server'
        $RunningCli | Stop-Process
    }
    
}
#EndRegion '.\Public\Vault API\REST\Stop-RestServer.ps1' 23
