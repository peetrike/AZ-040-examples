# Module 10

# Lesson 1 - Basic remoting

    #see ei ole Powershell remoting
Get-Service b* -ComputerName lon-dc1

Get-Command -ParameterName Session
Get-Command -parametername ComputerName

Test-NetConnection -ComputerName lon-dc1 -CommonTCPPort WINRM
Test-WSMan -ComputerName lon-dc1 -Authentication Default

    #workgroup'i kuuluv masin, kui sertidega ei viitsi jännata ...
$uusserver = "uusserver"
$esialgu = Get-Item WSMan:\localhost\Client\TrustedHosts | select -ExpandProperty value
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $uusserver -Concatenate
Enter-PSSession -ComputerName $uusserver -Credential "$uusserver\admin"
    #teen seal mis vaja
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $esialgu

    # kes saab sihtmasinas PS sessiooniga ligi
Get-LocalGroupMember -Name "remote management USers"
Add-LocalGroupMember -Name "remote management USers" -Member adatum\adam

    # requires -runasadministrator
Enable-PSRemoting #-Force

help about_remoting -ShowWindow
Get-Command -noun psremoting

    #see kaob varsti ära
Get-Command winrm
    #õpi neid kasutama
Get-Command -noun wsman*
Get-ChildItem -Path wsman:\


Enter-PSSession -ComputerName lon-dc1 # -Credential keegi
Invoke-Command -ComputerName lon-dc1, lon-cl1 -ScriptBlock {hostname}
$sessioon = New-PSSession -ComputerName lon-dc1, lon-cl1
Invoke-Command -Session $sessioon -ScriptBlock {hostname}
    # see ei õnnestu
Enter-PSSession -Session $sessioon
    # see õnnestub
$server = New-PSSession -ComputerName lon-dc1
$tulemus = Invoke-Command -Session $server -FilePath c:\skript.ps1

    # eeldus Enable-PSRemoting on lokaalses masinas tehtud
$localadmin = New-PSSession -ComputerName . -Credential .\administrator
Invoke-Command -Session $localadmin -ScriptBlock {tee-midagi}
    #alternatiiv
Start-Process -Verb runas -FilePath powershell -ArgumentList "tee-midagi"


# kohalike muutujate kasutamine PS sessioonis

$minumuutja= "meelis"
    #need teevad sama asja
invoke-command -Session $sessioon -ScriptBlock {get-aduser $using:minumuutja}
invoke-command -Session $sessioon -ScriptBlock {param($kasutaja); get-aduser $kasutaja} -ArgumentList $minumuutja


# persistent session

get-command -noun pssession

$dc = New-PSSession -ComputerName LON-DC1
Disconnect-PSSession -Session $dc
Get-PSSession -ComputerName LON-DC1
Get-PSSession -ComputerName LON-DC1 | Connect-PSSession
Enter-PSSession -Session $dc
Remove-PSSession -Session $dc


# implicit remoting
$server
Get-Module -PSSession $server -ListAvailable
Import-Module -PSSession $server -Name ActiveDirectory -Prefix server -Cmdlet get-aduser, set-aduser
get-serverADUser meelis | set-serverADUser -mobile "5553345"

Remove-PSSession -Session $server
