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
        https://diigo.com/profile/peetrike/?query=%23MOC-10961
    .LINK
        https://peterwawa.wordpress.com/tag/powershell/
#>


#region Safety to prevent the entire script from being run instead of a selection
    # The code in this region was stolen, I mean borrowed from Thomas Rayner (@MrThomasRayner).

    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1 - Overview and background of Windows PowerShell

# https://docs.microsoft.com/powershell/scripting/setup/starting-windows-powershell
Get-Help PowerShell_exe
Get-Help pwsh

    # PowerShell vs. OS
Get-Command Get-NetAdapter
Get-Command Get-VpnConnection
Get-Module ActiveDirectory


    # PowerShell hosts
# https://docs.microsoft.com/powershell/scripting/getting-started/fundamental/windows-powershell-integrated-scripting-environment--ise-

    # Powershell ISE difference: next line doesn't show one screen at time
Get-Command | more

# Visual Studio Code: http://code.visualstudio.com
# https://docs.microsoft.com/powershell/scripting/core-powershell/vscode/using-vscode

    # Windows Terminal
# https://github.com/microsoft/terminal
# https://aka.ms/terminal


    #Powershell version (PowerShell 2+)
$PSVersionTable
    # only works with Windows PowerShell ( < 6 )
$PSVersionTable.BuildVersion
    # only works with PowerShell 5.1+
$PSVersionTable.PSEdition
    # only works with PowerShell Core
$PSVersionTable.OS
get-help PowerShell_Editions

# look also https://peterwawa.wordpress.com/2017/09/22/mis-keskkonnas-mu-skript-jookseb/


    # starting PowerShell in version 2 mode
Start-Process -FilePath powershell.exe -ArgumentList '-version 2'

#endregion


#region Lesson 2: Understanding command syntax

Get-Command Get-VM
Get-Command get-mailbox
Get-Command Get-ADUser


Get-help Get-Process

Get-Help Get-Process -ShowWindow
Get-Help Get-Help -ShowWindow
Get-Help Get-Process -Examples
Get-Help Get-Process -Online
Get-Help Get-Process -Parameter Id

    # Understanding help syntax
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


    # to update local help
# Requires -RunAsAdministrator
Update-Help -Module VPNClient

# PowerShell 6+ allows to specify scope for Update-Help
Get-Help Update-Help


    # About topics
Get-Help about_
Get-Help about_quoting -ShowWindow
Get-Help quoting

#endregion


#region Lesson 3: Finding commands

Get-Module
Get-Module -ListAvailable

    # PowerShell 3+
Get-ADUser
    # PowerShell 2.0
Import-Module ActiveDirectory
Get-ADUser


Get-Command -Module VpnClient
Get-Command -Module VpnClient | Measure-Object
Get-Command -Noun VpnConnection
Get-VpnConnection

Get-Command -Noun Service
Get-Service BITS
Stop-Service BITS

Get-Command -Noun *user


    # aliases
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


Show-Command Get-Process

#endregion
