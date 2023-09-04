<#
    .SYNOPSIS
        Module 8 samples
    .DESCRIPTION
        This file contains sample commands from course AZ-040 for
        Module 8 - Administering remote computers
    .LINK
        https://learn.microsoft.com/training/paths/administer-remote-computers-use-windows-powershell/
    .LINK
        https://github.com/peetrike/AZ-040-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23AZ-040+%23M8
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Use basic PowerShell remoting

#region Remoting overview and architecture

Get-Help about_Remote -ShowWindow
Get-Help about_Remote_Requirements -ShowWindow

# https://learn.microsoft.com/powershell/scripting/learn/remoting/SSH-Remoting-in-PowerShell-Core

#endregion

#region Remoting vs. remote connectivity

# https://learn.microsoft.com/powershell/scripting/learn/remoting/powershell-remoting-faq#do-all-remote-commands-require-powershell-remoting-

Get-Command -ParameterName ComputerName -Module microsoft.powershell.* | Measure-Object

Get-Help CimSession -Category HelpFile -ShowWindow
Get-Command -ParameterName CimSession

Get-Command -ParameterName ComputerName |
    Where-Object { -not ($_.Parameters.Keys -match 'Session$') }

    # PowerShell 7 tries to remove that parameter.
Get-Command -ParameterName ComputerName
Get-Command -ParameterName Server

#endregion

#region Remoting security

# https://learn.microsoft.com/powershell/scripting/learn/remoting/winrmsecurity
# http://peterwawa.wordpress.com/2013/10/02/powershell-remoting-ja-trustedhosts/

    # Service WinRM must work to get access to WSMan drive
Get-Service WinRM
Get-Item WSMan:\localhost\Client\TrustedHosts

    #Requires -RunAsAdministrator
Set-PSSessionConfiguration -Name microsoft.powerShell -ShowSecurityDescriptorUI

Get-LocalGroup 'Remote Management Users'
Get-LocalGroup 'Remote Management Users' | Get-LocalGroupMember

# https://learn.microsoft.com/windows-server/administration/openssh/openssh_server_configuration#allowgroups-allowusers-denygroups-denyusers
# https://learn.microsoft.com/windows-server/administration/openssh/openssh_keymanagement#about-key-pairs

#endregion

#region Enabling remoting

Get-Help Enable-PSRemoting -ShowWindow
    #Requires -RunAsAdministrator
Enable-PSRemoting

Get-Help Set-WSManQuickConfig
    #Requires -RunAsAdministrator
Get-NetFirewallRule -Name WINRM-HTTP-In-TCP*
Get-NetFirewallRule -Group '@FirewallAPI.dll,-30267'
Get-NetFirewallRule -Name WINRM-HTTP-In* | Where-Object Profile -like 'Public' | Get-NetFirewallAddressFilter

# https://devops-collective-inc.gitbook.io/secrets-of-powershell-remoting/configuring-remoting-via-gpo

# https://learn.microsoft.com/powershell/scripting/learn/remoting/powershell-remoting-faq#can-i-test-remoting-on-a-single-computer-not-in-a-domain-

#endregion

#region Using remoting: one-to-one

Get-Help Enter-PSSession -ShowWindow

Enter-PSSession -ComputerName Sea-DC1
exit

Get-Help Enter-PSSession -Parameter Credential

#endregion

#region Using remoting: one-to-many

Get-Help Invoke-Command -ShowWindow

# https://github.com/peetrike/Examples/blob/main/src/Functions/Get-CurrentUser.ps1
Invoke-Command -ComputerName Sea-DC1 -ScriptBlock {
    [Security.Principal.WindowsIdentity]::GetCurrent()
}
Invoke-Command -ComputerName Sea-DC1, Sea-CL1 -ScriptBlock { $env:COMPUTERNAME }
Invoke-Command -ComputerName (Get-Content servers.txt) -ScriptBlock { $env:COMPUTERNAME }

Get-Help Invoke-Command -Parameter ThrottleLimit

Get-Help Invoke-Command -Parameter Credential

Get-Help Invoke-Command -Parameter ComputerName

#endregion

#region Remoting output vs. local output

    # remote command output
Get-Help about_Remote_Output -ShowWindow

# https://learn.microsoft.com/powershell/scripting/learn/remoting/powershell-remoting-faq#is-the-output-of-remote-commands-different-from-local-output-

Invoke-Command -ComputerName Sea-DC1 -ScriptBlock { 1..3 | start notepad.exe }
Invoke-Command -ComputerName Sea-DC1 -ScriptBlock { Get-Process notepad } | Get-Member
Invoke-Command -ComputerName Sea-DC1 -ScriptBlock {
    Get-Process notepad | Select-Object -Property ProcessName, Id, Path
} |
    Get-Member

Get-Process | Get-Member

#endregion

#endregion


#region Lesson 2: Using advanced  PowerShell remoting

#region Common remoting options

Get-Command -ParameterName Credential -Module microsoft.powershell.core
Get-Command -ParameterName Port -Module microsoft.powershell.core
Get-Command -ParameterName UseSSL -Module microsoft.powershell.core
Get-Command -ParameterName ConfigurationName -Module microsoft.powershell.core

Get-Command -ParameterName SessionOption -Module microsoft.powershell.core

Get-Command -Noun PSSessionConfiguration

Get-Help New-PSSession -Parameter SessionOption
Get-Help New-PSSessionOption -ShowWindow

#endregion

#region Sending parameters to remote computers

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_remote_variables#using-local-variables-with-argumentlist-parameter

$ServiceName = 'Bits'
    #Requires -Version 2
Invoke-Command -ComputerName Lon-DC1 -ScriptBlock {
    param ($sn)
    Get-Service $sn
} -ArgumentList $ServiceName

    #Requires -Version 3
Invoke-Command -ComputerName Lon-DC1 -ScriptBlock { Get-Service $using:ServiceName }

#endregion

#region PowerShell scopes

Get-Help Scopes -ShowWindow
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_scopes#the-using-scope-modifier

Get-Help Remote_Variables -ShowWindow

#endregion

#region Multi-hop remoting

# https://learn.microsoft.com/powershell/scripting/learn/remoting/ps-remoting-second-hop

$credential = Get-Credential

Invoke-Command -ComputerName Sea-DC1 -ScriptBlock {
    Invoke-Command -ComputerName Sea-Svr1 -Credential $using:Credential -ScriptBlock {
        'User: {0}, Computer: {1}' -f $env:USERNAME, $env:COMPUTERNAME
    }
}

# https://learn.microsoft.com/powershell/scripting/learn/remoting/jea/overview

# https://learn.microsoft.com/windows-server/manage/windows-admin-center/overview

#endregion

#endregion


#region Lesson 3: Using PSSessions

#region Persistent connections

Get-Command -Noun PSSession
Get-Command -ParameterName Session -Module Microsoft.PowerShell.Core

    #Requires -RunAsAdministrator
Get-ChildItem -Path WSMan:\localhost\Shell

#endregion

#region Creating and using a PSSession

Get-Help New-PSSession -ShowWindow

New-PSSession -ComputerName Sea-Svr1

$dc = New-PSSession -ComputerName Sea-DC1
$dc | Get-Member

Get-Help Enter-PSSession -Parameter Session
$dc | Enter-PSSession
Enter-PSSession -Session $dc
Get-PSSession -ComputerName Lon-DC1 | Enter-PSSession

Get-Help Invoke-Command -Parameter Session
Invoke-Command -Session $dc -ScriptBlock { whoami.exe }
Get-PSSession | ForEach-Object {
    Invoke-Command -Session $_ -ScriptBlock { $env:COMPUTERNAME }
}

#endregion

#region Disconnected sessions

Get-Help Disconnected -ShowWindow
Get-Command -noun PSSession -Verb *Connect

$DcName = 'Sea-DC1'
$dc = New-PSSession -ComputerName $DcName
Disconnect-PSSession -Session $dc
Get-PSSession -ComputerName $DcName
Get-PSSession -ComputerName $DcName | Connect-PSSession
Get-PSSession

$s = Invoke-Command -ComputerName $DcName -InDisconnectedSession -ScriptBlock {
    start-sleep -Seconds 100
    'valmis'
}
Start-Sleep -Seconds 120
Receive-PSSession -Session $s

#endregion

#region Implicit remoting

Get-Help Import-Module -Parameter PSSession
Get-Help Import-PSSession -Parameter Module

Get-Module ActiveDirectory -ListAvailable
$dc = New-PSSession -ComputerName $DcName
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


#region Lab

# https://github.com/MicrosoftLearning/AZ-040T00-Automating-Administration-with-PowerShell/blob/master/Instructions/Labs/LAB_08_Performing_remote_administration_with_PowerShell.md

#endregion
