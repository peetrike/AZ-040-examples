<#
    .SYNOPSIS
        Learning Path 07 samples
    .DESCRIPTION
        This file contains sample commands from course AZ-040 for
        Learning Path 07 - PowerShell scripting
    .LINK
        https://learn.microsoft.com/training/paths/create-modify-script-use-windows-powershell/
    .LINK
        https://github.com/peetrike/AZ-040-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23AZ-040+%23M7
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Module 1: Introduction to scripting

#region Overview of PowerShell scripts

Get-Help Scripts -Category HelpFile -ShowWindow

Get-Date
whoami.exe
Get-History -Count 2 |
    Select-Object -ExpandProperty CommandLine |
    Set-Content -Path käsud.txt -Encoding default

    # from PowerShell
Invoke-Expression (gc .\käsud.txt -Raw)
Get-Content .\käsud.txt | Invoke-Expression
Invoke-Item .\käsud.txt
pwsh -c (Get-Content .\käsud.txt -Raw)

    # from other shells
pwsh.exe -NoLogo -NoProfile < käsud.txt
type .\käsud.txt | powershell.exe -Command -

#endregion

#region Modifying/Creating scripts

# https://code.visualstudio.com
Get-Command code
code -r käsud.txt

# https://learn.microsoft.com/powershell/scripting/windows-powershell/ise/how-to-write-and-run-scripts-in-the-windows-powershell-ise
Get-Command ise
ise käsud.txt

# https://www.sapien.com/software/powershell_studio
# https://ironmansoftware.com/powershell-pro-tools/#psscriptpad
# https://visualstudio.microsoft.com/vs/community/

# https://www.powershellgallery.com/packages/psedit

# https://poshgui.com/
# https://docs.github.com/en/codespaces

# https://github.com/neoclide/coc.nvim
# https://emacs-lsp.github.io/lsp-mode/
# https://plugins.jetbrains.com/plugin/10249

# https://notepad-plus-plus.org/

# https://github.com/search?q=language:PowerShell

#endregion

#region What is the PowerShellGet module?

# https://www.powershellgallery.com/
# https://learn.microsoft.com/powershell/gallery/getting-started

#region PowerShellGet

Get-Module PowerShellGet -ListAvailable
Get-Command -Noun Module, Script

if ($PSVersionTable.PSVersion.Major -lt 6) {
    [Net.ServicePointManager]::SecurityProtocol =
        [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
}

# https://github.com/peetrike/scripts/blob/master/src/ComputerManagement/UserProfile/Install-UserProfile.ps1

Find-Script Send-PasswordNotification -Repository PSGallery
Find-Module UserProfile -Repository PSGallery | Update-Module
Find-Module -Command get-user -Repository PSGallery
Find-Module -Tag CrescendoBuilt -Repository PSGallery

Get-InstalledScript
Get-InstalledModule

Get-Command -noun PSRepository
Get-PSRepository

#endregion

#region PSResourceGet

# https://devblogs.microsoft.com/powershell/powershellget-3-0-preview-1/
# https://devblogs.microsoft.com/powershell/psresourceget-is-generally-available/
Get-Module Microsoft.PowerShell.PSResourceGet -ListAvailable
Get-Command -Module *PSResourceGet

Find-PSResource -Type Script -Name Send-PasswordNotification -Repository PSGallery
Find-PSResource -Type Module -Name UserProfile -Repository PSGallery
Find-PSResource -CommandName get-user -Repository PSGallery
Find-PSResource -Tag CrescendoBuilt -Repository PSGallery

Get-PSResource -Scope AllUsers
Get-PSResource
Get-Command Get-PSResource

Get-PSResourceRepository

#endregion

#endregion

#region Running scripts

powershell.exe -?
Get-Help PowerShell_exe -ShowWindow
    #Requires -Version 7
Get-Help pwsh -ShowWindow

    # this doesn't work
powershell.exe -File käsud.txt
    # but this works
Copy-Item -Path käsud.txt -Destination käsud.ps1
powershell.exe -NoProfile -NonInteractive -File käsud.ps1
pwsh -nop -f käsud.ps1

powershell.exe -NoProfile -Command .\käsud.ps1
.\käsud.ps1
.\käsud
käsud

Get-Help Command_Precedence -ShowWindow

Get-Help Run_With_PowerShell -ShowWindow

#endregion

#region The script execution policy

Get-Help Execution_Policies -ShowWindow
Get-Command -Noun ExecutionPolicy
Get-ExecutionPolicy -List

Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope Process  #DevSkim: ignore DS113853
.\käsud.ps1
powershell.exe -ExecutionPolicy RemoteSigned -file käsud.ps1
pwsh.exe -NoProfile -ExecutionPolicy AllSigned -c Get-ExecutionPolicy -List
Set-ExecutionPolicy RemoteSigned -Scope Process                 #DevSkim: ignore DS113853

Get-Help Unblock-File -ShowWindow

#endregion

#region PowerShell and AppLocker/WDAC

Get-Help Language_Modes -ShowWindow

$ExecutionContext.SessionState.LanguageMode

# https://learn.microsoft.com/windows/security/threat-protection/windows-defender-application-control/select-types-of-rules-to-create#windows-defender-application-control-file-rule-levels

#endregion

#region Digitally signing scripts

Get-Help Signing -Category HelpFile -ShowWindow

Get-Command -Noun AuthenticodeSignature

Get-AuthenticodeSignature -FilePath käsud.ps1

Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert
Get-Help Set-AuthenticodeSignature -Examples

Get-Help New-SelfSignedCertificate -ShowWindow

Get-Command -Noun FileCatalog

#endregion

#endregion


#region Module 2: Scripting constructs

#region Understanding foreach loops

Get-Help about_Foreach -Category HelpFile -ShowWindow
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-08#844-the-foreach-statement

$numbers = 1..10
foreach ($i in $numbers) {
    'number on {0}' -f ($i * 2)
}
$numbers | ForEach-Object { 'Number on {0}' -f ($_ * 2) }

foreach ($file in Get-ChildItem -File) { $file.Name }
$failid = Get-ChildItem -File
foreach ($file in $failid) {
    $file.Name
}

Get-Help ForEach-Object -ShowWindow
    #Requires -Version 7
Get-Help ForEach-Object -Parameter Parallel

#endregion

#region Understanding the If construct

Get-Help about_If -ShowWindow
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-08#83-the-if-statement

$a = 0
if ($a -gt 1) { 'a is greater' }
elseif ($null -eq $b) { 'b is not set' }
else { 'something else' }

if (Get-ChildItem -File) { 'there are some files' } else { New-Item uus.txt }

if (-not (Test-Path -Path käsud.txt -PathType Leaf)) {
    New-Item -Path käsud.txt -ItemType File
}

Test-Path HKLM:\SOFTWARE\

    #Requires -Version 7
$service = Get-Service BITS
$service.Status -eq 'Running' ? (Stop-Service $service) : (Start-Service $service)

#endregion

#region Understanding the Switch construct

Get-Help Switch -Category HelpFile -ShowWindow
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-08#86-the-switch-statement

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

$numbers = 1..4 | ForEach-Object { Get-Random -Maximum 6 }
switch ($numbers) {
    3 { Write-Host -ForegroundColor Cyan '3 this time' }
    { $_ % 2 } { 'Odd number: {0}' -f $_ }
    5 { 'Got it!' }
    default { Write-Warning -Message 'Missed it' }
}

#endregion

#region Understanding the For construct

Get-Help about_For -ShowWindow
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-08#843-the-for-statement

for ($i = 1; $i -le 10; $i++) { "Creating User $i" }

for (
    $i = 1
    $i -le 10
    $i += 2
) {
    "Creating User $i"
}

for ($i = 1) {
    $i
    Start-Sleep -Seconds 2
    $i++
}
for ($i = 1; ; Start-Sleep -Seconds 2) {
    ($i++)
}
Remove-Variable -Name i
for () {
    (++$i)
    Start-Sleep -Seconds 2
}


#endregion

#region Understanding other loop constructs

Get-Help about_Do -ShowWindow
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-08842-the-do-statement
Get-Help about_While -ShowWindow
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-08#841-the-while-statement

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

Start-Process notepad
while (Get-Process notepad -ErrorAction SilentlyContinue) {
    Write-Verbose -Message 'Notepad works' -Verbose
    Start-Sleep -Seconds 2
}

#endregion

#region Understanding Break and Continue

Get-Help about_Break -ShowWindow
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-08#851-the-break-statement
Get-Help about_Continue -ShowWindow
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-08#852-the-continue-statement

$users = Get-ADUser -Filter * -ResultSetSize 20

foreach ($user in $users) {
    if ($user.Name -eq 'Administrator') { continue }
    'Modify user {0}' -f $user.Name
}

$max = 3
$number = 0
foreach ($user in $users) {
    $number++
    "Modify User object $user"
    if ($number -ge $max) {
        'breaking out'
        break
    }
}
'After loop'

$ip = '10.1.2.3', '300.3.986.4', '100.10.4.5', '10.2.3.7', '13.9.4.5'
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

# https://github.com/nightroman/PowerShellTraps/tree/master/Basic/Break-and-Continue-without-loop

#endregion

#endregion


#region Module 3: Importing data from files

Get-Help Encoding -Category HelpFile -ShowWindow

#region Using Get-Content

Get-Command -Noun Content
Get-Help Get-Content -ShowWindow

Get-Content -Path .\* -Include *.txt, *.log -Exclude käsud*

Get-Help Get-Content -Parameter TotalCount
Get-Content LearningPath07.ps1 -Head 7

Get-Help Get-Content -Parameter Tail
Get-Content LearningPath07.ps1 -Tail 5

Get-Help Get-Content -Parameter ReadCount
Get-Help Get-Content -Parameter Raw
Get-Help Get-Content -Parameter Wait

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
Import-Clixml -Path protsessid.xml | Get-Member
Invoke-Item protsessid.xml

$XmlKasutajad = Get-ADUser -filter { City -like 'London' } | ConvertTo-Xml
$XmlKasutajad.OuterXml | Set-Content -Path kasutajad.xml -Encoding utf8

$kasutajad = [xml](Get-Content kasutajad.xml)
$kasutajad.GetType() | Get-TypeUrl -Invoke
$kasutajad.Load
$kasutajad.Save

#endregion

#region Using ConvertFrom-Json

Get-Command -Noun Json
Get-Help ConvertFrom-Json -ShowWindow

Get-Process p* | ConvertTo-Json | Set-Content -Path protsessid.json -Encoding utf8
Invoke-Item protsessid.json

    #Requires -Version 7
Get-Content protsessid.json | ConvertFrom-Json | Select-Object Name, Id, Cpu, Path
    #Requires -Version 3
(Get-Content protsessid.json | ConvertFrom-Json) | Select-Object Name, Id, Cpu, Path
$result = Get-Content protsessid.json | ConvertFrom-Json
$result | Select-Object Name, Id, Cpu, Path

    #Requires -Version 7
Get-Help ConvertFrom-Json -Parameter NoEnumerate

    # communicating with Web apps
$url = 'http://ipinfo.io/json'

$info = Invoke-WebRequest -Uri $url
$info.Headers.'Content-Type'
$jsonInfo = $info.Content | ConvertFrom-Json
$jsonInfo = Invoke-RestMethod -Uri $url

$jsonInfo.ip
$jsonInfo | Select-Object ip, hostname

Invoke-RestMethod -Uri https://devblogs.microsoft.com/powershell/feed | Select-Object -First 3

#endregion

#region Extra: Using .PSD1 files as data source

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

    #Requires -Version 2
$myConfig = Get-Content -Path config33.psd1 -Raw | Invoke-Expression
    #Requires -Version 5
$myConfig = Import-PowerShellDataFile -Path config33.psd1
$myConfig

# https://peterwawa.wordpress.com/2020/07/03/skriptid-ja-haalestus/

#endregion

#endregion


#region Module 4: Accepting user input

#region Identifying values that might change

Get-WinEvent -MaxEvents 10 -FilterHashtable @{
    LogName   = 'Application'
    ID        = 15
    StartTime = (Get-Date).AddDays(-1)
}

code -r events01.ps1

code -r events02.ps1

#endregion

#region Using Read-Host

Get-Help Read-Host -ShowWindow
$UserName = Read-Host -Prompt 'Enter user name for the server'
$Password = Read-Host -Prompt 'Enter the password' -AsSecureString
    #Requires -Version 7
$ClearPass = Read-Host -Prompt 'Enter the password' -MaskInput

#endregion

#region Using Get-Credential

Get-Command Get-Credential -All

Get-Help Get-Credential -ShowWindow

$Credential = Get-Credential -Credential 'domain\user'
$Credential.UserName

code -r -g Connect-VM.ps1:61
    #Requires -Version 3
Get-Credential -Message 'Please enter secret' -UserName 'not used'

$host.ui.PromptForCredential
$Credential = $host.ui.PromptForCredential(
    'Need credentials',
    'Please enter your user name and password.',
    'user',
    'target'  # used as domain name, when username doesn't have one
)

# https://learn.microsoft.com/powershell/module/microsoft.powershell.security/get-credential?view=powershell-5.1#example-4
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds' -Name ConsolePrompting

Find-Module BetterCredentials -Repository PSGallery

Find-Module Microsoft.PowerShell.SecretManagement -Repository PSGallery
Find-Module -Tag SecretManagement -Repository PSGallery

# https://peterwawa.wordpress.com/2010/04/28/powershell-ja-admin-oigused/
# https://learn.microsoft.com/powershell/scripting/learn/deep-dives/add-credentials-to-powershell-functions

#endregion

#region Using Out-GridView
Get-Help Out-GridView -ShowWindow

Get-ChildItem |
    Out-GridView -Title 'Select the files to remove' -PassThru |
    Remove-Item -WhatIf

Get-ADUser -Filter { City -like 'Tallinn' } |
    Out-GridView -Title 'Choose the user to add' -OutputMode Single |
    Add-ADPrincipalGroupMembership -MemberOf 'IT' -WhatIf

#endregion

#region Extra: Other possibilities

# https://github.com/peetrike/Examples/blob/master/src/Gui/Test-GuiElements.ps1#L35-L55
# https://github.com/peetrike/Examples/blob/master/src/Gui/ToastNotification.ps1
Find-Module burnttoast -Repository PSGallery

    #Requires -Version 6
Find-Module Microsoft.PowerShell.ConsoleGuiTools -Repository PSGallery

# https://gui-cs.github.io/Terminal.Gui

#endregion

#region Passing parameters to a script

Get-Help about_Parameters -ShowWindow
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-08#8109-param-block
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-08#8103-argument-processing

get-help
code -r events03.ps1

.\events03.ps1
.\events03.ps1 -aeg ([datetime]::Now).AddHours(-1)
.\events03.ps1 -aeg 'segadus'

code -r events04.ps1
.\events04.ps1 -aeg 'segadus'
.\events04.ps1 -a '2021.07.27'
.\events04.ps1 '2021.07.27' $env:COMPUTERNAME

(Get-Command .\events04.ps1).Parameters.ComputerName
.\events04.ps1 -cn $env:COMPUTERNAME

#endregion

#endregion


#region Module 5: Troubleshooting and error handling

#region Understanding error messages

get-help Automatic_Variables -ShowWindow
$Error

$Error.Count
$Error.Clear()
dir loll
$Error
dir pull -ErrorVariable viga
$Error[0]
$viga | format-list * -Force
    #Requires -Version 7
Get-Error

#endregion

#region Adding script output

Get-Command -Verb Write -Module Microsoft.PowerShell.Utility

Get-Help Output_ -Category HelpFile -ShowWindow
Get-Help CmdletBinding -Category HelpFile -ShowWindow
Get-Help _CommonParameters -Category HelpFile -ShowWindow
Get-Help Preference -Category HelpFile -ShowWindow

Get-Help redirect -ShowWindow
Get-Help Write-Host -ShowWindow

write-error 'suur viga'
$Error[0]
write-error 'suur viga' 2>> vealogi.txt
write-error 'suur viga' -ErrorVariable +viga

Write-Warning -Message 'Fail juba olemas, kirjutan üle'
Write-Warning -Message 'Fail juba olemas, kirjutan üle' 3>> hoiatuslogi.txt
Write-Warning -Message 'Fail juba olemas, kirjutan üle' -WarningVariable +hoiatus

$asi = 13
Write-Verbose -Message ('Muutuja väärtus: {0}, toimetan edasi' -f $asi) -Verbose
Write-Verbose -Message ('Muutuja väärtus: {0}, toimetan edasi' -f $asi) -Verbose 4>> verbaalne.txt

Write-Debug -Message 'Arendajale mõeldud teade' -Debug
Write-Debug -Message 'Arendajale mõeldud teade' -Debug 5>> debuglogi.txt

    #Requires -Version 5
Write-Information -MessageData 'Teade' -InformationAction Continue
Write-Information -MessageData 'Teade' 6>> infotekst.txt
Write-Information -MessageData 'Teade 2' -InformationVariable +info

Write-Host 'kah teade' 6>> infotekst.txt

code -r events05.ps1

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_commonparameters#-verbose
.\events05.ps1 -Verbose
.\events05.ps1 -Debug

#endregion

#region Extra: Using log files

code -r .\write-log.ps1

get-help .\write-log.ps1
.\write-log.ps1 -Level Warning -Message 'Midagi on viltu'

Find-Module -Command Write-PSFMessage -Repository PSGallery
Write-PSFMessage -Message 'Teade logisse'
Get-PSFMessage

# https://peterwawa.wordpress.com/2015/02/26/powershell-ja-sndmuste-logid/#kirjutamine

#endregion

#region Using breakpoints

Get-Help Debuggers -ShowWindow

Get-Command -Noun PSBreakpoint
Get-Help Wait-Debugger -ShowWindow
Get-Help Write-Debug -ShowWindow

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_commonparameters#-debug
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_preference_variables#debugpreference

$DebugPreference

    #Requires -Version 7
$oldDebugPreference = $DebugPreference
$DebugPreference = 'Break'
Write-Debug -Message 'Stop here'
$DebugPreference = $oldDebugPreference

# https://learn.microsoft.com/powershell/scripting/dev-cross-plat/vscode/using-vscode#debugging-with-visual-studio-code
# https://code.visualstudio.com/docs/editor/debugging

#endregion

#region Understanding error actions

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_commonparameters#-erroraction
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_preference_variables#erroractionpreference

$ErrorActionPreference
$ErrorActionPreference | Get-Member
[Management.Automation.ActionPreference] | Get-EnumValue

Get-ChildItem loll -ErrorAction SilentlyContinue

Get-Help Write-Error -ShowWindow

#endregion

#endregion


#region Module 6: Functions and modules

#region What are functions?

$func = { 'Hello' }
& $func
# https://peterwawa.wordpress.com/2011/01/26/kaustade-iguste-kaardistus/

Get-Command help
(Get-Command c:).Definition
(Get-Command pause).Definition

Get-Help about_Functions -ShowWindow

function get-hello { 'Hello' }
get-hello
get-command get-hello
get-item function:\get-hello | Remove-Item

code -r events06.ps1

#endregion

#region Using variable scopes

Get-Help about_Scope -ShowWindow
Get-Help Get-Variable -Parameter Scope

$minuasi = 'minu asi'
$minuasi
$local:minuasi
$script:minuasi
$global:minuasi

function katse {
    [CmdletBinding()]
    param (
        $InputObject,
            [switch]
        $PassThru
    )
    Write-Verbose -Message ('Minu asi on: {0}' -f $InputObject)

    $InputObject += ' + katsetuse asi'
    Write-Verbose ('Nüüd on asi: {0}' -f $InputObject)
    if ($PassThru) {
        <# return #> $InputObject
    }
}

katse -InputObject $minuasi -Verbose
katse -InputObject $minuasi -Verbose -PassThru

$minuasi = katse -InputObject $minuasi -Verbose -PassThru
$minuasi

Get-Help about_return -ShowWindow
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-08#854-the-return-statement

#endregion

#region Creating a module

# https://learn.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-script-module
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-11

code -r events06.psm1

Get-Help Export-ModuleMember -ShowWindow

Get-Help modules -Category HelpFile -ShowWindow

Import-Module .\events06.psm1
events06 -aeg ([datetime]::Now).AddHours(-2)
Get-Command -Module events06
Get-Help events06
Remove-Module events06

    # this is not module, it imports function to global scope
Import-Module .\events06.ps1
Get-Command events06 | Format-List
Remove-Item -Path function:\events06

Import-Module .\events06
Get-Module events06 | Format-List
Remove-Module events06

New-Module -Name SayHello -ScriptBlock {
    function get-hello {
        'Hello'
    }
} | Import-Module
Get-Module SayHello
get-hello
Remove-Module SayHello

#endregion

#region Using dot sourcing

# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-03#355-dot-source-notation
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator-

. .\events06.ps1
Get-Command events06
Get-Item function:\events06 | Remove-Item

#endregion

#endregion


#region Lab

# https://microsoftlearning.github.io/AZ-040T00-Automating-Administration-with-PowerShell/Instructions/Labs/LAB_07_Windows_PowerShell_Scripting.html

#endregion
