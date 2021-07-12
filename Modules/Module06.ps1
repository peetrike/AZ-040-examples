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

# CIM - Common Information Model: http://www.dmtf.org/standards/cim/
# WMI - Windows Management Instrumentation, based on WBEM: https://docs.microsoft.com/windows/win32/wmisdk/wmi-start-page

    # PowerShell < 6
Get-Command -noun Wmi*

    # PowerShell 3+
Get-Module CimCmdlets -ListAvailable
Get-Command -Module CimCmdlets

#endregion


#region Lesson 2: Querying data by using CIM and WMI

Get-WmiObject –Namespace root –List -Recurse | Select-Object -Unique __NAMESPACE

Get-CimClass | Sort-Object CimClassName

Get-CimInstance -ClassName Win32_LogicalDisk
Get-CimInstance -ClassName Win32_ComputerSystem
Get-CimInstance -ClassName Win32_OperatingSystem
Get-CimInstance -ClassName Win32_PhysicalMemory
Get-CimInstance -ClassName Win32_PhysicalMemoryArray

#endregion


#region Lesson 3: Making changes by using CIM and WMI

Get-CimInstance -ClassName Win32_OperatingSystem | Get-Member -Name ForegroundApplicationBoost

Get-WmiObject -Class Win32_Service | Get-Member
Get-CimClass -ClassName Win32_Service | Get-Member
Get-CimClass -ClassName Win32_Service | Select-Object -ExpandProperty CimClassMethods

Get-CimClass -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty CimClassMethods
# https://docs.microsoft.com/windows/win32/cimwin32prov/win32shutdown-method-in-class-win32-operatingsystem

Invoke-CimMethod –CN LON-DC1 –Class Win32_Process –MethodName Create ‑Arguments @{ Path = 'Notepad.exe' }
Get-CimInstance -ClassName Win32_Process -Filter "Name='notepad.exe'" -ComputerName LON-DC1 |
    Invoke‑CimMethod -MethodName Terminate

#endregion
