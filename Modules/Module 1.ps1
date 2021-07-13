# Module 1

# PS version
$PSVersionTable

get-command powershell
get-command ise

    # run as admin
Start-Process -Verb runas -FilePath powershell -ArgumentList "get-command"
start -Verb runas cmd
    # Win+X A
    # Ctrl-Shift-Enter

Start-Transcript
Stop-Transcript

Get-History

#ise ja mitte ise
Show-Command

# Lesson 2
Get-Verb

Get-ChildItem -Path c:\
dir c:\

#tab completion
get-com*d

Get-Command
Get-Help Get-Command -ShowWindow
Get-Help Set-ExecutionPolicy -Parameter scope
Get-Help Set-ExecutionPolicy -Online

    # Requires -RunAsAdministrator
Update-Help -Module microsoft.powershell.archive

Save-Help -DestinationPath \\server\share\kaust
Update-Help -SourcePath \\server\share\kaust

Get-Help get-aduser -Examples

Get-Help Set-ExecutionPolicy -Parameter scope
Get-Help Set-ExecutionPolicy -ShowWindow

get-help about_*
Get-Help about_exe -ShowWindow

Get-Help Get-UserProfile -Online


# Lesson 3

Get-Module -ListAvailable
Get-Command | measure


Find-Module userprofile
Find-Module *sql*

Find-Module azurerm.sql | fl *
Find-Module azurerm.sql | Install-Module #-Scope AllUsers
Find-Module azurerm.sql | Update-Module

Get-Module -ListAvailable

$env:PSModulePath
$env:PSModulePath -split ";"

# finding cmdlets
Get-Command -Module activedirectory | measure

Get-Command -Module activedirectory
Get-Command -Noun *user* -Verb get
Get-Help get-aduser

Get-ADUser meelis

    # otsime tundmatut käsku
Get-Command -noun *firewall*
Get-Command -noun *firewallrule
help Get-NetFirewallRule -ShowWindow
Get-NetFirewallRule | measure


#aliased
Get-Alias
Get-Alias dir
Get-Alias -Definition get-childitem

Get-Command -noun alias

Get-Command ping
Get-Command dir

# showing command syntax in GUI
show-command
show-command get-help
