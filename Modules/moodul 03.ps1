# Lesson 1

Get-Help Get-Service -Parameter name

"bits", "winrm" | Get-Service #-ComputerName (Get-Content serverid.txt)
"bits", "winrm" > teenused.txt
Get-Content teenused.txt | Get-Service
Get-Service -name "bits", "winrm" #-ComputerName (Get-Content serverid.txt)

Get-Help Get-Service -Parameter computername

get-help Stop-Service -Parameter InputObject
Get-Help Start-Service -Parameter inputobject
Get-Help Start-Service -Parameter name
Get-Content -Path teenused.txt | Start-Service


    # see annab vea
Get-Content teenused.txt | Get-Service -name BITS

    # aga see töötab
Get-Content teenused.txt | Get-Service -ComputerName (Get-Content serverid.txt)
Get-Service -Name (Get-Content teenused.txt) -ComputerName (Get-Content serverid.txt)

$muutuja = Get-Service a*

# lesson 2

help Get-Service -Parameter ComputerName

Get-ADComputer -Filter * |
    select @{name="ComputerName"; expression = {$_.name}} |
    #Get-Service -Name *
    Restart-Computer -WhatIf

    # töötab kui CSV faili veerupäised sobivad New-ADUser'i parameetritega
Import-Csv -path kasutajad.csv | New-AdUser


"2015.11.30" -as [datetime]
"2015/11/30" -as [datetime]

Get-ADComputer -Filter * | select -ExpandProperty name
Get-Service -ComputerName (Get-ADComputer -Filter * | select -ExpandProperty name)
