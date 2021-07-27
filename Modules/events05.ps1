<#
    .SYNOPSIS
        see skript otsib sündmuste logist asju
    .DESCRIPTION
        pikem kirjeldus sellest, mida skript teeb ...
    .EXAMPLE
        events05.ps1 -aeg (get-date).adddays(-3)

        Leiab 3 päeva vanad sündmused
    .LINK
        Get-WinEvent
#>
param (
        [datetime]
        # aeg, millest alates sündmusi otsida
    $aeg = [datetime]::Now.AddDays(-1),
        [ValidatePattern('Lon-*')]
        [Alias('CN')]
        [string]
    $ComputerName
)

$EventID = 15
$LogName = 'Application'

$EventParams = @{
    MaxEvents       = 10
    FilterHashtable = @{
        LogName   = $LogName
        ID        = $EventID
        StartTime = $aeg
    }
}
if ($ComputerName) {
    $EventParams.ComputerName = $ComputerName
}

Get-WinEvent @EventParams
