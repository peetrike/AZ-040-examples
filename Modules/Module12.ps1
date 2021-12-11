<#
    .SYNOPSIS
        Module 12 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 12 - Using advanced Windows PowerShell techniques
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M12
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Creating profile scripts

#region What is a profile script?

Get-Help about_Profiles -ShowWindow

    # this doesn't load profile scirpts
powershell.exe -noprofile
pwsh -NoProfile

#endregion

#region Profile script locations

$profile

$profile | Get-Member -MemberType NoteProperty
$profile.CurrentUserCurrentHost
$profile.AllUsersAllHosts

#endregion

#region Profile script security concerns

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_profiles#profiles-and-execution-policy

Get-Help about_Execution_Policies -ShowWindow

# https://docs.microsoft.com/powershell/scripting/learn/remoting/powershell-remoting-faq#where-are-my-profiles-

#endregion

#endregion


#region Lesson 2: Using advanced techniques

#region Passwords and secure strings
$password = Get-RandomString -Length 15

$SecurePassword = $password | ConvertTo-SecureString -AsPlainText -Force
$SecurePassword
$SecurePassword | Get-Member

$securePassword2 = Read-Host 'Sisesta parool' -AsSecureString

$securePassword2 | ConvertFrom-SecureString | Out-File parool.txt
$securePassword3 = Get-Content parool.txt | ConvertTo-SecureString

$credential = New-Object -TypeName pscredential -ArgumentList 'adatum\user', $SecurePassword
$credential

$credential | Export-Clixml -Path credential.xml
$savedCredential = Import-Clixml -Path credential.xml
Invoke-Item credential.xml

    # PowerShell 7+
Find-Module Microsoft.PowerShell.SecretManagement -Repository PSGallery
Find-Module -Tag SecretManagement -Repository PSGallery

    #Requires -Modules Microsoft.PowerShell.SecretManagement
Get-SecretInfo -Name test
$Credential = Get-Secret -Name test
$Cred2 = Get-Credential -UserName 'domain\test2' -Message 'Enter Credential for saving'
Set-Secret -Name Temporary -Secret $Cred2
$secretInfo = Get-SecretInfo -Name Temporary
Remove-Secret -Name Temporary -Vault $secretInfo.VaultName
#endregion

#region Array operators

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_comparison_operators#containment-operators

1 -in 1, 2, 3, 4
1 -in 2, 3, 4, 5

1, 2, 3, 4 -contains 1
2, 3, 4, 5 -contains 1

Get-Process notepad | Stop-Process
Start-Process notepad
$p = Get-Process notepad
    # this doesn't work
$p -in (Get-Process notepad)
(Get-Process) -contains $p
    # this works
$p.Id -in (Get-Process notepad).Id
$p.Id -in (Get-Process notepad | Select-Object -ExpandProperty Id)

#endregion

#region Regular expressions

Get-Help Regular -ShowWindow

$Matches
'mis kinni ei jää, saab kinni löödud' -match 'kinni'
$Matches
'mis kinni ei jää, saab kinni löödud' -match '.*kinni.*'
$Matches

'Windows PowerShell', 'Command Prompt' -match 'Power.*'
$Matches

'Windows PowerShell', 'Command Prompt' | Select-String -Pattern 'Power.*'
Select-String -Pattern 'Module 12' -Path module*.ps1 -List

    # https://docs.microsoft.com/dotnet/api/system.text.regularexpressions.regex
$expression = [regex] 'kinni'
$expression.Match('mis kinni ei jää, saab kinni löödud')
$expression.Matches('mis kinni ei jää, saab kinni löödud')

$string = 'The last logged on user was CONTOSO\jsmith'

$string -match '.+was (.+)'
$Matches
$Matches.1

$string -match 'was (?<domain>\w+)\\(?<user>\w+)'
$Matches
$Matches.user

#endregion

#region The format operator

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_operators#format-operator--f
# https://docs.microsoft.com/dotnet/standard/base-types/formatting-types

'Money: {0:c}' -f 1.24
'Percent {0:p}' -f 0.36
'Hex: {0:x}' -f 349
'Hex: {0:X}' -f 349
'Hex: {0:X4}' -f 349
'Hex: 0x{0:X4}' -f 349

'Custom: {0:00.00}' -f 3.2
'Custom: {0:##.00}' -f 3.2
'Custom: {0,10:f2}' -f 1.0782345

'Sortable date: {0:s}' -f [datetime]::Now
'Sortable date: ' + [datetime]::Now.ToString('s')
'ISO 8601 format: {0:o}' -f [datetime]::Now

#endregion

#region Running external commands

get-command ping
get-command sc.exe

Get-Help about_Parsing -ShowWindow
# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_special_characters#stop-parsing-token---

bcdedit.exe --% -default {current}

#endregion

#region Working with NTFS permissions

Get-Command -Noun Acl
$acl = get-acl -Path module12.ps1
$acl
$acl.Access

Get-Help Set-Acl -ShowWindow

Find-Module NTFSSecurity -Repository PSGallery

Get-NTFSAccess -Path module12.ps1
Get-NTFSAudit -Path module12.ps1

Get-Help Add-NTFSAccess -ShowWindow
Get-Help Set-NTFSOwner -ShowWindow
Get-Help Set-NTFSInheritance -ShowWindow
Get-Help Remove-NTFSAccess -ShowWindow

#endregion

#region Logging activity

Get-Help about_Logging -ShowWindow
    # PowerShell 6+
Get-Help about_Logging_Windows -ShowWindow

$RegPath = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
if (Test-Path -Path $RegPath) {
    Get-ItemProperty -Path $RegPath
}
Get-Help Group_Policy -ShowWindow

Get-Command -Noun Transcript
Get-Help Start-Transcript -ShowWindow

Get-Help about_History -ShowWindow
Get-Command -Noun History

#endregion

#region Extra: Logging from scripts

Get-Command -noun WinEvent
# https://peterwawa.wordpress.com/2015/02/26/powershell-ja-sndmuste-logid/

Find-Module -Command Write-Log -Repository PSGallery
Find-Module PSFramework -Repository PSGallery

# https://psframework.org/documentation/documents/psframework/logging.html
Get-Help Write-PSFMessage -ShowWindow

#region Preparation
$paramSetPSFLoggingProvider = @{
    Name         = 'logfile'
    InstanceName = 'Course 10961'
    FilePath     = Join-Path $pwd 'PsfMessage.log'
    Enabled      = $true
}
Set-PSFLoggingProvider @paramSetPSFLoggingProvider
#endregion

Write-PSFMessage 'Teade logisse'
Write-PSFMessage 'Teade ekraanile' -Level Host
Get-PSFMessage

code -r Write-Log.ps1
#endregion

#endregion
