<#
    .SYNOPSIS
        Module 05 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 05 - Using PSProviders and PSDrives
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M5
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Using PSProviders

Get-Command -Noun PSProvider

Get-PSProvider
Import-Module ActiveDirectory
Get-PSProvider

Get-Help about*Provider

Get-Help FileSystem -Category HelpFile -ShowWindow
Get-Help WSMan -Category HelpFile -ShowWindow

#endregion


#region Lesson 2: Using PSDrives

#region Cmdlets for using PSDrives

Get-Command -Noun PSDrive
Get-PSDrive

Get-Command -Noun Item, ItemProperty*, Content, Location
Get-Command -Noun ChildItem
Get-Alias -Definition Get-ChildItem

    #Requires -Version 3
New-PSDrive -Name 's' -Root '\\server\share\folder' -Persist -Credential 'domain\user' -PSProvider FileSystem
New-SmbMapping -LocalPath 'p:' -RemotePath '\\server\share\folder' -Persistent $true -UserName 'domain\user' -SaveCredentials
Get-Help New-SmbMapping -Parameter Password

#endregion

#region Working with the file system

New-PSDrive –Name WINDIR –Root C:\Windows –PSProvider FileSystem
Set-Location Windir:\System32

Get-Help FileSystem -Category HelpFile -ShowWindow

New-Item -ItemType Directory -Name uus
New-Item -ItemType File -Name minufail.txt -Path uus

Set-Location uus
    #Requires -Version 5
New-Item -ItemType HardLink -Name teinefail.txt -Value minufail.txt

    #Requires -RunAsAdministrator
New-Item -ItemType SymbolicLink -Name link.txt -Value minufail.txt


#endregion


#endregion
