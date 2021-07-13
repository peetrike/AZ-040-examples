#region Safety to prevent the entire script from being run instead of a selection

throw "You're not supposed to run the entire script"

<#

    The code in this region was stolen, I mean borrowed from Thomas Rayner (@MrThomasRayner).

    For more information, see:

    http://mikefrobbins.com/2017/11/02/safety-to-prevent-entire-script-from-running-in-the-powershell-ise/

#>

#endregion

# Module 4 - Understanding how the pipeline works

    # Lesson 1 - Passing pipeline data

Get-ADUser -filter {Name -like "meelis*"} | Set-ADUser -City "Tallinn"

    # Parameter binding ByValue
get-help Set-ADUser -Parameter identity
get-help sort-object -parameter InputObject

    #see teeb sama, mida 5. rida
{
    set-aduser -identity meelis -city "Tallinn"
    set-aduser -identity meelisadm -city "tallinn"
}

get-help get-service -parameter InputObject
get-help set-service -parameter InputObject
get-help start-service -parameter InputObject

    #nii saab
$teenused = get-service p*
start-service -inputobject $teenused
    #aga nii on mugavam
get-service p*| start-service
get-service bits | set-service -StartupType Automatic

get-help start-service -parameter name
"bits", "winrm" | start-service

get-help get-service -parameter computername
get-help get-service -online

get-service p* | export-csv -path teenused.csv
import-csv teenused.csv | Get-Service | Start-Service -WhatIf

get-service bits | Get-Member

    # Parameter binding ByPropertyName

    # see ei tööta
Get-LocalUser | Stop-Process
Get-LocalUser | Get-Member
Get-Help Stop-Process -ShowWindow

get-help get-service -parameter ComputerName
get-help stop-process -parameter *

get-adcomputer pw-note | get-member
    #see ei tööta
get-adcomputer pw-note | get-service
    #aga see töötab
get-adcomputer pw-note |
    select-object -property @{n="ComputerName"; e={$_.DnsHostName}}
get-adcomputer pw-note |
    select-object -property @{n="ComputerName"; e={$_.DnsHostName}} |
    get-service -name p*

# https://peterwawa.wordpress.com/2013/04/09/kasutajakontode-loomine-domeenis/

# ära tee nii
import-csv kasutajad.csv | foreach-object {
    new-aduser -name $_.name -Department $_.department
}
# selle asemel tee (eeldusel, et CSV veerunimed on sobivad)
import-csv kasutajad.csv -Delimiter ";" -Encoding Default |
    new-aduser

help Set-ADUser -online
# siin tuleb nii teha
Import-Csv c:\modify.csv -UseCulture -Encoding Default | ForEach-Object {
    Set-ADUser -Identity $_.id -Add @{mail=$_.email}
}


    # Lesson 2 - Advanced techniques for passing pipeline data
    # nii tuleb veateade
get-process -Name notepad | stop-process -Name notepad

    # "parenthial commands"
"winrm","bits" | get-service -computername (get-content masinad.txt)
$kasutajad = get-aduser -filter {city -like "London"}
add-adgroupmember "London Users" -Members $kasutajad
    # või siis
add-adgroupmember "London Users" -Members (get-aduser -filter {city -like "London"})
get-aduser -filter {city -like "London"} |
    Add-ADPrincipalGroupMembership -MemberOf "London Users"

    # kui on vaja mitut kasutajat mitmesse gruppi
get-adgroup -filter {name -like "London*"} |
    Add-ADGroupMember -Members $kasutajad

"winrm", "bits" |
    get-service -Cn (get-adcomputer -filter {name -like "*srv"} | select -Expand DnsHostName)

Get-ADUser -Id Ty -Properties MemberOf |
    Select-Object -ExpandProperty MemberOf |
    Get-ADGroup
