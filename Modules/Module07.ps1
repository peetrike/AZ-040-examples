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

Get-Help about_variables -ShowWindow

Get-Command -Noun Variable
New-Variable -Name MinuMuutuja  -Value 333
Get-Variable -Name MinuMuutuja
Get-Item -path Variable:\MinuMuutuja
$MinuMuutuja

[string]$tekst = Get-ADUser meelis

#endregion


#region Lesson 2: Manipulating variables

# https://docs.microsoft.com/dotnet/api/

"tere" | Get-Member
Get-Help quoting -ShowWindow

# https://docs.microsoft.com/dotnet/api/system.string

$tekst | Get-Member

#endregion


#region Lesson 3: Manipulating arrays and hash tables

    # Array
help array -ShowWindow
# https://docs.microsoft.com/dotnet/api/system.array

$arvutid = 'Lon-cl1', 'Lon-svr1'
$arvutid.Length
$arvutid | get-member   # shows array member objects, not array itself
$arvutid.GetType()
get-member -InputObject $arvutid

#endregion
