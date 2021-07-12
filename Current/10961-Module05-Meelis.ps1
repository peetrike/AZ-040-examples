# Module 5

# Lesson 1
Get-Command -verb format -Module microsoft.powershell*

help Format-Wide -ShowWindow
dir | Format-Wide -AutoSize
$failid = dir
Format-Wide -InputObject $failid -AutoSize
dir | Format-Wide -Column 7
dir | Format-Wide -Property * -Column 1
dir | Format-Wide -Property name, extension


help Format-List -ShowWindow
dir | select -First 1 | Format-List
dir | select -First 1 | Format-List -Property name, a*
dir | select -First 1 | Format-List -Property *

Get-Alias -Definition format-list

help Format-Table -Online
dir | Format-Table
dir | Format-Table -Property n*,a*,*time*
dir | Format-Table -Property name, a* -AutoSize

dir | Format-Table -Property n*,a*,*time* -Wrap

help Format-Custom -ShowWindow

help Format-Hex -ShowWindow

dir
dir | Format-Table -Property name,length,@{n="len(MB)"; e={$_.length/1MB}; f="N7"; a="right"; w=8}
dir | Format-Table -Property name,@{n="len(MB)"; e={$_.length/1MB}; f="N2"; a="right"; w=8}
Get-Volume
Get-Volume | ft driveletter,size*

get-service b* | Format-Table name, status -GroupBy status
get-service b* | sort status | Format-Table name -GroupBy status

help Group-Object -ShowWindow
Get-Service b* | Group-Object -Property status | Get-Member



get-service b* | Format-Table name, status | Get-Member


# Lesson 3

Get-Command -verb out
help Out-Printer -ShowWindow
help Out-Host -ShowWindow
help Out-File -ShowWindow
help Out-File -Online


dir | Out-GridView
dir | select * | Out-GridView

help Out-GridView -ShowWindow
dir | Out-GridView -PassThru
dir | Out-GridView -PassThru -Title "palun vali failid mida kustutada" | Remove-Item -WhatIf
