<#
    .SYNOPSIS
        Module 06 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 06 - Querying management information by using CIM and WMI
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M6
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Understanding CIM and WMI

#region Architecture and technologies

# CIM - Common Information Model: http://www.dmtf.org/standards/cim/
# WMI - Windows Management Instrumentation, based on WBEM: https://docs.microsoft.com/windows/win32/wmisdk/wmi-start-page
# Web-based Enterprise Management: https://www.dmtf.org/standards/wbem
# Desktop Management Interface: https://www.dmtf.org/sites/default/files/standards/documents/DSP0005.pdf

    # PowerShell < 6
Get-Command -noun Wmi*

    #Requires -Version 3.0
Get-Module CimCmdlets -ListAvailable
Get-Command -Module CimCmdlets

#endregion

#region Understanding the repository

Get-CimInstance -Namespace root -ClassName __Namespace
Get-CimInstance -Namespace root\cimv2 -ClassName __Namespace

#endregion

#region Finding documentation

# https://docs.microsoft.com/windows/win32/wmisdk/
# https://docs.microsoft.com/previous-versions/windows/desktop/wmi_v2
# https://docs.microsoft.com/windows/win32/srvnodes/wmi-mi-omi-providers
# https://docs.microsoft.com/windows/win32/cimwin32prov/win32-provider

#endregion

Get-Command wbemtest, wmic
wbemtest.exe

WMIC.exe /?
WMIC.exe alias /?
WMIC.exe alias list brief

WMIC.exe OS /?
WMIC.exe OS get Version

#endregion


#region Lesson 2: Querying data by using CIM and WMI

#region Listing namespaces

Get-WmiObject –Namespace root –List -Recurse | Select-Object -Unique __NAMESPACE

Get-CimInstance -Namespace root -ClassName __Namespace

#endregion

#region Listing classes

Get-WmiObject -Namespace root\cimv2 –List
Get-CimClass -ClassName Win32_* | Sort-Object CimClassName

    # don't use this
Get-CimClass Win32_Product
    # instead, use this, registry or module MSI
Get-CimClass -ClassName Win32_InstalledWin32Program
# https://docs.microsoft.com/troubleshoot/windows-server/admin-development/windows-installer-reconfigured-all-applications

#endregion

#region Querying instances

Get-Help Get-CimInstance -ShowWindow
Get-Help Get-WmiObject -ShowWindow

Get-WmiObject -Class Win32_LogicalDisk
Get-CimInstance -ClassName Win32_LogicalDisk
Get-CimInstance Win32_LogicalDisk –Filter "DriveType=3" -Property DeviceId, Size, FreeSpace -Verbose
Get-CimInstance -Query @'
SELECT DeviceId,Size,FreeSpace
FROM Win32_LogicalDisk
WHERE DriveType=3
'@

Get-CimInstance -ClassName Win32_ComputerSystem
Get-CimInstance -ClassName Win32_OperatingSystem
Get-CimInstance -ClassName Win32_PhysicalMemory
Get-CimInstance -ClassName Win32_PhysicalMemoryArray

#endregion

#region Connecting to remote computers

Get-Help Get-WmiObject -Parameter ComputerName
Get-Help Get-CimInstance -Parameter ComputerName

Get-WmiObject Win32_OperatingSystem -ComputerName 'LON-DC1'

#endregion

#region Using CIM sessions

Get-Command -Noun CimSession
Get-Command -ParameterName 'CimSession' | Measure-Object

$Session = New-CimSession -ComputerName (Get-Content servers.txt)
$kettad = Get-CimInstance -CimSession $Session -ClassName Win32_LogicalDisk
$malu = Get-CimInstance -CimSession $Session -ClassName Win32_PhysicalMemory
$Session | Remove-CimSession

#endregion

#endregion


#region Lesson 3: Making changes by using CIM and WMI

Get-CimInstance -ClassName Win32_OperatingSystem | Get-Member -Name ForegroundApplicationBoost

#region Discovering methods

Get-WmiObject -Class Win32_Service | Get-Member -MemberType Method
Get-CimClass -ClassName Win32_Service | Get-Member
Get-CimClass -ClassName Win32_Service | Select-Object -ExpandProperty CimClassMethods

#endregion

#region Finding documentation for methods

Get-CimClass -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty CimClassMethods

# https://docs.microsoft.com/windows/win32/cimwin32prov/win32shutdown-method-in-class-win32-operatingsystem
# https://docs.microsoft.com/windows/win32/cimwin32prov/win32-service-methods

#endregion

#region Invoking methods

Get-Help Invoke-WmiMethod -Parameter ArgumentList
([Wmiclass]'Win32_Process').GetMethodParameters('Create')
Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList 'notepad.exe'

Get-Help Invoke-CimMethod -Parameter Arguments

Get-CimClass -ClassName Win32_Process |
    Invoke-CimMethod -MethodName Create -Arguments @{ CommandLine = 'Notepad.exe' }
Get-Process Notepad
Get-CimInstance -ClassName Win32_Process -Filter "Name='notepad.exe'" |
    Invoke-CimMethod -MethodName Terminate

(Get-WmiObject win32_service -Filter 'Name="bits"').StopService()

#endregion



#endregion
