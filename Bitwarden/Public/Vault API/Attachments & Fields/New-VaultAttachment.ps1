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
