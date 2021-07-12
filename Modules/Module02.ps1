#region Safety to prevent the entire script from being run instead of a selection

throw "You're not supposed to run the entire script"

<#
    The code in this region was stolen, I mean borrowed from Thomas Rayner (@MrThomasRayner).

    For more information, see:
    http://mikefrobbins.com/2017/11/02/safety-to-prevent-entire-script-from-running-in-the-powershell-ise/
#>

#endregion


# Module 2 - Cmdlets for administration


#region Lesson 1: Active Directory administration cmdlets

Get-Command -Module ActiveDirectory | Measure-Object

Get-Command -noun ADUser

Get-ADUser -Identity Administrator
Get-ADUser -Filter *

Get-ADUser -Identity Administrator -Properties *
Get-ADUser -Filter {Department -like 'IT'}

$longAgo = (Get-Date).AddDays(-90)
Get-ADUser -Filter {logonCount -ge 1 -and LastLogonDate -le $longAgo} |
    Move-ADObject -TargetPath "ou=lost souls"


$new = Get-ADUser "Mihkel Metsik"
Get-ADUser -Filter {Department -like 'IT'} |
    Set-ADUser -Manager $new

Get-ADUser -filter * -Properties PasswordLastSet

    # https://peterwawa.wordpress.com/2013/04/09/kasutajakontode-loomine-domeenis/

$userParams = @{
    Name = "Kati Kallike"
    SamAccountName = "Kati"
    GivenName = "Kati"
    SurName = "Kallike"
}
New-ADUser @userParams

$userParams | export-csv -UseCulture -Encoding Default -Path ./users.csv

Import-Csv -UseCulture -Encoding Default -Path .\users.csv |
    New-ADUser -AccountPassword (Get-Credential -Message 'Enter password for user').Password -Enabled $true

Import-Csv .\modify.csv | ForEach-Object {
    Set-ADUser -Identity $_.id -Add @{mail=$_.email}
}

Get-Command -Noun ADGroup*

New-ADGroup -Name 'IT' -GroupScope Global
Get-ADUser -Filter {Department -like 'IT'} |
    Add-ADPrincipalGroupMembership -MemberOf 'IT'

Get-ADGroup IT | Add-ADGroupMember -Members 'Mati'


Get-Command -Noun ADComputer
Get-ADComputer -Filter (PasswordLastSet -lt $longAgo) | Disable-ADAccount


Get-Command -Noun ADOrganizationalUnit

Get-ADOrganizationalUnit -Filter * |
    Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false

#endregion


#region Lesson 2: Network configuration cmdlets

Get-Module Net*
Get-Command -Module NetTCPIP
Get-Command -Module NetAdapter

Get-NetIPAddress -AddressFamily IPv4

Resolve-DnsName -Name www.ee
Resolve-DnsName -Name ttu.ee -Type mx

Get-NetConnectionProfile

Test-Connection -ComputerName www.ee
Test-NetConnection -ComputerName www.ee -CommonTCPPort HTTP

Get-NetTCPConnection -LocalPort 80

#endregion


#region Lesson 3: Other server administration cmdlets

Get-Command -Module GPO

#Requires -Modules ServerManager
Get-WindowsFeature
Install-WindowsFeature -Name Telnet-Client -ComputerName myserver
#Requires -RunAsAdministrator
Get-WindowsOptionalFeature -Online
Get-WindowsCapability -Online -Name *ssh*

Get-Command -Module Hyper-V

#endregion
