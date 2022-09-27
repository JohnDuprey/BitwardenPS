---
external help file: Bitwarden-help.xml
Module Name: Bitwarden
online version: https://bitwarden.com/help/vault-management-api/
schema: 2.0.0
---

# Unlock-BwVault

## SYNOPSIS
Unlocks Bitwarden Vault

## SYNTAX

```
Unlock-BwVault [[-Credential] <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Calls the /unlock endpoint to open the vault

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Credential
Vault credential object for the master password

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Get-Credential -UserName 'Master Password' )
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

