# Lesson 1

Get-Help about_jobs -ShowWindow

Get-Command -Noun job

Get-Command -ParameterName asjob | measure

Get-Help Start-Job -ShowWindow

    # abivahend
help Start-Sleep -ShowWindow

Start-Sleep -Seconds 5

Start-Job -ScriptBlock {Start-Sleep -Seconds 600; "valmis"}

Get-Job

Get-Job -Id 64 | fl *
Get-Job -id 65

Start-Job -ScriptBlock {dir}
Get-Job -Id 68

while (Get-Job -State Running) {

    Get-Job -State Completed | Remove-Job

    Start-Sleep 10
    write-host "ootan tööde järgi"
}

Get-Job -State Completed

Get-Job -id 64
Remove-Job -Id 70
Stop-Job -Id 70 -PassThru | Remove-Job
Get-Job

Start-Job -ScriptBlock {
    1..10 | foreach {
        $_
        Start-Sleep -Seconds 30
    }
    "Valmis"
} -Name pikktoo

Get-Job
Receive-Job -Id 66
Receive-Job -Id 68 -Keep
Receive-Job -Id 72 -Keep | Get-Member

Receive-Job -id 68 -Keep | Get-Member

Get-Command -noun job

Get-Job | Remove-Job
Receive-Job -id 74 

Start-Job -Name Minutoo -ScriptBlock {start-sleep -Seconds 600}
Get-Job -Name minutoo

$minutoo = start-job -ScriptBlock {start-sleep -Seconds 60; "valnis"}
Get-Job $minutoo.Id
$minutoo.State
$minutoo | Get-Member
$minutoo.Progress


$uustoo = Get-Job -Name Minutoo
$uustoo.Progress
$uustoo.State
$uustoo.HasMoreData



# Lesson 2

help about_scheduled_jobs -ShowWindow
Get-Command Get-ScheduledJob
Get-Command -Module PSScheduledJob

    # Task Scheduler Powershelli liides
Get-Module ScheduledTasks -ListAvailable
Get-Command -Module ScheduledTasks

Get-ScheduledTask | measure
Get-ScheduledTask "Office 15*" | Start-ScheduledTask

$task = New-ScheduledTask `
    -Action (New-ScheduledTaskAction -Execute "notepad.exe") `
    -Trigger (New-ScheduledTaskTrigger -DaysInterval 3 -Daily -at 23:00) `
    -Settings (New-ScheduledTaskSettingsSet -Disable) `
#    -Principal ".\student"
Register-ScheduledTask -InputObject $task -TaskName "minutöö" #-CimSession Lon-dc1, Lon-cl1
Get-ScheduledTask minutöö | Start-ScheduledTask

