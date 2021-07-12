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
Remove-Job -name $viis
Stop-Job -Id 70 -PassThru | Remove-Job
Get-Job

"Viis tuli" > error.txt

Start-Job -Name ($Viis = 'viis') -ScriptBlock {
    1..10 | foreach {
        $_
        Start-Sleep -Seconds 1
        if ($_ -eq 2) {
           "blablabla" > C:\Users\student\error.txt
           & notepad C:\Users\student\error.txt
            }
    }
    "Valmis"
}

stop-job
Get-Job
Receive-Job -name $viis
Receive-Job -Id 68 -Keep
Receive-Job -Id 72 -Keep | Get-Member

Receive-Job -id 68 -Keep | Get-Member

Get-Command -noun job

Get-Job | Remove-Job
Receive-Job -id 74 
