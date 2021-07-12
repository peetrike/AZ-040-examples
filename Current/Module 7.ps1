# Module 7

# Lesson 1 - Using variables

help about_variables -show
get-command -noun variable
dir variable:

new-variable -name minu -value "asi"
$minu
get-variable minu
get-item variable:\minu

help new-variable -show

$minu = 5
$minu = get-aduser meelis
$MinuVagaPikkMuutujNnimi = 33
$MinuVagaPikkMuutujNnimi | get-member
$minu | get-member
$minu.Enabled = $false
$minu.GivenName = "miskit uut"

    # value data types
[int]$uus = 5
$uus = "tere"
$uus = "55"
$uus
[datetime]"1.1.2012"
[datetime]$paev = "2012.1.13"
$paev


# Lesson 2 - Manipulating variables

$teenused = get-service b*
$teenused.Count
$teenused = get-service uhhuu*
    # requires -Version 3.0
$teenused.Count
    #powershell 2.0 sees tuleb teha nii:
@($teenused).Count

$teenused | get-member


# string manipulation
$asi = "tere"
$asi | get-member
$asi.ToUpper()
$asi.Substring(1,2)
$env:PSModulePath | get-member

$env:PSModulePath.Split(";")
$env:PSModulePath -split ";"

$env:PSModulePath.Split(";")[0]
$env:PSModulePath.Split(";") | select -first 1
$env:PSModulePath.Split(";")[-1]
$env:PSModulePath.Split(";") | select -last 1

$env:PSModulePath.Split(";")[0..1]
$env:PSModulePath.Split(";") | select -first 2


# date manipulation

dir 
dir | Where-Object LastWriteTime -gt (Get-Date).AddDays(-30)

$ammu = (Get-Date).adddays(-90)
Get-ADUser -filter {LastLogonDate -gt $ammu}
Get-ADUser -filter {PasswordLastSet -gt $ammu}


New-TimeSpan -End "2018.12.24"
New-TimeSpan -start "2017.12.24"


# Lesson 3 - Arrays and Hashtables

# array 
$massiiv = @()
$massiiv.GetType()
$massiiv.Count

$massiiv = 1,2,3,4
$massiiv[3]

$massiiv = 1, "tere", (dir)
$massiiv.Count
$massiiv[-1]

$massiiv += "uus"
$massiiv.Count
$massiiv[-1]

    #see annab vea
$massiiv.Add(33)
$massiiv.GetType()

# arraylist
$MuutuvMassiiv = New-Object -TypeName System.Collections.ArrayList
    # see töötab
$MuutuvMassiiv.Add("tere") | Out-Null
$MuutuvMassiiv += 33
$MuutuvMassiiv


# hash table (dictionary or associative array)
$asjad = @{}
$asjad.esimene = "niimoodi"
$asjad.teine = 33
$asjad
$asjad.Add("kolmas",(dir))
$asjad
$asjad.3 = "ehhe"

$asjad.Count
$asjad.Keys
$asjad.Values


    #järjestatud hashtable
$jarjest = [ordered]@{}
$jarjest.nimi = "mina"
$jarjest.vanus = 22


$params = @{
    to = "mina@kuskil.ee"
    from = "sina@sea.ee"
    smtpserver= minu.server.ee
    subject = "tähtis asi"
}

Send-MailMessage @params -body "see on minu kiri1"

Get-ADUser -filter * -Properties email | foreach {
    $params.to = $_.email
    $params.body = "Kallis {0}, soovin sulle head päeva" -f $_.name
    Send-MailMessage @params
}

help about_splatting
