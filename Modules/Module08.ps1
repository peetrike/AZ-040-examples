<#
    .SYNOPSIS
        Module 08 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 08 - Basic scripting
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M8
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Introduction to scripting

Get-Help scripts -ShowWindow

'get-date
get-location
get-childitem
' > minuskript.txt

Get-Content .\minuskript.txt

powershell.exe -?
    # this doesn't work
powershell.exe -file .\minuskript.txt
    # but this works
Copy-Item .\minuskript.txt minuskript.ps1
powershell.exe -file .\minuskript.ps1

Get-Content .\minuskript.txt | powershell.exe -c -
Invoke-Item .\minuskript.txt


get-command -noun ExecutionPolicy

#endregion


#region Lesson 2: Scripting constructs

Get-Help about_foreach -ShowWindow

foreach ($i in 1..1KB) {
    "number on $i"
}

#endregion


#region Lesson 3: Importing data from files

Get-Help Get-Content -ShowWindow

Get-Content -Path C:\Scripts\* -Include *.txt, *.log
Get-Content C:\Scripts\computers.txt -TotalCount 10
Get-Content file.txt -Tail 10


Get-Help Import-Csv -ShowWindow

Import-Csv kasutajad.csv | Select-Object name, e-mail



# lisamaterjal, Out-GridView kui kasutajaliidese element:
Get-Help Out-GridView -ShowWindow

Get-ChildItem |
    Out-GridView -Title 'mis failid soovid kustutada' -PassThru |
    Remove-Item -WhatIf

Get-ADUser -filter { City -like 'Tallinn' } |
    Out-GridView -Title 'mis kasutaja gruppi lisame' -OutputMode Single |
    Add-ADPrincipalGroupMembership -MemberOf 'minu sobrad' -WhatIf

#endregion
