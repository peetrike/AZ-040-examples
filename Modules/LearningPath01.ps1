﻿<#
    .SYNOPSIS
        Learning Path 01 samples
    .DESCRIPTION
        This file contains sample commands from course AZ-040 for
        Learning Path 01 - Getting started with Windows PowerShell
    .NOTES
        Contact: Meelis Nigols
        e-mail/skype: meelisn@outlook.com
    .LINK
        https://learn.microsoft.com/training/paths/get-started-windows-powershell/
    .LINK
        https://learn.microsoft.com/training/courses/az-040t00
    .LINK
        https://microsoftlearning.github.io/AZ-040T00-Automating-Administration-with-PowerShell/
    .LINK
        https://github.com/peetrike/AZ-040-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23AZ-040+%23M1
    .LINK
        https://peterwawa.wordpress.com/tag/powershell/
    .LINK
        https://aka.ms/pskoans
    .LINK
        https://learn.microsoft.com/training/browse/?terms=PowerShell
    .LINK
        https://learn.microsoft.com/powershell/#community-resources
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Module 1 - Overview of Windows PowerShell

#region PowerShell Introduction

# https://microsoft.com/powershell
# https://learn.microsoft.com/powershell/scripting/overview

Get-Help Parsing -ShowWindow

# https://learn.microsoft.com/powershell/scripting/windows-powershell/starting-windows-powershell

#endregion

#region PowerShell versions

# https://learn.microsoft.com/powershell/scripting/what-is-windows-powershell

# https://learn.microsoft.com/powershell/scripting/windows-powershell/wmf/overview
# https://learn.microsoft.com/previous-versions/powershell/scripting/windows-powershell/whats-new/what-s-new-in-windows-powershell-50
# https://learn.microsoft.com/previous-versions/powershell/scripting/windows-powershell/wmf/whats-new/release-notes
Get-Help _PowerShell -Category HelpFile

# https://learn.microsoft.com/powershell/scripting/whats-new/what-s-new-in-powershell-75

# https://learn.microsoft.com/powershell/scripting/install/powershell-in-docker

# https://learn.microsoft.com/powershell/scripting/install/powershell-support-lifecycle
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_update_notifications

#endregion

#region Extra: PowerShell vs. operating system

# https://support.microsoft.com/windows/fdb690cf-876c-d866-2124-21b6fb29a45f

# https://learn.microsoft.com/powershell/windows/get-started
Get-Command Resolve-DnsName
Get-Command Get-ScheduledTask
Get-Command Get-NetAdapter
Get-Command Get-VpnConnection
Get-Module ActiveDirectory -ListAvailable
Get-Module Dism -ListAvailable

$PSHOME
$env:PSModulePath -split [IO.Path]::PathSeparator | Where-Object { $_ -like "$PSHOME*" }
$env:PSModulePath -split [IO.Path]::PathSeparator | Where-Object { $_ -like "$env:windir*" }
Get-ChildItem (Join-Path $PSHOME Modules)

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_special_characters#stop-parsing-token---
bcdedit.exe --% /enum {current}

#endregion

#region PowerShell applications

Get-Command powershell
Get-Command pwsh
Get-Command ise
Get-Command code

Get-Command -Noun Transcript

Get-Command -Noun History
Get-Help Get-History -ShowWindow
    #Requires -Modules PSReadLine
Get-Help PSReadLine -Category HelpFile -ShowWindow
Get-PSReadLineOption | Select-Object *history*
Get-PSReadLineKeyHandler -Chord 'UpArrow', 'DownArrow', 'F8', 'Shift-F8', 'F2'

# https://learn.microsoft.com/powershell/scripting/windows-powershell/ise/introducing-the-windows-powershell-ise

    # Powershell ISE difference: next line doesn't show one screen at time
Get-Command | more

#endregion

#region Extra: Working in mixed-version environments

    #Requires -Version 2
$PSVersionTable
$Host.Version

    # Windows PowerShell ( < 6 )
$PSVersionTable.BuildVersion
    #Requires -Version 5.1
$PSVersionTable.PSEdition
$PSEdition
    #Requires -Version 6
Get-Help Editions -Category HelpFile -ShowWindow
    # PowerShell Core
$PSVersionTable.OS

# https://peterwawa.wordpress.com/2017/09/22/mis-keskkonnas-mu-skript-jookseb/

# https://learn.microsoft.com/previous-versions/powershell/scripting/overview

# https://learn.microsoft.com/previous-versions/powershell/scripting/windows-powershell/starting-the-windows-powershell-2.0-engine
Start-Process -FilePath powershell.exe -ArgumentList '-Version 2'
# https://devblogs.microsoft.com/powershell/windows-powershell-2-0-deprecation/
# https://devblogs.microsoft.com/powershell/replacing-cmd-exe/

#endregion

#region Identify factors to install and use PowerShell

# https://learn.microsoft.com/powershell/scripting/learn/ps101/01-getting-started

    # PowerShell < 6
Get-Help PowerShell_exe -ShowWindow
    #Requires -Version 6
Get-Help pwsh -ShowWindow

    # Runas Admin
Get-Help Start-Process -Parameter Verb
Start-Process -Verb RunAs -FilePath powershell.exe
Start-Process -Verb RunAs -FilePath pwsh.exe

# https://github.com/peetrike/PWAddins/blob/master/src/Public/start-asadmin.ps1

    # run as different user
Get-Help Start-Process -Parameter Credential
Start-Process -FilePath powershell.exe -Credential (Get-Credential)

Get-Command runas.exe
runas.exe -?

Get-Help Execution_Policies -ShowWindow
Get-Command -Noun ExecutionPolicy

#endregion

#region Configuring the console

# https://learn.microsoft.com/previous-versions/windows/it-pro/windows-powershell-1.0/ee692799(v=technet.10)
$Host.PrivateData
$Host.UI.RawUI
Get-PSReadLineOption | Select-Object *color
# https://learn.microsoft.com/powershell/scripting/learn/shell/using-light-theme

    #Requires -Version 7.2
Get-Help ANSI_Terminals -ShowWindow
$PSStyle

    #Requires -Version 5
Find-Module PSStyle -Repository PSGallery

    #Requires -Version 7.3
$PSStyle.FileInfo
Find-Module terminal-icons -Repository PSGallery

    # Windows Terminal
# https://learn.microsoft.com/windows/terminal/
# https://github.com/microsoft/terminal

    # Ensure that following is different enough to differentiate:
# `' 0O 1Il

# https://learn.microsoft.com/typography/font-list/consolas
# https://github.com/microsoft/cascadia-code
# https://www.programmingfonts.org/

# https://learn.microsoft.com/windows/terminal/tips-and-tricks#zoom-with-the-mouse
# https://learn.microsoft.com/windows/terminal/customize-settings/interaction#automatically-copy-selection-to-clipboard
# https://learn.microsoft.com/windows/terminal/tutorials/custom-prompt-setup

    #Requires -Modules PSReadLine
Get-PSReadLineKeyHandler -Chord 'Ctrl-c', 'Ctrl-C', 'Ctrl-x', 'Ctrl-v', 'Shift-Insert'

#endregion

#region Configuring the ISE

# https://learn.microsoft.com/powershell/scripting/windows-powershell/ise/exploring-the-windows-powershell-ise

# ISE has not been changed since PowerShell 3.0
# https://learn.microsoft.com/previous-versions/powershell/scripting/windows-powershell/whats-new/what-s-new-in-the-powershell-50-ise

#endregion

#region Using Visual Studio Code with PowerShell

# http://code.visualstudio.com
# https://learn.microsoft.com/powershell/scripting/dev-cross-plat/vscode/using-vscode

# https://learn.microsoft.com/powershell/scripting/dev-cross-plat/vscode/how-to-replicate-the-ise-experience-in-vscode

# https://code.visualstudio.com/docs/getstarted/themes
# https://code.visualstudio.com/docs/getstarted/settings

# https://learn.microsoft.com/powershell/scripting/dev-cross-plat/vscode/using-vscode#configuration-settings-for-visual-studio-code

# https://code.visualstudio.com/docs/editor/accessibility#_zoom

#endregion

#endregion


#region Module 2: Understand PowerShell command syntax

#region Cmdlet structure

Get-Command -CommandType Cmdlet -TotalCount 20
Get-Command | Measure-Object

# https://learn.microsoft.com/powershell/scripting/discover-powershell#powershell-cmdlets
Get-Help about_Functions_Advanced -ShowWindow
Get-Verb

Get-Command Get-VM
Get-Command Get-EXOMailbox
Get-Command Get-ADUser
Get-Command -Verb Get -Noun *User

    #Requires -Modules Microsoft.PowerShell.PSResourceGet
Find-PSResource -Command Get-User -Repository PSGallery

    # when cmdlet names in different modules are same, you can use fully qualified cmdlet name
Find-PSResource -CommandName Get-Credential -Repository PSGallery
    #Requires -Modules BetterCredentials
Get-Command BetterCredentials\Get-Credential
Get-Command Microsoft.PowerShell.Security\Get-Credential
Get-Command Get-Credential -All

#endregion

#region Parameters

Get-Help about_Parameters -ShowWindow

Get-Command Start-Process | Get-Member
(Get-Command Start-Process).Parameters
Get-Help Start-Process -Parameter * | Select-Object Name, Required, Type

Get-Help Get-Process -ShowWindow
Get-Help Get-Process -Parameter *
Get-Help Get-Process -Parameter Id
Get-Help Get-Command -Parameter Verb

(Get-Help Get-Process).parameters.parameter | Where-Object Name -like IncludeUserName

#endregion

#region Tab completion

Get-Help Tab_Expansion -ShowWindow

Get-Help PSReadLine -Category HelpFile -ShowWindow
Get-Command -Module PSReadLine

Get-PSReadLineKeyHandler -Bound -Unbound | Where-Object Group -Like 'Completion'
# https://learn.microsoft.com/powershell/module/psreadline/about/about_psreadline_functions#completion-functions

# https://learn.microsoft.com/powershell/module/psreadline/about/about_psreadline#predictive-intellisense
Get-PSReadLineKeyHandler -Unbound -Bound | Where-Object Group -Like 'Prediction'
Get-PSReadLineKeyHandler -Chord 'Ctrl-RightArrow', 'RightArrow'
Get-PSReadLineOption | Select-Object Prediction*

Get-Module PSReadLine
Find-PSResource PSReadLine -Repository PSGallery

#endregion

#region About files

Get-Help -Category HelpFile
Get-Help about_
Get-Help about_quoting -ShowWindow
Get-Help quoting
Get-Help beep

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about

#endregion

#endregion


#region Module 3: Finding commands

#region What are modules?

Get-Help Modules -Category HelpFile -ShowWindow

Get-Module
Get-Module -ListAvailable

$env:PSModulePath
$env:PSModulePath -split [IO.Path]::PathSeparator

    #Requires -Version 4
$env:PSModulePath -split [IO.Path]::PathSeparator | Where-Object { $_ -like "$env:ProgramFiles*" }

    #Requires -Version 3
Get-ADUser
    #Requires -Version 2
Import-Module ActiveDirectory
Get-ADUser

    # where to find modules
    #Requires -Modules Microsoft.PowerShell.PSResourceGet
Find-PSResource -Name UserProfile -Repository PSGallery
Get-PSResource -Scope AllUsers

# https://powershellgallery.com

#endregion

#region Finding cmdlets

Get-Help Get-Command

Get-Command -Module VpnClient | Measure-Object
Get-Command -Module VpnClient
Get-Command -Noun VpnConnection
Get-VpnConnection

Get-Command -Noun Service
Get-Service BITS
Stop-Service BITS -WhatIf

Get-Command -Noun *user -Verb Get

Get-Help Command_Precedence -ShowWindow

Get-Command | Group-Object -Property CommandType

# https://learn.microsoft.com/powershell/scripting/gallery/overview
# https://learn.microsoft.com/powershell/module/powershellget/
Get-Command -Module Microsoft.PowerShell.PSResourceGet
Get-Help Find-PSResource -Parameter CommandName
Get-Help Install-PSResource

Get-Module PowerShellGet -ListAvailable
Get-Module *PSResourceGet -ListAvailable

#endregion

#region What are aliases?

Get-Help Aliases -Category HelpFile

dir
echo tere
ps p*

Get-Command -Noun Alias
Get-Help Get-Alias -ShowWindow

Get-Alias dir
Get-Alias -Definition Get-ChildItem
Get-Alias -Definition Get-Alias
Get-Alias
Get-Command -CommandType Alias

    # alias can override other commands
Get-Command ping
New-Alias -Name ping -Value Test-Connection
Set-Alias ping Test-Connection
Get-Command ping
ping www.ee
    # PowerShell < 6.0 does not have Remove-Alias cmdlet
    # https://github.com/peetrike/PWAddins/blob/master/src/Public/remove-alias.ps1
Remove-Item -Path alias:\ping
ping www.ee

    # command parameter aliases
dir /s
Get-Help dir -Parameter Recurse
(Get-Command Get-ChildItem).Parameters.Recurse
(Get-Command Get-ChildItem).Parameters.Recurse.Aliases
dir -s

# https://github.com/peetrike/CommandInfo/blob/master/src/Public/Get-ParameterAlias.ps1
    #Requires -Modules CommandInfo
Get-Command Get-ChildItem | Get-ParameterAlias -ParameterName Recurse

#endregion

#region Using Show-Command

Get-Help Show-Command -ShowWindow

Show-Command -Name Get-Process
Show-Command

# https://github.com/peetrike/Examples/blob/main/src/Gui/Test-Command.ps1

#endregion

#region Using Get-Help

# https://learn.microsoft.com/powershell/scripting/learn/ps101/02-help-system

Get-Help default -ShowWindow
Get-Help Get-Help -ShowWindow

Get-Help Get-Help -Examples
Get-Help Get-Help -Parameter *
Get-Help Get-Help -Parameter Examples
Get-Help Get-Help -Detailed
Get-Help Get-Help -Full
Get-Help Get-Process -Online

    # Get-Help uses substring search, the following commands produce same result
Get-Help process
Get-Help *process*

# https://github.com/peetrike/Examples/blob/main/CommandLine/README.md#command-line-samples

#endregion

#region Interpreting the help syntax

Get-Help Command_Syntax -Category HelpFile -ShowWindow
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_command_syntax#parameters

Get-Help Get-Command | Select-Object -ExpandProperty Syntax
(Get-Help Get-Command).Syntax
Get-Command Get-Command -Syntax

Get-Command Get-Command | Select-Object -ExpandProperty ParameterSets | Format-Table
# https://github.com/peetrike/CommandInfo/blob/master/src/Public/Get-ParameterInfo.ps1
    #Requires -Modules CommandInfo
Get-ParameterInfo -Name Get-Command
Get-Command Get-Command | Get-Syntax

Get-Help Get-WinEvent
Get-WinEvent Application -MaxEvents 5
Get-WinEvent -MaxEvents 5 -LogName Application

Get-Help dir
dir . *.ps1
Get-ChildItem -Path . -Filter *.ps1 -Recurse

Get-Help Test-Connection -ShowWindow
    # up to PowerShell 5.1
Test-Connection .
    #Requires -Version 6
Test-Connection -TargetName $env:COMPUTERNAME

Test-Connection -ComputerName $env:COMPUTERNAME
Test-Connection $env:COMPUTERNAME -cou 1
Test-Connection $env:COMPUTERNAME -Quiet
Get-Help Test-Connection -Parameter Quiet

#endregion

#region Updating help

Get-Help Updatable_Help -ShowWindow

Get-Command -Noun help
Get-Help Update-Help
Get-Help Save-Help -ShowWindow

    #Requires -RunAsAdministrator
Update-Help -Module VPNClient

    #Requires -Version 6.1
Get-Help Update-Help -Parameter Scope

#endregion

#endregion


#region Lab

# You can do the lab on your own computer
# https://microsoftlearning.github.io/AZ-040T00-Automating-Administration-with-PowerShell/Instructions/Labs/LAB_01_Configuring_Windows_PowerShell_finding_and_running_commands.html

#endregion
