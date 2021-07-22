<#
    .SYNOPSIS
        Module 01 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 01 - Getting started with Windows PowerShell
    .NOTES
        Contact: Meelis Nigols
        e-mai/skype: meelisn@outlook.com
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M1
    .LINK
        https://peterwawa.wordpress.com/tag/powershell/
    .LINK
        https://aka.ms/pskoans
    .LINK
        https://docs.microsoft.com/powershell/#community-resources
#>


#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1 - Overview and background of Windows PowerShell

#region PowerShell overview

# https://docs.microsoft.com/powershell/scripting/overview

get-help Parsing -ShowWindow

#endregion

#region PowerShell versions

# https://docs.microsoft.com/previous-versions/powershell/scripting/overview
# https://docs.microsoft.com/powershell/scripting/windows-powershell/wmf/overview
# https://docs.microsoft.com/powershell/scripting/windows-powershell/whats-new/what-s-new-in-windows-powershell-50

Get-Help PowerShell -Category HelpFile

# https://docs.microsoft.com/powershell/scripting/whats-new/what-s-new-in-powershell-71

# https://docs.microsoft.com/powershell/scripting/install/powershell-in-docker

#endregion

#region PowerShell vs. operating system

# https://docs.microsoft.com/powershell/windows/get-started
Get-Command Resolve-DnsName
Get-Command Get-ScheduledTask
Get-Command Get-NetAdapter
Get-Command Get-VpnConnection
Get-Module ActiveDirectory -ListAvailable
Get-Module Dism -ListAvailable

$PSHOME
Get-ChildItem (Join-Path $PSHOME Modules)

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_special_characters#stop-parsing-token---
bcdedit.exe --% /enum {current}

#endregion

#region Two host applications

# https://docs.microsoft.com/powershell/scripting/getting-started/fundamental/windows-powershell-integrated-scripting-environment--ise-

    # Powershell ISE difference: next line doesn't show one screen at time
Get-Command | more

# Visual Studio Code: http://code.visualstudio.com
# https://docs.microsoft.com/powershell/scripting/dev-cross-plat/vscode/using-vscode

#endregion

#region Working in mixed-version environments

    # Powershell 2+
$PSVersionTable
    # Windows PowerShell ( < 6 )
$PSVersionTable.BuildVersion
    # PowerShell 5.1+
$PSVersionTable.PSEdition
$PSEdition
    # PowerShell 6+
Get-Help Editions -Category HelpFile -ShowWindow
    # PowerShell Core
$PSVersionTable.OS

# look also https://peterwawa.wordpress.com/2017/09/22/mis-keskkonnas-mu-skript-jookseb/

# https://docs.microsoft.com/powershell/scripting/windows-powershell/starting-the-windows-powershell-2.0-engine
Start-Process -FilePath powershell.exe -ArgumentList '-version 2'

#endregion

#region Precautions when opening Windows PowerShell

# https://docs.microsoft.com/powershell/scripting/setup/starting-windows-powershell
# https://docs.microsoft.com/powershell/scripting/learn/ps101/01-getting-started

    # PowerShell < 6
Get-Help PowerShell_exe -ShowWindow
    # PowerShell 6+
Get-Help pwsh -ShowWindow

Start-Process -Verb RunAs -FilePath powershell.exe
Start-Process -Verb RunAs -FilePath pwsh

#endregion

#region Configuring the console

    # Windows Terminal
# https://docs.microsoft.com/windows/terminal/
# https://github.com/microsoft/terminal

# https://docs.microsoft.com/typography/font-list/consolas
# https://www.programmingfonts.org/
#endregion

#region Configuring the ISE

# https://docs.microsoft.com/powershell/scripting/dev-cross-plat/vscode/how-to-replicate-the-ise-experience-in-vscode

#endregion

#endregion


#region Lesson 2: Understanding command syntax

#region Cmdlet structure

Get-Command -CommandType Cmdlet -TotalCount 20
Get-Command | Measure-Object

Get-Verb

Get-Command Get-VM
Get-Command Get-Mailbox
Get-Command Get-ADUser
Get-Command -Noun *User -Verb Get

Find-Module -Command Get-User -Repository PSGallery

#endregion

#region Parameters

Get-Help about_Parameters -ShowWindow

Get-Command Get-Command | Get-Member
(Get-Command Get-Command).Parameters
Get-Help Get-Command -Parameter * | Select-Object Name, Required, Type

Get-Help Get-Process -ShowWindow
Get-Help Get-Process -Parameter *
Get-Help Get-Process -Parameter Id

#endregion

#region Tab completion

# https://docs.microsoft.com/powershell/scripting/learn/using-tab-expansion

Get-Help PSReadLine -Category HelpFile -ShowWindow
Get-Command -Module PSReadLine

Get-PSReadLineKeyHandler -Chord 'tab'
Get-PSReadLineKeyHandler -Chord 'ctrl- '

Get-Module PSReadLine
Find-Module PSReadLine -AllowPrerelease

#endregion

#region Using Get-Help

Get-Help Get-Help

Get-Help Get-Help -Examples
Get-Help Get-Help -Parameter *
Get-Help Get-Help -Detailed
Get-Help Get-Help -Full
Get-Help Get-Process -ShowWindow
Get-Help Get-Process -Online

#endregion

#region Interpreting the help syntax

Get-Help Command_Syntax -Category HelpFile -ShowWindow
# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_command_syntax#parameters

Get-Help Get-Command | Select-Object -ExpandProperty Syntax
Get-Command Get-Command | Select-Object -ExpandProperty ParameterSets | Format-Table

Get-Help Get-WinEvent
Get-WinEvent Application -MaxEvents 5
Get-WinEvent -LogName Application -MaxEvents 5

Get-Help dir
Get-ChildItem . *.ps1
Get-ChildItem -Path . -Filter *.ps1

Get-Help Test-Connection -ShowWindow
    # up to PowerShell 5.1
Test-Connection .
    # PowerShell 6+
Test-Connection -TargetName $env:COMPUTERNAME

Test-Connection -ComputerName $env:COMPUTERNAME
Test-Connection $env:COMPUTERNAME -cou 1
Test-Connection $env:COMPUTERNAME -Quiet
Get-Help Test-Connection -Parameter Quiet

#endregion

#region Updating help

Get-Command -Noun help
Get-Help Update-Help

# Requires -RunAsAdministrator
Update-Help -Module VPNClient

# PowerShell 6+ allows to specify scope for Update-Help
Get-Help Update-Help -Parameter Scope

#endregion

#region About files

Get-Help -Category HelpFile
Get-Help about_
Get-Help about_quoting -ShowWindow
Get-Help quoting

#endregion

#endregion


#region Lesson 3: Finding commands

#region What are modules?

Get-Help Modules -Category HelpFile -ShowWindow

Get-Module
Get-Module -ListAvailable

$env:PSModulePath
$env:PSModulePath -split [io.path]::PathSeparator

    # PowerShell 3+
Get-ADUser
    # PowerShell 2.0
Import-Module ActiveDirectory
Get-ADUser

#endregion

#region Finding cmdlets

Get-Command -Module VpnClient
Get-Command -Module VpnClient | Measure-Object
Get-Command -Noun VpnConnection
Get-VpnConnection

Get-Command -noun Service
Get-Service BITS
Stop-Service BITS

Get-Command -Noun *user -Verb Get -CommandType Cmdlet

Get-Help Command_Precedence -ShowWindow

Get-Command | Group-Object -Property CommandType

#endregion

#region What are aliases?

Get-Help aliases -Category HelpFile

dir
ls

Get-Command -Noun Alias
get-help Get-Alias -ShowWindow

Get-Alias dir
Get-Alias -Definition Get-ChildItem
Get-Alias -Definition Get-Alias
Get-Alias
Get-Command -CommandType Alias

    # command parameter aliases
Get-Help dir -Parameter Recurse
(Get-Command Get-ChildItem).Parameters.Recurse
(Get-Command Get-ChildItem).Parameters.Recurse.aliases
dir -s

#endregion

#region Using Show-Command

Get-Help Show-Command -ShowWindow

Show-Command -Name Get-Process
Show-Command

#endregion

#endregion
