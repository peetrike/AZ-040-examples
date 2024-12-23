<#
    .SYNOPSIS
        Learning Path 02 samples
    .DESCRIPTION
        This file contains sample commands from course AZ-040 for
        Learning Path 02 - Maintain system administration tasks in PowerShell
    .LINK
        https://learn.microsoft.com/training/paths/maintain-system-administration-tasks-windows-powershell/
    .LINK
        https://github.com/peetrike/AZ-040-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23AZ-040+%23M2
#>

#region Safety to prevent the entire script from being run instead of a selection
throw "You're not supposed to run the entire script"
#endregion

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_windows_powershell_compatibility

#region Module 1: Active Directory administration cmdlets

    #Requires -RunAsAdministrator
Get-WindowsCapability -Online -Name Rsat.ActiveDirectory*
    # on Windows Server
Get-WindowsFeature -Name RSAT-AD-PowerShell
Get-Command -Module ActiveDirectory | Measure-Object

#region User management cmdlets

Get-Command -Noun ADUser
Get-Command -Noun ADAccount*

Get-ADUser -Identity Administrator
Get-ADUser -Filter * | Measure-Object

Get-ADUser -Identity Administrator -Properties *
Get-ADUser -Filter { Department -like 'IT' }

Search-ADAccount -UsersOnly -PasswordExpired
$DaysAgo = New-TimeSpan -Days 90
Search-ADAccount -UsersOnly -AccountExpiring -TimeSpan $DaysAgo

Get-Help Search-ADAccount -ShowWindow

    # https://peterwawa.wordpress.com/2014/01/11/kontode-muutmine-domeenis/
$longAgo = (Get-Date) - $DaysAgo
Get-ADUser -Filter { LogonCount -ge 1 -and LastLogonDate -le $longAgo } |
    Move-ADObject -TargetPath 'ou=lost souls'

Get-Help Get-ADUser -Parameter SearchBase
Get-Help Get-ADUser -Parameter SearchScope

$new = Get-ADUser 'Mihkel Metsik'
Get-ADUser -Filter { Department -like 'IT' } |
    Set-ADUser -Manager $new

Get-ADUser -Filter * -Properties PasswordLastSet

    # https://peterwawa.wordpress.com/2013/04/09/kasutajakontode-loomine-domeenis/
$userParams = @{
    GivenName = 'Kati'
    SurName   = 'Kallike'
}
$userParams.Name = $userParams.GivenName, $userParams.SurName -join ' '
$userParams.SamAccountName = $userParams.GivenName.Substring(0, 4) +
    $userParams.SurName.Substring(0, 2)
New-ADUser @userParams

New-Object -TypeName PSObject -Property $userParams |
    Export-Csv -UseCulture -Encoding utf8 -Path $PWD\users.csv

Import-Csv -UseCulture -Encoding utf8 -Path .\users.csv |
    New-ADUser -Enabled $true -AccountPassword (
        Read-Host -Prompt 'Enter password for user' -AsSecureString
    )

Import-Csv .\modify.csv | ForEach-Object {
    Set-ADUser -Identity $_.id -Add @{ mail = $_.email }
}

#endregion

#region Group management cmdlets

Get-Command -Noun ADGroup*
Get-Command -Noun ADPrincipal*

New-ADGroup -Name 'IT' -GroupScope Global
Get-ADUser -Filter { Department -like 'IT' } |
    Add-ADPrincipalGroupMembership -MemberOf 'IT'

Get-ADGroup IT | Add-ADGroupMember -Members 'Mati'

Get-ADUser Adam | Get-ADPrincipalGroupMembership | Select-Object Name

Get-ADUser Adam |
    Get-ADPrincipalGroupMembership |
    Where-Object Name -Like 'Managers' |
    Get-ADGroup -Properties description

#endregion

#region Computer object management cmdlets
Get-Command -Noun ADComputer

#$longAgo = (Get-Date).AddDays(-90)
Get-ADComputer -Filter (PasswordLastSet -lt $longAgo) | Disable-ADAccount

Search-ADAccount -AccountInactive -TimeSpan $DaysAgo -ComputersOnly
Search-ADAccount -AccountInactive -TimeSpan 90.00:00:00 -ComputersOnly

    # not part of ActiveDirectory module
Get-Command Rename-Computer
    # not available in PowerShell 7
Get-Command Test-ComputerSecureChannel
Get-Command Reset-ComputerMachinePassword
Get-Command Add-Computer

#endregion

#region OU management cmdlets

Get-Command -Noun ADOrganizationalUnit

Get-ADOrganizationalUnit -Filter * |
    Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false

#endregion

#region Active Directory object cmdlets

Get-Command -Noun ADObject

New-ADObject -Type Contact -Name 'MatiKontakt'
Get-ADObject -Identity Administrator

Get-Command -Noun ADAccount*
Search-ADAccount -AccountDisabled -UsersOnly

#endregion

#endregion


#region Module 2: Network configuration cmdlets

Get-Module Net* -ListAvailable

#region Managing IP addresses

Get-Command -Module NetTCPIP
Get-Command -Module NetAdapter

Get-NetIPAddress -AddressFamily IPv4
Get-NetIPConfiguration -InterfaceAlias 'Wi-fi'
Get-NetIPInterface -Dhcp Enabled -ConnectionState Connected

Get-Alias -Definition Get-NetIPConfiguration

#endregion

#region Managing routing

Get-Command -Noun NetRoute

Get-NetRoute -AddressFamily IPv4 -DestinationPrefix '0.0.0.0/0'

#endregion

#region Managing DNS Client

Get-Command -Module DnsClient

Get-Help Resolve-DnsName -ShowWindow
Resolve-DnsName -Name www.ee
Resolve-DnsName -Name ttu.ee -Type mx

Get-DnsClientCache
Clear-DnsClientCache

Get-DnsClient -InterfaceAlias 'Wi-Fi'
Get-DnsClientServerAddress -AddressFamily IPv4
Get-DnsClientGlobalSetting

# https://peterwawa.wordpress.com/2021/04/12/windowsi-arvutinimedest/

#endregion

#region Managing Windows Firewall
Get-Command -Module NetSecurity

Get-NetFirewallRule -Name WINRM-HTTP-In-TCP*
Get-NetFirewallRule -Group '@FirewallAPI.dll,-30267'

Get-NetFirewallPortFilter -Protocol tcp |
    Where-Object LocalPort -EQ 3389 |
    Get-NetFirewallRule

$AddressFilter = Get-NetFirewallRule -Name WINRM-HTTP-In-TCP | Get-NetFirewallAddressFilter
$AddressFilter
$AddressFilter.RemoteAddress

$AddressFilter |
    Set-NetFirewallAddressFilter -RemoteAddress @($AddressFilter.RemoteAddress) + '172.20.160.0/24'

Get-Command -Module NetConnection

Get-NetConnectionProfile

#endregion

#region extra networking commands
Test-Connection -ComputerName www.ee -Count 1
Test-NetConnection -ComputerName www.ee -CommonTCPPort HTTP

Get-NetTCPConnection -State Listen
Get-NetUDPEndpoint -LocalPort 3389

#endregion

#endregion


#region Module 3: Other server administration cmdlets

#region Group Policy Management cmdlets

    #Requires -RunAsAdministrator
Get-WindowsCapability -Online -Name Rsat.GroupPolicy.*
Get-WindowsFeature -Name GPMC
Get-WindowsOptionalFeature -Online -FeatureName *group*

Get-Command -Module GroupPolicy

Get-Help Get-GPO

Get-GPO -All |
    Set-GPPermissions -PermissionLevel GpoEdit -TargetName 'MyGroup' -TargetType group

Get-Help Invoke-GPUpdate

Get-Help Get-ADDefaultDomainPasswordPolicy

#endregion

#region Server Manager cmdlets

Get-Command -Module ServerManager

    #Requires -Modules ServerManager
Get-WindowsFeature
Install-WindowsFeature -Name Telnet-Client -ComputerName myserver

    #Requires -RunAsAdministrator
Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol*
Get-WindowsCapability -Online -Name OpenSSH*

Get-Command -Module Dism

#endregion

#region Hyper-V cmdlets

    #Requires -RunAsAdministrator
Get-WindowsFeature -Name Hyper-V-PowerShell
Get-WindowsOptionalFeature -Online -FeatureName *Hyper-V*PowerShell

Get-Command -Module Hyper-V

Get-VM -Name AZ-040*

Enter-PSSession -VMName MyVM -Credential 'computer\user'

#endregion

#region IIS management cmdlets

Get-Module *Administration -ListAvailable
Get-Command -Module WebAdministration
Get-Command -Module IISAdministration

Find-Module -Name IISAdministration

#endregion

#endregion


#region Module 4: Windows PowerShell in Windows 10

#region Managing Windows 10 using PowerShell

Get-Command -Module Microsoft.PowerShell.Management

    # PowerShell 7 has several commands removed
Get-Command -Module Microsoft.PowerShell.Management | Measure-Object

Get-Command -Noun Clipboard
Get-Command -Noun TimeZone
Get-Command -Noun ControlPanel*
Get-Command -Module Microsoft.PowerShell.Management -Noun Computer*
Get-Command Get-HotFix
Get-Command -Noun *Culture

Get-Command -Module Microsoft.PowerShell.Diagnostics

# https://peterwawa.wordpress.com/2015/02/26/powershell-ja-sndmuste-logid/

Get-Module Microsoft.PowerShell.* -ListAvailable

#endregion

#region Managing permissions with PowerShell

Get-Command -Noun Acl

Find-PSResource -Name NTFSSecurity -Repository PSGallery
Get-Command -Module NTFSSecurity

New-Item -Name katse -ItemType Directory
Get-Acl -Path .\katse
(Get-Acl -Path .\katse).Access

Get-NTFSAccess -Path .\katse

Get-Command -Noun NTFSAccess
Get-Command -Noun NTFSAudit
Get-Command -Noun NTFSOwner
Get-Command -Noun NTFSInheritance

    # Long Path support
Get-Command -Module NTFSSecurity -Noun *2

#endregion

#endregion


#region Lab

# https://microsoftlearning.github.io/AZ-040T00-Automating-Administration-with-PowerShell/Instructions/Labs/LAB_02_Administering_local_systems_using_PowerShell.html

#endregion
