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
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion

#region Lesson 1: Understanding the pipeline

#region What is the pipeline?

Get-Help Pipelines -Category HelpFile

1..3 | ForEach-Object { Start-Process notepad.exe }
Get-Process notepad | Stop-Process

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
    # the following discovers sort order for alphabet
Get-Culture
Get-UICulture
Get-Command -noun *culture

#endregion

#region Measuring objects

Get-Help Measure-Object -ShowWindow

dir | Measure-Object -Property Length -Sum

#endregion

#region Selecting a subset of objects

Get-Help Select-Object -ShowWindow

dir | Sort-Object -Property Length | Select-Object -last 1
dir | Sort-Object -Property Length | Select-Object -first 2
dir | Sort-Object -Property Length | Select-Object -Skip 1 -first 1

net localgroup administrators | Select-Object -Skip 6 | Select-Object -SkipLast 2

Get-Help Select-Object -Parameter unique
#region ettevalmistus
New-ADGroup Katse1 -GroupScope Global
New-ADGroup Katse2 -GroupScope Global
Get-ADUser adam | Add-ADPrincipalGroupMembership -MemberOf katse1,katse2
#endregion
Get-ADGroup -Filter { Name -like 'katse*' } | Get-ADGroupMember | Select-Object -Unique

#endregion

#region Selecting properties of objects

Get-ChildItem | Select-Object -Property Name, LastWriteTime | Get-Member

Get-Process p* | Select-Object -Property PSResources
Get-Process p* |
    Select-Object -Property PSConfiguration

Get-ChildItem | Select-Object -Property Name, *Time | Out-GridView

Get-ADComputer pw-note | Select-Object -ExpandProperty DnsHostName | Get-Member
Get-ADComputer pw-note | Select-Object -Property DnsHostName | Get-Member

Get-Command powershell |
    Select-Object -Property Name -ExpandProperty FileVersionInfo

#endregion

#region Creating calculated properties

Get-Help Select-Object -Parameter Property
Get-Help Format-Table -Parameter Property

Get-CimInstance Win32_LogicalDisk

$SizeGB = @{ Name ='Size (GB)'; Expression = { $_.Size / 1GB } }
Get-CimInstance Win32_LogicalDisk | Select-Object -Property DeviceID, $SizeGB

$SizeGB.Format = 'N2'
Get-CimInstance Win32_LogicalDisk | Format-Table -Property DeviceID, $SizeGB

Get-Help Add-Member -ShowWindow
$MemberProps = @{
    MemberType = 'ScriptProperty'
    Name       = 'Size (GB)'
    Value      = { [math]::Round( ($this.Size / 1GB), 2) }
}
Get-CimInstance Win32_LogicalDisk |
    Add-Member @MemberProps -PassThru |
    Select-Object DeviceID, Size*

Get-Help Format.ps1xml -ShowWindow

#endregion

#endregion


#region Lesson 3: Filtering objects out of the pipeline

#region Comparison operators

Get-Help Comparison -Category HelpFile -ShowWindow

'tere' -eq 'Tere'
'tere' -ceq 'Tere'
'tere' -like 't*'
'tere' -match 't.*'

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
Get-Service p* | Where Status -like 'Running*'
gps | ? cpu -gt 1000

Get-ChildItem | Where PSIsContainer

#endregion

#region Advanced filtering syntax

Get-ChildItem | Where-Object -FilterScript { -not $_.PSIsContainer }
gci | ? { ! $_.PSIsContainer }


Get-ChildItem | Where-Object { ($_.Name.Length -ge 9) -and ($_.Length -ge 2KB) }

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
    Get-ScheduledTask -TaskName katse -TaskPath '\meelis\'
}
Measure-Command {
    Get-ScheduledTask -TaskName katse
}
Measure-Command {
    Get-ScheduledTask | where TaskName -eq 'katse'
}

function Get-TaskInfo {
    [CmdletBinding()]
    param(
            [ValidateNotNullOrEmpty()]
            [string]
        $TaskName = '*',
            [string]
        $TaskPath
    )

    function Get-TaskFolder {
        [CmdletBinding()]
        param (
            $Folder
        )
        $Folder
        foreach ($subFolder in $Folder.GetFolders(0)) {
            Get-TaskFolder -Folder $subFolder
        }
    }

    function Get-Task {
        param (
                [string]
            $Name = '*',
            $Folder
        )

        if ($Name -and $Name -notmatch '\*') {
            try {
                $Folder.GetTask($Name)
            } catch {
                Write-Verbose -Message ('No tasks in folder {0}' -f $Folder.Path)
            }
        } else {
                # include hidden tasks
            $Folder.GetTasks(1) | where { $_.Name -like $Name }
        }
    }

    $Scheduler = New-Object -ComObject 'Schedule.Service'
    $Scheduler.Connect()
    $RootFolder = $Scheduler.GetFolder('\')

    if ($TaskName -match '\\') {
        $RootFolder.GetTask($TaskName)
    } elseif ($TaskPath) {
        $currentFolder = $RootFolder.GetFolder($TaskPath)
        Get-Task -Name $TaskName -Folder $currentFolder
    } else {
        foreach ($folder in Get-TaskFolder -Folder $RootFolder) {
            # include hidden tasks
        Get-Task -Name $TaskName -Folder $folder
        }
    }
}

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

Get-Help ForEach-Object -ShowWindow

#endregion


#region Lesson 5: Sending pipeline data as output

Get-Help Out-File -ShowWindow
Get-Help redirect -ShowWindow

#endregion
