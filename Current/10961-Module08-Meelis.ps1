# Module 8

# Lesson 1

Get-Date | Get-Member

$aeg = (Get-Date).AddDays(-1)

Get-WinEvent -MaxEvents 10 -FilterHashtable @{
    LogName = "application"
    ID = 15
    StartTime = $aeg
}


events.ps1 -aeg (get-date).AddDays(-10)

$true
$false
C:\Users\Public\Documents\events04.ps1
Set-ExecutionPolicy RemoteSigned -Scope Process

help C:\Users\Public\Documents\events04.ps1

C:\Users\Public\Documents\events04.ps1 -Computername .

C:\Users\Public\Documents\events05.ps1 -Computername . -Verbose | Out-File midagi.txt

Get-Command -verb write

help C:\Users\Public\Documents\events06.ps1 -ShowWindow

powershell.exe -?

find-module isesteroids | install-module
Find-Module -Tag profile

Import-Module C:\Users\Public\Documents\events07.psm1
Get-Command events07
help events07
Get-Module events07 | Remove-Module

    #nendest kaustadest oskab Powershell ise mooduleid otsida ja laadida
$env:PSModulePath
$env:PSModulePath -split ";"
($env:PSModulePath -split ";")[0]
dir ($env:PSModulePath -split ";")[1]
start ($env:PSModulePath -split ";")[1]

# Lesson 3

Get-WinEvent -ComputerName localhost -MaxEvents 1 -LogName application
Get-Content asjad.txt
Get-Process uhuu*

Get-WmiObject Win32_OperatingSystem -ComputerName lon-svr1, .

$ErrorActionPreference
$ErrorActionPreference = "SilentlyContinue"
Get-WmiObject Win32_OperatingSystem -ComputerName lon-svr1, .

$ErrorActionPreference = "Continue"
Get-WmiObject Win32_OperatingSystem -ComputerName lon-svr1, .
$ErrorActionPreference = "Stop"
$ErrorActionPreference = "Inquire"

Get-WmiObject Win32_OperatingSystem -ComputerName lon-svr1, . -ErrorAction SilentlyContinue


try {
    Get-WmiObject Win32_OperatingSystem -ComputerName lon-svr1, . -ErrorAction Stop
} catch {
    Write-Warning "tekkis miski viga"
}

try {
    Get-WmiObject Win32_OperatingSystem -ComputerName . -ErrorAction Stop
} catch {
    Write-Warning "tekkis miski viga"
}

help about_try -ShowWindow

    # siin ei lähe catch tööle ...
try {
    Get-WmiObject Win32_OperatingSystem -ComputerName lon-svr1, . -ErrorAction Continue
} catch {
    Write-Warning "tekkis miski viga"
}

try {
    Get-WmiObject Win32_OperatingSystem -ComputerName lon-svr1, . -ErrorAction Stop
} catch {
    Write-Warning ("tekkis viga: {0}" -f $Error[0])
}
$Error[0]
$Error
$Error.Clear()

$Error | Get-Member
$Error[0].Exception
$Error[0].FullyQualifiedErrorId


try {
    Get-WmiObject Win32_OperatingSystem -ComputerName lon-svr1, . -ErrorAction Stop -ErrorVariable minuviga
} catch {
    Write-Warning ("tekkis viga: {0}" -f $minuviga)
}
 $minuviga | Get-Member

 try {} catch {}

 # logimine

function Write-Logfile {
    Param(
        $FileName,
        $Message
    )

    ("{0}`t{1}" -f (Get-Date), $Message) | Out-File -FilePath $FileName -Append
}


Write-Logfile -FileName minulogi -Message "see on minu teade"
Get-Content .\minulogi

$myProvider = "minuskript"
try {
  Get-WinEvent -ListProvider $myProvider | Out-Null
} catch {
  Start-Process -Verb runas powershell.exe -ArgumentList "New-EventLog -LogName Application -Source $myProvider"
}

$params = @{
  LogName = "Application"
  Source = $myProvider
  EventId = 1
  Message = "Minu kohandatud sündmus"
}
Write-EventLog @params
 
Get-WinEvent -ProviderName $myProvider

 # Lesson 4

$a = 4
$a -eq 5

if ($a -eq 5) {
    "on võrdne"
}

$a = 5
if ($a -eq 5) {
    "on võrdne"
}

$a = 4
if ($a -eq 5) {
    "on võrdne"
} else {
    "ei ole võrdne"
}

md kaust
$kaust = Get-Item .\kaust
$kaust.PSIsContainer

if ($kaust.PSIsContainer -eq $true ) { "on kaust" } else { "ei ole kaust"}
if ($kaust.PSIsContainer) { "on kaust" } else { "ei ole kaust"}

rd .\kaust
dir kaust # tuleb veateade
dir kaust* # ei tule veateadet

if (dir kaust*) { " on olemas kaust" } else { " ei ole olemas kausta"}

md kaust
if (dir kaust*) { " on olemas kaust" } else { " ei ole olemas kausta"}

1 -as [bool]
0 -as [bool]
"tere" -as [bool]
"" -as [bool]
(dir)  -as [bool]
@() -as [bool]


help about_switch -ShowWindow

$drive = Get-CimInstance Win32_LogicalDisk
$drive.DriveType
Switch ($drive.DriveType) {
    3 { "See on kõvaketas"}
    5 { "see on ajalugu" }
    Default { "midagi muud"}
}

$kettatyyp = Switch ($drive.DriveType) {
    3 { "kõvaketas"}
    5 { "ajalugu" }
    Default { "midagi muud"}
}

"ketas {0} on {1}" -f $drive.DeviceID, $kettatyyp


Get-Command -Noun host
help Read-Host -ShowWindow
Read-Host "kas sa tahad jätkata?"

$vastus = Read-Host -Prompt "kas sa tahad jätkata? [J/e]"

Switch -Wildcard ($vastus) {
    ""  { "sa ütlesid jah"}
    "j*" {"ok"}
    "e*" {"kahju küll"}
    Default {"ei saanud aru"}
}


1..10 | ForEach-Object -Process {"number $_"}
foreach ($number in 1..10) {
    "number $number"
}

$number = 0
foreach ($fail in (dir -File)) {
    $number++
    "protsessime faili: {0}" -f $fail.fullname
    if (-not ($number % 5)) {
        "`tpaneme kõrvale"
    }
}


$number = 0
dir -File | Where-Object {$true} | foreach {
#    $number++
    write-verbose -Message ("protsessime faili: {0}" -f $_.fullname)
    if (-not (++$number % 5)) {
        write-verbose -Message ("`tpaneme kõrvale: {0}" -f $_.fullname)
        $_ | Move-Item -Destination $env:TEMP -WhatIf
    }
}

$number = 0
$number++
$teine = $number++
$kolmas = ++$number
$teine
$kolmas
$number


help functions_advanced_parameter -ShowWindow

function process-file {
    Param(
            [Parameter(
                Mandatory=$true,
                ValueFromPipeline=$true
            )]
            [System.IO.FileInfo]
        $file,
            [string]
        $destination = $env:TEMP,
            [int]
        $fraction = 5
    )

    BEGIN {
        $number = 0
    }

    Process {
        write-verbose -Message ("protsessime faili: {0}" -f $file.fullname)
        if (-not (++$number % $fraction)) {
            write-verbose -Message ("`tpaneme kõrvale: {0}" -f $file.fullname)
            $file | Move-Item -Destination $destination -WhatIf
        }
    }
}

dir -File | Where-Object {$true} | process-file -fraction 7

help process-file

#lesson 5

