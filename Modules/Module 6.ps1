#region Safety to prevent the entire script from being run instead of a selection

throw "You're not supposed to run the entire script"

<#

    The code in this region was stolen, I mean borrowed from Thomas Rayner (@MrThomasRayner).

    For more information, see:

    http://mikefrobbins.com/2017/11/02/safety-to-prevent-entire-script-from-running-in-the-powershell-ise/

#>

#endregion

# Module 6 - Querying management information by using CIM and WMI

    # Lesson 1 - Understanding CIM and WMI

# CIM - Common Information Model: http://www.dmtf.org/standards/cim/
# WMI - Windows Management Instrumentation, based on WBEM: http://msdn.microsoft.com/library/aa394582

Get-Command -noun wmi*

    # olemas Windows 8/Server 2012 või värskemas
Get-Module cimcmdlets -ListAvailable
Get-Command -module cimcmdlets

    # CIM namespace hierarchy
Get-CimInstance -Namespace root -ClassName __Namespace
Get-CimInstance -Namespace root\cimv2 -ClassName __Namespace
Get-CimInstance -Namespace root\virtualization -ClassName __Namespace

# Documentation about namespaces - Win32 Provider: https://msdn.microsoft.com/en-us/library/aa394388

Get-Command wbemtest, wmic
wbemtest
# otsi internetist märksõnu "WMI Browser", "WMI Explorer"


# Lesson 2 - Querying data by using CIM and WMI

Get-WmiObject –Namespace root –List -Recurse | Select-Object -Unique __NAMESPACE

Get-CimClass | Sort-Object cimclassname

Get-CimInstance -ClassName Win32_LogicalDisk
Get-CimInstance -ClassName Win32_ComputerSystem
Get-CimInstance -ClassName Win32_OperatingSystem
Get-CimInstance -ClassName Win32_PhysicalMemory
Get-CimInstance -ClassName Win32_PhysicalMemoryArray

    # need teevad sama asja
Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3'
Get-CimInstance -query "SELECT * FROM Win32_LogicalDisk WHERE DriveType=3"

Get-CimInstance Win32_Service
Get-Service

Get-CimInstance Win32_Process
Get-Process

Get-CimInstance Win32_Volume
Get-Volume

Get-CimInstance Win32_DiskDrive
Get-Disk

Get-CimInstance Win32_NetworkAdapter
Get-NetAdapter

Get-CimInstance Win32_SystemEnclosure | Format-List ChassisTypes
# https://blogs.technet.microsoft.com/brandonlinton/2017/09/15/updated-win32_systemenclosure-chassis-types/

    # connecting to remote computers
Get-CimInstance –Classname Win32_BIOS –ComputerName LON-DC1

    # iga käsk on eraldi uus ühendus
Get-CimInstance -computername (Get-Content masinad.txt) -ClassName Win32_PhysicalMemory
Get-CimInstance -computername (Get-Content masinad.txt) -ClassName Win32_LogicalDisk

Get-Command -Noun CimSession
Get-Command -ParameterName Cimsession | Measure-Object

$serverid = New-CimSession -ComputerName (Get-Content masinad.txt)
$kettad = Get-CimInstance -CimSession $serverid -ClassName Win32_LogicalDisk
$malu = Get-CimInstance -CimSession $serverid -ClassName Win32_PhysicalMemory
    # ja nüüd kasutame muutujatesse korjatud infot

Get-CimInstance -ClassName Win32_OperatingSystem | Format-List PSComputerName


    # Lesson 3 - Making changes by using CIM and WMI

Get-Ciminstance -ClassName Win32_OperatingSystem | get-member -Name ForegroundApplicationBoost

Get-WmiObject -Class Win32_Service | Get-Member
Get-CimClass -ClassName Win32_Service | Get-Member
Get-CimClass -ClassName Win32_Service | Select-Object -ExpandProperty CimClassMethods

Get-CimClass -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty CimClassMethods
# https://msdn.microsoft.com/en-us/library/aa394058

Invoke-CimMethod –CN LON-DC1 –Class Win32_Process –MethodName Create ‑Arguments @{'Path'='Notepad.exe'}
Get-CimInstance -ClassName Win32_Process -Filter "Name='notepad.exe'" -ComputerName LON-DC1 |
    Invoke‑CimMethod -MethodName Terminate
