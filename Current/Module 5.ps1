# Module 5

# Lesson 1 - PSProviders
get-help providers -ShowWindow
get-command -noun psprovider
Get-PSProvider

get-help certificate

Import-Module ActiveDirectory
Get-PSProvider
get-module ActiveDirectory | Remove-Module
Get-PSProvider


# Lesson 2 - PSDrives

Get-Command -Noun psdrive
get-psdrive
dir alias:\
dir Cert:\CurrentUser\My | select -last 1 | Get-member

Get-Command -Noun item,itemproperty,content,location

set-location HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion
dir

Get-Command -noun location
Get-Command -Noun item

cd run
Get-ChildItem
Get-ItemProperty -Path .

    # registry
cd HKCU:\Software\Microsoft\Windows\CurrentVersion\Run
Get-ItemPropertyValue -Path . -Name OneDrive
get-command -Noun ItemProperty

c:
dir WSMan:\localhost\Client\TrustedHosts

    # Active Directory
Get-ADUser meelis

dir 'AD:\cn=computers,DC=ad,DC=itprotraining,DC=eu'
cd 'AD:\cn=computers,DC=ad,DC=itprotraining,DC=eu'
New-Item -ItemType Group -Name asjad
Get-Item CN=T450S | Get-ADComputer
c:
New-PSDrive -Name ad2 -PSProvider ActiveDirectory `
            -Root "dc=adatum,dc=com" -Credential adatum\admin
cd ad2:
get-aduser -filter * # siin tulevad adatum.com kasutajad
cd ad:
get-aduser -filter * # siin tulevad minu domeeni kasutajad

    # file system
c:
new-item -Path c:\temp -ItemType Directory
new-item -Path c:\temp -Name minufail.txt -ItemType File
new-item -Path c:\temp -Name link -ItemType SymbolicLink -Value minufail.txt

new-psdrive -Name server -PSProvider FileSystem -Root \\server\share\kaust
copy-item -path c:\temp -Include *.txt -Destination server:\

    # see muutub Windowsi mappitud kettaks
New-PSDrive -name s -PSProvider FileSystem -Root \\server\share\kaust -Persist
    # see teeb täpselt sama asja
New-SmbMapping -LocalPath s: -RemotePath \\server\share\kaust -Persistent -


dir env:
    #need teevad sama asja
get-item Env:\COMPUTERNAME | select -ExpandProperty value
$env:COMPUTERNAME

