# Module 12

# Lesson 1

"midagi" | Get-Member

("midagi").ToUpperInvariant()
($env:PSModulePath).Split(";")
($env:PSModulePath).Split(";")[1]

help about_operators -ShowWindow
help about_split -ShowWindow
help about_join  -ShowWindow

($env:PSModulePath) -split ";"
"meie väike kiisu" -replace "meie","tema"

"tere", "tulemast" -join " "
ping www.ee
ping -n 1 www.ee
ping -n 1 polesellist
Test-Connection www.ee -Count 1
Test-Connection polesellist -Count 1
Test-Connection polesellist -Count 1 -ErrorAction SilentlyContinue


ping -n 1 www.ee | Select-String "TTL="
ping -n 1 polesellist | Select-String "TTL="

[bool](ping -n 1 www.ee | Select-String "TTL=")
[bool](ping -n 1 polesellist | Select-String "TTL=")

31..49 | foreach {ping -n 1 "192.168.3.$_" | Select-String "TTL="}

netstat -n
netstat -n | Select-String ":443 " | Select-String "established"
netstat -n | Select-String ":993 " | Select-String "established" | measure

help Select-String -ShowWindow
Get-Command grep
get-alias -Definition select-string

get-date | Get-Member
$kuupäev = (get-date).ToShortDateString().Split(".")
$kuupäev[2],$kuupäev[1],$kuupäev[0] -join "."

'{2}.{1}.{0}' -f (Get-Date).ToShortDateString().Split(".")
'{0:yyyy.MM.dd}' -f (Get-Date)

"1.7.2017" -as [datetime]
[datetime]"1.7.2017"
[datetime]"1/7/2017"
[datetime]"14/1/2017"
[datetime]"14.1.2017"

help about_operators -ShowWindow
help about_Type_Operators -ShowWindow


Get-CimInstance Win32_OperatingSystem | select lastboot*
Get-WmiObject Win32_OperatingSystem | select lastboot*
Get-WmiObject Win32_OperatingSystem | Get-Member
Get-WmiObject Win32_OperatingSystem | select lastboot*, @{
    name = "Last Boot up time"
    Expression = {$_.ConvertToDateTime($_.lastbootuptime)}
}

    #Requires -Modules ActiveDirectory
Get-ADUser administrator -Properties lastlogon, lastlogondate | Get-Member

    # see töötab
1 -in 1,2,3,4
1 -in 2,3,4,5

1,2,3,4 -contains 1
2,3,4,5 -contains 1

    # see ei tööta

get-process notepad | Stop-Process
start notepad
$p = Get-Process notepad
$p -in  (Get-Process notepad)
(Get-Process) -contains $p
get-process notepad | Stop-Process

$Matches
"mis kinni ei jää, saab kinni löödud" -match "kinni"
$Matches
"mis kinni ei jää, saab kinni löödud" -match ".*kinni.*"
$Matches

"192.168.12.15" -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"

    #kontrollime, kas on IP aadress
$tulemus = $true
$aadress = "926.168.1.15"
($aadress -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"), $aadress.split(".") |
    foreach {$_ -lt 256} |
    foreach {$tulemus = $tulemus -and $_ }
$tulemus


$PSDefaultParameterValues
Get-ADUser
Get-ADUser -Filter "Name -like 'Administrator'"

$PSDefaultParameterValues.Add("Get-AdUser:Filter","Name -like 'Administrator'")
Get-ADUser
Get-ADUser -filter "Name -like 'a*'"

$PSDefaultParameterValues.Remove("Get-AdUser:Filter")
Get-ADUser


Get-WmiObject 
$PSDefaultParameterValues.Add("Get-WmiObject:Class","Win32_OperatingSystem")
Get-WmiObject 
Get-WmiObject -Class Win32_Bios
$PSDefaultParameterValues.remove("Get-WmiObject:Class")
Get-WmiObject 


help Send-MailMessage -ShowWindow


$profile
$profile | Get-Member -MemberType Properties

$profile.AllUsersAllHosts

if (-not (Test-Path $profile)) {
    New-Item -Path $profile -ItemType File -Force
}
Test-Path $profile
ise $profile

# Lesson 3

Invoke-Command -ComputerName lon-dc1 -Credential "adatum\administrator" -ScriptBlock {whoami}

Get-Command -ParameterName credential | measure

get-help Invoke-Command -Parameter credential

$kasutaja = Get-Credential
$kasutaja | Get-Member

$kasutaja = Get-Credential -Message "anna siia serveri adminni identiteet"
Invoke-Command -ComputerName lon-dc1 -Credential $kasutaja -ScriptBlock {whoami}

$kasutaja.Password

$kasutaja | Export-Clixml -Path kasutaja.xml
notepad .\kasutaja.xml
$uus = Import-Clixml .\kasutaja.xml
$uus

$kasutaja.Password | ConvertFrom-SecureString | out-file parool.txt
notepad .\parool.txt

$pass = Get-Content .\parool.txt | ConvertTo-SecureString
$user = New-Object -TypeName System.Management.Automation.PSCredential `
                   -ArgumentList "domain\kasutaja", $pass
Start-Process -Credential $user -FilePath cmd.exe -ArgumentList "/k dir"

$kasutaja | Get-Member
$kasutaja.GetNetworkCredential()
$kasutaja.GetNetworkCredential() | Get-Member
$kasutaja.GetNetworkCredential().Password
