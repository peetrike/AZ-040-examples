#region Safety to prevent the entire script from being run instead of a selection

throw "You're not supposed to run the entire script"

<#

    The code in this region was stolen, I mean borrowed from Thomas Rayner (@MrThomasRayner).

    For more information, see:

    http://mikefrobbins.com/2017/11/02/safety-to-prevent-entire-script-from-running-in-the-powershell-ise/

#>

#endregion

# Module 3 - Working with the Windows PowerShell pipeline

    # Lesson 1 - Understanding the pipeline

1..3 | foreach {Start-Process notepad}
Get-Process notepad | stop-process


    # Lesson 2: Selecting, sorting, and measuring objects


    # Lesson 3: Filtering objects out of the pipeline


    # Lesson 4: Enumerating objects in the pipeline


    # Lesson 4: Sending pipeline data as output
