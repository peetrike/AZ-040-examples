<#
    .SYNOPSIS
        Module 04 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 04 - Understanding how the pipeline works
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M4
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Passing pipeline data

Get-ADUser -filter { Name -like "meelis*" } | Set-ADUser -City "Tallinn"

    # Parameter binding ByValue
Get-Help Set-ADUser -Parameter Identity
Get-Help Sort-Object -Parameter InputObject

    #see teeb sama, mida 5. rida
{
    set-aduser -identity meelis -city "Tallinn"
    set-aduser -identity meelisadm -city "tallinn"
}

get-help get-service -parameter InputObject
get-help set-service -parameter InputObject
get-help start-service -parameter InputObject

    #nii saab
$teenused = get-service p*
start-service -inputobject $teenused
    #aga nii on mugavam
get-service p* | start-service
get-service bits | set-service -StartupType Automatic

#endregion


#region Lesson 2: Advanced techniques for passing pipeline data


#endregion
