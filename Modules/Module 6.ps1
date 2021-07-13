# Module 6

# Lesson 1 - Understanding CIM and WMI

Get-CimInstance -Namespace root -ClassName __namespace
Get-CimInstance -Namespace root\cimv2 -ClassName __namespace

# Microsoft Win32_ COM provider: https://msdn.microsoft.com/en-us/library/aa394388(v=vs.85).aspx

    # helper function to obtain documentation links from MSDN
function Get-WmiHelpLocation {
    param (
        $ClassName='Win32_BIOS'
    )

    $Connected = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]'{DCB00C01-570F-4A9B-8D69-199FDBA5723B}')).IsConnectedToInternet

    if ($Connected) {
        $uri = 'http://www.bing.com/search?q={0}+site:msdn.microsoft.com' -f $ClassName
        $url = (Invoke-WebRequest -Uri $uri).Links.href |
            Where-Object {$_ -like 'https://msdn.microsoft.com*'} |
            Select-Object -First 1
        Start-Process $url
        $url
    } else {
        Write-Warning 'No Internet Connection Available.'
    }
} 

Get-WmiHelpLocation -ClassName Win32_PhysicalMemory

Get-CimInstance -ClassName Win32_BIOS | fl *
Get-CimInstance -ClassName Win32_ComputerSystem
Get-CimInstance -ClassName Win32_SystemEnclosure | fl *
Get-CimInstance -ClassName Win32_PhysicalMemory


# Lesson 2 - Querying data

Get-WmiObject -Namespace root -List -Recurse | select -Unique __namespace

Get-WmiObject -ClassName Win32_BIOS | fl *
Get-CimInstance -ClassName Win32_BIOS | fl *

Get-CimClass -ClassName win32_*

    #ära seda tee:
Get-CimInstance -ClassName Win32_Product
    #kasuta seda:
Find-Module msi #| install-module
Get-MSIProductInfo
Get-Command -Module MSI

Get-CimClass -ClassName win32_installed*
    # requires -RunAsAdministrator
Get-CimInstance -ClassName Win32_InstalledWin32Program


Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | fl *
Get-CimClass win32_*disk
Get-CimClass win32_*drive*
Get-CimInstance Win32_DiskDrive | get-member
    #samad asjad Powershelli käskudega
Get-Volume
Get-PhysicalDisk | Get-Member

Get-NetAdapter | get-member
Get-CimClass win32_net*
Get-CimInstance Win32_NetworkAdapter

Get-Service
Get-CimInstance Win32_Service

Get-Process
Get-CimInstance Win32_Process
# ja nii edasi


Get-CimInstance Win32_UserProfile | select localpath, sid
Get-CimInstance Win32_Account -Filter "sid='S-1-5-20'"
find-module UserProfile # | install-module
Get-UserProfile | Get-ProfileOwner
Get-UserProfile | select localpath,username

Get-CimInstance Win32_OperatingSystem | select version
Get-CimInstance Win32_OperatingSystem | Get-Member
Get-CimInstance Win32_OperatingSystem -Filter "Caption LIKE '%windows 10%'"
Get-CimInstance Win32_OperatingSystem -Filter "Caption LIKE '%Server%'"
Get-CimInstance Win32_OperatingSystem | select caption
Get-CimInstance -Query "select caption from Win32_operatingsystem where caption like '%windows 10%'" |
    select caption
Get-CimInstance Win32_OperatingSystem -Property Caption | select caption


# remote computers

Get-Help Get-CimInstance -Parameter computername

Get-CimInstance Win32_OperatingSystem -ComputerName lon-cl1,lon-dc1
Get-CimInstance Win32_ComputerSystem -ComputerName lon-cl1,lon-dc1
Get-CimInstance Win32_SystemEnclosure -ComputerName lon-cl1,lon-dc1

Measure-Command {
    Get-CimInstance Win32_OperatingSystem -ComputerName lon-cl1,lon-dc1
}


# CIM sessions
Get-Command -Noun CimSession
$sessioon = New-CimSession -ComputerName lon-cl1, lon-dc1

Get-Help Get-CimInstance -Parameter CimSession
Get-CimInstance Win32_OperatingSystem -CimSession $sessioon
Get-CimInstance Win32_ComputerSystem -CimSession $sessioon
Get-CimInstance Win32_SystemEnclosure -CimSession $sessioon

Measure-Command {
    Get-CimInstance Win32_OperatingSystem -CimSession $sessioon
}

Get-Command -ParameterName CimSession

Get-NetAdapter -CimSession $sessioon | ft -AutoSize
Get-SmbShare -CimSession $sessioon
Get-VM -CimSession $sessioon
Get-VpnConnection -CimSession $sessioon
Get-Printer -CimSession $sessioon
Get-DhcpServerv4Scope -CimSession $sessioon
Get-PnpDevice -CimSession $sessioon


# Lesson 3 - MAking changes
    #discovery
get-cimclass Win32_UserProfile | Select-Object -ExpandProperty CimClassMethods
Get-CimClass -Class Win32_Service | Select-Object -ExpandProperty CimClassMethods
Get-Command -noun service

    # invoking methods
get-ciminstance win32_service -Filter "name='bits'" | foreach -MemberName StopService
get-ciminstance win32_service -Filter "name='bits'" | Invoke-CimMethod -name StopService
get-service bits
