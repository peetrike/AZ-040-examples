function Get-TaskInfo {
    <#
        .SYNOPSIS
            Finds Scheduled tasks from local computer
        .DESCRIPTION
            This sample function searches for Scheduled Tasks on local computer
        .LINK
            https://docs.microsoft.com/windows/win32/taskschd/task-scheduler-start-page
    #>

    [CmdletBinding()]
    param (
            [ValidateNotNullOrEmpty()]
            [string]
            # Specifies Scheduled Task name search pattern
        $TaskName = '*',
            [string]
            # Specifies path for scheduled tasks in Task Scheduler namespace.
        $TaskPath
    )

    function Get-TaskFolder {
        [CmdletBinding()]
        param (
            $Folder
        )
        $Folder
        foreach ($subFolder in $Folder.GetFolders(0)) {
            Get-TaskFolder -Folder $subFolder
        }
    }

    function Get-Task {
        param (
                [string]
            $Name = '*',
            $Folder
        )

        if ($Name -and $Name -notmatch '\*') {
            try {
                $Folder.GetTask($Name)
            } catch {
                Write-Verbose -Message ('No tasks in folder {0}' -f $Folder.Path)
            }
        } else {
                # include hidden tasks
            $Folder.GetTasks(1) | Where-Object { $_.Name -like $Name }
        }
    }

    $Scheduler = New-Object -ComObject 'Schedule.Service'
    $Scheduler.Connect()
    $RootFolder = $Scheduler.GetFolder('\')

    if ($TaskName -match '\\') {
        $RootFolder.GetTask($TaskName)
    } elseif ($TaskPath) {
        $currentFolder = $RootFolder.GetFolder($TaskPath.TrimEnd('\'))
        Get-Task -Name $TaskName -Folder $currentFolder
    } else {
        foreach ($folder in Get-TaskFolder -Folder $RootFolder) {
            Get-Task -Name $TaskName -Folder $folder
        }
    }
}
