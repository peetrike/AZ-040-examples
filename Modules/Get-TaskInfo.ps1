function Get-TaskInfo {
    [CmdletBinding()]
    param(
            [ValidateNotNullOrEmpty()]
            [string]
        $TaskName = '*',
            [string]
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
