# Lesson 1

Get-Service
Get-Service |
    Out-File teenused.txt
Get-Content .\teenused.txt

Get-Service |
    Out-GridView
Get-Service | Select-Object -Property * | Out-GridView

Get-Service |
    Export-Csv teenused.csv
Get-Content .\teenused.csv
$teenused = Import-Csv .\teenused.csv
$teenused

Get-Service | Select-Object -Property name, status

Get-Service | Get-Member
Get-WmiObject win32_service | Get-Member -MemberType Properties
Get-CimInstance win32_service | Get-Member -MemberType Properties
services.msc
get-service msdtc | select * | Out-GridView
Get-CimInstance win32_service  | select * | Out-GridView

  # get-childitem
dir
dir | Get-Member
#Requires -Version 3.0
dir -File
dir -Directory

Get-Service
Get-Service | Sort-Object -Descending -Property Name

Get-Command -Noun object

notepad; notepad; notepad
Get-Process notepad | sort -Unique
Get-Process notepad | Sort-Object -Property name, id -Unique
dir -File | sort length -Descending

dir -File | Measure-Object -Property length -Average -Sum -Maximum -Minimum

dir -File | sort -Descending -Property length | Select-Object -First 1
dir -File | Sort-Object -Property length | Select-Object -Last 1
dir -File | Sort-Object -Property length -Descending | Select-Object -Skip 1 -First 1

ping www.ee | Select-Object -Skip 2 -First 4

dir -File | Select-Object -Property name, length, mode | Get-Member
dir -File | Out-GridView
dir -File | Select-Object -Property * | Out-GridView
dir -File | Select-Object -Property e*,n*

# kalkuleeritud veerud
$suurus = @{name="length(MB)"; expression={$_.Length / 1MB}}
$suurus = @{
    name="length (MB)"
    expression={"{0:N2}" -f  ($PSItem.Length / 1MB)}
}
dir -File | select name, $suurus
1MB
1GB
1PB

Get-Volume
Get-Volume | Get-Member
Get-Volume | select driveletter, size
Get-Command -Noun volume


# Lesson 3

Get-Command -Verb convert*,export

dir | ConvertTo-Csv | Out-File ...
dir | Export-Csv ...
dir | Select-Object -Property name, ext*, len* | ConvertTo-Html | Out-File failid.htm
Invoke-Item .\failid.htm

help Out-File -ShowWindow
Get-Command -Verb out

help Out-Host

dir -file | Export-Csv -UseCulture failid.csv
dir  | Export-Clixml failid.xml
Invoke-Item .\failid.csv
Invoke-Item .\failid.xml
$failid = Import-Csv .\failid.csv -UseCulture
$failid | Get-Member
$failid | select mode, name, length
$failid = Import-Clixml .\failid.xml

Get-Command -verb import

Get-Item .\miski | Rename-Item -NewName miski.txt

Get-Command -noun item

# Lesson 4
help about_comparison_operators
100 -gt 10
10 -gt 100
10 -ne 12
"tere" -gt "tera"
    # mustriga võrdlus
"Powershell" -like "Power*"
"Windows" -like "*ws"
"Windows" -notlike "*shell"
10 -like "10*"
10 -eq "10"
    # regulaaravaldis
"tere" -match "t.*e"

    # hulgad
"tere" -in "tere", "tera", "asi"
"tere", "tera", "asi" -contains "tere"

    # case sensitive ...
"Tere" -ceq "tere"
"Tere" -ieq "tere"
"Tere" -clike "t*"

    # andmetüübi võrdlus
10 -is [int]
"10" -is [int]
10 + 1
("10" + 1) -is [int]

    # andmetüübi teisendus
"1,000" -as [int]
"2015/10/23" -as [datetime]

    #filtreerimine
help Where-Object
Get-Service | Where-Object -Property Status -eq -Value "Running"
Get-Service | Where Status -eq "Running"
gsv | ? Status -eq "Running"
    #see ei tööta
Get-Service | where Name.Length -gt 5
    #Where-Object {}
Get-Service | Where-Object -FilterScript {$_.Name.Length -gt 5}
Get-Service | Where-Object {$_.Name.Length -gt 5 -and $_.status -like "Running"}
Get-Process | Get-Member
Get-Process p* | Where-Object {$_.Responding}
Get-Process p* | Where-Object {-not $_.Responding}
ping www.ee
ping www.ee | where {$_}
net localgroup Administrators
net localgroup Administrators | select -skip 6 | where {$_ -and $_ -notlike "The command*successfully."}

(Get-Process p* | where Processname -eq "Powershell").count
(Get-Process Powershell).Count
Get-Process p* | where Processname -eq "Powershell" | measure

(dir -File) -as [boolean]

    # filter left
Get-ADUser -Filter * | Measure-Object

Measure-Command {
  Get-ADUser -Identity Administrator
}

Measure-Command {
  Get-ADUser -Filter {Name -like "Admin*"}
}

Measure-Command {
  Get-ADUser -Filter * | Where-Object Name -Like "Administrator"
}

Get-Volume | where {$_.Size -and $_.SizeRemaining/$_.Size -lt 0.5}

# Lesson 5
help ForEach-Object
get-alias -Definition "ForEach-Object"

dir -File | ForEach-Object Encrypt
dir -File | ForEach-Object {cipher.exe $_.FullName}

Get-Volume |
  where {$_.Size -and $_.SizeRemaining/$_.Size -lt 0.5} |
  ForEach-Object {
    Send-MailMessage -from "server@adatum.com" -To admin@adatum.com -Subject "ketas saab täis" -Body "Sinu ketas $($_.driveletter) on poolenisti täis"
  }

"Sinu ketas $($_.driveletter) on poolenisti täis"
"Sinu ketas {0} on poolenisti täis" -f $_.driveletter

    # Foreach kui loenduriga kordus
help Get-Random
Get-Random -Minimum 65 -Maximum 90
(Get-Random -Minimum 65 -Maximum 90) -as [char]
1..15 | foreach {(Get-Random -Minimum 65 -Maximum 90) -as [char]}
-join (1..15 | foreach {(Get-Random -Minimum 40 -Maximum 120) -as [char]} )
-join (1..(Get-Random -Minimum 12 -Maximum 20) | foreach {(Get-Random -Minimum 33 -Maximum 126) -as [char]} )

# Module review
Get-Service a* | Select-Object -Property Name
Gsv a* | Select Name
Get-Service a* | ForEach Name
Get-Service a* | % { $_.Name }
Get-Service -Name a* | Format-Table -Property name
