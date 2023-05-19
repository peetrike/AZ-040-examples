function events06 {
    [CmdletBinding()]
    param (
            [parameter(
                Mandatory = $false
            )]
            [datetime]
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
        Write-Verbose -Message ('Connecting to computer: {0}' -f $ComputerName)
        $EventParams.ComputerName = $ComputerName
    } else {
        Write-Debug -Message 'Checking from local computer'
    }

    Get-WinEvent @EventParams
}

$MinuMoodul = 'events06'
New-Alias -Name syndmus -Value events06

#Export-ModuleMember -Variable MinuMoodul -Function events06 -Alias syndmus
