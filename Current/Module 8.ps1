# Module 8

# Lesson 1 - introduction

    # mis on skript
"get-date","dir" > laused.txt
get-content laused.txt

powershell.exe -file laused.txt

get-content laused.txt | powershell -c -

rename-item laused.txt laused.ps1
powershell -file laused.ps1
.\laused.ps1
laused.ps1
$env:Path.split(";")

ise laused.ps1
    #pärast seda vajutad Powershell_ISE sees F5 (või Ctrl-A, F8)

get-command ise

    #millega skripte redigeerida
ise laused.ps1
code laused.ps1
    #https://code.visualstudio.com

    #kust saada skripte/mooduleid
find-module userprofile | install-module
find-module msi | update-module
Get-PSRepository

help Publish-Module
help publish-script

help find-script
help install-script -show
Find-Command get-userprofile -Repository itkrepo | save-module -Path c:\katse

get-command -noun module


UserPRofile\Get-UserProfile

# Script Launch security
start .

Get-ExecutionPolicy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Get-ExecutionPolicy -list
Set-ExecutionPolicy RemoteSigned -Scope process

help about_execution -show

Set-ExecutionPolicy Restricted -Scope Process
.\laused.ps1

help Unblock-File

Set-ExecutionPolicy AllSigned -Scope Process
.\laused.ps1
Set-ExecutionPolicy RemoteSigned -Scope Process
.\laused.ps1

Set-ExecutionPolicy Restricted -Scope Process
get-content laused.ps1 | powershell -c -

Set-ExecutionPolicy RemoteSigned -Scope Process
Get-ExecutionPolicy -list

powershell.exe -?


    # koodi allkirjastamine
help about_signing -ShowWindow

get-childitem cert:\CurrentUser\my -codesigning

Get-Command -Noun authenticode*
get-command -noun filecatalog


# Lesson 2 - scripting constructs

help about_foreach -ShowWindow

$numbrid = 1,2,3,4,5,6,7,8

$numbrid | ForEach-Object -Process {$_}

foreach ($number in $numbrid) {
    $number
}

get-aduser -filter * -ResultPageSize 20 | foreach-object { $_ }
help get-aduser -Parameter resultsetsize
help get-aduser -Parameter resultpagesize


help about_if -ShowWindow

$numbrid.Count -as [bool]
$tyhi = @()
$tyhi.Count -as [bool]

if ($numbrid.Count) {
    "on elemente"
} else {
    "täitsa tühi"
}

if ($tyhi.Count) {
    "on elemente"
} else {
    "täitsa tühi"
}

if ($tyhi.Count) {
    "on elemente"
} elseif ($numbrid.count) {
    "numbreid ikka on"
} else {
    "täitsa tühi"
}

$freespace = 7GB
$freespace = 4GB
$freespace = 14GB
if ($freeSpace -le 5GB) {
    Write-error "Error: Free disk space is less than 5 GB"
} elseif ($freeSpace -le 10GB) {
    Write-warning "Warning: Free disk space is less than 10 GB"
} else {
    Write-output "OK: Free disk space is more than 10 GB"
}


help about_switch -ShowWindow

$vastus = Read-Host -Prompt "kas Sa tahad jätkata?"
switch ($vastus) {
    "jah" { "olgu"}
    "ei" {"kahju"}
    Default {"proovi uuesti"}
}

$vastus = Read-Host -Prompt "kas Sa tahad jätkata? [j/e]"
switch -Wildcard ($vastus) {
    "[jy]*" { "olgu"}
    "e*" {"kahju"}
    Default {"proovi uuesti"}
}

$ip = "10.1.2.3"
$ip = "10.3.4.5"
switch -Regex ($ip) {
	"10`.1`..*" { Write-Host "This computer is in London"; break }
	"10`.2`..*" { Write-Host "This computer is in Vancouver"; break }
    "10`..*" { Write-Host "This computer is on the internal network" }
	default { Write-Host "This computer is not on the internal network" }
}


help about_for -ShowWindow

for($i=1; $i -le 10; $i++) {
    Write-Host "Creating User $i"
}


help about_do -ShowWindow
help about_while -ShowWindow

$answer = ""
Do {
    Write-Host "Script block to process"
    $answer = read-host -prompt "kas tahad veel?"
} While ($answer -eq "jah")

Do {
    Write-Host "Script block to process"
    $answer = read-host -prompt "kas tahad veel?"
} until ($answer -eq "ei")

$answer = "jah"
while ($answer -eq "jah") {
    "teeme midagi"
    $answer = read-host -prompt "tahad jätakata?"
}

while ($true) {
    "teeme"
    start-sleep -sec 3
    $answer = read-host -prompt "lõpetame?"
    if ($answer -eq "jah") {
        break
    }
}


help about_break -ShowWindow


# Lesson 3 - importing data

dir *.txt
get-content -Path .\* -include *.txt -TotalCount 2

help get-content -Parameter tail

get-command -verb import -module microsoft.powershell.*
get-command -verb export -module microsoft.powershell.*

get-command -verb convertto -module microsoft.powershell.*
get-command -verb convertfrom -module microsoft.powershell.*

[xml]$data = get-content file.xml
