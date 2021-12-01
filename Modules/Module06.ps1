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
# For Linux: OMI - Open Management Infrastructure: https://collaboration.opengroup.org/omi/
# Windows Remote Management (WinRM), based on Web Services Management (WS-Man)
#   * https://docs.microsoft.com/windows/win32/winrm
#   * https://www.dmtf.org/standards/ws-man

# WMI - Windows Management Instrumentation, based on WBEM
#   * https://docs.microsoft.com/windows/win32/wmisdk/wmi-start-page
# Web-Based Enterprise Management (WBEM): https://www.dmtf.org/standards/wbem
# Desktop Management Interface (DMI): https://www.dmtf.org/sites/default/files/standards/documents/DSP0005.pdf

    # PowerShell < 6
Get-Command -noun Wmi*

    #Requires -Version 3.0
Get-Module CimCmdlets -ListAvailable
Get-Command -Module CimCmdlets

#endregion

#region Understanding the repository

Get-CimInstance -Namespace root -ClassName __Namespace
Get-CimInstance -Namespace root\cimv2 -ClassName __Namespace
Get-CimInstance -Namespace root\Microsoft\Windows -ClassName __Namespace

#endregion

#region Finding documentation

# https://docs.microsoft.com/windows/win32/wmisdk/
# https://docs.microsoft.com/previous-versions/windows/desktop/wmi_v2
# https://docs.microsoft.com/windows/win32/srvnodes/wmi-mi-omi-providers
# https://docs.microsoft.com/windows/win32/cimwin32prov/win32-provider

#endregion

#region Extra: WMI browsers outside of PowerShell, but included in Windows

Get-Command wbemtest, wmic
wbemtest.exe

WMIC.exe /?
WMIC.exe alias /?
WMIC.exe alias list brief

WMIC.exe OS /?
WMIC.exe OS get Version

#endregion

#endregion


#region Lesson 2: Querying data by using CIM and WMI

#region Listing namespaces

Get-WmiObject –Namespace ROOT –List -Recurse -ErrorAction SilentlyContinue |
    Select-Object -Unique __NAMESPACE

Get-CimInstance -Namespace ROOT -ClassName __Namespace
code -r .\Get-CimNamespace.ps1
.\Get-CimNamespace.ps1

#endregion

#region Listing classes

Get-WmiObject -Namespace root\cimv2 –List
Get-CimClass -ClassName Win32_* | Sort-Object CimClassName

    # don't use this
Get-CimClass Win32_Product
    # instead, use this, registry or module MSI
Get-CimClass -ClassName Win32_InstalledWin32Program

Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
              'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'

Find-Module msi -Repository PSGallery
Get-MSIProductInfo

    # Microsoft Store apps
    #Requires -RunAsAdministrator
Get-CimClass -ClassName Win32_InstalledStoreProgram
#endregion

#region Querying instances

Get-Help Get-CimInstance -ShowWindow
Get-Help Get-WmiObject -ShowWindow

Get-WmiObject -Class Win32_LogicalDisk
Get-CimInstance -ClassName Win32_LogicalDisk

Get-Help wql -Category HelpFile -ShowWindow
# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_wql?view=powershell-5.1
Get-CimInstance -Query @'
SELECT DeviceId,Size,FreeSpace
FROM Win32_LogicalDisk
WHERE DriveType=3
'@
Get-CimInstance Win32_LogicalDisk –Filter "DriveType=3" -Property DeviceId, Size, FreeSpace -Verbose

Get-CimInstance -ClassName Win32_Service -Filter 'Name="bits"'
Get-Service BITS
Get-CimInstance -ClassName Win32_Process -Filter "ProcessID=$pid"
Get-Process -Id $pid

Get-CimInstance Win32_ComputerSystem
Get-CimInstance Win32_OperatingSystem
# https://peterwawa.wordpress.com/2014/04/11/mis-mlu-mul-masinasserveris-on/

#region version-neutral approach

$queryParam = @{
    Filter = 'DriveType=3'
    ComputerName = '.'
}
if ($command = Get-Command Get-CimInstance -ErrorAction SilentlyContinue) {
    $queryParam.ClassName = 'Win32_LogicalDisk'
} else {
    $command = get-command Get-WmiObject
    $queryParam.Class = 'Win32_LogicalDisk'
}
& $command @queryParam

#endregion


#endregion

#region Connecting to remote computers

Get-Help Get-WmiObject -Parameter ComputerName
Get-Help Get-CimInstance -Parameter ComputerName

Get-WmiObject -Class Win32_OperatingSystem -ComputerName 'LON-DC1'
Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName 'LON-DC1'


Get-NetFirewallRule -Name wmi*-in-*
Get-NetFirewallRule -Name winrm-http*

#endregion

#region Using CIM sessions

    #Requires -Version 3
Get-Help CimSession -Category HelpFile -ShowWindow

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
