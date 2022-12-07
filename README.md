# BitwardenPS Module
[![BitwardenPSDownloads]][BitwardenPSGallery] ![BitwardenPSBuild]

This module interacts with the Bitwarden Public API and the Vault API.

# Instructions

### Prerequisites

- PowerShell 7 or later
- Bitwarden cli installed and in your $PATH
  - Install with Chocolatey: `choco install bitwarden-cli`
- [Logged in account on cli](https://bitwarden.com/help/cli/#log-in)

#### Module Installation ([PowerShell Gallery](https://www.powershellgallery.com/packages/BitwardenPS))

```powershell
Install-Module BitwardenPS
```

### Reference

- [Vault API](https://bitwarden.com/help/vault-management-api/)
- [Public API](https://bitwarden.com/help/api/)
- [Full Cmdlet Docs](/Docs/)

# Examples

### Unlock Vault

```powershell
Unlock-BwVault

PowerShell credential request
Enter your credentials.
Password for user Master Password: ***********

Your vault is now unlocked!
True
```

### Search for Vault Item

```powershell
Get-BwVaultItem -Search Test
object         : item
id             : someguid
organizationId :
folderId       :
type           : 1
reprompt       : 0
name           : Item testing
notes          : this is a test
favorite       : False
login          : @{uris=System.Object[]; username=testuser; password=test; totp=JBSWY3DPEHPK3PXP; passwordRevisionDate=}
collectionIds  : {}
revisionDate   : 9/27/2022 11:57:52 AM
deletedDate    :
```

### Create a new Send

```powershell
New-BwSend -Name Test -Notes "This is a test" -Text "Super secret text" -Days 1 -HideEmail

object         : send
id             : 378ffa47-2e46-48dd-ad4b-af1d01841e75
accessId       : R_qPN0Yu3UitS68dAYQedQ
accessUrl      : https://vault.bitwarden.com/#/send/R_qPN0Yu3UitS68dAYQedQ/uuNb2Si7b6JiZU_IDL2Ohw
name           : Test
notes          : This is a test
key            : uuNb2Si7b6JiZU/IDL2Ohw==
type           : 0
maxAccessCount : 3
accessCount    : 0
revisionDate   : 9/27/2022 11:33:05 PM
deletionDate   : 9/28/2022 11:33:03 PM
expirationDate : 9/28/2022 11:33:03 PM
passwordSet    : False
disabled       : False
hideEmail      : True
text           : @{text=Super secret text; hidden=False}

```

# Notes

This module is a work in progress. Pull requests are welcome.

<!-- References -->
[BitwardenPSDownloads]: https://img.shields.io/powershellgallery/dt/BitwardenPS
[BitwardenPSGallery]: https://www.powershellgallery.com/packages/BitwardenPS/
[BitwardenPSBuild]: https://img.shields.io/github/workflow/status/johnduprey/BitwardenPS/Check%20and%20Publish/main