# Module 6

# Lesson 1

Get-Command -noun wmi*
Get-Command -Noun cim*
Get-Command -Module cimcmdlets

Get-WmiObject -Class Win32_OperatingSystem
Get-CimInstance -ClassName Win32_OperatingSystem | select caption,version

#Lesson 2
#Get-CimInstance -Namespace root/CIMV2 -ClassName win32_
Get-CimClass -ClassName win32_*
Get-CimClass -ClassName win32_*network*

Get-Module -ListAvailable

Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object # nii me ei tee...
Get-CimInstance -ClassName Win32_LogicalDisk  -Filter 'DriveType=3' -Property deviceid,size,freespace | select deviceid,size,freespace
Get-Volume

Get-Service bits | fl *
Get-CimInstance Win32_Service -Filter "name='bits'" | Get-Member
Get-WmiObject Win32_Service -Filter "name='bits'" | Get-Member

$teenus = Get-WmiObject Win32_Service -Filter "name='bits'" 
$teenus.StartName = "domain\kasutaja"


    # järgnevad 2 käsku annavad sama tulemuse
Get-CimInstance -ClassName Win32_LogicalDisk  -Filter 'DriveType=3' -Property deviceid,size,freespace | select deviceid,size,freespace
Get-CimInstance -Query "SELECT deviceid,size,freespace FROM Win32_LogicalDisk WHERE DriveType=3"


# lesson 3

Get-Process p* | Get-Member
Get-CimInstance Win32_Process -Filter 'name LIKE "p%"' | Get-Member
Get-WmiObject Win32_Process -Filter 'name LIKE "p%"' | Get-Member
1..10 | foreach { start notepad }
Get-WmiObject Win32_Process -Filter 'name LIKE "notepad%"' | foreach -MemberName terminate

Get-CimInstance Win32_Process -Filter 'name LIKE "p%"' | Get-Member -MemberType Methods
Get-WmiObject Win32_Process -Filter 'name LIKE "p%"' | Get-Member -MemberType Methods

[System.Enum]::GetValues([System.Diagnostics.ProcessPriorityClass])

start notepad
$notepad = Get-WmiObject Win32_Process -Filter 'name LIKE "notepad%"' 
$notepad | Get-Member -MemberType Methods
$notepad.SetPriority([System.Diagnostics.ProcessPriorityClass]"Belownormal")
$notepad.Priority

Get-Process notepad | Get-Member -MemberType Methods
Get-Process notepad | Get-Member -MemberType Properties
Get-CimInstance Win32_Process -Filter 'name LIKE "p%"' | Get-Member -MemberType Properties

Get-CimInstance Win32_LogicalDisk | Get-Member
Get-WmiObject Win32_LogicalDisk | Get-Member

start notepad
Get-CimInstance Win32_Process -Filter "name like 'notepad%'" |
    Invoke-CimMethod -MethodName terminate

    # korjame mitmest arvutist BIOS info kokku
$computers = Get-ADComputer -filter {name -like "lon-*"} |
     select -ExpandProperty dnshostname

$sess = New-CimSession -ComputerName $computers

Get-CimInstance -CimSession $sess -ClassName win32_bios |
    select pscomputername, version |
    Format-Table -AutoSize

