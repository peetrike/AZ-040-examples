<#
    .SYNOPSIS
        otsib sündmuste logist asju
    .DESCRIPTION
        See skript otsib Application logist sündmusi, mille EventId on 15
    .EXAMPLE
        .\events05.ps1 -Aeg (Get-Date).AddDays(-3)

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
