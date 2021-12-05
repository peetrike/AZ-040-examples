<#
    .SYNOPSIS
        Module 05 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 05 - Using PSProviders and PSDrives
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M5
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Using PSProviders

Get-Help Providers -Category HelpFile -ShowWindow

Get-Command -Noun PSProvider

Get-PSProvider
Import-Module ActiveDirectory
Get-PSProvider

Get-Help Function_ -Category HelpFile -ShowWindow
Get-Help Variable_ -Category HelpFile -ShowWindow

Get-Help about_*_provider

#endregion


#region Lesson 2: Using PSDrives

#region What are PSDrives?

Get-PSDrive

#endregion

#region Cmdlets for using PSDrives

Get-Command -Noun PSDrive

Get-Help Locations -Category HelpFile -ShowWindow

Get-Command -Noun Item, ItemProperty*, Content, Location
Get-Command -Noun ChildItem
Get-Alias -Definition Get-ChildItem

Get-Help New-PSDrive -ShowWindow
    #Requires -Version 3
New-PSDrive -Name 's' -Root '\\server\share\folder' -Persist -Credential 'domain\user' -PSProvider FileSystem
    #Requires -Modules SmbShare
New-SmbMapping -LocalPath 's:' -RemotePath '\\lon-dc1\netlogon' -Persistent $false
Get-Help New-SmbMapping -Parameter UserName
Get-Help New-SmbMapping -Parameter Password

#endregion

#region Working with the file system

Get-Help FileSystem -Category HelpFile -ShowWindow

if (-not (Test-Path -Path temp:\)) {
    New-PSDrive -Name Temp -Root $env:TEMP -PSProvider FileSystem -Persist
}
Get-ChildItem temp:\

Get-ChildItem | Where-Object { $_.PSIsContainer }
    #Requires -Version 3.0
Get-ChildItem -Directory
Get-ChildItem -File

New-Item -ItemType Directory -Name uus
Get-ChildItem -Path . -Filter uus

New-Item -ItemType File -Name minufail.txt -Path uus

    #Requires -Version 5.0
New-Item -Name kaust -ItemType Junction -Target uus

Set-Location kaust
New-Item -ItemType HardLink -Name teinefail.txt -Value ..\uus\minufail.txt
    #Requires -RunAsAdministrator
New-Item -ItemType SymbolicLink -Name link.txt -Value minufail.txt

# https://peterwawa.wordpress.com/2013/04/10/ntfs-alternate-data-stream/
Get-ChildItem -Recurse | Unblock-File

    #Requires -Version 5.0
Get-Command -Noun Archive

#endregion

#region Working with the registry

Get-Help Registry -Category HelpFile -ShowWindow

$regPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion'

Test-Path -Path $regPath
Set-Location -Path $regPath
Get-ChildItem

Get-ItemProperty -Path WSMan
    #Requires -Version 5
Get-ItemPropertyValue -Path WSMan -Name StackVersion

#endregion

#region Working with certificates

Get-Help Certificate -Category HelpFile -ShowWindow

Get-ChildItem -Path Cert:\LocalMachine\My
Get-ChildItem -Path Cert:\CurrentUser\My\ -CodeSigningCert

Get-Command Test-Certificate
Get-Command -Module pki

Set-Location Cert:\LocalMachine\My
    #Requires -Version 3.0
Get-ChildItem -ExpiringInDays 60 | Test-Certificate -User
Get-ChildItem -Path Cert:\LocalMachine\my | Select-Object not*, haspr*
# https://docs.microsoft.com/previous-versions/powershell/module/microsoft.powershell.security/about/about_certificate_provider?view=powershell-3.0#dynamic-parameters

Get-ChildItem -SSLServerAuthentication
Get-ChildItem -Path Cert:\ -CodeSigningCert -Recurse

#endregion

#region Working with other PSDrives

Get-PSDrive

Get-Help wsman -Category HelpFile -ShowWindow

Get-Service WinRM # must be running
Get-ChildItem WSMan:\localhost\Client\
Get-Item WSMan:\localhost\Client\TrustedHosts
    #Requires -RunAsAdministrator
Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'server1,server2'

Get-Command -Noun Alias
Get-Help Alias_ -Category HelpFile -ShowWindow
New-Alias -Name minu -Value 'miski asi'
Get-ChildItem Alias:\minu | Remove-Item

Get-Help Environment -Category HelpFile
Get-ChildItem Env:
$env:COMPUTERNAME

#endregion

#endregion
