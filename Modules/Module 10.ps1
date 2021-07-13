#region Safety to prevent the entire script from being run instead of a selection

throw "You're not supposed to run the entire script"

<#

    The code in this region was stolen, I mean borrowed from Thomas Rayner (@MrThomasRayner).

    For more information, see:

    http://mikefrobbins.com/2017/11/02/safety-to-prevent-entire-script-from-running-in-the-powershell-ise/

#>

#endregion

# Module 10 - Administering remote computers

    # Lesson 1 - Using basic Windows PowerShell remoting

help about_remoting -ShowWindow

Get-Command -ParameterName ComputerName -Module microsoft.powershell.* | Measure-Object

help Enable-PSRemoting
Enable-PSRemoting -Force

# https://devops-collective-inc.gitbooks.io/secrets-of-powershell-remoting/content/manuscript/configuring-remoting-via-gpo.html


# remote connection
Enter-PSSession -ComputerName masin
Exit
Get-Alias -Definition Exit-PSSession

Enter-PSSession -ComputerName masin -Credential adatum\administrator
Exit-PSSession

    # selle grupi liikmetel on õigus luua remote ühendus
Get-LocalGroup "Remote Management Users" | Get-LocalGroupMember

Invoke-Command -ComputerName lon-dc1 -ScriptBlock {whoami.exe; hostname}
Invoke-Command -ComputerName lon-dc1 -FilePath c:\minuskript.ps1

Get-Help Invoke-Command -Parameter ComputerName
Invoke-Command -ComputerName lon-dc1, lon-cl1 -FilePath c:\minuskript.ps1
Invoke-Command -ComputerName (Get-Content masinad.txt) -FilePath c:\minuskript.ps1
Invoke-Command -ComputerName (Get-ADComputer -filter {name -like "lon*"} | select -exp dnshostname) -FilePath c:\minuskript.ps1

Get-Help Invoke-Command -Parameter Throttle*


Get-Process s* | Get-Member
Invoke-Command -ComputerName lon-dc1 -ScriptBlock {Get-Process s* | Get-Member }
Invoke-Command -ComputerName lon-dc1 -ScriptBlock {Get-Process s* } |
    Get-Member


    # Lesson 2 - Using advanced Windows PowerShell remoting

Get-Command -Noun PSSession
Get-Command -Noun PSSessionOption
Get-Help New-PSSession -ShowWindow

    # sending parameters to remote computers
$Log = 'Security'
$Quantity = 10
Invoke-Command –Computer ONE,TWO –ScriptBlock {
    Param($x,$y)
    Get-EventLog –LogName $x –Newest $y
} –ArgumentList $Log, $Quantity

$s = New-PSSession -ComputerName LON-DC1
$ps = "Windows PowerShell"
Invoke-Command -Sessions $s -ScriptBlock {Get-WinEvent -LogName $Using:ps}

    # üllatus, aga see töötab
invoke-command -ComputerName lon-dc1 -ScriptBlock {get-credential}

# https://docs.microsoft.com/en-us/powershell/scripting/setup/ps-remoting-second-hop


    # Lesson 3 - Using PSSessions

help about_pssession -ShowWindow

Get-Command -noun pssession
Get-Command -parametername Session

$yhendus = new-pssession -computername "Lon-dc1"
$yhendus
Invoke-Command -Session $yhendus -ScriptBlock {whoami}
Enter-PSSession -Session $yhendus

Get-PSSession | Remove-PSSession
$serverid = New-PSSession -ComputerName lon-dc1, lon-cl1
Enter-PSSession -Session $serverid   # siin tuleb viga
Invoke-Command -Session $serverid -ScriptBlock {hostname}

Enter-PSSession -Session $yhendus

Get-PSSession -Name session14

    # admin ühendus lokaalmasinasse
$admin = new-pssession -ComputerName . -Credential local\administrator
enter-pssession -Session $admin
invoke-command -session $admin -ScriptBlock {"teeme midagi"}

    # implicit remoting
Import-Module -PSSession $yhendus -Name ActiveDirectory -Prefix "rem"
Get-remADUser administrator
    # import only 1 cmdlet
Import-Module -PSSession $yhendus -Name ActiveDirectory -Prefix "rem" -Cmdlet get-aduser

get-help get-remaduser -online
