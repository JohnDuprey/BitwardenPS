---
external help file: BitwardenPS-help.xml
Module Name: BitwardenPS
online version: https://bitwarden.com/help/vault-management-api/
schema: 2.0.0
---

# New-BwVaultAttachment

## SYNOPSIS
Creates attachment in vault

## SYNTAX

### Content (Default)
```
New-BwVaultAttachment -ItemId <Object> -Content <String> -FileName <String> [<CommonParameters>]
```

### File
```
New-BwVaultAttachment -ItemId <Object> -Path <String> [<CommonParameters>]
```

## DESCRIPTION
POSTS multipart form data to /attachment

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ItemId
Item guid

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Content
String contents of file

```yaml
Type: String
Parameter Sets: Content
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileName
Name of file to create

```yaml
Type: String
Parameter Sets: Content
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path to file instead of string contents

```yaml
Type: String
Parameter Sets: File
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
