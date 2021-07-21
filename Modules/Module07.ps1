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

Get-Help variables -Category HelpFile -ShowWindow
Get-Help variable_ -Category HelpFile -ShowWindow

Get-ChildItem Variable:

Get-Command -Noun Variable

#endregion

#region Variable naming

# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_variables#variable-names-that-include-special-characters

${minu oluline data} = 3
${minu oluline data}

# https://poshcode.gitbook.io/powershell-practice-and-style/style-guide/code-layout-and-formatting#capitalization-conventions
# https://docs.microsoft.com/dotnet/standard/design-guidelines/capitalization-conventions
#endregion

#region Assigning a value to a variable

New-Variable -Name MinuMuutuja -Value 333
Set-Variable -Name uus -Value 'tere'

Get-Help Assignment -Category HelpFile -ShowWindow
$kasutaja = Get-ADUser meelis
$MinuMuutuja += 10

#endregion

#region Variable types

# https://docs.microsoft.com/dotnet/api/

$x = 7
$x = 'tere'
$x = get-process p*

Get-Help Type_Accelerator -ShowWindow
[int] $Number = 4
$Number = '4'
$Number = 'neli'

$Number | Get-Member
$Number.GetType()

#endregion

#endregion


#region Lesson 2: Manipulating variables

#region Identifying methods and properties

'tere' | Get-Member
$set = 1, 2, 3
$set | Get-Member
$set.GetType()

Start-Process ('https://docs.microsoft.com/dotnet/api/{0}' -f $set.GetType().BaseType)

$set.GetLength

#endregion

#region Working with strings

# https://docs.microsoft.com/dotnet/api/system.string

$tekst = 'tere'
$tekst | Get-Member

Get-Help quoting -ShowWindow

$tekst.ToUpper()
$tekst.Length

$PWD.ToString().Contains('\')
$PWD.ToString().Split('\')

#endregion

#region Working with dates

# https://docs.microsoft.com/dotnet/api/system.datetime

$täna = Get-Date
$täna
$täna = [datetime]'2018.06.03'
$täna | Get-Member

# https://docs.microsoft.com/dotnet/api/system.timespan
$aeg = New-TimeSpan -days 13
$täna - $aeg
$täna.AddDays(-13)
$täna.Subtract($aeg)
$täna.add($aeg)

#endregion

#endregion


#region Lesson 3: Manipulating arrays and hash tables

#region What is an array?

Get-Help Array -Category HelpFile -ShowWindow

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
#endregion

#region Working with arrays

$arvutid
$arvutid[1]
$arvutid[-1]
$arvutid | Select-Object -First 1 -Skip 1
$arvutid.Add('Lon-DC1')
$arvutid += 'Lon-DC2'
$arvutid.Count

$numbrid = @()

Measure-Command {
    foreach ($number in 1..10000) {
        $numbrid += $number
    }
}
$numbrid.Count

Measure-Command {
    $numbrid = foreach ($number in 1..10000) {
        $number
    }
}
$numbrid.Count

#endregion

#region Working with arraylists

# https://docs.microsoft.com/dotnet/api/system.collections.arraylist

$computers = [Collections.ArrayList] (Get-Content computers.txt)
$computers.Add('Lon-DC1')
$computers.RemoveAt(1)


#https://docs.microsoft.com/dotnet/api/system.collections.generic.list-1

$computers = [Collections.Generic.List[string]] (Get-Content computers.txt)
, $computers | Get-Member
$computers.Add('Lon-DC1')
$computers.Contains('Lon-DC1')

# https://docs.microsoft.com/dotnet/api/system.collections.objectmodel.collection-1
$computers = [Collections.ObjectModel.Collection[string]] (Get-Content computers.txt)
, $computers | Get-Member
$computers.Insert(1, 'Lon-DC1')
$computers.IndexOf('Lon-DC1')

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

#endregion

#endregion
