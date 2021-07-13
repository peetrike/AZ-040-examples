function events07 {
<#
 .Synopsis
  see skript otsib sündmuste logist asju

 .Description
  pikem kirjeldus sellest, mida skript teeb ...

 .Parameter aeg
  aeg, millest alates sündmusi otsida

 .Example
 PS c:\> events06.ps1 -aeg (get-date).adddays(-3)

 Leiab 3 päeva vanad sündmused
#>

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
}
