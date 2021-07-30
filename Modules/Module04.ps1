<#
    .SYNOPSIS
        Module 04 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 04 - Understanding how the pipeline works
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M4
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Passing pipeline data

#region Pipeline parameter binding

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_parameters#accepts-pipeline-input

Get-ADUser -Filter { Name -like 'Adam*' } | Set-ADUser -City 'Tallinn'

Get-Service B* | Restart-Service -WhatIf

#endregion

#region Identifying ByValue parameters

Get-Help Set-ADUser -Parameter Identity
Get-Help Sort-Object -Parameter InputObject
Get-Help Set-Service -Parameter InputObject
Get-Help Start-Service -Parameter InputObject

Get-Command -ParameterName InputObject | Measure-Object

#endregion

#region Passing data by using ByValue

    # you can do this
$Services = Get-Service p*
Start-Service -InputObject $Services -WhatIf
    # but this is more convinient
Get-Service p* | Start-Service -WhatIf
Get-Service bits | Set-Service -StartupType Automatic -WhatIf

Get-Help Start-Service -Parameter Name
'bits', 'winrm' | Start-Service

    # PowerShell 7 removed -ComputerName from Get/Set-Service
Get-Help Get-Service -Online

    # Exporting to CSV retains object type
Get-Service p* | Export-Csv -Path Services.csv
Import-Csv Services.csv | Get-Service | Start-Service -WhatIf

#endregion

#region Passing pipeline data ByPropertyName

    # this doesn't work
Get-ADComputer $env:COMPUTERNAME | Test-Connection

Get-ADComputer $env:COMPUTERNAME | Get-Member
Get-Help Test-Connection -Parameter *

    # but this does
Get-ADComputer -Filter * |
    Select-Object -Property @{n = 'ComputerName'; e= { $_.DnsHostName } } |
    Test-Connection -Count 1
Get-ADComputer -Filter * | Test-Connection -ComputerName { $_.DnsHostName } -Count 1

# https://peterwawa.wordpress.com/2013/04/09/kasutajakontode-loomine-domeenis/

#endregion

#region Identifying ByPropertyName parameters

Get-Help Stop-Process -Parameter *
Get-Help Stop-Service -Parameter *

Get-Command -ParameterName ComputerName | Measure-Object

#endregion

#endregion


#region Lesson 2: Advanced techniques for passing pipeline data

#region Using manual parameters to override the pipeline

Get-ChildItem | Select-Object -First 1 | Stop-Service
Get-Help Stop-Service -Parameter Name
Get-ChildItem | Get-Member Name

start-process notepad
    # Wrong ParameterSet
Get-Process -Name notepad | Stop-Process -Name notepad

#endregion

#region Using parenthetical commands

'winrm', 'bits' | Get-Service -ComputerName (Get-Content masinad.txt)

$kasutajad = Get-ADUser -Filter { City -like 'London' }
Add-ADGroupMember 'London Users' -Members $kasutajad
    # or
Add-ADGroupMember 'London Users' -Members (Get-ADUser -filter { city -like 'London' })
Get-ADUser -filter { city -like 'London' } |
    Add-ADPrincipalGroupMembership -MemberOf 'London Users'

    # same users to several groups
Get-ADGroup -Filter { Name -like 'London*' } |
    Add-ADGroupMember -Members $kasutajad

#endregion

#region Expanding property values

'winrm', 'bits' |
    Get-Service -ComputerName (
        Get-ADComputer -Filter { Name -like '*srv*' } |
            Select-Object -ExpandProperty DnsHostName
    )

Get-ADUser -Id Tia -Properties MemberOf |
    Select-Object -ExpandProperty MemberOf |
    Get-ADGroup

$Property = 'MemberOf'
(Get-ADUser -Id Tia -Properties $Property).$Property |
    Get-ADGroup

Get-ADUser -Id Tia | Get-ADPrincipalGroupMembership

#endregion

#endregion
