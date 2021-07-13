<#
    .SYNOPSIS
        Module 09 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 09 - Advanced scripting
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M9
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Accepting user input

Get-Help Read-Host -ShowWindow
Get-Help Get-Credential -ShowWindow
Get-Help Out-GridView -ShowWindow


Get-WinEvent -MaxEvents 10 -FilterHashtable @{
    LogName   = "application"
    ID        = 15
    StartTime = (Get-Date).AddDays(-1)
}


#endregion


#region Lesson 2: Overview of script documentation

get-help Comment_Based -ShowWindow

#endregion


#region Lesson 3: Troubleshooting and error handling

$Error.Count
$Error.Clear()
dir loll
$Error
dir pull -ErrorVariable viga
$Error
$viga
    # PowerShell 7+
Get-Error


    # Using Breakpoints
Get-Command -Noun PSBreakpoint


    # Understanding error actions
$ErrorActionPreference
$ErrorActionPreference | Get-Member
[Management.Automation.ActionPreference]
[enum]::GetValues([Management.Automation.ActionPreference])

dir loll -ErrorAction SilentlyContinue


    # Using try..catch
Get-Help about_try -ShowWindow

try {
    Get-CimInstance Win32_OperatingSystem -ComputerName lon-svr1, . -ErrorAction Stop
} catch {
    Write-Warning 'tekkis miski viga'
}

#endregion


#region Lesson 4: Functions and modules

Get-Help about_Functions -ShowWindow

get-help about_scope -ShowWindow

Get-Help about_Modules -ShowWindow

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator-

#endregion
