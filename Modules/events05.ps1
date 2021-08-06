<#
    .SYNOPSIS
        see skript otsib sündmuste logist asju
    .DESCRIPTION
        pikem kirjeldus sellest, mida skript teeb ...
    .PARAMETER ComputerName
        See parameeter ütleb et kust arvutist sündmused võtta.
    .EXAMPLE
        .\events05.ps1 -aeg (get-date).adddays(-3)

        Leiab 3 päeva vanad sündmused
    .LINK
        Get-WinEvent
#>
param (
        [parameter(
            Mandatory=$false
        )]
        [datetime]
        # aeg, millest alates sündmusi otsida
    $Aeg = [datetime]::Now.AddDays(-1),
        [ValidatePattern('Lon-*')]
        [Alias('CN')]
        [string]
    $ComputerName
)

#region kasutaja eelistuste muutujad
$EventID = 15
$LogName = 'Application'
#endregion

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
