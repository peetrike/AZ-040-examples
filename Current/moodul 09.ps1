# Lesson 1

help Enable-PSRemoting -ShowWindow
Test-NetConnection alektor -CommonTCPPort WINRM

    #Requires -RunAsAdministrator
Enable-PSRemoting -Force


if (Test-NetConnection localhost -CommonTCPPort WINRM | select -ExpandProperty TcpTestSucceeded) {
    # olemas, pole vaja midagi teha
} else {
    Enable-PSRemoting -Force
}

    #Powershell Remoting eelne liides
Get-Process -ComputerName .
Get-Service -ComputerName .

Get-Command -ParameterName Computername | measure
Get-Command -ParameterName Credential | measure

    # Powershell Remoting liides
Get-Command -ParameterName Session | measure
    # CIM liidesega remoting
Get-Command -ParameterName CimSession | measure

    #Requires -RunAsAdministrator
Set-PSSessionConfiguration Microsoft.PowerShell –ShowSecurityDescriptorUI
Get-PSSessionConfiguration

    # one-to-one interactive PS remoting
Enter-PSSession -ComputerName .
hostname
exit

Invoke-Command -ScriptBlock {hostname} -ComputerName lon-dc1
Invoke-Command -ScriptBlock {Get-CimInstance Win32_LogicalDisk} -ComputerName lon-dc1 | Get-Member


Invoke-Command -ScriptBlock {hostname; ipconfig } -ComputerName lon-dc1, lon-cl1 |
    Where-Object {$_}

Invoke-Command -FilePath c:\minuskript.ps1 -ComputerName lon-dc1

help Invoke-Command -ShowWindow


# Lesson 2

$parameetrid = New-PSSessionOption ...
Invoke-Command -SessionOption $parameetrid

help Invoke-Command -Parameter session
$minusession = New-PSSession -ComputerName .
Invoke-Command -Session $minusession -ScriptBlock {$P = Get-Process p*}
Invoke-Command -Session $minusession -ScriptBlock {$P.VM}

$serverid = New-PSSession -ComputerName (Get-Content serverid.txt)
Invoke-Command -Session $serverid -FilePath c:\miskiskript.ps1
Remove-PSSession $serverid

help Invoke-Command -Parameter filepath

# Lesson 3

help about_PSSessions -ShowWindow
Get-Command -Noun pssession

help about_Remote_Disconnected_Sessions -ShowWindow
Disconnect-PSSession -Session $minusession
Connect-PSSession -Session $minusession

    # implicit remoting
$minuDC = New-PSSession -ComputerName Lon-dc1 -Credential adatum\administrator
Import-Module -PSSession $minuDC -Name ActiveDirectory #-Prefix MinuDC
    # või
Invoke-Command -Session $minuDC -ScriptBlock {Import-Module ActiveDirectory}
Import-PSSession -Session $minuDC -module ActiveDirectory #-Prefix MinuDC

get-MinuDCAdUser Administrator
    # või
get-aduser administrator



Get-PSSession

Get-Command Get-PSSession | ft -AutoSize
Get-Command -Module Microsoft.PowerShell.Core

