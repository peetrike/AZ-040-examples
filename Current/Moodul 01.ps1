start powershell_ise -Credential domain\user
Get-Command ping
Get-Command dir
Get-Alias | measure
Get-Alias -Definition "foreach-object"
Get-Alias -Definition "get-childitem"

Get-Command *alias*
Get-Command  -CommandType Alias | measure
Get-Command * -CommandType Application | measure
Get-Command | Where-Object commandtype -EQ alias | measure
Get-Command *ping*
Get-Command -Name *-vm -Module "Hyper-V"
Get-Command -Noun vm* -Module hyper-v

Get-Help New-VM
Get-Help New-VM -ShowWindow
Get-Help New-VM -Detailed
get-help new-vm -Full

Get-Help Get-Command -ShowWindow
get-help Get-Command -Parameter name
get-help *ping*

get-help Get-Command -Online
Get-Help Get-Command -Examples
GET-HELP PING
get-help Test-Connection
get-help icmp


Get-EventLog -LogName Application -Newest 10
Get-Help Get-EventLog -Parameter logname
Get-EventLog Application -Newest 10
Get-EventLog -LogName Application -Newest 10 -ComputerName Lon-dc1,Lon-cl1

Get-Command -ParameterName ComputerName | measure
Get-Command -ParameterName session | measure
Get-Command -ParameterName CimSession | measure

Update-Help -Module Hyper-V


help about_*
help remote
help about_remote -ShowWindow
help about_remote -Online
help about_hyper_v

# Lesson 3

dir '.\3D Objects'
Get-Command dir
Get-Command ping
cmd /c mklink /?

Get-EventLog -LogName Application
Get-EventLog -Log Application -n 10
Get-EventLog -Log Application -n 10 -a

Get-EventLog -Newest 10 Application 1000
help Get-EventLog -Full

Get-EventLog -LogName Application -Newest 10 -ComputerName lon-dc1
Get-EventLog Application -N 10 -CN lon-dc1 |
   measure


"Lon-cl1", "lon-dc1" > .\servers.txt
dir .\servers.txt
$names = Get-Content .\servers.txt
$names
Get-EventLog -LogName Application -ComputerName $names
Get-EventLog -LogName Application -ComputerName "Lon-cl1", "lon-dc1"
  # samaväärne eelmistega
Get-EventLog -LogName Application -ComputerName (Get-Content .\servers.txt)

Get-EventLog -LogName Application -Newest 10 -ComputerName (
    Get-ADComputer -Filter * |
      Select-Object -ExpandProperty DnsHostName
)


Get-Service -Name BITS
gsv BITS | Stop-Service
Get-Service b*
Get-Service windows*
Get-Service -DisplayName windows*
Get-Service -DisplayName "windows update"

start powershell -Credential mina
$mina = Get-Credential
start powershell -Credential $mina

Get-Service b* | Stop-Service -WhatIf
Get-Service b* | Stop-Service -Confirm

  # väga ohtlik tegevus, küsitakse luba
"tere" > miski
dir miski | del
    # ära küsi, tee ikka
dir miski | del -Force

help Send-MailMessage