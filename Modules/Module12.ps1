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

get-help about_profiles -ShowWindow

$profile

$profile | Get-Member -MemberType NoteProperty
$profile.CurrentUserCurrentHost
$profile.AllUsersAllHosts

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
Find-Module Microsoft.PowerShell.SecretManagement
#endregion

#region Array operators

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_comparison_operators#containment-operators

#endregion

#region Regular expressions

Get-Help regular -ShowWindow

#endregion

#region The format operator

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_operators#format-operator--f

#endregion

#region Running external commands

get-command ping
get-command sc.exe

Get-Help about_Parsing -ShowWindow

bcdedit.exe --% -default {current}

#endregion

#region Working with NTFS permissions

Get-Command -Noun Acl

Find-Module NTFSSecurity

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


Get-Command -noun WinEvent
# https://peterwawa.wordpress.com/2015/02/26/powershell-ja-sndmuste-logid/

#endregion

#endregion
