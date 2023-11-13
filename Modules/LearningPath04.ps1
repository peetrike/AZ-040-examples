<#
    .SYNOPSIS
        Learning Path 04 samples
    .DESCRIPTION
        This file contains sample commands from course AZ-040 for
        Learning Path 04 - Using PSProviders and PSDrives
    .LINK
        https://learn.microsoft.com/training/paths/work-powershell-providers-powershell-drives-windows-powershell/
    .LINK
        https://github.com/peetrike/AZ-040-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23AZ-040+%23M4
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Module 1: Using PSProviders

#region What are PowerShell providers?

Get-Help Providers -Category HelpFile -ShowWindow

#endregion

#region Different provider capabilities

Get-Command -Noun PSProvider

Get-PSProvider
Import-Module ActiveDirectory
Get-PSProvider

#endregion

#region Accessing provider help

Get-Help Function_ -Category HelpFile -ShowWindow
Get-Help Variable_ -Category HelpFile -ShowWindow

Get-Help about_*_provider

# https://learn.microsoft.com/sql/powershell/sql-server-powershell-provider

#endregion

#endregion


#region Module 2: Using PSDrives

#region What are PSDrives?

Get-PSDrive

#endregion

#region Cmdlets for using PSDrives

Get-Command -Noun PSDrive

Get-Help Locations -Category HelpFile -ShowWindow

Get-Command -Noun Item, ItemProperty*, Content, Location, Path
Get-Command -Noun ChildItem

Get-Help New-PSDrive -ShowWindow
    #Requires -Version 3
New-PSDrive -Name 's' -Root '\\server\share\folder' -PSProvider FileSystem -Credential 'domain\user' -Persist
    #Requires -Modules SmbShare
New-SmbMapping -LocalPath 's:' -RemotePath '\\lon-dc1\netlogon' -Persistent $false
Get-Help New-SmbMapping -Parameter UserName
Get-Help New-SmbMapping -Parameter Password

#endregion

#region Working with the file system

Get-Help FileSystem -Category HelpFile -ShowWindow

Get-Alias -Definition Get-ChildItem
Get-Alias -Definition *-Item

if (-not (Test-Path -Path Temp:\)) {
    New-PSDrive -Name Temp -Root $env:TEMP -PSProvider FileSystem
}
    # both directory separators are supported in all platforms
Get-ChildItem Temp:\
Get-ChildItem Temp:/

Get-ChildItem | Where-Object { $_.PSIsContainer }
    #Requires -Version 3.0
Get-ChildItem -Directory
Get-ChildItem -File

New-Item -ItemType Directory -Name uus
Get-ChildItem -Path . -Filter uus
Get-ChildItem -Path c:\ -Filter uus -Recurse -Directory

New-Item -ItemType File -Name minufail.txt -Path .\uus

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

    # for long path support
Get-Command -Module NTFSSecurity -Noun *2

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
# https://learn.microsoft.com/previous-versions/powershell/module/microsoft.powershell.security/about/about_certificate_provider?view=powershell-3.0#dynamic-parameters

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
Get-Command Remove-Alias -All

Get-Help Environment -Category HelpFile
Get-ChildItem Env:
$env:COMPUTERNAME

#endregion

#endregion


#region Lab

# https://github.com/MicrosoftLearning/AZ-040T00-Automating-Administration-with-PowerShell/blob/master/Instructions/Labs/LAB_04_Using_PSProviders_and_PSDrives.md

#endregion
