#region Safety to prevent the entire script from being run instead of a selection

throw "You're not supposed to run the entire script"

<#

    The code in this region was stolen, I mean borrowed from Thomas Rayner (@MrThomasRayner).

    For more information, see:

    http://mikefrobbins.com/2017/11/02/safety-to-prevent-entire-script-from-running-in-the-powershell-ise/

#>

#endregion

# Module 7 - Working with variables, arrays, and hash tables

    # Lesson 1 - Using variables
help about_variables -ShowWindow

get-command -noun variable
new-variable -name  MinuMuutuja  -Value 333
get-variable -name MinuMuutuja
get-item -path Variable:\MinuMuutuja
$MinuMuutuja

$cpdat          # lühendatud muutujanimi pole mõne aja pärast enam arusaadav
$CorporateData
$ServerName = "minuserver"

$ServerName

    #muutuja nimi võib olla ka selline
${minu oluline data} = 3
${minu oluline data}
Set-Variable -Name "minu oluline data" -Value "uhhuu"
Get-Variable -Name "minu oluline data"

# muutujad on vaikimisi andmetüübita
$x = 2
$x = "see on tore tekst"
$x = get-aduser meelis

[string]$tekst = Get-ADUser meelis
[int]$number = Get-ADUser meelis

help Set-Variable -ShowWindow
help New-Variable -ShowWindow


    # Lesson 2 - Manipulating variables
# https://docs.microsoft.com/en-us/dotnet/api/

"tere" | Get-Member
help quoting -show

# https://docs.microsoft.com/en-us/dotnet/api/system.string

$tekst | get-member

$tekst.ToUpper()
$tekst.Contains("Meelis")
$tekst.Substring(3,4)
$tekst.Split(",")

# https://docs.microsoft.com/en-us/dotnet/api/system.datetime
$täna = get-date
$täna
$täna = [datetime]"2018.06.03"
$täna | Get-Member

# https://docs.microsoft.com/en-us/dotnet/api/system.timespan
$aeg = new-timespan -days 13
$täna - $aeg
$täna.AddDays(-13)
$täna.Subtract($aeg)
$täna.add($aeg)


    # Lesson 3 - Manipulating arrays and hash tables

# massiiv
help array -ShowWindow
# https://docs.microsoft.com/en-us/dotnet/api/system.array

$arvutid = "Lon-cl1", "Lon-svr1"
$arvutid.Length
$arvutid | get-member   # näitab infot masiivi liikmete, mitte massiivi enda kohta
$arvutid.GetType()
get-member -InputObject $arvutid

$arvutid[0]
$arvutid[1]
$arvutid[-1]
$arvutid[2]     # tühi hulk
$arvutid[-4]    # tühi hulk
$arvutid[0..1]

1..3
1..10 | foreach {write-output ("number on {0}" -f $_)}

$arvutid += "lon-Dc1"
$arvutid

    # arraylist - dynamically sized array
# https://docs.microsoft.com/en-us/dotnet/api/system.collections.arraylist
[System.Collections.ArrayList]$computers = "LON-DC1","LON-SVR1","LON-CL1"
$computers.Add("Lon-Svr32")
$computers.Remove("Lon-CL1")
get-member -InputObject $computers
# http://byronwright.blogspot.com/2016/11/how-you-do-things-matters-powershell.html


    # hashtable
help hash_table -ShowWindow
# https://docs.microsoft.com/en-us/dotnet/api/system.collections.hashtable

$masinad = @{
    "Lon-DC1" = "172.16.0.10"
    "Lon-Cl1" = "172.16.0.13"
    Server2 = "172.17.3.4"
}

$masinad["Lon-Cl1"]
$masinad.'Lon-DC1'
$masinad.Server2

$masinad."lon-SVR1" = "172.16.0.12"
$masinad.Add("lon-svr2","172.16.0.32")
$masinad
$masinad."lon-svr3"
$masinad.ContainsKey("Lon-svr1")

$masinad | get-member
