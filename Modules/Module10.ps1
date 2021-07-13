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

Get-Help about_Remote -ShowWindow
Get-Help about_Remote_Requirements -ShowWindow

Get-Command -ParameterName ComputerName -Module microsoft.powershell.* | Measure-Object

# Requires -RunAsAdministrator
Get-Item WSMan:\localhost\Client\TrustedHosts
Get-LocalGroup 'Remote Management Users'
Get-LocalGroup 'Remote Management Users' | Get-LocalGroupMember

# Requires -RunAsAdministrator
Enable-PSRemoting

Get-Help Enter-PSSession -ShowWindow

Get-Help Invoke-Command -ShowWindow


    # remote command output
Get-Help about_Remote_Output -ShowWindow
Invoke-Command -ComputerName lon-svr1 -ScriptBlock { 1..3 | start notepad.exe }
Invoke-Command -ComputerName lon-svr1 -ScriptBlock { Get-Process notepad } | Get-Member
Get-Process | Get-Member

#endregion


#region Lesson 2: Using advanced Windows PowerShell remoting

Get-Help Enter-PSSession -ShowWindow

Get-Help about_Remote_Variables -ShowWindow
# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_scopes#the-using-scope-modifier

# https://docs.microsoft.com/powershell/scripting/learn/remoting/ps-remoting-second-hop

#endregion


#region Lesson 3: Using PSSessions

Get-Command -Noun PSSession

Get-Help New-PSSession -ShowWindow

Get-Help about_Remote_Disconnected_Sessions -ShowWindow

Get-Help Import-Module -Parameter PSSession

#endregion
