---
external help file: Bitwarden-help.xml
Module Name: Bitwarden
online version:
schema: 2.0.0
---

# Connect-BwPublicApi

## SYNOPSIS
Connects to Bitwarden Public API

## SYNTAX

```
Connect-BwPublicApi [[-Credentials] <PSCredential>] [[-Server] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Generates OAuth token to interact with public API

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Credentials
Client ID and Secret in PSCredential object

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Get-Credential -Message 'Enter ClientID and Secret')
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
Bitwarden identity server hostname, default identity.bitwarden.com

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Identity.bitwarden.com
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
