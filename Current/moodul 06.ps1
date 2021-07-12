# lesson 1

    #kontrollime, kas WinRM töötab
Get-NetTCPConnection -LocalPort 5985
Test-NetConnection localhost -CommonTCPPort WINRM
    #häälestame WinRM teenuse, kui tahame seda kõike üle võrgu kasutada
winrm quickconfig
Start-Service WinRM
Set-Service WinRM -StartupType Automatic
    #Requires -RunAsAdministrator
Enable-PSRemoting -Force

Get-Command -noun wmi*
Get-Command -Noun cim*

Get-WmiObject Win32_bios
Get-WmiObject Win32_ComputerSystem
Get-WmiObject Win32_PhysicalMemory
8GB

Get-WmiObject Win32_OperatingSystem | select Caption
Get-WmiObject Win32_SystemEnclosure | select chassistypes

    #nii on tänapäeval ilusam
Get-CimInstance Win32_ComputerSystem
Get-CimInstance Win32_PhysicalMemory
Get-CimInstance Win32_OperatingSystem | select Caption
Get-CimInstance Win32_OperatingSystem | select Status

Get-CimInstance Win32_UserProfile

    #mida kõike Sa tead, arvuti?
Get-WmiObject *memory* -List
Get-CimClass *memory*
Get-WmiObject -list | measure
Get-CimClass | measure

Measure-Command {
    Get-WmiObject win32_bios -ComputerName lon-dc1 #, loll
}

Measure-Command {
  Get-CimInstance Win32_BIOS #-ComputerName lon-dc1
}

#lesson 2
Get-WmiObject Win32_LogicalDisk
    #Requires -Version 3.0
Get-CimInstance Win32_LogicalDisk
    # vajab Win8 või värskemat
Get-Volume

Get-CimInstance Win32_PhysicalMedia
    # win8 ja värskem
Get-PhysicalDisk

Get-CimInstance Win32_LogicalDisk
help Get-CimInstance -Parameter filter
help Get-WmiObject -Parameter filter

Get-CimInstance Win32_OperatingSystem -Filter "Caption LIKE '%Windows 10%'"

Get-CimInstance Win32_OperatingSystem -Filter "Caption LIKE '%Windows 8.1%'"
Get-CimInstance Win32_LogicalDisk -Filter "DriveType = 3"

Get-CimInstance -Query "SELECT * FROM Win32_LogicalDisk WHERE DriveType = 3"

help Get-CimInstance

Get-CimInstance Win32_OperatingSystem -Property caption | select caption


    # teised masinad
Measure-Command {
  Get-CimInstance Win32_BIos -ComputerName lon-dc1
  Get-CimInstance Win32_PhysicalMemory -ComputerName lon-dc1
}

$pass = "Password"
$kasutaja = New-Object -TypeName System.Management.Automation.PSCredential `
                   -ArgumentList "domain\kasutaja", $pass

$sessioon = New-CimSession -Credential $kasutaja -ComputerName lon-dc1, lon-dc1 #, lon-cl1
Measure-Command {
    Get-CimInstance Win32_BIos -CimSession $sessioon
    Get-CimInstance Win32_PhysicalMemory -CimSession $sessioon
}
Remove-CimSession $sessioon

    #kasutajakontod ja paroolid
$kasutaja = Get-Credential mina
$kasutaja | Get-Member
$kasutaja.Password
$kasutaja.GetNetworkCredential() | Get-Member
$kasutaja.GetNetworkCredential().Password

# Lesson 3
    #uurime meetodeid
Get-WmiObject Win32_Process | Get-Member -MemberType Method | select -Last 1 -ExpandProperty Definition
Get-CimInstance Win32_Process | Get-Member -MemberType Method
Get-CimClass Win32_Process | select -ExpandProperty cimclassmethods | select -Skip 1 -First 1 -ExpandProperty Parameters

    # teeme notepad protsesse
1..3 | foreach {start notepad}
Get-WmiObject win32_process -Filter "name = 'notepad.exe'" | measure
    # koristame notepadid ära
(Get-WmiObject win32_process -Filter "name = 'notepad.exe'").terminate() | Out-Null
$tulemus = Get-WmiObject win32_process -Filter "name = 'notepad.exe'" | ForEach-Object Terminate
Get-WmiObject win32_process -Filter "name = 'notepad.exe'" | Invoke-WmiMethod -Name Terminate
Get-CimInstance win32_process -Filter "name = 'notepad.exe'" | Invoke-CimMethod -Name Terminate

Get-Module -ListAvailable
Get-NetAdapter | Get-Member


Get-CimClass Win32_Process | select -ExpandProperty cimclassmethods | select -First 1 -ExpandProperty Parameters

Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{'Commandline'='notepad.exe'}
