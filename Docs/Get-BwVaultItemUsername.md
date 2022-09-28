---
external help file: BitwardenPS-help.xml
Module Name: BitwardenPS
online version: https://bitwarden.com/help/vault-management-api/
schema: 2.0.0
---

# Get-BwVaultItemUsername

## SYNOPSIS
Returns username of a vault item

## SYNTAX

```
Get-BwVaultItemUsername [-Id] <Object> [<CommonParameters>]
```

## DESCRIPTION
Calls /object/username/{id} endpoint to retrieve username

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Id
Item guid

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://bitwarden.com/help/vault-management-api/](https://bitwarden.com/help/vault-management-api/)

