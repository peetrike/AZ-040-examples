# Lesson 1

help about_variables -ShowWindow

Get-Command -Noun variable
dir variable:

$HOME
Get-Content Variable:\HOME
Get-Variable home

$MinuMuutuja = "see on minu muutuja sisu"
Set-Variable -Name MinuMuutuja2 -Value "see on teise muutuja sisu"

$MinuMuutuja
$MinuMuutuja2

$prosessid = Get-Process p*
$prosessid
$prosessid.Count
$prosessid[1]
$prosessid[0]
$prosessid[-1]

$prosessid | Get-Member
$prosessid.GetType()

$MinuMuutuja | Get-Member
$MinuMuutuja.GetType()
$MinuMuutuja.count
$MinuMuutuja[12]
($MinuMuutuja -as [char[]])[12]
($MinuMuutuja -as [char[]]).GetType()

@() | Get-Member
@().GetType()

$uus = 10
$uus2 = (@(10) -as [int[]])
$uus.GetType()
$uus2.GetType()
$uus2 | Get-Member

$MinuMuutuja -is [string]
$uus2 -is [int]
$uus2 -is [int[]]
$uus2 -is [object]

$x = 10
$x = "see on tekst"

[int]$y = 10
$y = "teine tekst"

New-Variable -Name asi -Value "asi" -Option ReadOnly
$asi
$asi = "uus asi"
Set-Variable -name asi -Option Unspecified
Remove-Variable -Name asi #-Force
Set-Variable -name asi -Option Unspecified -Force
New-Variable asi2 -Option ReadOnly
$asi2 = "uhhuu"
$asi2 = "ahhaa"
Get-Variable asi2 | fl *

New-Variable -Name asi3
$asi3

$tekst = "*+*"
$tekst
$tekst + "ahhaa"
$tekst = $tekst * 7
$test = " uhhuu \"

help about_quoting -ShowWindow

$x = "5"
$y = 10
$x + $y
$y + $x
$z = @()
$z + $y + $x | Get-Member
$z = $z + $y + $x
$z
$z.Add("tere")

$z += "tere"
$z = 5, "10", "tere"
$z = 5..10

$MinuMuutuja
$MinuMuutuja = "see on uus tekst koos vana sisuga: $MinuMuutuja"
$prosessid[2].ProcessName
$MinuMuutuja = "see on uus tekst koos protsessi nimega: $prosessid[2].ProcessName"
$MinuMuutuja = "see on uus tekst koos protsessi nimega: $($prosessid[2].ProcessName)"
$MinuMuutuja = "see on uus tekst koos protsessi nimega: {0} - {1}" -f $prosessid[2].ProcessName, $prosessid[2].Id

Measure-Command {
1..100000 | foreach {
  "see on uus tekst koos protsessi nimega: {0} - {1}" -f $prosessid[2].ProcessName, $prosessid[2].Id
}}
Measure-Command {
1..100000 | foreach {
  "see on uus tekst koos protsessi nimega: $($prosessid[2].ProcessName) - $($prosessid[2].id)"
}}
Measure-Command {
1..100000 | foreach {
  "see on uus tekst koos protsessi nimega: " + $prosessid[2].ProcessName + " - " + $prosessid[2].id
}}

# Lesson 2

& 'C:\Program Files\Microsoft Learning\10961\Allfiles\Mod07\Democode\Test-CodesignedFile.ps1'
Get-ExecutionPolicy
Get-ExecutionPolicy -List
help about_Execution_Policies -ShowWindow
help Set-ExecutionPolicy
Set-ExecutionPolicy AllSigned -Scope Process -Force
& 'C:\Program Files\Microsoft Learning\10961\Allfiles\Mod07\Democode\Test-CodesignedFile.ps1' 
& 'C:\Program Files\Microsoft Learning\10961\Allfiles\Mod07\Democode\Test-NonCodesignedFile.ps1'
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
& 'C:\Program Files\Microsoft Learning\10961\Allfiles\Mod07\Democode\Test-NonCodesignedFile.ps1'
Set-ExecutionPolicy AllSigned -Scope Process -Force
& 'C:\Program Files\Microsoft Learning\10961\Allfiles\Mod07\Democode\Test-CodesignedFile-modified.ps1' 
    #Requires -RunAsAdministrator
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine

Set-ExecutionPolicy RemoteSigned -Scope Process -Force
C:\Users\Public\Documents\WmiExplorer.ps1
    #Requires -Version 3.0
Unblock-File C:\Users\Public\Documents\WmiExplorer.ps1
Get-Item C:\Users\Public\Documents\WmiExplorer.ps1 -Stream *
Get-content C:\Users\Public\Documents\WmiExplorer.ps1 -Stream Zone.Identifier
Get-Item 'C:\Users\Public\Desktop\IT Koolituse tagasiside.url'-stream *

Get-AuthenticodeSignature 'C:\Program Files\Microsoft Learning\10961\Allfiles\Mod07\Democode\Test-CodesignedFile.ps1' | fl *
Get-AuthenticodeSignature 'C:\Program Files\Microsoft Learning\10961\Allfiles\Mod07\Democode\Test-CodesignedFile-modified.ps1' | fl *
Get-AuthenticodeSignature 'C:\Program Files\Microsoft Learning\10961\Allfiles\Mod07\Democode\Test-NonCodesignedFile.ps1'
Get-Command -noun AuthenticodeSignature
