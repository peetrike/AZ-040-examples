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

#endregion

#endregion


#region Lesson 2: Selecting, sorting, and measuring objects

Get-Help Sort-Object -ShowWindow

Get-ChildItem

Get-ChildItem | Sort-Object -Property LastWriteTime -Descending
    # the following discovers sort order for alphabet
Get-Culture
Get-UICulture
Get-Command -noun *culture

#endregion


#region Lesson 3: Filtering objects out of the pipeline

Get-Help about_Comparison -ShowWindow
Get-Help about_Type_Operators -ShowWindow

#endregion


#region Lesson 4: Enumerating objects in the pipeline

Get-Help ForEach-Object -ShowWindow

#endregion


#region Lesson 5: Sending pipeline data as output

Get-Help Out-File -ShowWindow
Get-Help redirect -ShowWindow

#endregion
