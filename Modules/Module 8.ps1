#region Safety to prevent the entire script from being run instead of a selection

throw "You're not supposed to run the entire script"

<#

    The code in this region was stolen, I mean borrowed from Thomas Rayner (@MrThomasRayner).

    For more information, see:

    http://mikefrobbins.com/2017/11/02/safety-to-prevent-entire-script-from-running-in-the-powershell-ise/

#>

#endregion

# Module 8 - Basic scripting

    # Lesson 1 - Introduction to scripting
help scripts -ShowWindow

'get-date
get-location
get-childitem
' > minuskript.txt

Get-Content .\minuskript.txt

powershell.exe -?

Get-Content .\minuskript.txt | powershell.exe -c -

invoke-item .\minuskript.txt
powershell.exe -file .\minuskript.txt
Copy-Item .\minuskript.txt minuskript.ps1
powershell.exe -file .\minuskript.ps1

get-command -noun ExecutionPolicy

Set-ExecutionPolicy Restricted -Scope Process
powershell.exe -file .\minuskript.ps1

get-module PowerShellGet -ListAvailable
Set-ExecutionPolicy RemoteSigned -Scope Process
Get-Command -Module PowerShellGet

find-module userprofile
find-module userprofile | Install-Module
find-module userprofile | Update-Module  # uuendamiseks

find-script ... | Install-Script

Get-PSRepository

Get-InstalledModule | Update-Module

Set-ExecutionPolicy Restricted -Scope Process
powershell.exe -ExecutionPolicy RemoteSigned -file .\minuskript.ps1

Get-ExecutionPolicy -List

#signeerimine
$cert = Get-ChildItem -Path "Cert:\CurrentUser\My" -CodeSigningCert
Set-AuthenticodeSignature -FilePath "C:\Scripts\MyScript.ps1" -Certificate $cert

get-command -noun FileCatalog  #grupi failide allkirjastamiseks


    # Lesson 2 - Scripting constructs

help about_foreach -ShowWindow

foreach ($i in 1..1KB) {
    write-output "number on $i"
}

$users = get-aduser -filter *
foreach ($kasutaja in $users) {
    write-output "kasutaja on $kasutaja"
}
# see on samaväärne
get-aduser -Filter * | foreach-object {
    write-output "kasutaja on $_"
}

help about_if -ShowWindow

if ($true) { "on tõene"}
elseif ($false) { "on väär"}
else {"on midagi muud"}

if (dir) { "on faile "}
else {new-item uus.txt}

$ErrorActionPreference

help about_switch -ShowWindow

switch ($choice) {
    1 { Write-Host “You selected menu item 1” }
    2 { Write-Host “You selected menu item 2” }
    3 { Write-Host “You selected menu item 3” }
    default { Write-Host “You did not select a valid option” }
}

Switch -WildCard ($ip) {
    “10.*” { Write-Host “This computer is on the internal network” }
    “10.1.*” { Write-Host “This computer is in London” }
    “10.2.*” { Write-Host “This computer is in Vancouver” }
    default { Write-Host “This computer is not on the internal network” }
}

switch -Regex ($choice) {
    "1|7" {}
    "2|8" {}
}

#region näide
$computer = "LON-CL1"
$role = "unknown role"
$location = "unknown location"
Switch -WildCard ($computer) {
    "*-CL*" {$role = "client"}
    "*-SRV*" {$role = "server"}
    "*-DC*" {$role = "domain controller"}
    "LON-*" {$location = "London"}
    "VAN-*" {$location = "Vancouver"}
    Default {"$computer is not a valid name"}
}
Write-Host "$computer is a $role in $location"
#endregion

help about_for -ShowWindow
for ($i = 1; $i -le 10; $i++) {
    Write-Host "Creating User $i"
}

help about_do -ShowWindow
help about_while -ShowWindow

Do {
    Write-Host “Script block to process”
} While ($answer -eq “go”)

Do {
    Write-Host “Script block to process”
} Until ($answer -eq “stop”)

$i = 1
while ($i -le 10) {
    write-output ("number on {0}" -f $i++)
}
$i

while ($true) {
    "teeme"
    Start-Sleep -Seconds 2
}

# muutujaga tegutsemiseks ei pea tal väärtust olema
Remove-Variable -Name i
$i++
$i

help about_break -ShowWindow
help about_continue -ShowWindow

ForEach ($user in $users) {
    If ($user.Name -eq “Administrator”) {Continue}
    Write-Host “Modify user object”
}


ForEach ($user in $users) {
    $number++
    Write-Host “Modify User object $number”
    If ($number -ge $max) {Break}
}
Write-Output "pärast tsüklit"

help about_try -ShowWindow

try {
    "teeme midagi mis võib katki minna"
    get-aduser meeeeee
    get-aduser meelis -ErrorAction Stop # erroraction on vajalik
    get-location
    miskijama
} catch [System.Exception.ResourceUnavailableException] { "ressurss puudu"}
catch {
    "tekkis viga, töötleme"
} finally {
    "seda teeme igal juhul, kas on või ei ole viga"
}

$oldErrorAction = $ErrorActionPreference
$ErrorActionPreference = "stop"
get-aduser meelis
#ja veel 100 käsku
$ErrorActionPreference = $oldErrorAction


# Lesson 3 - Importing data from files

help get-content -ShowWindow

Get-Content -Path “C:\Scripts\*” -Include “*.txt”, ”*.log”
Get-Content C:\Scripts\computers.txt -TotalCount 10
Get-Content file.txt -Tail 10


help import-csv -ShowWindow

import-csv kasutajad.csv | Select-Object name, e-mail

notepad katse.csv
import-csv .\katse.csv
get-content .\katse.csv

import-csv -header "yks", "kaks", "kolm" -Path .\katse.csv
import-csv -Encoding Default -UseCulture -delimiter ","
# täpitähed       # , või ;

help Import-Clixml -ShowWindow

get-process p* | export-csv protsessid.csv
import-csv protsessid.csv | get-member
get-process p* | Export-Clixml protsessid.xml
Import-Clixml .\protsessid.xml | get-member
dir protsessid.*

help ConvertFrom-Json -ShowWindow

# lisamaterjal, Out-GridView kui kasutajaliidese element:
help Out-GridView -ShowWindow

Get-ChildItem |
    Out-GridView -Title "mis failid soovid kustutada" -PassThru |
    Remove-Item -WhatIf

get-aduser -filter {City -like "Tallinn"} |
    Out-GridView -Title "mis kasutaja gruppi lisame" -OutputMode Single |
    Add-ADPrincipalGroupMembership -MemberOf "minu sobrad" -WhatIf
