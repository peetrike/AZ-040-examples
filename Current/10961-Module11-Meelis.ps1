# Module 11

#Lesson 1

powershell -?
Start-Process -FilePath powershell.exe -ArgumentList "-file minusksirpt"

Get-Command -Noun job
Get-Command -ParameterName asjob | measure
help about_jobs -ShowWindow

Get-Command -ParameterName asjob -noun wmi*

1..300 | foreach {Start-Sleep -Seconds 2; Write-Output "."}

start-job -ScriptBlock {1..300 | foreach {Start-Sleep -Seconds 2; Write-Output "."}}
Invoke-Command -ComputerName lon-dc1 -ScriptBlock {hostname} -AsJob
Get-WmiObject -ComputerName lon-dc1 -Class win32_operatingsystem -AsJob

Get-Job

$minutöö = start-job -ScriptBlock {1..300 | foreach {Start-Sleep -Seconds 2; Write-Output "."}}
$minutöö

Start-Job -Name "Minu töö" -ScriptBlock {whoami}

Receive-Job -Id 45 -Keep
Get-Job
Receive-Job -Id 45
Get-Job
$punktid = Receive-Job -Name job41 -Keep
$punktid | measure
get-job -Id 45 | Remove-Job
get-job

# Lesson 2

Get-Command -Module PSScheduledJob # sellest me ei räägi

Get-Command -Module scheduledTasks # sellest räägime

Get-ScheduledTask
Get-ScheduledTask -TaskName "office 15*"
Get-ScheduledTask -TaskPath "\Microsoft\Office\" # see töötab
Get-ScheduledTask -TaskPath "\Microsoft\Office" # see ei tööta
Get-ScheduledTask -TaskPath "\Microsoft\Office*" # see töötab jälle

Get-Command -noun scheduledTask

Get-ScheduledTask -TaskName "office 15*"

help New-ScheduledTask -ShowWindow
help Register-ScheduledTask -ShowWindow

$tegum = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-command {whoami}"
$aeg = New-ScheduledTaskTrigger -Daily -At "12:00"
Register-ScheduledTask -Action $tegum -Trigger $aeg -TaskName "minu töö"

    # create scheduled task folder
$scheduleObject = New-Object -ComObject schedule.service
$scheduleObject.connect()
$rootFolder = $scheduleObject.GetFolder("\")
$rootFolder.CreateFolder("Meelis")

Get-ScheduledTask -TaskPath "\maimu\"
Get-ScheduledTask -TaskName a


$tegum = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-command {whoami}" -WorkingDirectory "c:\"
$aeg = New-ScheduledTaskTrigger -Daily -At "12:00"
Register-ScheduledTask -Action $tegum -Trigger $aeg -TaskName "Meelise töö" -TaskPath "\meelis\"

Get-ScheduledTask "meelise töö" | Disable-ScheduledTask

Register-ScheduledTask -Action $tegum -TaskName "katse" -TaskPath "\meelis\"
Get-ScheduledTask katse | Start-ScheduledTask
