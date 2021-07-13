# Lesson 1

Get-Process p*
Get-Process p* | Get-Member
Get-Process p* | Out-GridView
Get-Process p* | select * | Out-GridView

Get-Command -Verb format -Module microsoft.powershell.*
help Format-Table
 
Get-Help Format-Table -Parameter autosize
    #Powershell 4 vajab -AutoSize atribuuti
Get-Process p* | Format-Table -Property name, id, sessionid, vm, cpu #-AutoSize

Get-Process  | Format-Wide -Column 4 #-Property id
get-help Format-Wide -Parameter property

Get-Process * | Format-Wide -Property id -Column 8

Get-Process | Format-Wide -AutoSize
Get-Process | Format-Wide -Property id -AutoSize

Get-Help Format-List

Get-Process powershell | Format-List *
    # more ei tööta ISEs
Get-Process powershell | select -ExpandProperty modules | Format-List | more
Get-Process powershell | select -ExpandProperty modules | Format-List | out-file protsessid.txt
notepad .\protsessid.txt
Invoke-Item .\protsessid.txt

    #Requires -Version 5
help Set-Clipboard


Get-Process p* | format-table name, id, modules -Wrap
Get-Process p* | format-table name, id, modules -Wrap | Get-Member
    # see ei tööta
Get-Process p* | format-table name, id, modules -Wrap | Out-GridView
    #küll aga töötab see
Get-Process p* | select name, id, modules | Out-GridView
Get-Process p* | select name, id, modules | export-csv moodulid.csv -UseCulture
Get-Process p* | select name, id, modules | Export-Clixml moodulid.xml
Invoke-Item .\moodulid.csv
Invoke-Item .\moodulid.xml

get-service | Format-Table -GroupBy status
Get-Service | sort status | Format-Table -GroupBy status
Get-Service | sort status | Group-Object -Property status

$teenused = Get-CimInstance Win32_Service | Group-Object -Property startmode
$teenused | where name -like "Auto" | select -ExpandProperty group


# Lesson 3
    # see töötab
Get-Process |
  select name,id,vm,pm |
  ConvertTo-Html |
  Out-File raport.htm

  #see ei tööta
Get-Process |
  Format-Table name,id,vm,pm |
  ConvertTo-Html |
  Out-File raport.htm

