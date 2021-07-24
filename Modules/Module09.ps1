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

#region Using Read-Host

Get-Help Read-Host -ShowWindow
$answer = Read-Host -Prompt 'Enter your choice'
$Password = Read-Host -Prompt 'Enter the password' -AsSecureString

#endregion

#region Using Get-Credential

Get-Help Get-Credential -ShowWindow

$Credential = Get-Credential -Credential 'domain\user'
$Credential.UserName

Get-Credential -Message 'Please enter secret' -UserName 'not used'

$Credential = $host.ui.PromptForCredential(
    'Need credentials',
    'Please enter your user name and password.',
    'user',
    'domain'
)

Find-Module BetterCredentials -Repository PSGallery
Find-Module Microsoft.PowerShell.SecretManagement -Repository PSGallery

# https://docs.microsoft.com/powershell/scripting/learn/deep-dives/add-credentials-to-powershell-functions

#endregion

#region Using Out-GridView
Get-Help Out-GridView -ShowWindow

Get-ChildItem |
    Out-GridView -Title 'Select the files to remove' -PassThru |
    Remove-Item -WhatIf

Get-ADUser -Filter { City -like 'Tallinn' } |
    Out-GridView -Title 'Choose the user to add' -OutputMode Single |
    Add-ADPrincipalGroupMembership -MemberOf 'IT' -WhatIf

#endregion

#region Passing parameters to a script

Get-WinEvent -MaxEvents 10 -FilterHashtable @{
    LogName   = 'Application'
    ID        = 15
    StartTime = (Get-Date).AddDays(-1)
}

#endregion

#endregion


#region Lesson 2: Overview of script documentation

#region Using comments to document a script

Get-ChildItem # one line comment

<#
    several
    lines
#>

Get-ChildItem <# -Path c:\ #> -File

#endregion

#region Adding help information

Get-Help Comment_Based -ShowWindow

Start-Process https://docs.microsoft.com/powershell/scripting/developer/help/writing-comment-based-help-topics

#endregion

#endregion


#region Lesson 3: Troubleshooting and error handling

#region Understanding error messages

get-help Automatic_Variables -ShowWindow
$Error

$Error.Count
$Error.Clear()
dir loll
$Error
dir pull -ErrorVariable viga
$Error[0]
$viga
    # PowerShell 7+
Get-Error

#endregion

#region Adding script output

Get-Command -Verb Write -Module Microsoft.PowerShell.Utility

Get-Help Output_ -Category HelpFile -ShowWindow
Get-Help CmdletBinding -Category HelpFile -ShowWindow
Get-Help _CommonParameters -Category HelpFile -ShowWindow
Get-Help Preference -Category HelpFile -ShowWindow

#endregion

#region Using breakpoints

Get-Help Debuggers -ShowWindow

Get-Command -Noun PSBreakpoint
Get-Help Wait-Debugger -ShowWindow
Get-Help Write-Debug -ShowWindow

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_commonparameters#-debug
# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_preference_variables#debugpreference

$DebugPreference

    #Requires -Version 7
$oldDebugPreference = $DebugPreference
$DebugPreference = 'Break'
Write-Debug -Message 'Stop here'
$DebugPreference = $oldDebugPreference

# https://docs.microsoft.com/powershell/scripting/dev-cross-plat/vscode/using-vscode#debugging-with-visual-studio-code
# https://code.visualstudio.com/docs/editor/debugging

#endregion

#region Understanding error actions

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_commonparameters#-erroraction
# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_preference_variables#erroractionpreference

$ErrorActionPreference
$ErrorActionPreference | Get-Member
[Management.Automation.ActionPreference]
[enum]::GetValues([Management.Automation.ActionPreference])

Get-ChildItem loll -ErrorAction SilentlyContinue

Get-Help Write-Error -ShowWindow

#endregion

#region Using Try..Catch

Get-Help about_try -ShowWindow
Get-Help about_throw -ShowWindow

try {
    Get-CimInstance Win32_OperatingSystem -ComputerName lon-svr1, . -ErrorAction Stop
} catch {
    Write-Warning 'tekkis miski viga'
    throw
}

#endregion

#region Identifying specific errors to use with Try..Catch

try {
    New-Item -Path polesellist -Name katse.txt -ItemType File -ErrorAction Stop
} catch [System.IO.DirectoryNotFoundException] {
    Write-Warning -Message $_.Exception.Message
    Write-Verbose -Message 'Creating missing folder'
    $null = New-Item -Path polesellist -ItemType Directory
} catch [System.IO.IOException] {
    Write-Warning -Message $_.Exception.Message
} catch {
    Write-Warning -Message 'Something other happened'
}

#endregion

#endregion


#region Lesson 4: Functions and modules

#region What are functions?

Get-Help about_Functions -ShowWindow

#endregion

#region Using variable scopes

Get-Help about_Scope -ShowWindow

#endregion

#region Creating a module

# https://docs.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-script-module

New-Module -Name SayHello -ScriptBlock {
    function get-hello {
        'Hello'
    }
} | Import-Module
Get-Module SayHello
get-hello
Remove-Module SayHello

#endregion

#region Using dot sourcing

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator-

#endregion

#endregion
