# Meelis Nigols, e-mail meelis@koolitus.ee , skype: meelis.nigols
# lisamaterjal - lingid:  https://diigo.com/profile/peetrike/?query=%23MOC-10961
# vaata ka https://peterwawa.wordpress.com/tag/powershell/
# Companion materials - http://www.microsoft.com/learning/companionmoc (otsi: 10961)

#region Safety to prevent the entire script from being run instead of a selection

throw "You're not supposed to run the entire script"

<#

    The code in this region was stolen, I mean borrowed from Thomas Rayner (@MrThomasRayner).

    For more information, see:

    http://mikefrobbins.com/2017/11/02/safety-to-prevent-entire-script-from-running-in-the-powershell-ise/

#>

#endregion

# Module 1 - Getting started with Windows PowerShell

    # Lesson 1 - Overview and background of Windows PowerShell
Get-Command Get-Help

# https://docs.microsoft.com/en-us/powershell/scripting/setup/starting-windows-powershell

# https://docs.microsoft.com/en-us/powershell/scripting/getting-started/fundamental/windows-powershell-integrated-scripting-environment--ise-
# Powershell ISE erinevus: järgnev rida ei näita ISEs teksti ekraanikaupa
Get-Command | more

# Visual Studio Code: http://code.visualstudio.com
# https://docs.microsoft.com/en-us/powershell/scripting/core-powershell/vscode/using-vscode

    #Powershelli versioon
$PSVersionTable
# vaata ka https://peterwawa.wordpress.com/2017/09/22/mis-keskkonnas-mu-skript-jookseb/

    # kuidas näha, mis Sa teinud oled
Get-Help Start-Transcript -ShowWindow
Start-Transcript -Path c:/transcript.txt
Get-History
Stop-Transcript

Get-Service p*
Get-ADUser -Filter {name -like "*m"} -ResultSetSize 10000

    # kui on vaja Powershelli eest erimärke ära peita
bcdedit.exe --% -default {current}
icacls.exe --%


# see on kommentaar
<#see on
mitmerealine
kommentaar
#>

    # Lesson 2 - Understanding command syntax
Get-Command dir
get-help dir -ShowWindow
get-help dir -Online
Get-Help dir -Examples
get-help dir -Parameter recurse
get-help dir -Detailed

    # vaikimisi spikker puudub
Update-Help -Module ActiveDirectory
Update-Help
Save-Help -DestinationPath \\server\share\folder
Update-Help -SourcePath \\server\share\folder


get-help about_splatting -ShowWindow
get-help workflow


    # Lesson 3 - Finding commands
get-command get-aduser
get-command get-adusser
get-command ping

Get-Module ActiveDirectory

get-command -Module ActiveDirectory
get-command -noun aduser

Get-Module -ListAvailable

    # kui moodulit ei ole:
Find-Module UserProfile
Find-Module UserProfile | Install-Module

get-command -noun *ipaddress* -Module NetTCPIP

get-command | Measure-Object
get-command -Noun *firewall*rule*

get-alias ls
get-alias -Definition Get-ChildItem
new-alias ls Get-ChildItem

get-command -Noun alias

show-command get-aduser
