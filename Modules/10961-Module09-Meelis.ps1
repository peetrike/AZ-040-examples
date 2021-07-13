# Module 9

Get-Command -ParameterName computername

Get-HotFix -ComputerName lon-dc1
Get-WinEvent -LogName Application -ComputerName lon-dc1 -MaxEvents 3

# Lesson 1

help about_remote -ShowWindow


    # see on vajalik, kui masinad ei kuulu domeeni
    # seda teed lähtemasinas
Get-Item WSMan:\localhost\Client\TrustedHosts
$OldHosts = ""
$OldHosts = (Get-Item WSMan:\localhost\Client\TrustedHosts).Value
$NewList = "uusmasin, 192.168.2.3"
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $NewList -Concatenate
    # siin teeme midagi eemal masinas
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $OldHosts
    # seda teed sihtmasinas
Set-PSSessionConfiguration Microsoft.PowerShell –ShowSecurityDescriptorUI

Enable-PSRemoting
Get-Command -Noun PsRemoting


    #interaktiivne sessioon
Enter-PSSession -ComputerName lon-dc1 -Credential adatum\administrator


    # käsud täidetakse kaugel
Invoke-Command -ComputerName lon-dc1 -ScriptBlock {hostname; whoami}

Invoke-Command -ComputerName lon-dc1, lon-cl1 -ScriptBlock {hostname; whoami}

"lon-dc1", "lon-cl1" > servers.txt
Invoke-Command -ComputerName (Get-Content .\servers.txt) -ScriptBlock {hostname; whoami}

Get-ADComputer -Filter * | select -ExpandProperty dnshostname > servers.txt

Invoke-Command -ComputerName (
    Get-ADComputer -Filter {name -like "lon-*"} | select -ExpandProperty dnshostname
) -ScriptBlock {
    hostname
    whoami
}


Invoke-Command -ComputerName lon-dc1 -ScriptBlock {
    $asjad = dir c:\
    $asjad
}

$asjad = "kahvel", "lusikas"
Invoke-Command -ComputerName lon-dc1 -ScriptBlock {
    $asjad
}

Invoke-Command -ComputerName lon-dc1 -ScriptBlock {
    Param($besjad)
        $besjad
} -ArgumentList @($asjad)

Invoke-Command -ComputerName lon-dc1 -ScriptBlock {
        $using:asjad
}


Invoke-Command -ComputerName lon-dc1, lon-cl1 -FilePath c:\minuskript.ps1

$yhendus = New-PSSession -ComputerName lon-dc1, lon-cl1 -Credential adatum\administrator
Invoke-Command -Session $yhendus -FilePath c:\minuskript.ps1


help about_workflows -ShowWindow

$credential = Get-Credential -Message " ütle üks ilus parool" -UserName mina
$credential | Get-Member
$credential.Password

Invoke-Command -ComputerName lon-dc1 -Credential $credential -FilePath c:\skript.ps1

# Lesson 3

Get-Command -ParameterName session -Module microsoft.powershell.*

Get-Command -ParameterName cimsession | measure

Get-PSSession

$masinad = New-PSSession -ComputerName lon-dc1,lon-cl1
$masinad

Invoke-Command -Session $masinad -ScriptBlock {hostname}

Enter-PSSession -Session $masinad
Enter-PSSession -Session ($masinad | select -First 1)
Enter-PSSession -Session ($masinad | select -Last 1)

Get-PSSession -ComputerName lon-dc1
Enter-PSSession -Session (Get-PSSession -ComputerName lon-dc1)

Get-PSSession | Remove-PSSession
Get-PSSession -ComputerName lon-dc1 | Disconnect-PSSession
Connect-PSSession -Session $masinad

Get-Command -Noun PSSession
help Export-PSSession -ShowWindow

    # implicit remoting
Get-Module ActiveDirectory -list
$dc = New-PSSession -ComputerName lon-dc1
Import-Module -Name ActiveDirectory -PSSession $dc -Prefix dc
Get-Module ActiveDirectory

Get-ADUser administrator
Get-dcADUser administrator

Remove-PSSession -Session $dc
Get-dcADUser administrator # loob uue sessiooni
