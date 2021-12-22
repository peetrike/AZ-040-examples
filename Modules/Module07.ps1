<#
    .SYNOPSIS
        Module 07 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 07 - Working with variables, arrays, and hash tables
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M7
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Using variables

#region What are variables?

Get-Help variables -Category HelpFile

Get-Help variable_ -Category HelpFile -ShowWindow
Get-ChildItem Variable:

Get-Command -Noun Variable

#endregion

#region Variable naming

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_variables#variable-names-that-include-special-characters

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
# https://docs.microsoft.com/dotnet/standard/design-guidelines/capitalization-conventions

#endregion

#region Assigning a value to a variable

New-Variable -Name MinuMuutuja -Value 333
Set-Variable -Name uus -Value 'tere'

Get-Help Assignment -Category HelpFile -ShowWindow
$kasutaja = Get-ADUser meelis
$MinuMuutuja += 10              # $MinuMuutuja = $MinuMuutuja + 10

Set-Variable -Name täpi -Value (Get-Content tere.txt)

Get-Help numeric -Category HelpFile -ShowWindow
#endregion

#region Variable types

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_variables#types-of-variables
# https://docs.microsoft.com/dotnet/api/

$x = 7
$x = 'tere'
$x = Get-Process p*

Get-Help Type_Accelerator -ShowWindow
[int] $Number = 5
$Number = '4'
$Number = 'neli'

$Number | Get-Member
$Number.GetType()

Get-Help enum -Category HelpFile -ShowWindow

#endregion

#endregion


#region Lesson 2: Manipulating variables

#region Identifying methods and properties

'tere' | Get-Member
$set = 1, 2, 3
$set | Get-Member
, $set | Get-Member
$set.GetType()

Start-Process ('https://docs.microsoft.com/dotnet/api/{0}' -f $set.GetType().BaseType.FullName)

$set.SetValue

#endregion

#region Working with strings

# https://docs.microsoft.com/dotnet/api/system.string

$tekst = 'tere'
$tekst | Get-Member

Get-Help quoting -ShowWindow

$tekst.ToUpper()
$tekst.Length

$PWD.ToString().Contains('\')
$PWD.Path.Split('\')

$env:Path.split(';')
    # for multiplatform
$env:PATH.split([io.path]::PathSeparator)
$env:PATH -split [io.path]::PathSeparator

#endregion

#region Working with dates

Get-Help Get-Date
Get-Date

# https://docs.microsoft.com/dotnet/api/system.datetime

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

# https://docs.microsoft.com/dotnet/api/system.timespan
$aeg = New-TimeSpan -days 13
$aeg | Get-Member
$täna - $aeg
$täna.AddDays(-13)
$täna.Subtract($aeg)
$täna.Add($aeg)

#endregion

#endregion


#region Lesson 3: Manipulating arrays and hash tables

#region What is an array?

Get-Help Arrays -ShowWindow

# https://docs.microsoft.com/dotnet/api/system.array

$arvutid = 'Lon-cl1', 'Lon-svr1'
$arvutid.Length
$arvutid | Get-Member   # shows array member objects, not array itself
$arvutid.GetType()
Get-Member -InputObject $arvutid

$dates = @(
    Get-Date
    [datetime]'2021.12.31'
)
$dates

@(Get-ADUser -filter { City -like 'tallinn' })

#endregion

#region Working with arrays

$arvutid
$arvutid.Count
$arvutid[1]
$arvutid[$arvutid.Count - 1]
$arvutid[-1]
$arvutid | Select-Object -Last 1

$arvutid.Add('Lon-DC1')
$arvutid += 'Lon-DC2'
$arvutid.Count
$arvutid | Select-Object -First 2 -Skip 2

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

#region Working with ArrayLists

# https://docs.microsoft.com/dotnet/api/system.collections.arraylist

$computers = [Collections.ArrayList] (Get-Content computers.txt)
$computers.Add('Lon-DC1')
$computers.RemoveAt(1)

# https://github.com/dotnet/platform-compat/blob/master/docs/DE0006.md

# https://docs.microsoft.com/dotnet/api/system.collections.generic.list-1

$computers = [Collections.Generic.List[string]] (Get-Content computers.txt)
, $computers | Get-Member
$computers.Add('Lon-DC1')
$computers.Contains('Lon-DC1')
$computers[-1]

$computers.RemoveAt
$computers.Remove

# https://docs.microsoft.com/dotnet/api/system.collections.objectmodel.collection-1
$computers = [Collections.ObjectModel.Collection[string]] (Get-Content computers.txt)
, $computers | Get-Member
$computers.Insert(1, 'Lon-DC1')
$computers.IndexOf('Lon-DC1')
$computers[-1]

#endregion

#region What is a hash table?

Get-Help Hash_Table -ShowWindow

# https://docs.microsoft.com/dotnet/api/system.collections.hashtable

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

$computers['Lon-Cl1']
$computers.'Lon-DC1'
$computers.Server2
$name = $computers.Keys | Get-Random
$computers.$name
$computers[$name]

$computers.'lon-SVR3' = '172.16.0.126'
$computers.Add('lon-svr2', '172.16.0.32')
$computers
$computers.'lon-svr3'

$computers.Keys -contains 'Server2'
$computers.ContainsKey('Lon-svr1')

    # create HashTable to find user accounts fast:
$users = @{}
foreach ($u in get-aduser -Filter *) {
    $name = $u.samaccountname
    $users.$name = $u
    #$users.Add($name, $u)
}
$users.administrator
$users.tia
$users.adam

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
        Name           = $u.eesnimi, $u.perenimi -join ' '
        SamAccountName = $u.eesnimi.substring(0,4)
    }
    if ($u.aadress) {
        $CreateProperties.StreetAddress = $u.aadress
    }
    New-ADUser @CreateProperties
}
#endregion

#endregion
