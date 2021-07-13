# Module 4

# lesson 1
Get-PSProvider

    # see töötab virtuaalmasinas ...
Import-Module ActiveDirectory
Get-PSProvider

dir ad:\
dir "ad:\ou=development,DC=Adatum,DC=com"
Get-Item "ad:\CN=Susanna Stubberod,OU=Development,DC=Adatum,DC=com" | Get-Member
Get-Item "ad:\CN=Susanna Stubberod,OU=Development,DC=Adatum,DC=com" | Get-ADUser

help registry -ShowWindow

Get-PSDrive
dir HKLM:\SOFTWARE
dir Cert:\CurrentUser\My
dir Cert:\LocalMachine\My | foreach export

New-PSDrive -Name ketas -PSProvider FileSystem -Root C:\Users\student
dir ketas:\Documents

    #võtame võrguketta külge
New-PSDrive -Name k -PSProvider FileSystem -Root \\server\share\ -Persist -Credential mina
    #Requires -Modules SmbShare
New-SmbMapping -LocalPath k: -RemotePath \\server\share -UserName mina -Password 'Pa$$word' -Persistent 
