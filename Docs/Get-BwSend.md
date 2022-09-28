---
external help file: BitwardenPS-help.xml
Module Name: BitwardenPS
online version: https://bitwarden.com/help/vault-management-api/
schema: 2.0.0
---

# Get-BwSend

## SYNOPSIS
Gets Bitwarden Sends

## SYNTAX

### List (Default)
```
Get-BwSend [-Search <Object>] [<CommonParameters>]
```

### Single
```
Get-BwSend -Id <Object> [<CommonParameters>]
```

## DESCRIPTION
Calls /list/object/send or /object/send/{id}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Id
Guid of Collection

```yaml
Type: Object
Parameter Sets: Single
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Search
Search parameters

```yaml
Type: Object
Parameter Sets: List
Aliases:

Required: False
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

[https://bitwarden.com/help/vault-management-api/](https://bitwarden.com/help/vault-management-api/)

