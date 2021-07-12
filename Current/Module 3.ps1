# Module 3


# Lesson 1 - Understanding the pipeline

Get-Service
Get-Service -name BITS
Get-Service -name B*

Get-Service bits | select *
Get-CimInstance win32_userprofile
    # Requires -Modules UserProfile - install it from PowershellGallery.com
Get-UserProfile

# discovering object members
dir | Get-Member
Get-UserProfile | get-member
Get-UserProfile | select loaded, localpath, username

Get-Process power* | Get-Member
Get-Service bits | Get-Member
"esimene","teine" | Get-Member
1,2,3 | Get-Member

# format-*
help Format-List -ShowWindow
help Format-Table -ShowWindow

Get-ADUser meelis | Format-Table name,enabled
Get-ADUser -Filter {name -like "a*"} | Format-Table name, enabled
Get-ADUser -Filter {name -like "a*"} | Format-Table *

dir -Directory | Format-List *
dir -Directory | Format-Table *

dir | Format-Table -GroupBy psiscontainer
dir | gm
Get-Service a* | sort status | format-table -GroupBy status
    #see ei tööta
Get-Service a* | sort status | format-table -GroupBy status | Out-GridView
    #see töötab
Get-Service a* | sort status | Out-GridView

    #see ka ei tööta
Get-Service a* | sort status | Format-Table -GroupBy status | Export-Csv -Path asjad.csv
Get-Content .\asjad.csv

Get-Service a* | sort status | Export-Csv -Path asjad.csv
Get-Service a* | sort status | Format-Table -GroupBy status | Out-File -FilePath asjad.txt
Invoke-Item .\asjad.txt

Get-Service a* | sort status | Format-Table -GroupBy status | Get-Member


dir | Format-Wide -AutoSize
Get-Process | Format-Wide -AutoSize 
Get-Process | Format-Wide -Column 10


# Lesson 2 - Select, Sort and measure

dir | Sort-Object -Property length -Descending
Get-Process | Sort-Object -Property ws -Descending | Select-Object -First 10 | Stop-Process -Confirm

# group-object
Get-Service a* | Group-Object -Property status | select -first 1 | select -ExpandProperty group

Get-ADUser -filter {name -like "a*"} | Group-Object -Property enabled

Get-WinEvent -LogName Application -MaxEvents 10 | Group-Object -Property id

# measure-object
dir | measure-object
dir | measure-object -Property length -Sum -Maximum -Minimum -ave
Get-Content .\asjad.csv | Measure-Object -Word -Character
Get-ADUser -Filter * | Group-Object -Property enabled

# select-object
cd C:\windows\System32
dir | select -First 25
dir | select -last 10
dir | select -First 10 -Skip 12

    #see ei tööta
dir | select -first 1 -last 1 -Skip 1 -skiplast 1
    #see töötab
dir | select -first 1 -last 2 -Skip 1 | select -skiplast 1

$adminnid = net localgroup administrators | select -Skip 6 | select -SkipLast 2
$adminnid 
help select-object -ShowWindow

    # select-object -unique
Get-Process powers* | select -Unique -Property name 

New-ADGroup katse1 -GroupScope Global
New-ADGroup katse2 -GroupScope Global

Get-ADUser annie | Add-ADPrincipalGroupMembership -MemberOf katse1,katse2

Get-ADGroup -filter {name -like "katse*"} | Get-ADGroupMember | select -Unique
1,2,3,1,1,4 | select -Unique


# select -property
dir a*.exe | select -Property name, length | Get-Member


# calculated property

Get-PhysicalDisk | Get-Member
Get-CimInstance Win32_logicaldisk | get-member
$sizeGB = @{name="Size (GiB)"; Expression={ "{0:N2}" -f ( $_.size / 1GB)}}
$freeGB = @{name="Free (GiB)"; Expression={ "{0:N2}" -f ( $_.freespace / 1GB)}}
$freeGBformat = @{name="Free (GiB)"; Expression={$_.freespace / 1GB};format="N2";align="right"}

Get-CimInstance Win32_logicaldisk | Select-Object -Property DeviceID,$sizeGB,$freeGB,size,freespace |
     Get-Member
Get-CimInstance Win32_logicaldisk | Format-Table -Property DeviceID,$sizeGB,$freeGBformat,size,freespace

1MB
1KB
3TB

help select-object -Parameter Property
help format-table -Parameter Property
help format-table  -online

Get-Volume | Get-Member


# Lesson 3 - filtering objects

help about_comparison -ShowWindow

    # basic filtering syntax
Get-Service | Where-Object Status -eq Running
Get-Service | Where Status -eq Running

Get-Process | where CPU -gt 20

    #ilus kirjaviis
Get-Service | Where Status -eq Running
    # tegelik kirjaviis
Get-Service | Where -Property Status -EQ -Value Running
help Where-Object -ShowWindow

# advanced syntax
    #see ei tööta
Get-Service | where name.length -GT 5
    # see töötab
Get-Service | Where-Object -FilterScript {$_.Name.Length -gt 5}
Get-Service | Where {$_.Name.Length -gt 5}
gsv | ? {$_.Name.Length -gt 5}

Get-Service | where {$_.DisplayName -like "Background*"}
Get-Service | where {$false}


"tere" -as [bool]
"" -as [bool]
1 -as  [bool]

$null -as  [bool]
@() -as [bool]
1,2 -as [bool]

Get-ADUser -filter * | where {$_.enabled}
help Operator_Precedence -ShowWindow


#filter left
Get-Process | where Name -like p*
Get-Process -name p*

    # kiirem
Measure-Command {
    Get-ADUser -Filter {enabled -eq $true }
}
    #aeglasem
Measure-Command {
    Get-ADUser -filter * | Where-Object Enabled -eq $true
}


# Lesson 4 - Enumerating objects

help foreach-object -ShowWindow

#simple sytax
Get-Service | ForEach-Object -MemberName name
get-service | foreach name
gsv | % name

Get-ChildItem E:\ -Directory -Recurse |
    Where Name -eq Democode |
	ForEach-Object  -MemberName CreateSubdirectory -ArgumentList 'Test' |
    Select-Object FullName


# advanced syntax
dir *.ps1.txt | ForEach-Object {Rename-Item $_ -NewName $_.basename}
dir *demo?.txt | foreach {Rename-Item $_ -NewName $_.BaseName + ".ps1" }

dir | get-member

    #ära tee nii
Import-Csv kasutajad.txt |
    ForEach-Object {
        New-ADUser -name $_.nimi -GivenName $_.eesnimi -Surname $_.perenimi ...
    }


# Lesson 5 - Converting data

get-help out-file -ShowWindow
get-help out-file -Parameter nonewline
get-help out-file -Online


Get-Command -Verb convertto

get-service | ConvertTo-Csv -UseCulture -NoTypeInformation | Out-File -FilePath teenused.csv
notepad .\teenused.csv
rename-item .\teenused.csv teenused.txt
excel teenused.txt

Get-Service | Export-Csv -UseCulture -Path teenused.csv -NoTypeInformation -Encoding Default

get-service |
    select -Property status,name,displayname |
    export-csv -NoTypeInformation -UseCulture -Encoding Default -Path teenused.csv
invoke-item .\teenused.csv

get-service b* | ConvertTo-Xml -As String | out-file teenused.xml
notepad .\teenused.xml

help convertto-xml -ShowWindow
help convertto-xml -parameter as

help export-clixml -ShowWindow
get-service b* | Export-Clixml teenused.xml
Import-Clixml .\teenused.xml | Get-Member

get-service b* | Export-Csv teenused.csv
import-csv .\teenused.csv | Get-Member

get-service b* | ConvertTo-Xml -Depth 3 -as string | out-file teenused.xml
notepad .\teenused.xml
$teenused = get-service b* | ConvertTo-Xml -Depth 3 -as string
$teenused

Get-Credential -Message "ütle kasutaja parool" -UserName adatum\mina | Export-Clixml konto.xml
$kasutaja = Import-Clixml .\konto.xml 
$kasutaja | Get-Member

Get-Command -noun clixml

Get-Command -noun json
get-service b* | ConvertTo-Json | Out-File teenused.json


Get-Command -noun html
help ConvertTo-Html -ShowWindow
get-service b* | select -Property status,displayname | ConvertTo-Html | out-file teenused.htm
invoke-item .\teenused.htm

get-service b* | select -Property status,displayname |
     ConvertTo-Html -Body "see on teenuste tabel" -Title "Teenused" |
     out-file teenused.htm


get-command -Verb out

get-service  | select status,*name | sort status | Out-GridView

get-service |
    Where-Object Status -EQ Running |
    select status,*name | sort status |
    Out-GridView -Title "Vali teenus mida peatada" -OutputMode Single |
    Stop-Service

dir -file |
#    select name, length, creationtime |
    Out-GridView -Title "vali failid mida kustutada" -OutputMode Multiple | #get-member
    Remove-Item -whatif

    #see ei tööta Powershell ISE-s
get-service | out-host -Paging
