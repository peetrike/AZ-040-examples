#region Safety to prevent the entire script from being run instead of a selection

throw "You're not supposed to run the entire script"

<#

    The code in this region was stolen, I mean borrowed from Thomas Rayner (@MrThomasRayner).

    For more information, see:

    http://mikefrobbins.com/2017/11/02/safety-to-prevent-entire-script-from-running-in-the-powershell-ise/

#>

#endregion

# Module 3 - Working with the Windows PowerShell pipeline

    # Lesson 1 - what is pipeline

1..3 | foreach {Start-Process notepad}
Get-Process notepad | stop-process

Get-ChildItem | Sort-Object length -Descending | Select-Object -First 3 | Remove-Item -WhatIf

Get-ChildItem |
    Sort-Object length -Descending |
    Select-Object -First 3 |
    Remove-Item -WhatIf

Send-MailMessage -To meelis@koolitus.ee`
    -From mina@kuskil.ee`
    -Subject "minu kiri"`
    -smtpserver minu.server.ee

get-service Winrm,vds | Where-Object status -eq "Running" | Stop-Service -WhatIf

get-service bits | stop-service -PassThru

get-command -ParameterName PassThru | Measure-Object

    # Get-member
help Get-Member -ShowWindow
Get-ChildItem | Get-Member
Get-Process p* | Get-Member
get-aduser meelis -Properties * | get-member -MemberType Property | Measure-Object

get-aduser meelis | Select-Object *name
get-aduser meelis | Select-Object name, sid, enabled, samacc* | get-member
get-aduser meelis | Format-Table name, sid, enabled, samacc* | get-member
get-aduser meelis | Format-Table name, sid, enabled, samacc* -AutoSize -Wrap

    # Lesson 2 - Selecting, sorting, and measuring objects
help Sort-Object -ShowWindow

Get-ChildItem

Get-ChildItem | sort-object -Property LastWriteTime -Descending
    # sellest sõltub sorteerimisjärjekord
get-culture
get-uiculture
get-command -noun *culture

get-service p* | sort-object -Property DisplayName | group-object -Property status |
    Select-Object -ExpandProperty Group

get-command -ParameterName GroupBy

get-help measure-object -ShowWindow
dir | measure-object -Property length -Average -Sum | get-member


# Select-Object
help Select-Object -ShowWindow

write-output "tere" | out-file tere.txt
dir | Sort-Object -Property Length | Select-Object -last 1
dir | sort -Property Length | Select-Object -first 2
dir | sort -Property Length | Select-Object -Skip 1 -first 1

net localgroup administrators | Select-Object -Skip 6

get-help Select-Object -Parameter unique
#region ettevalmistus
New-ADGroup Katse1 -GroupScope Global
New-ADGroup Katse2 -GroupScope Global
Get-ADUser adam | Add-ADPrincipalGroupMembership -MemberOf katse1,katse2
#endregion
Get-ADGroup -Filter {name -like "katse*"} | Get-ADGroupMember | Select-Object -Unique

Get-ChildItem | Select-Object -Property name, LastWriteTime | Get-Member

Get-ADComputer pw-note | Select-Object -ExpandProperty dnshostname | Get-Member
Get-ADComputer pw-note | Select-Object -Property dnshostname | Get-Member

Invoke-Command -ComputerName (Get-ADComputer pw-note | Select-Object -Property dnshostname) ...

    # kalkuleeritud property'd
Get-CimInstance Win32_LogicalDisk
$suurus = @{
    name= "suurus (GB)"
    expression = {$_.size / 1GB}
}
Get-CimInstance Win32_LogicalDisk | Select-Object -Property DeviceID, $suurus

$suurus = @{ n="suurus (GB)"; e= {"{0:N2}" -f ($_.size/1GB)}}
Get-CimInstance Win32_LogicalDisk | Select-Object -Property DeviceID, $suurus

# semikoolon asendab reavahetust
dir; Get-Process p*


    # Lesson 3 - Filtering objects out of the pipeline
# loogilised avaldised
Help about_Comparison -ShowWindow
Help about_Type_Operators -ShowWindow

"tere" -eq "Tere"
"tere" -ceq "Tere"
"tere" -like "t*"
"tere" -match "t.*"
3 -eq "3"
3 -eq [string]"3"
[string]$a = "3"
3 -eq $a

"tere" -as [bool]
(dir) -as [bool]
1 -as [bool]
0 -as [bool]
"" -as [bool]
$null -as [bool]
@() -as [bool]
mkdir katse
(dir .\katse) -as [bool]


# filtreerimine
    # basic syntax
get-help Where-Object -ShowWindow

get-service p* | Where Status -like "Running*"
get-service p* | Where-Object Status -eq "Stopped"
Get-Process | where cpu -gt 20


    # advanced syntax
net localgroup administrators |
    Select-Object -Skip 6 |
    Where-Object {-not ($_ -like "*completed successfully.")}

Get-ChildItem | Where-Object -FilterScript {($_.name.Length -ge 9) -and ($_.length -ge 2KB) }
Get-ChildItem | where-object {$_.psiscontainer}
New-Item -ItemType file -Name katse.txt
Get-ChildItem | where-object {$_.Length}
    # kaustal pole property't Length
Get-Item katse | get-member

    #nii saab ka
Get-ChildItem | where-object -FilterScript {$PSItem.Length}
Get-ChildItem | where {$_.Length}
gci | ? {$_.Length}
get-alias -Definition where-object

Get-ChildItem | where-object {-not $_.psiscontainer}
gci | ? {! $_.psiscontainer}

    # filter left
Get-ChildItem -File -Recurse
get-childitem -Directory # -Recurse
Get-ChildItem -Filter *.txt
get-aduser -Filter {name -like "meelis"}
measure-command {
    get-aduser -Identity meelis
}
measure-command {
    get-aduser -filter * | where-object Name -like "meelis*"
}

    # Lesson 4 - Enumerating objects in the pipeline
help foreach-object -ShowWindow

dir | ForEach-Object name | get-member
    #see teeb sama asja
dir | Select-Object -ExpandProperty name
dir | foreach -MemberName encrypt -WhatIf

get-alias -Definition foreach-object

    # advanced syntax
dir | ForEach-Object -Process {$_.name}
dir | % {$_.name}

get-service bits | foreach {stop-service $_}
get-service bits | Stop-Service


# Lesson 5 - Sending pipeline data as output
help out-file -ShowWindow
help redirect -ShowWindow

dir | out-file -path ... -
dir > c:\file.txt

help ConvertTo-Csv -ShowWindow
help Export-Csv -ShowWindow
dir | export-csv -Path failid.csv -Encoding Default -UseCulture
dir | ConvertTo-Csv -UseCulture | out-file -Encoding utf8 -path ...
help export-csv -Parameter Encoding

Get-Command -noun *xml -module Microsoft.PowerShell.Utility
help Export-Clixml -ShowWindow
help ConvertTo-Xml -ShowWindow
dir | ConvertTo-Xml
dir | Export-Clixml -Path failid.xml

help ConvertTo-Json -ShowWindow
dir | select name, length, LastWriteTime | ConvertTo-Json

help ConvertTo-Html -ShowWindow
dir |
    ConvertTo-Html -PreContent "siin on mõned failid" -Property Name, Length |
    out-file -FilePath failid.htm

help out-printer -ShowWindow
help Out-GridView -ShowWindow
Get-ChildItem | out-gridview
