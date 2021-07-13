# Module 2

#Lesson 1
Get-Service b* | Stop-Service -WhatIf
Get-Process powershell | Stop-Process -Confirm
Get-Service b* | Out-File .\teenused.txt
Get-Service b* | Tee-Object -FilePath .\teenused2.txt | Stop-Service
Get-Service bits | Stop-Service

Get-Process p*
Get-Process powershell_ise | Format-List *
dir
dir .\minu.txt | Format-List *
dir .\minu.txt | Get-Member
dir | Get-Member 

1, "tere", 3, "veel midagi" | Get-Member

(dir *.txt), (get-process p*)

# sordime
dir | Get-Member
dir | sort -Property Length -Descending
dir | Sort-Object -Property CreationTime -Descending

"tere" > .\teenused.txt
dir | Sort-Object -Property CreationTime -Descending
help Sort-Object -ShowWindow
Get-Process powershell | sort -Unique -Property Id

"tere" > päike.txt
"tere" > pabin.txt
"tere" > puukoor.txt
dir
dir | sort -Culture en-us
dir | sort -Culture et-ee
dir | sort -Culture de-de
dir | Measure-Object -Property Length -Sum -Average -Maximum -Minimum
Get-Process p* | measure -Property vm -Sum -Average
dir -Recurse -file | measure -Property length -Sum
"tere" > .\Adobe\tere.txt

# select
dir | sort length -Descending | Select-Object -First 3
dir | sort length -Descending | Select-Object -last 2
dir | sort length -Descending | Select-Object -First 5 | select -Last 2
dir | sort length -Descending | Select-Object -First 3 -Skip 1
dir -file | Get-Member
dir -file | Select-Object -Property name, length | Get-Member
dir | Select-Object -Property * | Out-GridView
dir | select -Property name, length, @{name="Lenght (MB)"; Expression={ "{0,5:n1}" -f ($_.length/1MB)}}
$lengthmega = @{Name="Size MB"; Expression={ "{0,6:n1}" -f ($_.length/1MB)}}
dir | select -Property name, length, $lengthmega
$lengthMB = @{Name="Lenght (MB)"; Expression={$_.length/1MB}; formatstring="N1"}
dir | Format-Table -Property name, length, $lengthmega, $lengthMB
help Select-Object -online
help Format-Table -ShowWindow

help Get-Volume
Get-Volume | Get-Member
Get-Volume | select driveletter,size*

# lesson 3

Get-Command -Verb convertto -Module microsoft.powershell*
Get-Command -verb export -Module microsoft.powershell*

Get-Command powers* | ConvertTo-Csv | Out-File powershell.csv
Get-Content .\powershell.csv

Get-Command powersh* | Export-Csv -Path powershell2.csv

Get-Process powersh* | Export-Csv -Path powershell2.csv -UseCulture -Encoding Default
Get-Process powers* | ConvertTo-Csv -UseCulture | Out-File powershell.csv -Encoding default

    # need kõik annavad sama tulemuse
Get-Process powersh* | ConvertTo-Html | Out-File powershell.htm
Get-Process powersh* | ConvertTo-Html > powershell.htm
Get-Process powersh* | ConvertTo-Html | Set-Content powershell.htm

    # need kõik annavad sama tulemuse
"tere" >> file.txt
"tere" | Out-File -Append -FilePath file.txt
"tere" | Add-Content -Path file.txt


Get-Process powersh* | Export-Clixml -Path powershell.xml

Get-Command -Verb import -Module microsoft.powershell.u*
Import-Csv .\powershell.csv -UseCulture | Get-Member
Get-Process powersh* | Get-Member

Import-Csv .\powershell.csv -UseCulture | select name, vm
Import-Clixml .\powershell.xml | Get-Member

Get-Command -Verb ConvertFrom -Module microsoft.powershell.u*

help Export-Csv -ShowWindow

# Lesson 4

4 -eq 4
4 -eq 10
4 -lt 10
"tere" -eq "TERE"
"tere" -ceq "TERE"
"tere" -lt "kere"
"tere" -gt "kere"
"tere" -cgt "TERE"
"tere" -clt "TERE"

    # failinime mustrid
"tere" -like "t*"
    #regulaaravaldise mustrid
"tere" -match "t.*"
"tere" -notlike "t*"
help about_comparison -ShowWindow

    #Requires -Version 3
Get-Service b* | Where Status -Like "Running"
    # see ei tööta
Get-Service b* | where Name.Length -gt 5

    # $_ on see objekt, mida võrdleme
Get-Service b* | Where-Object -FilterScript {$_.Name.Length -ge 5}
    # $_ -eq  $PSItem
Get-Service b* | Where-Object -FilterScript {$PSItem.Name.Length -ge 5}

Get-Alias -Definition Where-Object
gsv b* | ? {$_.Name.Length -ge 5}

    # slaidil olev variant ei tööta, see siin töötab
Get-Volume | Where-Object -FilterScript {
    $_.HealthStatus -ne "Healthy" -or
    $_.SizeRemaining -lt 100MB
}
    # see töötab ka
Get-Volume | Where-Object -FilterScript {
    $_.HealthStatus -ne "Healthy" `
     -or
    $_.SizeRemaining -lt 100MB
}


    # optimeerime filtreerimist
Get-Service | where name -like "b*"
Get-Service -Name b*

Measure-Command {
    Get-Service | where name -like "b*"
}
Measure-Command {
    Get-Service -Name b*
}

get-help Get-Service -Parameter name
get-help Get-Service -ShowWindow


Get-Service | sort DisplayName | where Status -like "running"
Get-Service | where Status -like "running" | sort DisplayName


# Lesson 5

get-help ForEach-Object -ShowWindow
get-alias -Definition ForEach-Object
dir -File | Get-Member
    #Requires -version 3
dir -File | foreach -MemberName encrypt
dir -File | foreach Name

    # advanced syntax
dir -file | ForEach-Object -Process { $_.Encrypt() }

1..100 | foreach {Get-Random}
Measure-Command {
  1..100 | foreach {
    Get-Service | sort DisplayName | where Status -like "running"
  }
}
Measure-Command {
  1..100 | foreach {
    Get-Service | where Status -like "running" | sort DisplayName
  }
}

1..100 | foreach -Begin {$a = 0} -Process { $a = $a + $_} -End {$a}
