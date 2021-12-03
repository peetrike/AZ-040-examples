<#
    .SYNOPSIS
        otsib sündmuste logist asju
    .DESCRIPTION
        pikem kirjeldus sellest, mida skript teeb ...
    .EXAMPLE
        .\events05.ps1 -aeg (get-date).adddays(-3)

        Leiab 3 päeva vanad sündmused
    .LINK
        Get-WinEvent
    .LINK
        http://www.ee
    .NOTES
        Author: Meelis Nigols
#>
param (
        [parameter(
            Mandatory = $false
        )]
        [datetime]
        # aeg, millest alates sündmusi otsida
    $Aeg = [datetime]::Now.AddDays(-1),
        [ValidatePattern('Lon-*')]
        [Alias('CN')]
        [string]
        # arvuti nimi, kust logi vaadata
    $ComputerName
)

#region User preference variables
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
