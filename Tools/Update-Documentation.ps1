Build-Module
Remove-Module BitwardenPS
Import-Module .\Output\BitwardenPS\BitwardenPS.psd1
New-MarkdownHelp -Module BitwardenPS -OutputFolder .\Docs\ -Force