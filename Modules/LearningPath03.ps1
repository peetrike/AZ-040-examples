<#
    .SYNOPSIS
        Learning Path 03 samples
    .DESCRIPTION
        This file contains sample commands from course AZ-040 for
        Learning Path 03 - Working with the PowerShell pipeline
    .LINK
        https://learn.microsoft.com/training/paths/work-windows-powershell-pipeline/
    .LINK
        https://github.com/peetrike/AZ-040-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23AZ-040+%23M3
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion

#region Module 1: Understanding the pipeline

#region What is the pipeline?

Get-Help Pipelines -Category HelpFile -ShowWindow

1..3 | ForEach-Object { Start-Process notepad.exe }
Get-Process notepad | Stop-Process

Get-ChildItem | Sort-Object Length -Descending | Select-Object -First 3 | Remove-Item -WhatIf

Get-ChildItem |
    Sort-Object Length -Descending |
    Select-Object -First 3 |
    Remove-Item -WhatIf

# https://get-powershellblog.blogspot.com/2017/07/bye-bye-backtick-natural-line.html

    # unfinished line
Get-ChildItem |

    #Requires -Modules PSReadLine
Get-PSReadLineOption | Select-Object *Prompt* | Format-List
Get-Help Set-PSReadLineOption -Parameter ContinuationPrompt

#endregion

#region Pipeline output

Get-Help Objects -Category HelpFile -ShowWindow

Get-ChildItem | Out-GridView

#endregion

#region Discovering object members

Get-Help Get-Member -ShowWindow

Get-Command | Get-Member

Get-ChildItem
Get-ChildItem | Get-Member

Get-ADUser -Identity Administrator
Get-ADUser -Identity Administrator | Get-Member
Get-ADUser -Identity Administrator -Properties * | Get-Member

#endregion

#region Formatting pipeline output

Get-Command -Verb Format -Module Microsoft.PowerShell.Utility

Get-Help Format.ps1xml -ShowWindow

# https://peterwawa.wordpress.com/2021/06/10/objektide-kuvamisest/
Get-FormatData -TypeName System.Diagnostics.Process* |
    Select-Object -ExpandProperty FormatViewDefinition

Get-Process p* | Format-Table -View StartTime

#endregion

#endregion


#region Module 2: Selecting, sorting, and measuring objects

#region Sorting objects by a property

Get-Help Sort-Object -ShowWindow

Get-ChildItem

Get-ChildItem | Sort-Object -Property LastWriteTime -Descending

Get-ChildItem |
    Sort-Object -Property @{ Expression = { $_.LastWriteTime - $_.CreationTime }; Descending = $false } |
    Format-Table Name, CreationTime, LastWriteTime

New-Item -Name täpid.txt -ItemType File
New-Item -Name topid.txt -ItemType File
Get-ChildItem t* | Sort-Object -Property Name
Get-ChildItem t* | Sort-Object -Property Name -Culture en-us

    # the following discovers sort order for alphabet
Get-Culture
Get-UICulture
Get-Command -Noun *culture

    # Grouping results
Get-Help Format-Table -Parameter GroupBy
Get-Service c* | Format-Table -GroupBy Status
Get-Service c* | Sort-Object Status | Format-Table -GroupBy Status

Get-Help Group-Object -ShowWindow
Get-Service c* | Group-Object Status
Get-Service c* | Group-Object Status -NoElement

# https://peterwawa.wordpress.com/2023/03/29/os-inventuur-ad-objektide-baasil/

$ComputerProps = @{
    Filter     = {
        Enabled -eq $true -and
        OperatingSystem -like 'Windows*'
    }
    Properties = 'OperatingSystemVersion'
}
Get-ADComputer @ComputerProps |
    Group-Object { $_.OperatingSystemVersion.Split('.')[0] } -NoElement |
    Sort-Object { [int] $_.Name } -Descending

#endregion

#region Measuring objects

Get-Help Measure-Object -ShowWindow

Get-ChildItem -File | Measure-Object -Property Length -Sum

Get-Content module03.ps1 | Measure-Object -Word -Line

#endregion

#region Selecting a subset of objects

Get-Help Select-Object -ShowWindow

Get-ChildItem | Sort-Object -Property Length | Select-Object -Last 1
Get-ChildItem | Sort-Object -Property Length | Select-Object -First 2
Get-ChildItem | Sort-Object -Property Length | Select-Object -Skip 1 -First 1

    #Requires -Version 5
net.exe localgroup administrators | Select-Object -Skip 6 | Select-Object -SkipLast 2

    #region Selecting unique objects
    Get-Help Select-Object -Parameter Unique

    #region Preparation
        New-ADGroup Katse1 -GroupScope Global
        New-ADGroup Katse2 -GroupScope Global
        Get-ADUser Adrian | Add-ADPrincipalGroupMembership -MemberOf katse1, katse2
    #endregion
    Get-ADGroup -Filter { Name -like 'katse*' } | Get-ADGroupMember | Select-Object -Unique

    Get-ADUser -Filter * -Property Department |
        Select-Object -Property Department -Unique

    Get-ADUser -Filter * -Property Department |
        Group-Object -Property Department |
        Foreach-Object { $_.Group | Get-Random }

    Get-Help Sort-Object -Parameter Unique
    Get-ADUser -Filter * -Property Department |
        Sort-Object -Property Department -Unique
    #endregion

#endregion

#region Selecting properties of objects

Get-ChildItem | Select-Object -Property Name, LastWriteTime | Get-Member

Get-ChildItem | Select-Object -Property Name, *Time | Out-GridView

Get-Process p* | Get-Member -MemberType PropertySet
Get-Process p* | Select-Object -Property PSResources
Get-Process p* |
    Select-Object -Property PSConfiguration

$ComputerName = 'Sea-Cl1'
Get-ADComputer $ComputerName | Select-Object -Property DnsHostName | Get-Member
Get-ADComputer $ComputerName | Select-Object -ExpandProperty DnsHostName | Get-Member

Get-Command powershell |
    Select-Object -Property Name -ExpandProperty FileVersionInfo

Get-Help Select-Object -Parameter ExcludeProperty

#endregion

#region Creating calculated properties

Get-Help Calculated_Properties -ShowWindow
Get-Help Hash_Tables -ShowWindow
# https://learn.microsoft.com/dotnet/standard/base-types/formatting-types

Get-CimInstance Win32_LogicalDisk

$SizeGB = @{ Name = 'Size (GB)'; Expression = { $_.Size / 1GB } }
Get-CimInstance Win32_LogicalDisk | Select-Object -Property DeviceID, $SizeGB

# https://learn.microsoft.com/dotnet/standard/base-types/standard-numeric-format-strings#standard-format-specifiers
$SizeGB.Format = 'N2'
Get-CimInstance Win32_LogicalDisk | Format-Table -Property DeviceID, VolumeName, $SizeGB

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_operators#format-operator--f
$SizeGB = @{ Name = 'Size (GB)'; Expression = { '{0:n2}' -f ($_.Size / 1GB) } }
Get-CimInstance Win32_LogicalDisk | Select-Object -Property DeviceID, $SizeGB | Get-Member

Get-Help Add-Member -ShowWindow
$MemberProps = @{
    MemberType = 'ScriptProperty'
    Name       = 'Size (GB)'
    Value      = { [math]::Round( ($this.Size / 1GB), 2) }
}
Get-CimInstance Win32_LogicalDisk |
    Add-Member @MemberProps -PassThru |
    Select-Object DeviceID, Size*

    #Requires -Modules Storage
Get-Volume
Get-Volume | Get-Member
Get-Volume | Select-Object DriveLetter, Size, SizeRemaining

Get-FormatData -TypeName *MSFT_Volume
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control.Rows
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control.Rows.Columns
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control.Rows.Columns | Select-Object -Last 2
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control.Rows.Columns |
    Select-Object -Last 2 -ExpandProperty DisplayEntry
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control.Rows.Columns |
    Select-Object -Last 2 -ExpandProperty DisplayEntry |
    Select-Object -ExpandProperty | Value


# https://peterwawa.wordpress.com/2023/03/29/os-inventuur-ad-objektide-baasil/
$OSVersion = @{
    Name       = 'OSVersion'
    Expression = { [version]($_.OperatingSystemVersion -replace '(\d+\.\d+) \((\d+)\)', '$1.$2') }
}
$ComputerProps.Properties = 'OperatingSystem', 'OperatingSystemVersion'
$ComputerProps.Filter = {
    Enabled -eq $true -and
    OperatingSystem -like 'Windows S*'
}
Get-ADComputer @ComputerProps |
    Select-Object Name, DnsHostName, OperatingSystem, $OSVersion |
    Sort-Object $OSVersion.Name

#endregion

#endregion


#region Module 3: Filtering objects out of the pipeline

#region Comparison operators

Get-Help Comparison -Category HelpFile -ShowWindow

'tere' -eq 'Tere'       # by default the text comparison is case-insensitive
'tere' -ceq 'Tere'
'tere' -like 't*'       # wildcards/filesystem pattern
'tere' -match 't.*'     # Regular Expression pattern

Get-Help Wildcards -ShowWindow
Get-Help about_regular -ShowWindow

3 -eq '3'   # right side type is converted to match left side

'13' -gt 3
13 -gt '3'

    # arrays in comparison
2 -in 1, 2, 3, 4
1, 2, 3, 4 -contains 3

1, 2, 3 -eq 2
2, 4, 2, 3 -eq 2
'tere', 'tore', 'mäger' -match '^t'

Get-Help Type_Operators -ShowWindow

$a = Get-Date
$a -is [datetime]

Get-Help about_Booleans -ShowWindow
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

Get-Service bits | Get-Member -Name Status
[enum]::GetValues([ServiceProcess.ServiceControllerStatus])
[ServiceProcess.ServiceControllerStatus] 'Stopped'

# https://github.com/peetrike/PWAddins/blob/master/src/Public/Get-EnumValue.ps1
[ServiceProcess.ServiceControllerStatus] | Get-EnumValue

Get-Service p* | Where-Object -Property Status -EQ -Value 'Stopped'
Get-Service p* | Where-Object Status -eq 'Stopped'
Get-Service p* | where Status -like 'Run*'
gsv p* | ? Status -eq 1
[ServiceProcess.ServiceControllerStatus]1
[ServiceProcess.ServiceControllerStatus]::Stopped.value__

Get-ChildItem | Where-Object -Property PSIsContainer -EQ $true
Get-ChildItem | where PSIsContainer -EQ $true
dir | ? PSIsContainer

    #Requires -Version 6.1
Get-ChildItem | Where-Object -Not PSIsContainer

#endregion

#region Advanced filtering syntax

Get-ChildItem | Where-Object -FilterScript { -not $PSItem.PSIsContainer }
Get-ChildItem | where { -not $_.PSIsContainer }
gci | ? { ! $_.PSIsContainer }

Get-ChildItem | Where-Object { ($_.Name.Length -ge 9) -and ($_.Length -ge 2KB) }

Get-Service p* | Where-Object { $_.Status -in 'Running', 'StartPending' }

'get-service', 'get-uhhuu', 'get-userprofile' | Where-Object { Get-Command $_ -ErrorAction SilentlyContinue }

#endregion

#region Optimizing filtering performance

# https://learn.microsoft.com/powershell/scripting/learn/ps101/04-pipelines#filtering-left

Get-ChildItem -Filter *.txt
    #Requires -Version 3
Get-ChildItem -File -Recurse
Get-ChildItem -Directory # -Recurse

Get-Help Get-ChildItem -Parameter *

Get-CimInstance -ClassName Win32_UserAccount | Where-Object SID -Like '*-500'
Get-CimInstance -ClassName Win32_UserAccount -Filter "SID Like '%-500'"
Get-CimInstance -ClassName Win32_UserAccount -Filter "LocalAccount=True and SID Like '%-500'"
    #Requires -Modules Microsoft.PowerShell.LocalAccounts
Get-LocalUser | where SID -Like '*-500'

Get-ADUser -Identity adam

Get-Help Measure-Command -ShowWindow
Measure-Command {
    Get-ADUser -Identity Adrian
}
Measure-Command {
    Get-ADUser -Filter { Name -like 'Adrian*' }
}
Measure-Command {
    Get-ADUser -LDAPFilter '(Name=Adrian*)'
}
Measure-Command {
    Get-ADUser -Filter * | Where-Object Name -like 'Adrian*'
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


#region Lab 3A

# https://github.com/MicrosoftLearning/AZ-040T00-Automating-Administration-with-PowerShell/blob/master/Instructions/Labs/LAB_03A_Working_with_Windows_PowerShell_Pipeline.md

#endregion


#region Module 4: Enumerating objects in the pipeline

#region Purpose of enumeration

1..3 | ForEach-Object { Start-Process notepad }
Get-Process notepad | Stop-Process
Stop-Process -Name Notepad

# https://learn.microsoft.com/powershell/scripting/learn/ps101/04-pipelines#the-pipeline
(Get-Help Get-Process).returnValues
(Get-Help Stop-Process).inputTypes

Get-ChildItem -File | Get-Member -name Encrypt

#endregion

#region Basic enumeration syntax

Get-Help Simplified_Syntax -ShowWindow

Get-Help ForEach-Object -ShowWindow
Get-Alias -Definition ForEach-Object

Get-ChildItem -File | ForEach-Object -MemberName Name | Get-Member
    #the following do the same
Get-ChildItem *.txt | Select-Object -ExpandProperty Name
    #Requires -Version 3
(Get-ChildItem *.txt).Name

Get-ChildItem -File | foreach Encrypt -WhatIf
dir -File | % Decrypt -WhatIf

#region Preparation
'katse', 'kutse' | ForEach-Object { New-Item -ItemType Directory -Name $_ -ErrorAction SilentlyContinue }
#endregion
Get-ChildItem k?tse -Directory | ForEach-Object CreateSubdirectory -ArgumentList 'muu'
dir k* -Directory | % CreateSubdirectory 'muu'

#endregion

#region Advanced enumeration syntax

Get-ChildItem | ForEach-Object -Process { $_.Name }
dir | foreach { $_.Name }

Get-Service BITS | ForEach-Object { Stop-Service $_ -WhatIf }
Get-Service BITS | Stop-Service -WhatIf

Get-ChildItem -File |
    ForEach-Object -Begin { $summa = 0 } -Process { $summa += $_.Length } -End { Write-Output $summa }
Get-ChildItem -File | Measure-Object -Property Length -Sum

1..10 | ForEach-Object { Get-Random }

#endregion

#endregion


#region Module 5: Sending pipeline data as output

Get-Help Encoding -Category HelpFile -ShowWindow
Get-Command -ParameterName Encoding

#region Writing output to a file

Get-Help Out-File -ShowWindow
Get-Help Out-File -Parameter NoClobber
Get-Help Redirect -Category HelpFile -ShowWindow

Get-ChildItem | Out-File -FilePath failid.txt -Encoding utf8
dir > kaustad.txt       # Out-File
dir >> kaustad.txt      # Out-File -Append

Get-Help Set-Content -ShowWindow
Get-Help Add-Content -ShowWindow

Get-Process p* | Select-Object PSResources | Format-Table | Out-File protsessid.txt

#endregion

#region Converting output to CSV

# https://en.wikipedia.org/wiki/Delimiter-separated_values

Get-Help ConvertTo-Csv -ShowWindow
Get-Help Export-Csv -ShowWindow

Get-ChildItem | Export-Csv -Path failid.csv -Encoding utf8 -UseCulture
Get-ChildItem |
    ConvertTo-Csv -UseCulture -NoTypeInformation |
    Out-File -Encoding utf8 -FilePath failid.csv

# https://peterwawa.wordpress.com/2014/05/13/excel-csv-ja-powershell/

Get-Help Export-Csv -Parameter Encoding
Get-Help ConvertTo-Csv -Parameter UseCulture
Get-Help Export-Csv -Parameter Delimiter

#endregion

#region Converting output to XML

# http://www.w3.org/TR/xml/

Get-Command -Noun *xml -Module Microsoft.PowerShell.Utility
Get-Help Export-Clixml -ShowWindow
Get-Help ConvertTo-Xml -ShowWindow

Get-ChildItem | ConvertTo-Xml
Get-ChildItem | ConvertTo-Xml -As Stream | Out-File files.xml -Encoding utf8
Get-ChildItem | Export-Clixml -Path failid.xml

#endregion

#region Converting output to JSON

# https://www.json.org/

    #Requires -Version 3
Get-Help ConvertTo-Json -ShowWindow
Get-ChildItem | Select-Object Name, Length, LastWriteTime | ConvertTo-Json
Get-ChildItem |
    Select-Object Name, Length, LastWriteTime |
    ConvertTo-Json |
    Out-File -FilePath failid.json -Encoding utf8

Get-Help ConvertTo-Json -Parameter Depth

    # PS Version 2 and .NET 3.5
Add-Type -AssemblyName System.Web.Extensions
$Serializer = New-Object System.Web.Script.Serialization.Javascriptserializer
$Serializer.Serialize
$Serializer.Deserialize

# https://github.com/peetrike/PWAddins/blob/master/src/Public/Get-TypeUrl.ps1
$Serializer.GetType() | Get-TypeUrl -Invoke

# https://www.newtonsoft.com/json

#endregion

#region Converting output to HTML

# https://html.spec.whatwg.org/

Get-Help ConvertTo-Html -ShowWindow
Get-ChildItem -File |
    Select-Object -First 4 |
    ConvertTo-Html -PreContent 'Here are some files' -Property Name, Length |
    Out-File -FilePath failid.htm -Encoding utf8

Find-Module PSWriteHTML -Repository PSGallery
Find-Module -Tag html -Repository PSGallery

# https://github.com/Stephanevg/PSHTML
# https://ironmansoftware.com/powershell-universal/

#endregion

#region Additional output options

Get-Command -Verb Out

Get-Help Out-Host -Parameter Paging
Get-Command more

Get-Help Out-Printer -ShowWindow
Get-Help Out-String -ShowWindow
Get-Help Out-GridView -ShowWindow
Get-ChildItem | Select-Object * | Out-GridView

#endregion

#region Extra: More export options

Find-Module powershell-yaml -Repository PSGallery

Find-Module ImportExcel -Repository PSGallery
Find-Module ImportExcel -Repository PSGallery | Select-Object ProjectUri

# https://github.com/dfinke/ImportExcel/tree/master/Examples

Find-Module PSWriteOffice -Repository PSGallery

# https://evotec.xyz/merging-splitting-and-creating-pdf-files-with-powershell/

#endregion

#endregion


#region Lab 3B

# https://github.com/MicrosoftLearning/AZ-040T00-Automating-Administration-with-PowerShell/blob/master/Instructions/Labs/LAB_03B_Working_with_Windows_PowerShell_Pipeline.md

#endregion


#region Module 6: Passing pipeline data

#region Pipeline parameter binding

Get-Help about_Parameters -ShowWindow
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_parameters#accepts-pipeline-input
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-08#814-parameter-binding

# https://github.com/peetrike/CommandInfo/master/src/Public/Get-ParameterInfo.ps1
Get-ParameterInfo Set-ADUser -ParameterName Identity
(Get-Command Set-ADUser).Parameters.Identity.ParameterType.FullName
Get-Help Set-ADUser -Parameter Identity

Get-ADUser -Filter { Name -like 'Adam*' } | Set-ADUser -City 'Tallinn'

Get-Help Restart-Service -Parameter InputObject

Get-Service B* | Restart-Service -WhatIf

#endregion

#region Identifying ByValue parameters

(Get-Help Get-ADUser).returnValues.returnValue.type.name
(Get-Help Set-ADUser).parameters.parameter |
    Where-Object pipelineInput -like 'true*' |
    Select-Object name, pipelineInput, type
Get-Help Set-ADUser -Parameter Identity

$type = (Get-Command Get-Service).OutputType.Type
(Get-Command Restart-Service).Parameters.Values | Where-Object {
    $_.Attributes.ValueFromPipeLine -and
    $type.Name -like $_.ParameterType.Name.replace('[]', '')
}
Get-Help Restart-Service -Parameter InputObject

# https://github.com/indented-automation/Indented.Profile/blob/master/Indented.Profile/public/Get-ParameterInfo.ps1
Get-ParameterInfo -Name Sort-Object | Where-Object PipeLine -NotLike 'None'
Get-Help Sort-Object -Parameter InputObject

Get-Command -ParameterName InputObject | Measure-Object
Get-Help * -Parameter InputObject | Measure-Object

#endregion

#region Passing data by using ByValue

    # you can do this
$Services = Get-Service p*
Start-Service -InputObject $Services -WhatIf
    # but this is more convenient
Get-Service p* | Start-Service -WhatIf
Get-Service bits | Set-Service -StartupType Automatic -WhatIf

Get-Help Start-Service -Parameter Name
'bits', 'winrm' | Start-Service

Get-Help Get-Service -Online

    # Exporting to CSV retains object type
Get-Service p* | Export-Csv -Path Services.csv
    #Requires -Version 7
Get-Service p* | Export-Csv -Path Services.csv -IncludeTypeInformation
Import-Csv Services.csv | Get-Member
Import-Csv Services.csv | Start-Service -WhatIf

#endregion

#region Passing pipeline data ByPropertyName

    # this doesn't work
Get-ADComputer $env:COMPUTERNAME | Test-Connection -Count 1

Get-ADComputer $env:COMPUTERNAME | Get-Member
Get-Help Test-Connection -Parameter *
Get-ParameterInfo Test-Connection | Where-Object Pipeline -like '*ByPropertyName'

    # but this does
Get-ADComputer $env:COMPUTERNAME |
    Select-Object -Property @{ n = 'ComputerName'; e = { $_.DnsHostName } } |
    Test-Connection -Count 1
Get-ADComputer $env:COMPUTERNAME | Test-Connection -ComputerName { $_.DnsHostName } -Count 1

    #Requires -Version 3
Get-ADComputer $env:COMPUTERNAME |
    Update-TypeData -MemberType AliasProperty -MemberName ComputerName -Value DnsHostName
Get-ADComputer $env:COMPUTERNAME | Test-Connection -Count 1

# https://peterwawa.wordpress.com/2013/04/09/kasutajakontode-loomine-domeenis/

#endregion

#region Identifying ByPropertyName parameters

Get-ParameterInfo -Name New-ADUser

Get-Help Stop-Process -Parameter *
Get-Help Stop-Service -Parameter *

Get-Command -ParameterName ComputerName | Measure-Object

#endregion

#region Using manual parameters to override the pipeline

    # this doesn't work
'bits', 'winrm' | Start-Service -Name b* -WhatIf
New-Object PSObject -Property @{ ComputerName = 'Sea-DC1' } |
    Test-Connection -ComputerName 'Sea-Cl1'

Get-ChildItem | Select-Object -First 1 | Stop-Service
Get-Help Stop-Service -Parameter Name
Get-ChildItem | Get-Member Name

Start-Process notepad
    # Wrong ParameterSet
Get-Process -Name notepad | Stop-Process -Name notepad

#endregion

#region Using parenthetical commands
    # in PS 7 the -ComputerName parameter was removed from several commands
'winrm', 'bits' | Get-Service -ComputerName (Get-Content masinad.txt)

$kasutajad = Get-ADUser -Filter { City -like 'London' }
Add-ADGroupMember 'London Users' -Members $kasutajad
    # or
Add-ADGroupMember 'London Users' -Members (Get-ADUser -Filter { City -like 'London' })
Get-ADUser -Filter { City -like 'London' } |
    Add-ADPrincipalGroupMembership -MemberOf 'London Users'

    # same users to several groups
Get-ADGroup -Filter { Name -like 'London*' } |
    Add-ADGroupMember -Members $kasutajad

#endregion

#region Expanding property values

Get-Help Select-Object -Parameter ExpandProperty

'winrm', 'bits' |
    Get-Service -ComputerName (
        Get-ADComputer -Filter { Name -like '*srv*' } |
            Select-Object -ExpandProperty DnsHostName
    )

Get-ADUser -Id Tia -Properties MemberOf |
    Select-Object -ExpandProperty MemberOf |
    Get-ADGroup

$Property = 'MemberOf'
Get-ADUser -Id Tia -Properties $Property |
    Select-Object -ExpandProperty $Property |
    Get-ADGroup
(Get-ADUser -Id Tia -Properties $Property).$Property |
    Get-ADGroup

Get-ADUser -Id Tia | Get-ADPrincipalGroupMembership

#endregion

#endregion
