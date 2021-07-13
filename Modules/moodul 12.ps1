# Lesson 1

    # mängime stringiga
"tekst" | Get-Member -MemberType Method

dir | Export-Clixml -Path failid.xml

$MinuMuutuja = Import-Clixml -Path .\failid.xml
$MinuMuutuja | Get-Member

$MinuMuutuja[3].FullName | Get-Member

$MinuMuutuja[3].FullName.ToUpper()
$MinuMuutuja[3].FullName.Split("\")[-1]

$MinuMuutuja[3].FullName.IndexOf("märk")
$MinuMuutuja[3].FullName.Substring(35,4)

$env:PSModulePath.Split(";")[1]
($env:PSModulePath -split  ";")[1]

$MinuMuutuja[3].FullName -replace "\\", "/"

Get-Item ($MinuMuutuja[3].FullName -replace "\\", "/")


    #mängime kuupäevaga
Get-Date
Get-Date | Get-Member
(get-date).DayOfWeek
[datetime]"2015.11.30" | Get-Member
dir .\fail.txt | select -ExpandProperty lastwritetime | Get-Member

$kuupaev = dir .\fail.txt | select -ExpandProperty lastwritetime
(get-date) - $kuupaev | select totalhours
(get-date).AddDays(-10)
(get-date).AddDays(-10) -gt $kuupaev

dir -Path c:\ -Recurse -File | Where-Object {$_.LastWriteTime -le (get-date).AddDays(-1)}

(get-date) - (New-TimeSpan -Days 10)

(get-date).AddMonths(-3)
([string]((get-date).Year) + ".12.25" -as [datetime]) - (get-date) | select -ExpandProperty days

$aega = [datetime]"2015.12.25" - (Get-Date)
"jõuludeni on veel {0} päeva aega" -f $aega.days

Get-ADUser administrator | Format-List *

Get-ADUser administrator -Properties * 

Get-ADUser -filter * -Properties PasswordNeverExpires,mail |
    Where-Object PasswordNeverExpires -eq true |
    measure

#Requires -Modules ActiveDirectory
 
Search-ADAccount -AccountInactive -TimeSpan 90.00:00:00 -UsersOnly
 
$ammu = (Get-Date).AddDays(-90)
 
Get-ADUser -Filter {logonCount -ge 1 -and LastLogonDate -le $ammu} |
  Move-ADObject -TargetPath "ou=kadunud hinged"
 
Get-ADUser -Filter {Enabled -eq $true -and PasswordLastSet -le $ammu} `
  -SearchBase "ou=IT,ou=kasutajad,dc=firma,dc=ee"
 
Get-ADComputer -Filter {PasswordLastSet -le $ammu} | Disable-ADAccount

    # WMI and CIM
Get-CimInstance Win32_OperatingSystem | select lastbootuptime

Get-WmiObject Win32_OperatingSystem | select lastbootuptime
Get-WmiObject Win32_OperatingSystem | Get-Member

$kuupaev = @{
    name="kuupäev"
    expression={$_.converttodatetime($_.lastbootuptime)}
}

Get-WmiObject Win32_OperatingSystem | select lastbootuptime, $kuupaev

(get-date) - (Get-CimInstance Win32_OperatingSystem | select -ExpandProperty lastbootuptime)
(get-date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime


    # advanced operators
dir -file
$minufail = Get-Item .\fail.txt

(dir -file) -contains $minufail
$minufail -in (dir -File)
$minufail | Get-Member
$minufail.GetType()
$minufail

$minufail | select lastaccesstime
Get-Item .\fail.txt | select lastaccesstime

$minufail = dir -File | select -First 1
Compare-Object $minufail (dir -File)

Get-Help Compare-Object -ShowWindow

Compare-Object $minufail (dir -File) -IncludeEqual -ExcludeDifferent | select -exp inputobject


(dir -file | select -ExpandProperty name) -contains $minufail.Name
    #Requires -Version 3
(dir -file).Name -contains $minufail.Name

$hulk = "yks", "kaks", "kolm", "neli"
$hulk -contains "yks"
$hulk -contains "kymme"
"yks" -in $hulk
"kymme" -in $hulk


$ip = Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin Dhcp
$iphulk = $ip.ipaddress.Split(".")
if ($ip.IPAddress -like "192.168*" -and $iphulk[2] -eq 2) { "õige võrk"}
else {"Appi! Sissetungija!"}


help about_preference -ShowWindow
help about_Parameters_Default_Values -ShowWindow

$PSDefaultParameterValues
$PSDefaultParameterValues = @{}
$PSDefaultParameterValues = @{"get-childitem:Path"="c:\users"}
Get-ChildItem
Get-ChildItem -Path .

$PSDefaultParameterValues.add("get-ciminstance:ComputerName","lon-cl1")
$PSDefaultParameterValues

dir .\fail.txt
icacls.exe /?
icacls.exe .\fail.txt /grant Everyone:"(r)"

icacls --% .\fail.txt /grant Everyone:(r)

bcdedit.exe -delete "{default}"
bcdedit.exe --% -delete {default}

help "--%"

ping www.ee | Select-String "TTL=" | select -Unique
ping polesellist | Select-String "TTL=" | select -Unique

# Lesson 2

help about_profiles -ShowWindow
$profile

ise $profile
if (Test-Path $profile) { 
    #olemas
} else {
    New-Item -ItemType File -Path $profile -Force
}

ise $profile
$profile | Get-Member
$profile.AllUsersAllHosts
$profile.CurrentUserAllHosts

New-Item -Path $profile.CurrentUserAllHosts -ItemType File -Force
ise $profile.CurrentUserAllHosts

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

dir Function:\prompt
Get-Content Function:\prompt

function Prompt {
#"PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
    Write-host "PS " -NoNewline -ForegroundColor (Get-Random -Minimum 10 -Maximum 15)
    ">"
}

$Host.UI.RawUI.WindowTitle = "ahhaa"

"`nGet-ChildItem c:\`n" | Out-File -Append $profile.CurrentUserAllHosts


# Lesson 3

Get-Command -ParameterName Credential | measure
Update-Help
Update-Help -Credential .\admin

$admin = Get-Credential -Message "Ütle adminni õigustes nimi/parool" -UserName mina
$admin | Get-Member

$admin.Password
    
    # ettevaatust !!!
$admin.GetNetworkCredential().Password

$parool = ConvertTo-SecureString -String "Password" -AsPlainText -Force
$teinekasutaja = New-Object -TypeName System.Management.Automation.PSCredential `
    -ArgumentList "Mina", $parool
$teinekasutaja
$teinekasutaja.GetNetworkCredential().Password | out-file lahtineparool.txt

Import-Csv | foreach {
    $parool = ConvertTo-SecureString -String $_.password -AsPlainText -Force
    new-aduser -AccountPassword $parool -enabled $true
}
