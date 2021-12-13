#Requires -Version 2.0

<#PSScriptInfo
    .VERSION 1.0.1
    .GUID eadd2163-b84f-46dc-9ccd-d6f16b26a2ab
    .AUTHOR CPG4285
    .COMPANYNAME
    .COPYRIGHT

    .TAGS

    .LICENSEURI
    .PROJECTURI
    .ICONURI

    .EXTERNALMODULEDEPENDENCIES
    .REQUIREDSCRIPTS
    .EXTERNALSCRIPTDEPENDENCIES

    .RELEASENOTES
        [2019-10-29] - 1.0.0 - Initial release
        [2021-12-11] - 1.0.1 - Add pipeline support

    .PRIVATEDATA
#>

<#
    .SYNOPSIS
        Writes to log file and screen
    .DESCRIPTION
        This script writes to screen and log file with various urgency levels
#>

param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [String]
        # Log message to write
    $Message,
        [Parameter(Position = 1)]
        [string]
        # Specifies log file path.
    $Path = $(
        if ($LogFilePath) {
            $LogFilePath
        } else {
            Join-Path $PWD WriteLog.txt
        }
    ),
        [ValidateSet('Error', 'Warning', 'Info', 'Verbose', 'Debug', 'Log', 'Empty')]
        [Alias('Type')]
        [string]
        # Urgency level for the message
    $Level = 'Info',
        [bool]
    $WriteLog = $true,
        [Switch]
        # Don't add date to log message
    $NoDate,
        [Switch]
        # Add empty line to the end of message in log file
    $AddEmptyLine
)

begin {
    Function Write-Log {
        param(
                [Parameter(Position = 0, ValueFromPipeline = $true)]
                [String]
            $Message,
                [Parameter(Position = 1)]
                [string]
            $Path = $(
                if ($LogFilePath) {
                    $LogFilePath
                } else {
                    Join-Path $PWD WriteLog.txt
                }
            ),
                [ValidateSet('Error', 'Warning', 'Info', 'Verbose', 'Debug', 'Log', 'Empty')]
                [Alias('Type')]
                [string]
            $Level = 'Info',
                [bool]
            $WriteLog = $true,
                [Switch]
            $NoDate,
                [Switch]
            $AddEmptyLine
        )

        begin {
            if ($NoDate) {
                $screenPattern = '{1}'
                $msgPattern = '{0,-9} - {2}'
            } else {
                $screenPattern = '{0} - {1}'
                $msgPattern = '{0,-9} - {1} - {2}'
            }
            $ActionPreferenceList = @(
                [Management.Automation.ActionPreference]::Stop
                [Management.Automation.ActionPreference]::Continue
                [Management.Automation.ActionPreference]::Inquire
                [Management.Automation.ActionPreference]::Suspend
            )
        }

        process {
            $TimeStamp = [datetime]::Now.ToString('G')
            $Time = [datetime]::Now.ToString('T')

            switch ($Level) {
                'Error' {
                    $prefix = '[ERROR]'
                    Write-Error ($screenPattern -f $Time, $Message)
                    if ($WriteLog -and ($ErrorActionPreference -in $ActionPreferenceList)) {
                        Add-Content -Path $Path -Value ($msgPattern -f $prefix, $TimeStamp, $Message)
                    }
                }
                'Warning' {
                    $prefix = '[WARNING]'
                    Write-Warning -Message ($screenPattern -f $Time, $Message)
                    if ($WriteLog -and ($WarningPreference -in $ActionPreferenceList)) {
                        Add-Content -Path $Path -Value ($msgPattern -f $prefix, $TimeStamp, $Message)
                    }
                }
                'Info' {
                    $prefix = '[INFO]'
                    if (Get-Command Write-Information -ErrorAction SilentlyContinue) {
                        Write-Information -MessageData ($screenPattern -f $Time, $Message) -InformationAction Continue -Tags 'Log'
                    } else {
                        Write-Host ($screenPattern -f $Time, $Message)
                    }
                    $Logging = $true
                    if ($InformationPreference) {
                        $Logging = $InformationPreference -in $ActionPreferenceList
                    }
                    if ($WriteLog -and $Logging) {
                        Add-Content -Path $Path -Value ($msgPattern -f $prefix, $TimeStamp, $Message)
                    }
                }
                'Verbose' {
                    $prefix = '[VERBOSE]'
                    Write-Verbose -Message ($screenPattern -f $Time, $Message)
                    if ($WriteLog -and ($VerbosePreference -in $ActionPreferenceList)) {
                        Add-Content -Path $Path -Value ($msgPattern -f $prefix, $TimeStamp, $Message)
                    }
                }
                'Debug' {
                    $prefix = '[DEBUG]'
                    Write-Debug -Message ($screenPattern -f $Time, $Message)
                    if ($WriteLog -and ($DebugPreference -in $ActionPreferenceList)) {
                        Add-Content -Path $Path -Value ($msgPattern -f $prefix, $TimeStamp, $Message)
                    }
                }
                'Log' {
                    $prefix = '[LOG]'
                    if ($WriteLog) {
                        Add-Content -Path $Path -Value ($msgPattern -f $prefix, $TimeStamp, $Message)
                    }
                }
            }

        }
        end {
            if ($AddEmptyLine -or ($Type -like 'Empty')) {
                Add-Content -Value '' -Path $Path -WhatIf:$false -Confirm:$false
            }
        }
    }
}

process {
    Write-Log @PSBoundParameters
}
