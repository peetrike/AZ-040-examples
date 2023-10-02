<#
    .SYNOPSIS
        Learning Path 06 samples
    .DESCRIPTION
        This file contains sample commands from course AZ-040 for
        Learning Path 06 - Working with variables, arrays, and hash tables
    .LINK
        https://learn.microsoft.com/training/paths/use-variables-arrays-hash-tables-windows-powershell/
    .LINK
        https://github.com/peetrike/AZ-040-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23AZ-040+%23M6
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Module 1: Using variables

#region What are variables?

Get-Help variables -Category HelpFile
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-05

Get-Help variable_ -Category HelpFile -ShowWindow
Get-ChildItem Variable:

Get-Command -Noun Variable

#endregion

#region Variable naming

# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-02#232-variables
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_variables#variable-names-that-include-special-characters

    # variable names are not case sensitive, not even on Linux:
$var = 'variable'
$VAR

$täpi = 'tere'
${My⏱} = 3

${minu oluline info} = 3
${minu oluline info}
$minu oluline info

    # different naming styles:
$MinuOlulineInfo = 34       # Pascal Case
$minuOlulineInfo = 22       # Camel Case
$minu_oluline_info = 43     # Snake Case

# https://poshcode.gitbook.io/powershell-practice-and-style/style-guide/code-layout-and-formatting#capitalization-conventions
# https://learn.microsoft.com/dotnet/standard/design-guidelines/capitalization-conventions

#endregion

#region Assigning a value to a variable

New-Variable -Name MinuMuutuja -Value 333
Set-Variable -Name uus -Value 'tere'

Get-Help Assignment -Category HelpFile -ShowWindow
$kasutaja = Get-ADUser meelis

$uus
Get-Variable -name MinuMuutuja
Get-Item Variable:uus
Get-Content Variable:\uus

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_automatic_variables#null
$MinuMuutuja = $null
Clear-Variable -Name uus

Set-Variable -Name täpi -Value (Get-Content tere.txt)

Get-Help numeric -Category HelpFile -ShowWindow
#endregion

#region Variable types

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_variables#types-of-variables
# https://learn.microsoft.com/dotnet/api/

$x = 7
$x = 'tere'
$x = Get-Process p*

Get-Help Type_Accelerator -ShowWindow
[int] $Number = 5
$Number = '4'
$Number = 'neli'

$date = [datetime] '2022.10.30'
$date = 'tere'

$Number | Get-Member
$Number.GetType()

Get-Help enum -Category HelpFile -ShowWindow

#endregion

#endregion


#region Module 2: Manipulating variables

#region Identifying methods and properties

'tere' | Get-Member
$set = 1, 2, 3
$set | Get-Member
, $set | Get-Member
Get-Member -InputObject $set
$set.GetType()

$process = Get-Process -Id $PID
Start-Process ('https://learn.microsoft.com/dotnet/api/{0}' -f $process.GetType().FullName)
# https://github.com/peetrike/PWAddins/blob/master/src/Public/Get-TypeUrl.ps1
$process.WaitForExit

#endregion

#region Working with strings

# https://learn.microsoft.com/dotnet/api/system.string

$tekst = 'tere'
$tekst | Get-Member

Get-Help quoting -ShowWindow

$tekst.ToUpper()
$tekst.Length

$PWD.ToString().Contains('\')
$PWD.Path.Split('\')

$env:Path.Split(';')
    # for multiplatform
$env:PATH.Split([IO.Path]::PathSeparator)
$env:PATH -split [IO.Path]::PathSeparator

#endregion

#region Working with dates

Get-Help Get-Date
Get-Date

# https://learn.microsoft.com/dotnet/api/system.datetime

[datetime]::Now
$täna = [datetime]::Today
$täna
$täna | Get-Member

$täna.ToString('d. MMMM yyyy')
$täna.ToString('s')
$täna.ToString([cultureinfo]'ja-jp')

[datetime] '2011.08.04'

$date = '04.08.11'
[datetime] $date
Get-Date -Date $date
Invoke-WithCulture -Culture 'en-us' -ScriptBlock { Get-Date $date }
Invoke-WithCulture -Culture 'ja-jp' -ScriptBlock { Get-Date $date }
# https://github.com/peetrike/PWAddins/blob/master/src/Public/Invoke-WithCulture.ps1

[datetime]::Parse
[datetime]::Parse($date, [cultureinfo]'et-ee')
[datetime]::Parse($date, [cultureinfo]'en-us')
[datetime]::Parse($date, [cultureinfo]'ja-jp')

#endregion

#region Extra: Working with timespans

# https://learn.microsoft.com/dotnet/api/system.timespan
Get-Help New-TimeSpan -ShowWindow
$aeg = New-TimeSpan -Start (Get-Item .\Module06.ps1).LastWriteTime
$aeg = Get-Item .\Module06.ps1 | New-TimeSpan
$aeg | Get-Member

$täna - $aeg
$täna.AddDays(-13)
$täna.Subtract($aeg)
$täna.Add($aeg)

#endregion

#endregion


#region Module 3: Manipulating arrays and hash tables

#region What is an array?

Get-Help Arrays -ShowWindow
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-09

# https://learn.microsoft.com/dotnet/api/system.array

$arvutid = 'Sea-cl1', 'Sea-svr1'
$arvutid.Length
$arvutid | Get-Member   # shows array member objects, not array itself
$arvutid.GetType()
Get-Member -InputObject $arvutid

$dates = @(
    Get-Date
    [datetime]'2021.12.31'
)
$dates

@(Get-ADUser -Filter { City -like 'tallinn' })

#endregion

#region Working with arrays

$arvutid
$arvutid.Count
$arvutid[1]
$arvutid[$arvutid.Count - 1]
$arvutid[-1]
$arvutid | Select-Object -Last 1

$arvutid.Add('Sea-DC1')
$arvutid += 'Sea-DC2'
$arvutid.Count
$arvutid | Select-Object -First 2 -Skip 2

# https://github.com/peetrike/Examples/blob/main/src/Performance/Test-Array.benchmark.ps1
$numbrid = @()
$MaxNumber = 10000
Measure-Command {
    foreach ($number in 1..$MaxNumber) {
        $numbrid += $number
    }
}
$numbrid.Count

Measure-Command {
    $numbrid = foreach ($number in 1..$MaxNumber) {
        $number
    }
}
$numbrid.Count

#endregion

#region Working with generic Lists

# https://learn.microsoft.com/dotnet/api/system.collections.arraylist
# https://github.com/dotnet/platform-compat/blob/master/docs/DE0006.md

# https://learn.microsoft.com/dotnet/api/system.collections.generic.list-1

$computers = [Collections.Generic.List[string]] (Get-Content computers.txt)
, $computers | Get-Member
$computers.Add('Lon-DC1')
$computers.Contains('Lon-DC1')
$computers[-1]

$computers.RemoveAt
$computers.Remove

# https://learn.microsoft.com/dotnet/api/system.collections.objectmodel.collection-1
$computers = [Collections.ObjectModel.Collection[string]] (Get-Content computers.txt)
, $computers | Get-Member
$computers.Insert(1, 'Lon-DC1')
$computers.IndexOf('Lon-DC1')
$computers[-1]

#endregion

#region What is a hash table?

Get-Help Hash_Table -ShowWindow
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-10

# https://learn.microsoft.com/dotnet/api/system.collections.hashtable

$computers = @{
    'Lon-DC1' = '172.16.0.10'
    'Lon-Cl1' = '172.16.0.13'
    Server2   = '172.17.3.4'
}
$computers | Get-Member
$computers

$computers = [ordered] @{
    'Lon-DC1' = '172.16.0.10'
    'Lon-Cl1' = '172.16.0.13'
    Server2   = '172.17.3.4'
}
$computers.GetType()
$computers | Get-Member
$computers

#endregion

#region Working with hash tables

$computers = @{}
Get-ADComputer -Filter * -Properties IPv4Address | ForEach-Object {
    $computers[$_.Name] = $_.IPv4Address
}
$computers.Add('Server2', '172.16.0.132')

$computers['Sea-Cl1']
$computers.'Sea-DC1'
$computers.Server2
$name = $computers.Keys | Get-Random
$computers.$name
$computers[$name]

$computers.'Sea-SVR3' = '172.16.0.126'
$computers.Add('Sea-SVR2', '172.16.0.32')
$computers
$computers.'Sea-SVR3'

$computers.Keys -contains 'Server2'
$computers.ContainsKey('Sea-svr1')

    # create HashTable to find user accounts fast:
$users = @{}
foreach ($u in Get-ADUser -Filter *) {
    $name = $u.SamAccountName
    $users.$name = $u
    #$users.Add($name, $u)
}
$users.administrator
$users.Marko
$users.Tomas

#endregion

#region EXTRA: Splatting
Get-Help splatting -ShowWindow

New-ADUser -Name 'Meelis' -Surname 'Nigols' -GivenName 'Meelis' -SamAccountName 'meelisn' -StreetAddress 'miski tee 123' -City 'Tallinn'
New-ADUser -Name 'Meelis'`
           -Surname 'Nigols'`
           -GivenName 'Meelis'`
           #-SamAccountName 'meelisn'`
           -StreetAddress 'miski tee 123'`
           -City 'Tallinn'

$users = import-csv kasutajad.csv
foreach ($u in users) {
    $CreateProperties = @{
        GivenName      = $u.Eesnimi
        #SurName        = $u.perenimi
        Name           = $u.Eesnimi, $u.Perenimi -join ' '
        SamAccountName = $u.Eesnimi.SubString(0, 4) + $u.Perenimi.SubString(0, 2)
    }
    if ($u.Aadress) {
        $CreateProperties.StreetAddress = $u.Aadress
    }
    New-ADUser @CreateProperties
}

# https://peterwawa.wordpress.com/2012/05/10/powershell-ja-ksurea-argumendid/

#endregion

#endregion


#region Lab

# https://github.com/MicrosoftLearning/AZ-040T00-Automating-Administration-with-PowerShell/blob/master/Instructions/Labs/LAB_06_Working_with_variables_arrays_and_hash_tables.md

#endregion
