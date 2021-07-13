Param(
    [datetime]$aeg = (Get-Date).AddDays(-1),
        [Parameter(Mandatory=$true)]
    [string]$Computername,
    [int]$EventID = 15,
        [ValidateSet("application","system")]
    [string]$LogName = "application"
)

Write-Host " Tere, mina olen skript"
Write-Information " see on informatiivne tekst"
Write-Warning "see on hoiatus"
Write-Error "see on viga"

Write-Verbose "proovin arvuteid: $Computername"

Get-WinEvent -ComputerName $Computername -MaxEvents 10 -FilterHashtable @{
    LogName = $LogName
    ID = $EventID
    StartTime = $aeg
}
