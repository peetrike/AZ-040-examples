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

#region Identifying values that might change

Get-WinEvent -MaxEvents 10 -FilterHashtable @{
    LogName   = 'Application'
    ID        = 15
    StartTime = (Get-Date).AddDays(-1)
}

code -r events01.ps1

code -r events02.ps1

#endregion

#region Using Read-Host

Get-Help Read-Host -ShowWindow
$UserName = Read-Host -Prompt 'Enter user name for the server'
$Password = Read-Host -Prompt 'Enter the password' -AsSecureString

#endregion

#region Using Get-Credential

Get-Command Get-Credential -All

Get-Help Get-Credential -ShowWindow

$Credential = Get-Credential -Credential 'domain\user'
$Credential.UserName

code -r -g Connect-VM.ps1:61
Get-Credential -Message 'Please enter secret' -UserName 'not used'

$host.ui.PromptForCredential
$Credential = $host.ui.PromptForCredential(
    'Need credentials',
    'Please enter your user name and password.',
    'user',
    'target'
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

#region Extra: Other possibilities

# https://github.com/peetrike/Examples/blob/master/src/Gui/Test-GuiElements.ps1#L35-L55
# https://github.com/peetrike/Examples/blob/master/src/Gui/ToastNotification.ps1
Find-Module burnttoast -Repository PSGallery

#Requires -Version 6

Find-Module Microsoft.PowerShell.ConsoleGuiTools -Repository PSGallery

# https://blog.ironmansoftware.com/tui-powershell

#endregion

#region Passing parameters to a script

code -r events03.ps1

.\events03.ps1
.\events03.ps1 -aeg ([datetime]::Now).AddHours(-1)
.\events03.ps1 -aeg 'segadus'

code -r events04.ps1
.\events04.ps1 -aeg 'segadus'
.\events04.ps1 -a '2021.07.27'
.\events04.ps1 '2021.07.27' $env:COMPUTERNAME

(Get-Command .\events04.ps1).Parameters.ComputerName
.\events04.ps1 -cn $env:COMPUTERNAME

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

Get-Help .\events04.ps1

Get-Help Comment_Based -ShowWindow
Start-Process https://docs.microsoft.com/powershell/scripting/developer/help/writing-comment-based-help-topics

code -r events05.ps1

Get-Help .\events05.ps1
Get-Help .\events05.ps1 -Examples
Get-Help .\events05.ps1 -Parameter aeg
Get-Help .\events05.ps1 -Online

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
$viga | format-list * -Force
    #Requires -Version 7
Get-Error

#endregion

#region Adding script output

Get-Command -Verb Write -Module Microsoft.PowerShell.Utility

Get-Help Output_ -Category HelpFile -ShowWindow
Get-Help CmdletBinding -Category HelpFile -ShowWindow
Get-Help _CommonParameters -Category HelpFile -ShowWindow
Get-Help Preference -Category HelpFile -ShowWindow

Get-Help redirect -ShowWindow
Get-Help Write-Host -ShowWindow

write-error "suur viga"
$Error[0]
write-error "suur viga" 2>> vealogi.txt

Write-Warning -Message 'Fail juba olemas, kirjutan üle'
Write-Warning -Message 'Fail juba olemas, kirjutan üle' 3>> hoiatuslogi.txt

$asi = 13
Write-Verbose -Message ('Muutuja väärtus: {0}, toimetan edasi' -f $asi) -Verbose
Write-Verbose -Message ('Muutuja väärtus: {0}, toimetan edasi' -f $asi) -Verbose 4>> verbaalne.txt

Write-Debug -Message 'Arendajale mõeldud teade' -Debug
Write-Debug -Message 'Arendajale mõeldud teade' -Debug 5>> debuglogi.txt

    #Requires -Version 5
Write-Information -MessageData 'Teade' -InformationAction Continue
Write-Information -MessageData 'Teade' -InformationAction Continue 6>> infotekst.txt
Write-Host 'kah teade' 6>> infotekst.txt

code -r events06.ps1

.\events06.ps1 -Verbose
.\events06.ps1 -Debug

#endregion

#region Using log files

code -r .\write-log.ps1

get-help .\write-log.ps1
.\write-log.ps1 -Level Warning -Message 'Midagi on viltu'

Find-Module -Command Write-PSFMessage -Repository PSGallery
Write-PSFMessage 'Teade logisse'
Get-PSFMessage

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

$func = { 'Hello' }
& $func
# https://peterwawa.wordpress.com/2011/01/26/kaustade-iguste-kaardistus/

Get-Command help
(Get-Command c:).Definition

Get-Help about_Functions -ShowWindow

function get-hello { 'Hello' }
get-hello
get-command get-hello
get-item function:\get-hello | Remove-Item

code -r events07.ps1

#endregion

#region Using variable scopes

Get-Help about_Scope -ShowWindow
Get-Help Get-Variable -Parameter Scope

$minuasi = 'minu asi'
$minuasi
$local:minuasi
$script:minuasi
$global:minuasi

function katse {
    [CmdletBinding()]
    param (
        $minuasi
    )
    write-verbose -Message ('Minu asi on: {0}' -f $minuasi)

    $minuasi += " + katsetuse asi"
    <# return #> $minuasi
}

katse -minuasi $minuasi -Verbose

$minuasi = katse -minuasi $minuasi -Verbose
$minuasi

Get-Help about_return -ShowWindow

#endregion

#region Creating a module

# https://docs.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-script-module

code -r events07.psm1

Get-Help Export-ModuleMember -ShowWindow

Import-Module .\events07.psm1
events07 -aeg ([datetime]::Now).AddHours(-2)
Get-Command -Module events07
Get-Help events07
Remove-Module events07

    # this is not module, it imports function to global scope
Import-Module .\events07.ps1
Get-Command events07 | Format-List
Remove-Item -Path function:\events07

Import-Module .\events07
Get-Module events07 | Format-List
Remove-Module events07

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

. .\events07.ps1
Get-Command events07
Get-Item function:\events07 | Remove-Item

#endregion

#endregion
