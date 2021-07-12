#Lesson 1
$PSVersionTable
$Host

start powershell.exe -ArgumentList "-version 2.0"
start powershell.exe -Verb runas

#Lesson 2

dir
cd
cmd -c cd
mklink

bcdedit --% -default {current}
    # see ei tööta
dir /s
    #see töötab
dir -s

Get-Command help
Get-Command ping
Get-Command Get-Command
Get-Command get-aduser
Get-Command -Noun aduser
Get-Command -Noun computer
Get-Command -Noun vm

Get-Verb
Get-Command -Verb get

Get-Command -Noun *network*
Get-Command -Noun netip*
Get-Command -Module NetTCPIP | measure

Get-Module net* -ListAvailable


Get-Help ping
get-help Get-Command
Get-Command Get-Command
Update-Help  #-Module *
Get-Help Get-Help
Get-Command help
get-help Get-Help -Online

Get-Command -Noun help
help Save-Help
help Update-Help
help Update-Help -ShowWindow


get-help Test-NetConnection -ShowWindow
Test-NetConnection -ComputerName www.ee -CommonTCPPort HTTP
Test-NetConnection www.ee http

help about_
help about_wild -ShowWindow
help about_if -ShowWindow

Test-NetConnection -ComputerName www.ee
help Test-Connection -ShowWindow
Test-Connection -ComputerName www.ee,www.microsoft.com,
                              www.hp.com

Show-Command Test-NetConnection

Test-Connection