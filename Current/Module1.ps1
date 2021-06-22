# Meelis Nigols, e-mail meelisn@outlook.com , skype: meelis.nigols
# https://github.com/peetrike/10961-examples
# additional links: https://diigo.com/profile/peetrike/?query=%23MOC-10961
# look also https://peterwawa.wordpress.com/tag/powershell/


#region Safety to prevent the entire script from being run instead of a selection

throw "You're not supposed to run the entire script"

<#
    The code in this region was stolen, I mean borrowed from Thomas Rayner (@MrThomasRayner).

    For more information, see:
    http://mikefrobbins.com/2017/11/02/safety-to-prevent-entire-script-from-running-in-the-powershell-ise/
#>

#endregion


# Module 1 - Getting started with Windows PowerShell


#region Lesson 1 - Overview and background of Windows PowerShell

# https://docs.microsoft.com/en-us/powershell/scripting/setup/starting-windows-powershell

# https://docs.microsoft.com/en-us/powershell/scripting/getting-started/fundamental/windows-powershell-integrated-scripting-environment--ise-
# Powershell ISE difference: next line doesn't show one screen at time
Get-Command | more

# Visual Studio Code: http://code.visualstudio.com
# https://docs.microsoft.com/en-us/powershell/scripting/core-powershell/vscode/using-vscode


    #Powershell version
$PSVersionTable
# look also https://peterwawa.wordpress.com/2017/09/22/mis-keskkonnas-mu-skript-jookseb/

Get-Help Start-Transcript -ShowWindow
Start-Transcript -Path c:/transcript.txt
Get-History
Stop-Transcript

Get-Service p*
Get-ADUser -Filter {name -like "*m"} -ResultSetSize 10000

    # if you need to hide command line components from Powershell
bcdedit.exe --% -default {current}
icacls.exe --%


# This is comment
<# this is
multi-line
comment
#>


$PSVersionTable
Get-Command
Get-Command | Measure-Object
Get-Command Get-Help

Get-Service
Get-Process
get-process powershell
Get-Process powers*
Get-Process powers*, smartscreen

Get-Process

#endregion


#region Lesson 2: Understanding command syntax

get-command Get-VM
get-command get-mailbox
get-command get-aduser

Get-help Get-Process

get-help Get-Process -ShowWindow
get-help get-help -ShowWindow
get-help Get-Process -Examples
get-help Get-Process -Online

    # to update local help
Update-Help -Module VPNClient

Get-EventLog Application -Newest 5
Get-EventLog -LogName Application -Newest 5

get-help Get-Content -ShowWindow
get-help about_
Get-Help about_quoting -ShowWindow
get-help quoting

#endregion


#region Lesson 3: Finding commands

Get-Module
Get-Module -ListAvailable

#powershell 3+
Get-ADUser

# powershell 2.0
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

get-alias dir
Get-Alias -Definition Get-ChildItem
Get-Alias -Definition Get-Alias
Get-Alias
Get-Command -CommandType Alias
ipconfig.exe


Show-Command Get-Process

#endregion
