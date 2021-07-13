#region Safety to prevent the entire script from being run instead of a selection

throw "You're not supposed to run the entire script"

<#

    The code in this region was stolen, I mean borrowed from Thomas Rayner (@MrThomasRayner).

    For more information, see:

    http://mikefrobbins.com/2017/11/02/safety-to-prevent-entire-script-from-running-in-the-powershell-ise/

#>

#endregion


# Module 5 - Using PSProviders and PSDrives

    # Lesson 1 - Using PSProviders

get-command  -noun psprovider

Get-PSProvider
import-module ActiveDirectory
Get-PSProvider

get-help FileSystem
get-help WSMan
# https://docs.microsoft.com/en-us/powershell/module/microsoft.wsman.management/providers/wsman-provider
get-help Registry

    # Lesson 2 - Using PSDrives

get-command -noun PSDrive
Get-PSDrive

get-command -noun item, itemproperty*, Content, Location
get-command -noun childitem
get-alias -Definition Get-ChildItem

cd C:\
get-command cd

set-location HKLM:\SOFTWARE\BrowserChoice
Get-ChildItem
get-item .
get-itemproperty -Path .

get-help new-psdrive -online
get-help new-psdrive

New-PSDrive -provider FileSystem -LocalPath s: -root \\server\share\folder -Persist -Credential domain\user
New-SmbMapping -LocalPath p: -RemotePath \\server\share\folder -Persistent -UserName -Password -save
help new-smbmapping -parameter Password

    # file system items
New-PSDrive –Name WINDIR –Root C:\Windows –PSProvider FileSystem
cd Windir:\System32

Help FileSystem -Category Provider
New-Item -ItemType Directory -Name uus
new-item -ItemType File -name minufail.txt
    #Requires -Version 5
new-item -ItemType HardLink -Name teinefail.txt -Value minufail.txt
    #Requires -RunAsAdministrator
new-item -ItemType SymbolicLink -Name link.txt -Value minufail.txt

help about_requires -ShowWindow

dir -Recurse | Unblock-File
# https://peterwawa.wordpress.com/2013/04/10/ntfs-alternate-data-stream/

    # Registry items
Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion
Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
Get-ItemPropertyValue HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name SecurityHealth

    # Certificate items
get-command -noun certificate
Help Certificate -Category Provider
cd Cert:\CurrentUser\my
Get-ChildItem -ExpiringInDays 60 | test-certificate -User
cd c:

# other psdrives
get-childitem WSMan:\localhost\Client\
get-item WSMan:\localhost\Client\TrustedHosts
    #Requires -RunAsAdministrator
set-item WSMan:\localhost\Client\TrustedHosts -Value "server1,server2"

get-command -noun alias
new-alias -name minu -value "miski asi"
dir alias:\minu | remove-item
help alias -Category Provider
