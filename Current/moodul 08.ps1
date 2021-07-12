# Lesson 1
get-winevent -LogName Application -MaxEvents 10 |
    Where-Object ID -eq 8233

    # salvestame ülaltoodud skriptiks
powershell.exe -file 'C:\Users\Public\Documents\minuskript.ps1' -executionPolicy RemoteSigned
(Get-Content 'C:\Users\Public\Documents\minuskript.ps1') | powershell.exe -command -

C:\Users\Public\Documents\minuskript.ps1


get-winevent -LogName Application -ComputerName . |
    Where-Object ID -eq 8233 |
    select -First 10

Get-EventLog -LogName Application -ComputerName . |
    Where-Object eventID -eq 8233 |
    select -first 10

ise C:\Users\Public\Documents\minuskript.ps1

C:\Users\Public\Documents\minuskript.ps1 #-syndmus 1000 -kokku 1

help C:\Users\Public\Documents\minuskript.ps1 -detailed

C:\Users\Public\Documents\minuskript.ps1 -syndmus "ei tea" -kokku 1
C:\Users\Public\Documents\minuskript.ps1 "." 1000 1

help about_functions_advanced_parameters -ShowWindow

"yks", "kaks" | & "C:\Users\Public\Documents\minuskript.ps1" -kokku 1

help get-winevent -Parameter computername
help Get-Process -Parameter cn #computername
Get-Process -cn .

C:\Users\Public\Documents\minuskript.ps1 -cn "." 1000 -kokku 1

C:\Users\Public\Documents\minuskript.ps1 -cn . -kokku 1 -InformationAction Continue | Out-Null

help about_redirection -ShowWindow

C:\Users\Public\Documents\test-output.ps1 -informationaction Continue -ea Continue -debug -Verbose
C:\Users\Public\Documents\test-output.ps1 > väljund.txt 2>error.txt 3>verbose.txt

help about_comment_based_help -ShowWindow


# Lesson 2

Get-Command -Module UserProfile
Get-UserProfile | Get-Member

C:\users\Public\Documents\minufunktsioon.ps1
. C:\users\Public\Documents\minufunktsioon.ps1
Get-EventInfo -ComputerName . -syndmus 1000 -kokku 1
dir Function:\Get-EventInfo

dir Function:\Get-EventInfo | del

Get-Module C:\users\Public\Documents\minufunktsioon.psm1 -ListAvailable
Import-Module C:\users\Public\Documents\minufunktsioon.psm1
Remove-Module MinuFunktsioon
Get-Module
Get-EventInfo -ComputerName . 

$env:PSModulePath
Get-Module -ListAvailable
Get-Module | Remove-Module
Get-Module

$env:PSModulePath -split ";"
explorer ($env:PSModulePath -split ";")[1]

Get-Command -Module psreadline
Get-Module

New-Item -ItemType Directory -Path ($env:PSModulePath -split ";")[0] -Force
dir ($env:PSModulePath -split ";")[0]
New-Item -ItemType Directory -Name minufunktsioon -Path ($env:PSModulePath -split ";")[0]
copy C:\Users\Public\Documents\minufunktsioon.psm1 (Join-Path ($env:PSModulePath -split ";")[0] -ChildPath minufunktsioon)
Get-Module -ListAvailable

Get-Module minufunktsioon -ListAvailable
Get-EventInfo -ComputerName .
Remove-Module minufunktsioon
Get-EventInfo -ComputerName .
help Get-EventInfo
help Get-EventInfo -Parameter computername
Get-EventInfo -ComputerName . -Verbose
Get-EventInfo -ComputerName . -Debug


help about_functions_CmdletBindingAttribute -ShowWindow

# Lesson 3

help Set-StrictMode -ShowWindow
help Set-PSDebug -ShowWindow

dir polesellist.txt, fail.txt -ErrorAction Stop
dir polesellist.txt, fail.txt -ErrorAction SilentlyContinue
dir -Directory -Path C:\Users -Recurse -ErrorAction SilentlyContinue | Out-File kaustad.txt

$Error[0] | Get-Member

dir polesellist.txt, fail.txt -ErrorAction SilentlyContinue -ErrorVariable minuviga
$minuviga

try {
    dir polesellist.txt, fail.txt -ErrorAction Stop -ErrorVariable minuviga
}
catch {
    "Tekkis viga: $minuviga"
}


"polesellist.txt", "fail.txt" | foreach {
    $argument = $_
    try {
        dir $argument -ErrorAction Stop
    } catch {
        "midagi läks nihu: $argument"
    }
}




get-adcomputer -filter * |  foreach {
    $tulem = Test-NetConnection $_.name
    if ($tulem.tcptestsucceeded) {
        Get-CimInstance midagi -ComputerName $_
    }
    else {
        "masinat $_ pole võrgus"
    }
}

#Lesson 4


$number = 3
if ($number -eq 3) {"on küll"} else {"ei ole"}

$vastus = if ($number -ge 3) {"on"} else {"ei ole"}
$vastus

if (dir -file fail.txt) {"on faile jooksvas kaustas"} else {"ei ole faile"}

if (Get-Content .\fail.txt) {"siin on sisu"} else {"fail on tühi"}

$failisuurus = 738
if (
    (Get-Item .\fail.txt |
        select -ExpandProperty length) -ge $failisuurus
    ) {
    "siin on sisu"
} else {
    "fail on tühi"
}

    # tüübiteisendused
"2015.12.3" -as [datetime]
[datetime]"2015.12.3"

    # Vajab Windows 8.1 või värskemat, vastasel korral kasuta PING ja PORTQRY utiliite
Get-Command Test-NetConnection

if (
    Test-NetConnection www.ee | select -ExpandProperty PingSucceeded
) {
    "server vastab"
} else {
    "pole serverit"
}

if (
    Test-NetConnection www.ee -CommonTCPPort HTTP | select -ExpandProperty TCPTestSucceeded
) {
    "server (HTTP) vastab"
} else {
    "pole serverit"
}

help Set-StrictMode -ShowWindow
help Set-PSDebug -ShowWindow


$drive = Get-CimInstance Win32_LogicalDisk
switch ($drive.DriveType) {
    2 {"Ketas {0} on 2" -f $_.DeviceID}
    3 {}
    5 {}
    Default {}
}

Get-CimInstance Win32_LogicalDisk | ForEach-Object {
    $ketas = $_
    switch ($ketas.DriveType) {
#        2 { "Ketas {0} on selline" -f $ketas.DeviceID}
        3 {"Ketta {0} suurus on {1}" -f $ketas.DeviceID, $ketas.Size}
        Default {"ei hooli sellest"}
    }
}
$veerg = @{
    name="Kettatüüp"
    Expression = {switch ($_.DriveType){ 2{"Miski ketas"}; 3{"Kõvaketas"} }}
}

Get-CimInstance Win32_LogicalDisk | select DeviceId, $veerg
help about_Hash_Tables -ShowWindow


$vastus = Read-Host -Prompt "Kas Sa tahad jätkata"
switch -Wildcard ($vastus) {
    [jy]* {"jätkame"}
    e* {"ei jätka"}
    default {"loll oled, vastama pidi jah või ei"}
}

help about_switch -ShowWindow


$drives = Get-CimInstance Win32_LogicalDisk
foreach ($ketas in $drives) {
    switch ($ketas.DriveType) {
#        2 { "Ketas {0} on selline" -f $ketas.DeviceID}
        3 {"Ketta {0} suurus on {1}" -f $ketas.DeviceID, $ketas.Size}
        Default {"ei hooli sellest"}
    }    
}

foreach ($loendur in 1,3,5,7,9,10) {
    $loendur
}

1..10

foreach ($fail in (dir -File -Recurse)) { $fail.FullName }
    # samaväärne eelmisega
dir -File -Recurse | ForEach-Object { $_.FullName }

# Lesson 5

help about_debuggers -ShowWindow

for ($i=1;$i -le 10; $i++) {
    $i
}
help about_for -ShowWindow

$i = 1
$j=1
for (;$i -lt 10 -and $j -le 5;) {
    Write-Output ($i++)
    Write-Output ($j++)
}

$i=1
    # need on samaväärsed
$i++ # kasuta väärtust, ja siis suurenda
++$i # suurenda väärtust, ja siis kasuta
$i += 1
$i = $i + 1

$i=1
Write-Output $i ($i++) (++$i)
$i--


help about_do -ShowWindow

help about_while -ShowWindow

$i = 1
while ($true) {
    if ($i -gt 10) {
        break
    }
    "tere $i"
    $i++
}
 help about_break -ShowWindow
 help about_continue -ShowWindow

 help about_return -ShowWindow
 help about_language_keywords -ShowWindow
