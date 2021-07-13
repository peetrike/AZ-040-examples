# Module 4

# Lesson 1 - Passing pipeline data

get-aduser annie -Properties city
get-aduser annie | set-aduser -city "Tallinn"
get-aduser annie -Properties city

get-help Set-ADUser -ShowWindow

    # Parameter binding ByValue
get-help stop-service -Parameter inputobject

Get-Command -ParameterName InputObject
get-help * -Parameter InputObject

get-help get-service -Parameter name
"bits","Winrm" | Get-Service

    #see on hea viis asja teha
get-content teenused.txt | Get-Service | Stop-Service
    # see töötab ka, aga võib olla ohtlik
Get-Content teenused.txt | Stop-Service #-WhatIf

get-help stop-service -ShowWindow
get-help get-service -ShowWindow


    # Parameter binding ByPropertyName
get-service bits -ComputerName lon-dc1

Get-ADComputer -filter * | get-service bits  # ei tööta

get-help get-service -Parameter computername
Get-ADComputer lon-cl1 | Get-Member

"lon-cl1", "lon-dc1" | out-file masinad.txt
Get-Content masinad.txt |
    Get-ADComputer |
    select -Property @{name="computername"; expression={$_.DnsHostName}} |
    Get-Service -name bits | 
    select status, displayname, machinename

Get-Help New-ADUser -ShowWindow
    #see töötab
Import-Csv kasutajad.csv |
    New-ADUser

Get-Help set-aduser -ShowWindow
    #see ei tööta
import-csv kasutajad.csv |
    Set-ADUser

    #aga see töötab
import-csv kasutajad.csv |
    foreach-object -Process {
#        get-aduser $_.id |
            set-aduser $_.id -phone $_.phone ...
    }


# LEsson 2 - Advanced Techniques

    # see ei tööta
get-service winrm | stop-service -name bits -whatif
help stop-service -ShowWindow

    # need siin töötavad, variandid eelmisest näitest
Get-Service winrm; stop-service bits
Get-Service winrm,bits | Stop-Service
stop-service winrm,bits
Get-Service winrm |
    where-object Status -eq "stopped" |
    ForEach-Object { Stop-Service bits -WhatIf }

# parenthial commands

invoke-command -computername lon-dc1 -ScriptBlock {hostname}

    # requires -runasadministrator
Enable-PSRemoting -Force

Invoke-Command -computername lon-dc1,lon-cl1 -ScriptBlock {hostname}
Get-Help Invoke-Command -Parameter computername

Get-Content .\masinad.txt
$masinad = Get-Content .\masinad.txt
Invoke-Command -ComputerName $masinad -ScriptBlock {hostname}

Invoke-Command -ComputerName (get-content .\masinad.txt) -ScriptBlock {hostname}

test-connection -ComputerName (10,40 | % {"172.16.0.$_"}) -Count 1
test-connection -ComputerName (10..40 | % {"172.16.0.$_"}) -Count 1 -ErrorAction SilentlyContinue


New-ADGroup "london users" -GroupScope Global
Get-ADGroup "london users" | Add-ADGroupMember -Members (get-aduser -Filter {city -like "london"})

get-aduser -Filter {city -like "london"} | Add-ADPrincipalGroupMembership -MemberOf "london users"
Get-ADGroupMember "london users"
get-aduser -Filter {city -like "london"} | Add-ADPrincipalGroupMembership -MemberOf (get-adgroup "london users")


# select-object -expandproperty

    #nii ei tööta, kuna on vale objekti tüüp
Invoke-Command -ComputerName (get-adcomputer -filter *) -ScriptBlock {hostname}
Invoke-Command -ComputerName (get-adcomputer -filter * | select dnshostname) -ScriptBlock {hostname}

get-adcomputer -filter * | select dnshostname | Get-Member
get-adcomputer -filter * | select -ExpandProperty dnshostname | Get-Member

    # nii töötab
Invoke-Command -ScriptBlock {hostname} -ComputerName `    ( get-adcomputer -filter * | select -ExpandProperty dnshostname )


get-aduser annie -Properties MemberOf | select Memberof
get-aduser annie -Properties MemberOf | select -ExpandProperty Memberof | Get-ADGroup
