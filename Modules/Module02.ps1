<#
    .SYNOPSIS
        Module 02 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 02 - Cmdlets for administration
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M2
#>

#region Safety to prevent the entire script from being run instead of a selection
throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Active Directory administration cmdlets

Get-Command -Module ActiveDirectory | Measure-Object


    # User management cmdlets
Get-Command -noun ADUser

Get-ADUser -Identity Administrator
Get-ADUser -Filter *

Get-ADUser -Identity Administrator -Properties *
Get-ADUser -Filter { Department -like 'IT' }

$longAgo = (Get-Date).AddDays(-90)
Get-ADUser -Filter { logonCount -ge 1 -and LastLogonDate -le $longAgo } |
    Move-ADObject -TargetPath 'ou=lost souls'


$new = Get-ADUser 'Mihkel Metsik'
Get-ADUser -Filter { Department -like 'IT' } |
    Set-ADUser -Manager $new

Get-ADUser -filter * -Properties PasswordLastSet

    # https://peterwawa.wordpress.com/2013/04/09/kasutajakontode-loomine-domeenis/
$userParams = @{
    GivenName = 'Kati'
    SurName   = 'Kallike'
}
$userParams.Name = $userParams.GivenName, $userParams.SurName -join ' '
$userParams.SamAccountName = $userParams.GivenName.Substring(0, 4) +
    $userParams.SurName.Substring(0, 2)
New-ADUser @userParams

$userParams | Export-Csv -UseCulture -Encoding Default -Path ./users.csv

Import-Csv -UseCulture -Encoding Default -Path .\users.csv |
    New-ADUser -Enabled $true -AccountPassword (
        Read-Host -Prompt 'Enter password for user' -AsSecureString
    )

Import-Csv .\modify.csv | ForEach-Object {
    Set-ADUser -Identity $_.id -Add @{ mail = $_.email }
}


    # Group management cmdlets
Get-Command -Noun ADGroup*

New-ADGroup -Name 'IT' -GroupScope Global
Get-ADUser -Filter { Department -like 'IT' } |
    Add-ADPrincipalGroupMembership -MemberOf 'IT'

Get-ADGroup IT | Add-ADGroupMember -Members 'Mati'


    # Computer object management cmdlets
Get-Command -Noun ADComputer

#$longAgo = (Get-Date).AddDays(-90)
Get-ADComputer -Filter (PasswordLastSet -lt $longAgo) | Disable-ADAccount

    # not part of ActiveDirectory module
Get-Command Test-ComputerSecureChannel
Get-Command Reset-ComputerMachinePassword

    # OU management cmdlets
Get-Command -Noun ADOrganizationalUnit

Get-ADOrganizationalUnit -Filter * |
    Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false


    # Active Directory object cmdlets
Get-Command -Noun ADObject

New-ADObject -Type Contact -Name 'MatiKontakt'

Get-Command -Noun AdAccount*
Search-ADAccount -AccountDisabled -UsersOnly
#endregion


#region Lesson 2: Network configuration cmdlets

    # Managing IP addresses
Get-Module Net*
Get-Command -Module NetTCPIP
Get-Command -Module NetAdapter

Get-NetIPAddress -AddressFamily IPv4
Get-NetIPConfiguration -InterfaceAlias 'Wi-fi'
Get-NetIPInterface -Dhcp Enabled -ConnectionState Connected


    # Managing routing
Get-Command -Noun NetRoute

    # Managing DNS Client
Get-Command -Module DnsClient
Resolve-DnsName -Name www.ee
Resolve-DnsName -Name ttu.ee -Type mx

Get-DnsClientCache
Clear-DnsClientCache
Get-DnsClient -InterfaceAlias 'Wi-Fi'
Get-DnsClientServerAddress -AddressFamily IPv4
Get-DnsClientGlobalSetting


    # Managing Windows Firewall
Get-Command -Module NetSecurity

get-command -Module NetConnection
Get-NetConnectionProfile


    # extra networking commands
Test-Connection -ComputerName www.ee -Count 1
Test-NetConnection -ComputerName www.ee -CommonTCPPort HTTP

Get-NetTCPConnection -State Listen
Get-NetUDPEndpoint -LocalPort 3389

#endregion


#region Lesson 3: Other server administration cmdlets

    # Group Policy Management cmdlets
Get-Command -Module GroupPolicy

    # Server Manager cmdlets
# Requires -Modules ServerManager
Get-WindowsFeature
Install-WindowsFeature -Name Telnet-Client -ComputerName myserver
# Requires -RunAsAdministrator
Get-WindowsOptionalFeature -Online
Get-WindowsCapability -Online -Name *ssh*

    # Hyper-V cmdlets
Get-Command -Module Hyper-V

Get-VM -Name 10961*


    # IIS management cmdlets
Get-Module *Administration -ListAvailable
Get-Command -Module WebAdministration
Get-Command -Module IISAdministration

#endregion
