# Module 7

#mis on skript
get-date
whoami

"get-date; whoami" > käsud.txt
Get-Content .\käsud.txt | powershell -command -

# lesson 1

Get-Command -Noun variable

New-Variable -Name minu -Value "asi"
Get-Variable -Name minu | select -ExpandProperty value
New-Variable -name teeme -Value {get-date; whoami}
Get-Variable -Name teeme | select -ExpandProperty value | Invoke-Expression

# teeme natuke lihtsamalt
$minu
& $teeme

Set-Variable -Name minu -Value "uus asi"
$minu = "midagi muud"
$minu
$minu * 3
"*" * 24
"see siin on $minu"
Get-Variable

Remove-Variable -Name minu

$minu
Set-PSDebug -Strict

$nädal = "p","e","t","k","n","r","l","p"

$nädal
$nädal[1]
$nädal[7]
$nädal[0]
$nädal[-3]

$number = "34"
$number | Get-Member
$number + 3
3+$number
3*$number
$number*3
$minu = "miski asi"
$minu |Get-Member
$minu.Length
$minu.ToUpper()
$failinimi = "  minu fail.txt  "
$failinimi.Trim()

$number | Get-Member
$number -as [int] | Get-Member
[int]$number | Get-Member
$number -is [int]
$number -is [string]
[datetime]"11.1.2017"
[datetime]"2017.1.18"
$hulk= @($minu)
$hulk.GetType()
$minu.GetType()

"see siin on $minu"
'see siin on $minu'
"tere" > 'minu asi.txt'
& '.\minu asi.txt'
$teenused = Get-Service b*
$teenused
"minu teenused on: $teenused."
$teenused[3]
"minu teenused on: $($teenused[3].Name)"
'minu teenused on: {0}' -f $teenused[3].Name


# Lesson 2
"get-date; whoami" > käsud.ps1
Get-Content .\käsud.ps1 | powershell -command -
powershell.exe < .\käsud.txt
.\käsud.ps1
.\käsud.txt
start .

help about_exec -ShowWindow

powershell.exe -file käsud.ps1
powershell.exe -file .\käsud.txt

help about_Signing -ShowWindow
Get-ExecutionPolicy -List
Set-ExecutionPolicy RemoteSigned -Scope Process

dir käsud.ps1
.\käsud.ps1
Get-Command ping
