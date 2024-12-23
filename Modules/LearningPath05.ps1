﻿<#
    .SYNOPSIS
        Learning Path 05 samples
    .DESCRIPTION
        This file contains sample commands from course AZ-040 for
        Learning Path 05 - Querying management information by using CIM and WMI
    .LINK
        https://learn.microsoft.com/training/paths/query-use-common-information-model-windows-management/
    .LINK
        https://github.com/peetrike/AZ-040-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23AZ-040+%23M5
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Module 1: Understanding CIM and WMI

#region Architecture and technologies

# CIM - Common Information Model: http://www.dmtf.org/standards/cim/
# For Linux/Unix: OMI - Open Management Infrastructure: https://github.com/Microsoft/omi
# Windows Remote Management (WinRM), based on Web Services Management (WS-Man)
# - https://learn.microsoft.com/windows/win32/winrm
# - https://www.dmtf.org/standards/ws-man

# WMI - Windows Management Instrumentation, based on WBEM
# - https://learn.microsoft.com/windows/win32/wmisdk
# Web-Based Enterprise Management (WBEM): https://www.dmtf.org/standards/wbem
# Desktop Management Interface (DMI): https://www.dmtf.org/standards/dmi

    # PowerShell < 6
Get-Command -noun Wmi*

    #Requires -Version 3.0
Get-Module CimCmdlets -ListAvailable
Get-Command -Module CimCmdlets

(Get-Command Get-NetAdapter).OutputType
(Get-Command Get-UserProfile).OutputType

#endregion

#region Understanding the repository

Get-CimInstance -Namespace root -ClassName __Namespace
Get-CimInstance -Namespace root\cimv2 -ClassName __Namespace
Get-CimInstance -Namespace root\Microsoft\Windows -ClassName __Namespace

#endregion

#region Finding documentation

# https://learn.microsoft.com/windows/win32/wmisdk/
# https://learn.microsoft.com/previous-versions/windows/desktop/wmi_v2
# https://learn.microsoft.com/windows/win32/cimwin32prov/win32-provider
# https://learn.microsoft.com/windows/win32/wmisdk/wmi-providers
# https://learn.microsoft.com/windows/win32/srvnodes/wmi-mi-omi-providers

#endregion

#region Extra: WMI browsers outside of PowerShell, but included in Windows

Get-Command wbemtest, wmic
wbemtest.exe

WMIC.exe /?
WMIC.exe alias /?
WMIC.exe alias list brief

WMIC.exe OS /?
WMIC.exe OS get Version

# https://gist.github.com/mitchelldavis/6868927
# https://github.com/vinaypamnani/wmie2

#endregion

#endregion


#region Module 2: Querying data by using CIM and WMI

#region Listing namespaces

Get-WmiObject -Namespace ROOT -List -Recurse -ErrorAction SilentlyContinue |
    Select-Object -Unique __NAMESPACE

Get-CimInstance -Namespace ROOT -ClassName __Namespace
code -r .\Get-CimNamespace.ps1
.\Get-CimNamespace.ps1

# https://github.com/peetrike/CimNamespace/blob/main/src/Public/Get-CimNamespace.ps1

#endregion

#region Listing classes

Get-Help Get-CimClass -ShowWindow

Get-WmiObject -Namespace root\cimv2 -List
Get-CimClass -ClassName Win32_* | Sort-Object CimClassName

    # don't use this
Get-CimClass Win32_Product
    # instead, use this, registry or module MSI
Get-CimClass -ClassName Win32_InstalledWin32Program

Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
              'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
# https://github.com/peetrike/scripts/blob/master/src/ComputerManagement/Get-InstalledSoftware.ps1

Find-Module msi -Repository PSGallery
Get-MSIProductInfo

    # Microsoft Store apps
Get-CimClass -ClassName Win32_InstalledStoreProgram
Get-AppxPackage
Get-AppxProvisionedPackage

#endregion

#region Querying instances

Get-Help Get-CimInstance -ShowWindow
Get-Help Get-WmiObject -ShowWindow

Get-WmiObject -Class Win32_LogicalDisk
Get-CimInstance -ClassName Win32_LogicalDisk

    # PowerShell < 6.0
Get-Help wql -Category HelpFile -ShowWindow
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_wql?view=powershell-5.1
Get-CimInstance -Query @'
    SELECT DeviceId, Size, FreeSpace
    FROM Win32_LogicalDisk
    WHERE DriveType=3
'@
Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' -Property DeviceId, Size, FreeSpace -Verbose

Get-CimInstance -ClassName Win32_Service -Filter 'Name="bits"'
Get-Service BITS
Get-CimInstance -ClassName Win32_Process -Filter "ProcessID=$PID"
Get-Process -Id $PID

Get-CimInstance Win32_ComputerSystem
Get-CimInstance Win32_OperatingSystem
# https://peterwawa.wordpress.com/2014/04/11/mis-mlu-mul-masinasserveris-on/

#region version-neutral approach

$queryParam = @{
    Filter       = 'DriveType=3'
    ComputerName = '.'
}
if ($command = Get-Command Get-CimInstance -ErrorAction SilentlyContinue) {
    $queryParam.ClassName = 'Win32_LogicalDisk'
} else {
    $command = Get-Command Get-WmiObject
    $queryParam.Class = 'Win32_LogicalDisk'
}
& $command @queryParam

    # alternative
[wmi] 'Win32_LogicalDisk.DeviceID="C:"'
([wmisearcher] 'SELECT * FROM Win32_OperatingSystem').Get()

#endregion

#endregion

#region Connecting to remote computers

Get-Help Get-WmiObject -Parameter ComputerName
Get-Help Get-CimInstance -Parameter ComputerName

$Computer = 'SEA-DC1'
Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer
Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $Computer

Get-Help Get-WmiObject -Parameter Credential

# https://learn.microsoft.com/windows/win32/wmisdk/connecting-to-wmi-remotely-starting-with-vista

    #Requires -RunAsAdministrator
Get-NetFirewallRule -Name wmi*-in-* | Select-Object name, enabled, profile, action
Get-NetFirewallRule -Name winrm-http* | Select-Object name, enabled, profile, action
Get-NetFirewallRule -Name WINRM-HTTP-In* | Where-Object Profile -like 'Public' | Get-NetFirewallAddressFilter

#endregion

#region Using CIM sessions

    #Requires -Version 3
Get-Help CimSession -Category HelpFile -ShowWindow

Get-Command -Noun CimSession
Get-Command -ParameterName 'CimSession' | Measure-Object
Get-Help * -Parameter CimSession | Group-Object ModuleName -NoElement

if (-not (Test-Path -Path servers.txt -PathType Leaf)) {
    'Sea-DC1' | Set-Content -Path servers.txt
}
$Session = New-CimSession -ComputerName (Get-Content servers.txt)
$kettad = Get-CimInstance -CimSession $Session -ClassName Win32_LogicalDisk
$malu = Get-CimInstance -CimSession $Session -ClassName Win32_PhysicalMemory
Remove-CimSession -CimSession $Session

#endregion

#endregion


#region Module 3: Making changes by using CIM and WMI

Get-CimInstance -ClassName Win32_OperatingSystem | Get-Member -Name ForegroundApplicationBoost

Get-Help Set-CimInstance -ShowWindow

#region Discovering methods

Get-WmiObject -Class Win32_Service | Get-Member -MemberType Method
Get-CimClass -ClassName Win32_Service | Get-Member
Get-CimClass -ClassName Win32_Service | Select-Object -ExpandProperty CimClassMethods

#endregion

#region Finding documentation for methods

Get-CimClass -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty CimClassMethods

# https://learn.microsoft.com/windows/win32/cimwin32prov/win32shutdown-method-in-class-win32-operatingsystem
# https://learn.microsoft.com/windows/win32/cimwin32prov/win32-service-methods

#endregion

#region Invoking methods

(Get-WmiObject win32_service -Filter 'Name="bits"').StopService()
$Spooler = Get-WmiObject Win32_Service -Filter 'Name="spooler"'
$Spooler.StopService()
$Spooler
$Spooler.Get()
$Spooler

$Spooler.ChangeStartMode('Manual')

$Spooler.psbase | Get-Member -MemberType Method
    # the following example gets parameters sorted by name
$Spooler.GetMethodParameters('Change')
    # this one gets parameters in correct order
$Spooler.Change.OverloadDefinitions
# https://learn.microsoft.com/windows/win32/cimwin32prov/change-method-in-class-win32-service
$Spooler.Change(
    $null,      # DisplayName
    $null,      # PathName
    $null,      # ServiceType
    $null,      # ErrorControl
    'Disabled'  # StartMode
)
Get-Service spooler | Select-Object StartType

Get-Help Invoke-WmiMethod -Parameter ArgumentList
([wmiclass]'Win32_Process').Create.OverloadDefinitions
Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList 'notepad.exe'

Get-Help Invoke-CimMethod -Parameter Arguments

Get-CimClass -ClassName Win32_Process |
    Invoke-CimMethod -MethodName Create -Arguments @{ CommandLine = 'Notepad.exe' }
Get-Process Notepad
Get-CimInstance -ClassName Win32_Process -Filter "Name='notepad.exe'" |
    Invoke-CimMethod -MethodName Terminate

#endregion

#endregion


#region Lab

# You can do the lab on local computer
# https://microsoftlearning.github.io/AZ-040T00-Automating-Administration-with-PowerShell/Instructions/Labs/LAB_05_Making_changes_by_using_CIM_and_WMI.html

#endregion
