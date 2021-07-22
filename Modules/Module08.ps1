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

'get-date; whoami' | Set-Content -Path käsud.txt -Encoding utf8BOM
Start-Process cmd.exe -ArgumentList '/k powershell < käsud.txt'
Invoke-Expression (gc .\käsud.txt)
Invoke-Item .\käsud.txt

Get-Content .\käsud.txt | powershell -command -
pwsh -c (gc .\käsud.txt)

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

foreach ($i in 1..10) {
    "number on $i"
}

foreach ($file in Get-ChildItem) {
    $file.Name
}

Get-Help ForEach-Object -ShowWindow
Get-Help Pipelines -Category HelpFile -ShowWindow

#endregion

#region Understanding the If construct

Get-Help about_If -ShowWindow

if ($true) { 'on tõene' }
elseif ($false) { 'on väär' }
else { 'on midagi muud' }

if (Get-ChildItem -File) { 'on faile ' }
else { new-item uus.txt }

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

$choice = Read-Host -Prompt 'kas Sa tahad jätkata? [j/e]'
switch -Wildcard ($choice) {
    '[jy]*' { 'olgu' }
    'e*' { 'kahju' }
    Default { 'proovi uuesti' }
}

$ip = Get-NetIPAddress -InterfaceAlias wi-fi -AddressFamily IPv4
Switch -WildCard ($ip.IPAddress) {
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
Switch -WildCard ($computer) {
    '*-CL*' { $role = 'client' }
    '*-SRV*' { $role = 'server' }
    '*-DC*' { $role = 'domain controller' }
    { $_ -like 'L*' } {
        $location = 'London'
    }
    'VAN-*' { $location = 'Vancouver' }
    Default { "$computer is not a valid name" }
}
"$computer is a $role in $location"

$numbers = 1..4 | ForEach-Object { Get-Random -Maximum 5 }
switch ($numbers) {
    3 { Write-Host -ForegroundColor Cyan '3 this time' }
    { $_ % 2 } { 'Odd number: {0}' -f $_ }
    5 { 'Got it!' }
    Default { Write-Warning -Message 'Missed it' }
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

Do {
    'Script block to process'
    $answer = Read-Host -Prompt 'Go or Stop'
} While ($answer -eq 'go')

Do {
    'Script block to process'
    $answer = Read-Host -Prompt 'Go or Stop'
} Until ($answer -eq 'stop')

Remove-Variable -Name i
while (++$i -le 10) {
    'number on {0}' -f $i
}
$i

while ($true) {
    'Processing...'
    Start-Sleep -Seconds 2
}

#endregion

#region Understanding Break and Continue

Get-Help about_Break -ShowWindow
Get-Help about_Continue -ShowWindow

$users = Get-ADUser -Filter * -ResultSetSize 20

ForEach ($user in $users) {
    If ($user.Name -eq 'Administrator') { continue }
    'Modify user object'
}

$max = 3
ForEach ($user in $users) {
    $number++
    "Modify User object $number"
    If ($number -ge $max) { break }
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

Get-Help Get-Content -ShowWindow

Get-Content -Path C:\Scripts\* -Include *.txt, *.log
Get-Content C:\Scripts\computers.txt -TotalCount 10
Get-Content file.txt -Tail 10


Get-Help Import-Csv -ShowWindow

Import-Csv kasutajad.csv | Select-Object name, e-mail



# lisamaterjal, Out-GridView kui kasutajaliidese element:
Get-Help Out-GridView -ShowWindow

Get-ChildItem |
    Out-GridView -Title 'mis failid soovid kustutada' -PassThru |
    Remove-Item -WhatIf

Get-ADUser -filter { City -like 'Tallinn' } |
    Out-GridView -Title 'mis kasutaja gruppi lisame' -OutputMode Single |
    Add-ADPrincipalGroupMembership -MemberOf 'minu sobrad' -WhatIf

#endregion
