<#
    .SYNOPSIS
        Module 03 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 03 - Working with the PowerShell pipeline
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M3
    .LINK
        https://docs.microsoft.com/learn/paths/powershell/
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion

#region Lesson 1: Understanding the pipeline

#region What is the pipeline?

Get-Help Pipelines -Category HelpFile -ShowWindow

1..3 | ForEach-Object { Start-Process notepad.exe }
Get-Process notepad | Stop-Process -Confirm

Get-ChildItem | Sort-Object Length -Descending | Select-Object -First 3 | Remove-Item -WhatIf

Get-ChildItem |
    Sort-Object Length -Descending |
    Select-Object -First 3 |
    Remove-Item -WhatIf

# https://get-powershellblog.blogspot.com/2017/07/bye-bye-backtick-natural-line.html

#endregion

#region Pipeline output

Get-Help Objects -Category HelpFile

#endregion

#region Discovering object members

Get-Help Get-Member -ShowWindow

Get-Command | Get-Member

#endregion

#region Formatting pipeline output

Get-Command -Verb Format -Module Microsoft.PowerShell.Utility

Get-Help Format.ps1xml -ShowWindow

# https://peterwawa.wordpress.com/2021/06/10/objektide-kuvamisest/
Get-FormatData -TypeName System.Diagnostics.Process |
    Select-Object -ExpandProperty FormatViewDefinition

Get-Process p* | Format-Table -View StartTime
#endregion

#endregion


#region Lesson 2: Selecting, sorting, and measuring objects

#region Sorting objects by a property

Get-Help Sort-Object -ShowWindow

Get-ChildItem

Get-ChildItem | Sort-Object -Property LastWriteTime -Descending

Get-Help about_calculated -ShowWindow
Get-ChildItem |
    Sort-Object -Property @{ Expression = { $_.LastWriteTime - $_.CreationTime }; Descending = $false } |
    Format-Table Name, CreationTime, LastWriteTime

    # the following discovers sort order for alphabet
Get-Culture
Get-UICulture
Get-Command -Noun *culture

#endregion

#region Measuring objects

Get-Help Measure-Object -ShowWindow

Get-ChildItem | Measure-Object -Property Length -Sum

Get-Content module03.ps1 | Measure-Object -Word -Line

#endregion

#region Selecting a subset of objects

Get-Help Select-Object -ShowWindow

Get-ChildItem | Sort-Object -Property Length | Select-Object -Last 1
Get-ChildItem | Sort-Object -Property Length | Select-Object -First 2
Get-ChildItem | Sort-Object -Property Length | Select-Object -Skip 1 -First 1

    #Requires -Version 5
net.exe localgroup administrators | Select-Object -Skip 6 | Select-Object -SkipLast 2

Get-Help Select-Object -Parameter Unique
#region ettevalmistus
New-ADGroup Katse1 -GroupScope Global
New-ADGroup Katse2 -GroupScope Global
Get-ADUser adam | Add-ADPrincipalGroupMembership -MemberOf katse1, katse2
#endregion
Get-ADGroup -Filter { Name -like 'katse*' } | Get-ADGroupMember | Select-Object -Unique
Get-ADGroup -Filter { Name -like 'katse*' } |
    Get-ADGroupMember |
    Sort-Object -Property Name -Unique

#endregion

#region Selecting properties of objects

Get-ChildItem | Select-Object -Property Name, LastWriteTime | Get-Member

Get-Process p* | Select-Object -Property PSResources
Get-Process p* |
    Select-Object -Property PSConfiguration

Get-ChildItem | Select-Object -Property Name, *Time | Out-GridView

Get-ADComputer lon-cl1 | Select-Object -Property DnsHostName | Get-Member
Get-ADComputer lon-cl1 | Select-Object -ExpandProperty DnsHostName | Get-Member
Get-ADComputer -Filter * |
    Select-Object -ExpandProperty DnsHostName |
    Out-File servers.txt

Get-Command powershell |
    Select-Object -Property Name -ExpandProperty FileVersionInfo

Get-Help Select-Object -Parameter ExcludeProperty

#endregion

#region Creating calculated properties

Get-Help Calculated_Properties -ShowWindow
# https://docs.microsoft.com/dotnet/standard/base-types/formatting-types

Get-CimInstance Win32_LogicalDisk

$SizeGB = @{ Name ='Size (GB)'; Expression = { $_.Size / 1GB } }
Get-CimInstance Win32_LogicalDisk | Select-Object -Property DeviceID, $SizeGB

$SizeGB.Format = 'N2'
Get-CimInstance Win32_LogicalDisk | Format-Table -Property DeviceID, VolumeName, $SizeGB
Get-CimInstance Win32_LogicalDisk | Format-Table -Property DeviceID,
    VolumeName,
    @{ Name ='Size (GB)'; Expression = { $_.Size / 1GB }; Format = 'N3' }

Get-Help Add-Member -ShowWindow
$MemberProps = @{
    MemberType = 'ScriptProperty'
    Name       = 'Size (GB)'
    Value      = { [math]::Round( ($this.Size / 1GB), 2) }
}
Get-CimInstance Win32_LogicalDisk |
    Add-Member @MemberProps -PassThru |
    Select-Object DeviceID, Size*

#endregion

#endregion


#region Lesson 3: Filtering objects out of the pipeline

#region Comparison operators

Get-Help Comparison -Category HelpFile -ShowWindow

'tere' -eq 'Tere'
'tere' -ceq 'Tere'
'tere' -like 't*'       # filesystem pattern
'tere' -match 't.*'     # Regular Expression pattern

Get-Help about_regular -ShowWindow

1, 2, 3 -eq 2
2, 4, 2, 3 -eq 2

3 -eq '3'

'13' -gt 3
13 -gt '3'

Get-Help Type_Operators -ShowWindow

'tere' -as [bool]
(Get-ChildItem) -as [bool]
1 -as [bool]
0 -as [bool]
'' -as [bool]
$null -as [bool]
@() -as [bool]

$Folder = '.\katse'
New-Item -Path $Folder -ItemType Directory
Test-Path -Path $Folder -PathType Container
(Get-ChildItem $Folder) -as [bool]

#endregion

#region Basic filtering syntax

Get-Help Simplified_Syntax -ShowWindow

Get-Help Where-Object -ShowWindow
Get-Alias -Definition Where-Object

Get-Service p* | Where-Object Status -eq 'Stopped'
Get-Service p* | where Status -like 'Running*'
gps | ? cpu -gt 1000

Get-ChildItem | Where PSIsContainer
Get-ChildItem | Where PSIsContainer -eq $false

#endregion

#region Advanced filtering syntax

Get-ChildItem | Where-Object -FilterScript { -not $_.PSIsContainer }
gci | ? { ! $_.PSIsContainer }

Get-ChildItem | Where-Object { ($_.Name.Length -ge 9) -and ($_.Length -ge 2KB) }

    # lase filtrist läbi ainult PowerShelli käsud (mida Get-Command üles leiab)
'get-service', 'get-uhhuu' | Where-Object { Get-Command $_ -ErrorAction SilentlyContinue }

#endregion

#region Optimizing filtering performance

# https://docs.microsoft.com/powershell/scripting/learn/ps101/04-pipelines#filtering-left

Get-ChildItem -File -Recurse
Get-ChildItem -Directory # -Recurse
Get-ChildItem -Filter *.txt

Get-ADUser -Identity adam
Measure-Command {
    Get-ADUser -Filter { Name -like 'Adam*' }
}
Measure-Command {
    Get-ADUser -LDAPFilter '(Name=Adam*)'
}
Measure-Command {
    Get-ADUser -Filter * | Where-Object Name -like 'Adam*'
}

    # negatiivne näide ka
Get-ScheduledTask -TaskName katse
Get-CimInstance MSFT_ScheduledTask -Namespace 'Root/Microsoft/Windows/TaskScheduler' -Filter 'TaskName="katse"'

Measure-Command {
    Get-CimInstance MSFT_ScheduledTask -Namespace 'Root/Microsoft/Windows/TaskScheduler' -Filter 'TaskName="katse"'
}
Measure-Command {
    Get-ScheduledTask -TaskName katse
}
Measure-Command {
    Get-ScheduledTask -TaskName katse -TaskPath '\meelis\'
}
Measure-Command {
    Get-ScheduledTask | where TaskName -eq 'katse'
}

# import function
. .\Get-TaskInfo.ps1

Measure-Command {
    Get-TaskInfo -TaskName meelis\katse
}
Measure-Command {
    Get-TaskInfo -TaskName katse -TaskPath meelis
}
Measure-Command {
    Get-TaskInfo -TaskName katse
}
Measure-Command {
    Get-TaskInfo | where Name -eq 'katse'
}

#endregion

#endregion


#region Lesson 4: Enumerating objects in the pipeline

#region Basic enumeration syntax

Get-Help Simplified_Syntax -ShowWindow

Get-Help ForEach-Object -ShowWindow
Get-Alias -Definition ForEach-Object

dir | ForEach-Object Name | get-member
    #see teeb sama asja
dir | Select-Object -ExpandProperty Name
    # PowerShell 3+
(dir *.txt).Name

Get-ChildItem | foreach -MemberName Encrypt -WhatIf
dir | % Encrypt -WhatIf

    # need teevad sama asja
dir *.txt | % MoveTo('.\katse')
dir *.txt | Move-Item -Destination '.\katse'

#endregion

#region Advanced enumeration syntax

Get-ChildItem | ForEach-Object -Process { $_.Name }
dir | ForEach { $_.Name }
dir | % { $_.Name }

    # kõigi ketaste pealt kõigist kaustadest *.txt failid
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Get-ChildItem -Path $_.Root -Recurse -Filter *.txt |
        Move-Item -Destination 'kuskile'
}

Get-Service B* | ForEach-Object {
    Stop-Service $_ -WhatIf
}
Get-Service BITS | Stop-Service

#endregion

#endregion


#region Lesson 5: Sending pipeline data as output

Get-Help Encoding -Category HelpFile -ShowWindow
Get-Command -ParameterName Encoding

#region Writing output to a file

Get-Help Out-File -ShowWindow
Get-Help Out-File -Parameter NoClobber

Get-Help Redirect -Category HelpFile -ShowWindow

Get-ChildItem | Out-File -FilePath failid.txt -Encoding utf8
dir > kaustad.txt
dir | Set-Content -Path failid.txt -Encoding utf8

Get-Help Add-Content -ShowWindow
Get-Help Set-Content -ShowWindow

dir | Select-Object name, *time | Set-Content -Path failid.txt -Encoding utf8
dir | Select-Object name, *time | Add-Content -Path failid.txt -Encoding utf8

#endregion

#region Converting output to CSV

Get-Help ConvertTo-Csv -ShowWindow
Get-Help Export-Csv -ShowWindow

Get-ChildItem | Export-Csv -Path failid.csv -Encoding Default -UseCulture
Get-ChildItem |
    ConvertTo-Csv -UseCulture -NoTypeInformation |
    Out-File -Encoding utf8 -FilePath failid.csv

# https://peterwawa.wordpress.com/2014/05/13/excel-csv-ja-powershell/

Get-Help Export-Csv -Parameter Encoding
Get-Help ConvertTo-Csv -Parameter UseCulture
Get-Help Export-Csv -Parameter Delimiter

#endregion

#region Converting output to XML

Get-Command -Noun *xml -Module Microsoft.PowerShell.Utility
Get-Help Export-Clixml -ShowWindow
Get-Help ConvertTo-Xml -ShowWindow

Get-ChildItem | ConvertTo-Xml
Get-ChildItem | ConvertTo-Xml -As Stream | Out-File files.xml -Encoding utf8
Get-ChildItem | Export-Clixml -Path failid.xml

#endregion

#region Converting output to JSON

Get-Help ConvertTo-Json -ShowWindow
Get-ChildItem | Select-Object Name, Length, LastWriteTime | ConvertTo-Json

Get-Help ConvertTo-Json -Parameter Depth

#endregion

#region Converting output to HTML

Get-Help ConvertTo-Html -ShowWindow
Get-ChildItem |
    Select-Object -First 4 |
    ConvertTo-Html -PreContent 'Here are some files' -Property Name, Length |
    Out-File -FilePath failid.htm -Encoding utf8

# https://github.com/EvotecIT/PSWriteHTML
# https://github.com/Stephanevg/PSHTML

# https://ironmansoftware.com/powershell-universal/

#endregion

#region Additional output options

Get-Command -Verb Out

Get-Help Out-Host -Parameter Paging

Get-Help Out-Printer -ShowWindow
Get-Help Out-String -ShowWindow
Get-Help Out-GridView -ShowWindow
Get-ChildItem | Out-GridView

#endregion

#endregion
