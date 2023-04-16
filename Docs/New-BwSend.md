---
external help file: BitwardenPS-help.xml
Module Name: BitwardenPS
online version: https://bitwarden.com/help/vault-management-api/
schema: 2.0.0
---

# New-BwSend

## SYNOPSIS
Creates Bitwarden Send

## SYNTAX

### SendParams (Default)
```
New-BwSend -Name <Object> [-Notes <Object>] [-SendPass <Object>] -Text <Object> [-Days <Int32>]
 [-MaxAccessCount <Int32>] [-HideText] [-HideEmail] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### FullObject
```
New-BwSend -Send <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Calls POST /object/send to create a new send

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Name
{{ Fill Name Description }}

```yaml
Type: Object
Parameter Sets: SendParams
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notes
{{ Fill Notes Description }}

```yaml
Type: Object
Parameter Sets: SendParams
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SendPass
{{ Fill SendPass Description }}

```yaml
Type: Object
Parameter Sets: SendParams
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text
{{ Fill Text Description }}

```yaml
Type: Object
Parameter Sets: SendParams
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Days
{{ Fill Days Description }}

```yaml
Type: Int32
Parameter Sets: SendParams
Aliases:

Required: False
Position: Named
Default value: 7
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxAccessCount
{{ Fill MaxAccessCount Description }}

```yaml
Type: Int32
Parameter Sets: SendParams
Aliases:

Required: False
Position: Named
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -HideText
{{ Fill HideText Description }}

```yaml
Type: SwitchParameter
Parameter Sets: SendParams
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -HideEmail
{{ Fill HideEmail Description }}

```yaml
Type: SwitchParameter
Parameter Sets: SendParams
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Send
{{ Fill Send Description }}

```yaml
Type: Object
Parameter Sets: FullObject
Aliases:

Required: True
Position: Named
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

