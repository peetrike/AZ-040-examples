﻿#Requires -Version 2.0

<#PSScriptInfo
    .VERSION 1.0
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

    .PRIVATEDATA
#>

<#
    .DESCRIPTION
        Writes to screen and logfile with various urgency levels
#>

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
        [string]
    $Type = 'Info',
        [bool]
    $WriteLog = $true,
        [Switch]
    $NoDate,
        [Switch]
    $AddEmptyLine
)

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
            [string]
        $Type = 'Info',
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

        switch ($Type) {
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

Write-Log @PSBoundParameters
