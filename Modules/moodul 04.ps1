# Lesson 1

Get-PSProvider
help filesystem

Get-PSDrive
dir c:\
dir HKLM:\SOFTWARE

dir Cert:\CurrentUser\my | select -last 1 | Get-Member

Get-Command -Noun alias

Get-Command -noun psdrive
help New-PSDrive

New-PSDrive -Name n -PSProvider FileSystem -Root \\server\share -Persist
    #Requires -Modules SMBShare
New-SmbMapping ...

dir env:
Get-Item Env:\USERPROFILE
Get-Content Env:\USERPROFILE
dir variable:
New-PSDrive -name minu -PSProvider FileSystem -Root (Get-Content Env:\USERPROFILE)
New-PSDrive -name minu -PSProvider FileSystem -Root $env:USERPROFILE
New-PSDrive -name minu2 -PSProvider FileSystem -Root $HOME
dir minu:\Documents

Get-PSDrive -Name minu* | Remove-PSDrive

Get-help New-Item -Parameter itemtype

new-item -Name asi.txt -ItemType File
New-Item -Name uus.txt -ItemType HardLink -Target asi.txt
dir
    #Requires -RunAsAdministrator
New-Item -name kolmas.txt -ItemType SymbolicLink -Target .\asi.txt

New-Item -name kaust -ItemType Directory
New-Item -name uuskaust -ItemType Junction -Target .\kaust
dir -Directory

New-Item -name server -ItemType Junction -Target \\server\share\kaust
Get-Item .\uus.txt | format-list *
Get-Item .\asi.txt | format-list *

    #Requires -Version 5.0
get-help Compress-Archive
get-help Expand-Archive