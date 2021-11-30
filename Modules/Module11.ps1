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

#region What are background jobs?

Get-Help about_Jobs -ShowWindow
Get-Help Job_Details -ShowWindow

Get-Command -Noun Job

#endregion

#region Starting jobs

Get-Help Start-Job -ShowWindow

Start-Job -ScriptBlock { Get-CimInstance Win32_Processor }

Get-Command -ParameterName AsJob
Invoke-Command -ComputerName lon-dc1 -ScriptBlock { Get-CimInstance Win32_Processor } -AsJob
Get-Volume -AsJob
Get-WmiObject Win32_Processor -AsJob

Get-Help Remote_Jobs -ShowWindow

    # workflows are removed in PowerShell 7
    #Requires -Version 3
workflow getinfo { Get-CimInstance Win32_Processor }

getinfo -AsJob -PSComputerName lon-dc1

#endregion

#region Managing jobs

Get-Help Get-Job -ShowWindow
Get-Job

Get-Help Wait-Job -ShowWindow
Get-Help Stop-Job -ShowWindow
Get-Help Remove-Job -ShowWindow

#endregion

#region Retrieving job results

Get-Help Receive-Job -ShowWindow
Get-Job
Receive-Job -id 0 -Keep

#endregion

#endregion


#region Lesson 2: Using scheduled jobs

#region Running Windows PowerShell scripts as scheduled tasks

Get-Command schtasks.exe
schtasks.exe -?

# https://docs.microsoft.com/windows/win32/taskschd/about-the-task-scheduler
$Scheduler = New-Object -ComObject 'Schedule.Service'
$Scheduler | Get-Member
$scheduler.Connect

$rootFolder = $Scheduler.GetFolder('\')
$rootFolder | Get-Member
    # https://docs.microsoft.com/windows/win32/api/taskschd/nf-taskschd-itaskfolder-getfolders
$rootFolder.GetFolders(0)
$rootFolder.GetFolder('\meelis')
    # https://docs.microsoft.com/windows/win32/api/taskschd/nf-taskschd-itaskfolder-gettasks
$RootFolder.GetFolder('\meelis').GetTasks(1)

    # Windows 8/Server 2012 or newer
Get-Command -Module ScheduledTasks
# https://docs.microsoft.com/powershell/module/scheduledtasks
# https://docs.microsoft.com/powershell/module/scheduledtasks/?view=winserver2012-ps

Get-Help Get-ScheduledTask -ShowWindow

Get-ScheduledTask | Measure-Object
Get-ScheduledTask -TaskPath \Meelis\
Get-ScheduledTask -TaskPath \Meelis\ | Get-ScheduledTaskInfo

Get-ScheduledTask -TaskPath \Meelis\ | Start-ScheduledTask

Get-Help Register-ScheduledTask -ShowWindow

#endregion

#region What are scheduled jobs?

Get-Help about_Scheduled_Jobs -ShowWindow
# https://docs.microsoft.com/powershell/module/psscheduledjob/about/about_scheduled_jobs

# https://docs.microsoft.com/previous-versions/powershell/module/psscheduledjob/?view=powershell-3.0

    #Requires -Version 3
    # this module is removed from PowerShell 7
Get-Command -Module PSScheduledJob

#endregion

#region Job options

Get-ScheduledTask -TaskPath /Meelis/ | Select-Object -ExpandProperty Settings

Get-Help New-ScheduledTaskSettingsSet -ShowWindow

$settings = New-ScheduledTaskSettingsSet -WakeToRun -RunOnlyIfNetworkAvailable -RestartOnIdle

#endregion

#region Job triggers

Get-Help New-ScheduledTaskTrigger -ShowWindow

$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(10)
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday, Thursday -At '15:00'

#endregion

#region Creating a scheduled task

Get-Help Register-ScheduledTask -ShowWindow
# https://docs.microsoft.com/powershell/module/scheduledtasks/register-scheduledtask

$Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument '-Noninteractive -command c:\myscript.ps1'
Register-ScheduledTask -TaskName 'SoftwareScan' -Action $Action # -Trigger $trigger

$User = 'Adatum\Administrator'
$TaskCreateProps = @{
    Action   = $Action
    Trigger  = $trigger
    Settings = $settings
    #Principal = $User
}
New-ScheduledTask @TaskCreateProps | Register-ScheduledTask -TaskName 'PowerShell' -TaskPath '\meelis\'
#endregion

#endregion
