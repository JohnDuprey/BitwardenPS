---
external help file: BitwardenPS-help.xml
Module Name: BitwardenPS
online version: https://bitwarden.com/help/vault-management-api/
schema: 2.0.0
---

# New-BwVaultItem

## SYNOPSIS
Creates Bitwarden Vault Items

## SYNTAX

```
New-BwVaultItem [-Item] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Calls POST /object/item to create vault items

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Item
Full item object in pscustoobject or json format

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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

