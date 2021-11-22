<#
    .SYNOPSIS
        Module 08 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 08 - Basic scripting
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M8
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Introduction to scripting

#region Overview of Windows PowerShell scripts

Get-Help Scripts -Category HelpFile -ShowWindow

get-date
whoami

'get-date', 'whoami' | Set-Content -Path käsud.txt -Encoding utf8
Start-Process cmd.exe -ArgumentList '/k powershell < käsud.txt'
Invoke-Expression (gc .\käsud.txt -Raw)
Invoke-Item .\käsud.txt

Get-Content .\käsud.txt | powershell -command -
pwsh -c (gc .\käsud.txt -Raw)

#endregion

#region Modifying scripts

# https://github.com/janikvonrotz/awesome-powershell#editors-and-ides

# https://code.visualstudio.com
Get-Command code
code -r käsud.txt

# https://docs.microsoft.com/powershell/scripting/windows-powershell/ise/how-to-write-and-run-scripts-in-the-windows-powershell-ise
Get-Command ise
ise käsud.txt

# https://www.sapien.com/software/powershell_studio
# https://visualstudio.microsoft.com/vs/community/

# https://github.com/neoclide/coc.nvim
# https://emacs-lsp.github.io/lsp-mode/
# https://plugins.jetbrains.com/plugin/10249
# https://www.sublimetext.com/
# https://atom.io/

# https://code.labstack.com/powershell
# https://poshgui.com/
# https://docs.github.com/en/codespaces

# https://notepad-plus-plus.org/

#endregion

#region What is the PowerShellGet module?

# https://www.powershellgallery.com/
# https://docs.microsoft.com/powershell/scripting/gallery/getting-started

Get-Module PowerShellGet -ListAvailable

Get-Command -Noun Module, Script

if ($PSVersionTable.PSVersion.Major -lt 6) {
    if (-not ([Net.ServicePointManager]::SecurityProtocol -band [Net.SecurityProtocolType]::Tls12)) {
        [Net.ServicePointManager]::SecurityProtocol =
            [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }
}

Find-Script Send-PasswordNotification -Repository PSGallery
Find-Module UserProfile -Repository PSGallery
Find-Module -Command get-user -Repository PSGallery

Get-InstalledScript
Get-InstalledModule

#endregion

#region Running scripts

powershell.exe -?

    # this doesn't work
powershell.exe -file käsud.txt
    # but this works
Copy-Item -Path käsud.txt -Destination käsud.ps1
powershell.exe -file käsud.ps1
pwsh -f käsud.ps1

powershell.exe -command .\käsud.ps1
.\käsud.ps1
.\käsud
käsud

Get-Help Command_Precedence -ShowWindow

Get-Help Run_With_PowerShell -ShowWindow

Get-Help Unblock-File -ShowWindow

#endregion

#region The script execution policy

Get-Help Execution_Policies -ShowWindow
Get-Command -noun ExecutionPolicy
Get-ExecutionPolicy -List

Set-ExecutionPolicy Restricted -Scope Process
.\käsud.ps1
powershell.exe -ExecutionPolicy RemoteSigned -file käsud.ps1
Set-ExecutionPolicy RemoteSigned -Scope Process

#endregion

#region PowerShell and AppLocker/WDAC

Get-Help Language_Modes -ShowWindow

$ExecutionContext.SessionState.LanguageMode

# https://docs.microsoft.com/windows/security/threat-protection/windows-defender-application-control/select-types-of-rules-to-create#table-1-windows-defender-application-control-policy---policy-rule-options

#endregion

#region Digitally signing scripts

Get-Help Signing -Category HelpFile -ShowWindow

Get-Command -Noun AuthenticodeSignature

Get-AuthenticodeSignature -FilePath käsud.ps1

Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert
Get-Help Set-AuthenticodeSignature -Examples

Get-Command -Noun FileCatalog

#endregion

#endregion


#region Lesson 2: Scripting constructs

#region Understanding foreach loops

Get-Help about_Foreach -Category HelpFile -ShowWindow

$numbers = 1..10
foreach ($i in $numbers) {
    'number on {0}' -f ($i * 2)
}

1..10 | ForEach-Object { 'Number on {0}' -f ($_ * 2) }

foreach ($file in Get-ChildItem -File) { $file.Name }
$failid = Get-ChildItem -File
foreach ($file in $failid)
{
    $file.Name
}

Get-Help ForEach-Object -ShowWindow
Get-Help Pipelines -Category HelpFile -ShowWindow

#endregion

#region Understanding the If construct

Get-Help about_If -ShowWindow

$a = 0
if ($a -gt 1) { 'greater' }
elseif ($a -eq 0) { 'equal' }
else { 'something else' }

if (Get-ChildItem -File) { 'there are some files' }
else { New-Item uus.txt }

#endregion

#region Understanding the Switch construct

Get-Help Switch -Category HelpFile -ShowWindow

$choice = Get-Random -Maximum 4
switch ($choice) {
    1 { 'You selected menu item 1' }
    2 { 'You selected menu item 2' }
    3 { 'You selected menu item 3' }
    default { Write-Warning -Message 'You did not select a valid option' }
}

$choice = Read-Host -Prompt 'Do you want to continue? [y/n]'
switch -Wildcard ($choice) {
    '[jy]*' { 'Ok' }
    'n*' { 'Too bad' }
    default { 'Try again' }
}

$ip = Get-NetIPAddress -InterfaceAlias wi-fi -AddressFamily IPv4
switch -WildCard ($ip.IPAddress) {
    '10.*' { 'This computer is on the internal network' }
    '10.1.*' { 'This computer is in London' }
    '10.2.*' { 'This computer is in Vancouver' }
    default { Write-Warning -Message 'This computer is not on the internal network' }
}

switch -Regex (Get-Random -Maximum 11) {
    '(1|7)$' { $_ }
    '2|8' { $_ * 3 }
    '[1-5]' { 'lower part' }
    { $_ % 2 } { 'Odd number' }
    '^\d$' { 'lower than 10' }
    default { Write-Warning -Message 'Missed it' }
}

$computer = 'LON-CL1'
$role = 'unknown role'
$location = 'unknown location'
switch -WildCard ($computer) {
    '*-CL*' { $role = 'client' }
    '*-SRV*' { $role = 'server' }
    '*-DC*' { $role = 'domain controller' }
    { $_ -like 'L*' } {
        $location = 'London'
    }
    'VAN-*' { $location = 'Vancouver' }
    default { "$computer is not a valid name" }
}
"$computer is a $role in $location"

$numbers = 1..4 | ForEach-Object { Get-Random -Maximum 5 }
switch ($numbers) {
    3 { Write-Host -ForegroundColor Cyan '3 this time' }
    { $_ % 2 } { 'Odd number: {0}' -f $_ }
    5 { 'Got it!' }
    default { Write-Warning -Message 'Missed it' }
}

#endregion

#region Understanding the For construct

Get-Help about_For -ShowWindow

for ($i = 1; $i -le 10; $i++) { "Creating User $i" }

for (
    $i = 1
    $i -le 10
    $i += 2
) {
    "Creating User $i"
}

#endregion

#region Understanding other loop constructs

Get-Help about_Do -ShowWindow
Get-Help about_While -ShowWindow

do {
    'Script block to process'
    $answer = Read-Host -Prompt 'Go or Stop'
} while ($answer -eq 'go')

do {
    'Script block to process'
    $answer = Read-Host -Prompt 'Go or Stop'
} until ($answer -eq 'stop')

Remove-Variable -Name i
while (++$i -le 10) {
    'number on {0}' -f $i
}
$i

while ($true) {
    'Processing...'
    Start-Sleep -Seconds 2
}

$i = 1
while ($i--) {
    'Processing...'
    Start-Sleep -Seconds 2
}
#endregion

#region Understanding Break and Continue

Get-Help about_Break -ShowWindow
Get-Help about_Continue -ShowWindow

$users = Get-ADUser -Filter * -ResultSetSize 20

foreach ($user in $users) {
    if ($user.Name -eq 'Administrator') { continue }
    'Modify user {0}' -f $user.Name
}

$max = 3
$number = 0
forEach ($user in $users) {
    $number++
    "Modify User object $number"
    if ($number -ge $max) {
        "breaking out"
        break
    }
}
'After loop'

$ip = '10.1.2.3', '300.3.986.4', '10.3.4.5', '10.2.3.7', '13.9.4.5'
switch -Regex ($ip) {
    '^10\.1' {
        "$_ is in London"
        continue
    }
    "^10`.2`." {
        'This computer is in Vancouver'
        break
    }
    "10`." { '{0} is on the internal network' -f $_ }
    { -not ($_ -as [ipaddress]) } { Write-Warning -Message ('not a valid IP address: {0}' -f $_) }
    default { '{0} is not on the internal network' -f $_ }
}

#endregion

#endregion


#region Lesson 3: Importing data from files

#region Using Get-Content

Get-Command -Noun Content
Get-Help Get-Content -ShowWindow

Get-Content -Path .\* -Include *.txt, *.log

Get-Help Get-Content -Parameter TotalCount
Get-Content Module08.ps1 -Head 7

Get-Help Get-Content -Parameter Tail
Get-Content Module08.ps1 -Tail 5

Get-Help Get-Content -Parameter ReadCount

#endregion

#region Using Import-Csv

Get-Command -Noun Csv
Get-Help Import-Csv -ShowWindow

Get-Process p* | Export-Csv -Path protsessid.csv
Import-Csv protsessid.csv | Select-Object Name, Path

Invoke-Item protsessid.csv
# https://peterwawa.wordpress.com/2014/05/13/excel-csv-ja-powershell/
Get-Help Import-Csv -Parameter Encoding

Get-ADUser -Filter * -ResultSetSize 10 -Properties mail |
    Select-Object *name, mail -ExcludeProperty DistinguishedName |
    Export-Csv -Path kasutajad.csv -Encoding utf8 -UseCulture -NoTypeInformation
Invoke-Item kasutajad.csv
Import-Csv kasutajad.csv -UseCulture

#endregion

#region Using Import-Clixml

Get-Command -Noun *xml -Module Microsoft.PowerShell.*
Get-Help Import-Clixml -ShowWindow

Get-Process p* | Export-Clixml -Path protsessid.xml
Import-Clixml -Path protsessid.xml | get-member
Invoke-Item protsessid.xml

$XmlKasutajad = Get-ADUser -filter { City -like 'Tallinn' } | ConvertTo-Xml
$XmlKasutajad.OuterXml | Set-Content -Path kasutajad.xml -Encoding utf8
$häälestus = [xml](Get-Content kasutajad.xml)

#endregion

#region Using ConvertFrom-Json

Get-Command -Noun Json
Get-Help ConvertFrom-Json -ShowWindow

Get-Process p* | ConvertTo-Json | Set-Content -Path protsessid.json
Invoke-Item protsessid.json

    #Requires -Version 7
Get-Content protsessid.json | ConvertFrom-Json | Select-Object Name, Id, Cpu, Path
    #Requires -Version 3
(Get-Content protsessid.json | ConvertFrom-Json) | Select-Object Name, Id, Cpu, Path

    # communicating with Web apps
$url = 'http://ipinfo.io/json'

$info = Invoke-WebRequest -Uri $url | Select-Object -ExpandProperty Content | ConvertFrom-Json
$info = Invoke-RestMethod -Uri $url

$info.ip
$info | Select-Object ip, hostname

Invoke-RestMethod -Uri https://devblogs.microsoft.com/powershell/feed

#endregion

#endregion

#region Using .PSD1 files as data source

Get-Help Import-PowerShellDataFile -ShowWindow

@'
@{
    Config = @(
        @{
            Setting = 1
        }
        @{
            Setting = 7
        }
    )
}
'@ | Set-Content config33.psd1

    #Requires -Version 5
$myConfig = Import-PowerShellDataFile -Path config33.psd1
$myConfig

#endregion
