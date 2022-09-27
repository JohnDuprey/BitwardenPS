---
external help file: Bitwarden-help.xml
Module Name: Bitwarden
online version: https://bitwarden.com/help/vault-management-api/
schema: 2.0.0
---

# Update-BwVaultItem

## SYNOPSIS
Updates Bitwarden Vault Items

## SYNTAX

### BodyUpdate (Default)
```
Update-BwVaultItem -Id <Object> [-Item <Object>] [<CommonParameters>]
```

### FullObject
```
Update-BwVaultItem [-Item <Object>] [<CommonParameters>]
```

## DESCRIPTION
PUT /object/item/{id}

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
Parameter Sets: BodyUpdate
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Item
Full item object in pscustoobject or json format

```yaml
Type: Object
Parameter Sets: BodyUpdate
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Object
Parameter Sets: FullObject
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

