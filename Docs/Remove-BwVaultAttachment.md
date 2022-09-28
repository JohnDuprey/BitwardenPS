---
external help file: BitwardenPS-help.xml
Module Name: BitwardenPS
online version: https://bitwarden.com/help/vault-management-api/
schema: 2.0.0
---

# Remove-BwVaultAttachment

## SYNOPSIS
Deletes Bitwarden Vault Attachments

## SYNTAX

```
Remove-BwVaultAttachment [-Id] <Object> [-ItemId] <Object> [<CommonParameters>]
```

## DESCRIPTION
Calls DELETE /object/item/{id} to move items to the trash

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Id
Attachment id

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ItemId
Item Guid

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

