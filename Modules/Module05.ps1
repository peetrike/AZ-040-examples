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

Get-Help FileSystem
Get-Help WSMan

#endregion


#region Lesson 2: Using PSDrives

Get-Command -Noun PSDrive
Get-PSDrive

Get-Command -Noun Item, ItemProperty*, Content, Location
Get-Command -noun ChildItem
Get-Alias -Definition Get-ChildItem

#endregion
