﻿function events07 {
    <#
        .SYNOPSIS
            see skript otsib sündmuste logist asju
        .DESCRIPTION
            pikem kirjeldus sellest, mida skript teeb ...
        .EXAMPLE
            events06.ps1 -aeg (get-date).adddays(-3)

            Leiab 3 päeva vanad sündmused
        .LINK
            Get-WinEvent
    #>

    [CmdletBinding()]
    param (
            [datetime]
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
        Write-Verbose -Message ('Connecting to computer: {0}' -f $ComputerName)
        $EventParams.ComputerName = $ComputerName
    } else {
        Write-Debug -Message 'Checking from local computer'
    }

    Get-WinEvent @EventParams
}
