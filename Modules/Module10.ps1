<#
    .SYNOPSIS
        Module 10 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 10 - Administering remote computers
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M10
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Using basic Windows PowerShell remoting

#region Remoting overview and architecture

Get-Help about_Remote -ShowWindow
Get-Help about_Remote_Requirements -ShowWindow

# https://docs.microsoft.com/powershell/scripting/learn/remoting/SSH-Remoting-in-PowerShell-Core

#endregion

#region Remoting vs. remote connectivity

# https://docs.microsoft.com/powershell/scripting/learn/remoting/powershell-remoting-faq#do-all-remote-commands-require-powershell-remoting-

Get-Command -ParameterName ComputerName -Module microsoft.powershell.* | Measure-Object

Get-Help CimSession -Category HelpFile -ShowWindow
Get-Command -ParameterName CimSession

    # PowerShell 7 tries to remove that parameter.
Get-Command -ParameterName ComputerName
Get-Command -ParameterName Server

#endregion

#region Remoting security

# https://docs.microsoft.com/powershell/scripting/learn/remoting/winrmsecurity
# http://peterwawa.wordpress.com/2013/10/02/powershell-remoting-ja-trustedhosts/

    # Service WinRM must work to get access to WSMan drive
Get-Service WinRM
Get-Item WSMan:\localhost\Client\TrustedHosts

    #Requires -RunAsAdministrator
Set-PSSessionConfiguration -Name microsoft.powerShell -ShowSecurityDescriptorUI

Get-LocalGroup 'Remote Management Users'
Get-LocalGroup 'Remote Management Users' | Get-LocalGroupMember

#endregion

#region Enabling remoting

Get-Help Enable-PSRemoting -ShowWindow
    #Requires -RunAsAdministrator
Enable-PSRemoting

Get-Help Set-WSManQuickConfig

# https://devops-collective-inc.gitbook.io/secrets-of-powershell-remoting/configuring-remoting-via-gpo

# https://docs.microsoft.com/powershell/scripting/learn/remoting/powershell-remoting-faq#can-i-test-remoting-on-a-single-computer-not-in-a-domain-

#endregion

#region Using remoting: one-to-one

Get-Help Enter-PSSession -ShowWindow

Enter-PSSession -ComputerName Lon-DC1
exit

Get-Help Enter-PSSession -Parameter Credential

#endregion

#region Using remoting: one-to-many

Get-Help Invoke-Command -ShowWindow

Invoke-Command -ComputerName Lon-DC1 -ScriptBlock { whoami.exe }
Invoke-Command -ComputerName Lon-DC1, Lon-CL1 -ScriptBlock { whoami.exe }
Invoke-Command -ComputerName (get-content servers.txt) -ScriptBlock { whoami.exe }

Get-Help Invoke-Command -Parameter Credential

#endregion

#region Remoting output vs. local output

    # remote command output
Get-Help about_Remote_Output -ShowWindow

# https://docs.microsoft.com/powershell/scripting/learn/remoting/powershell-remoting-faq#is-the-output-of-remote-commands-different-from-local-output-

Invoke-Command -ComputerName Lon-DC1 -ScriptBlock { 1..3 | start notepad.exe }
Invoke-Command -ComputerName Lon-DC1 -ScriptBlock { Get-Process notepad } | Get-Member
Invoke-Command -ComputerName Lon-DC1 -ScriptBlock {
    Get-Process notepad | Select-Object -Property ProcessName, Id, Path
} |
    Get-Member

Get-Process | Get-Member

#endregion

#endregion


#region Lesson 2: Using advanced Windows PowerShell remoting

#region Common remoting options

Get-Command -ParameterName Credential -Module microsoft.powershell.core
Get-Command -ParameterName Port -Module microsoft.powershell.core
Get-Command -ParameterName UseSSL -Module microsoft.powershell.core
Get-Command -ParameterName ConfigurationName -Module microsoft.powershell.core
Get-Command -Noun PSSessionConfiguration

Get-Help New-PSSession -Parameter SessionOption
Get-Help New-PSSessionOption -ShowWindow

#endregion

#region Sending parameters to remote computers

Get-Help Remote_Variables -ShowWindow

$ServiceName = 'Bits'
    #Requires -Version 3
Invoke-Command -ComputerName Lon-DC1 -ScriptBlock { get-service $using:ServiceName }
    #Requires -Version 2
Invoke-Command -ComputerName Lon-DC1 -ScriptBlock {
    param ($sn)
    Get-Service $sn
} -ArgumentList $ServiceName

#endregion

#region Windows PowerShell scopes

Get-Help Scopes -ShowWindow

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_scopes#the-using-scope-modifier

#endregion

#region Multi-hop remoting

# https://docs.microsoft.com/powershell/scripting/learn/remoting/ps-remoting-second-hop

$credential = Get-Credential

Invoke-Command -ComputerName Lon-DC1 -ScriptBlock {
    Invoke-Command -ComputerName lon-Svr1 -Credential $using:Credential -ScriptBlock {
        'User: {0}, Computer: {1}' -f $env:USERNAME, $env:COMPUTERNAME
    }
}

#endregion

#endregion


#region Lesson 3: Using PSSessions

#region Persistent connections

Get-Command -Noun PSSession
Get-Command -ParameterName Session -Module Microsoft.PowerShell.Core

#endregion

#region Creating a PSSession

Get-Help New-PSSession -ShowWindow

New-PSSession -ComputerName Lon-Svr1

$dc = New-PSSession -ComputerName Lon-DC1
$dc | Get-Member

#endregion

#region Using a PSSession

$dc | Enter-PSSession
Enter-PSSession -Session $dc
Get-PSSession -ComputerName Lon-DC1 | Enter-PSSession

Get-PSSession | Invoke-Command -ScriptBlock { $env:COMPUTERNAME }
Invoke-Command -Session $dc -ScriptBlock { whoami.exe }

#endregion

#region Disconnected sessions

Get-Help Disconnected -ShowWindow
Get-Command -noun PSSession -Verb *Connect

$DcName = 'lon-dc1'
$dc = New-PSSession -ComputerName $DcName
Disconnect-PSSession -Session $dc
Get-PSSession -ComputerName $DcName
Get-PSSession -ComputerName $DcName | Connect-PSSession
Get-PSSession

#endregion

#region Implicit remoting

Get-Help Import-Module -Parameter PSSession
Get-Help Import-PSSession -Parameter Module

Get-Module ActiveDirectory -ListAvailable
$dc = New-PSSession -ComputerName lon-dc1
Import-Module -PSSession $dc -Name ActiveDirectory -Prefix 'dc' -Function Get-ADUser
    # or
Import-PSSession -Session $dc -Module ActiveDirectory -Prefix 'dc' -CommandName Get-ADUser

Get-Command Get-dcADUser
Get-Module #ActiveDirectory

Get-dcADUser administrator
Get-Module ActiveDirectory | Select-Object Version, ModuleType, ModuleBase

Remove-PSSession -Session $dc
Get-dcADUser administrator # creates a new session

#endregion

#endregion
