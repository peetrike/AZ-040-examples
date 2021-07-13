<#
    .SYNOPSIS
        Module 11 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 11 - Using background jobs and scheduled jobs
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M11
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Using background jobs

Get-Help about_Jobs -ShowWindow

#endregion


#region Lesson 2: Using scheduled jobs

Get-Help about_Scheduled_Jobs -ShowWindow
# https://docs.microsoft.com/powershell/module/psscheduledjob/about/about_scheduled_jobs

#endregion

#region Additional topic: Using Task Scheduler

Get-Command -Module ScheduledTasks

help Get-ScheduledTask -ShowWindow

Get-ScheduledTask | Measure-Object
Get-ScheduledTask -TaskPath \Meelis\
Get-ScheduledTask -TaskPath \Meelis\ | Get-ScheduledTaskInfo

Get-ScheduledTask -TaskPath \Meelis\ | Start-ScheduledTask

Get-Help Register-ScheduledTask -ShowWindow

#endregion
