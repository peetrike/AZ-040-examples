# Module 3

# Lesson 1

Get-Service | sort status | select name, status

help Stop-Service -ShowWindow
help Set-Service -ShowWindow

help Stop-Service -Parameter InputObject
Get-Service b* | Stop-Service -PassThru | Set-Service -StartupType Disabled


help Stop-Service -Parameter name
    # parameter binding by value -> string = name
"bits", "Workstation" | Stop-Service
    # parameter binding doesn't work, use foreach
"background intelligent Transwer Service" | foreach { Stop-Service -DisplayName $_ }
help Stop-Service -Parameter displayname
Stop-Service -DisplayName "", "", ""


help Get-Service -ShowWindow
"bits", "winrm" | Get-Service
"bits", "winrm" | Get-Service -Name ALG

Get-Service b* | Get-Member
Get-Service b* |
    Where-Object StartType -like "Disabled" |
    Set-Service -StartupType Manual -PassThru |
    Start-Service -PassThru

Get-Command -Noun Object
Get-Help Sort-Object -Parameter inputobject

Get-Command dir
Get-Command -Noun item,childitem,itemproperty
Get-Command del
get-help Remove-Item -ShowWindow

dir *.txt | del # see ei tööta "by value"
".\fail.txt", ".\tere.txt" | Remove-Item
dir -File -Recurse |
    sort length -Descending |
    select -First 10 |
    select -ExpandProperty fullname |
    Remove-Item


get-help Get-Service -ShowWindow

Get-Content names.txt | Get-Service #-Name bits

Get-Service b* | Export-Csv -path teenused.csv
Import-Csv -Path .\teenused.csv | Get-Service

"lon-dc1", "lon-cl1" | Out-File computers.txt
Get-Service -Name BITS -ComputerName (Get-Content .\computers.txt)
Get-Content .\computers.txt | foreach {
    Get-Service -Name bits -ComputerName $_
}


help Get-Service -ShowWindow
help Get-process -ShowWindow
start-service bits
Get-Service bits | Get-Process

get-service spool*


get-Service -ComputerName (Get-Content .\servers.txt) -Name bits
get-adcomputer -filter {Name -like "lon-srv*"} | select -ExpandProperty dnshostname | Out-File servers.txt

get-Service -ComputerName (
    get-adcomputer -filter {Name -like "srv*"} |
        select -ExpandProperty dnshostname
) -Name bits | Start-Service

Get-Content .\computers.txt | ForEach-Object -Process {
    invoke-gpupdate -computername $_
}

get-adcomputer -filter {Name -like "lon-srv*"} |
    select -ExpandProperty dnshostname |
    ForEach-Object -Process {
        invoke-gpupdate -computername $_
    }

dir m* | select full* | Get-Member
dir m* | select -ExpandProperty full* | Get-Member
dir m* | select -ExpandProperty full* | Get-Content # ei tööta

dir m* | select full*,@{name="path"; e={$_.fullname}} | Get-Content 


$failid = dir m*
$nimed = Select-Object -InputObject $failid -Property full*, @{name="path"; e={$_.fullname}}
Get-Content -Path $nimed
