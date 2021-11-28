function Get-CimNameSpace {
    [CmdletBinding()]
    param (
            [string]
        $NameSpace = 'ROOT',
            [cimsession]
        $CimSession,
            [switch]
        $Recurse
    )

    $QueryParam = @{
        Namespace   = $NameSpace
        ClassName   = '__Namespace'
        ErrorAction = [Management.Automation.ActionPreference]::SilentlyContinue
    }
    $NameSpaceValue = { $this.CimSystemProperties.Namespace }
    if ($CimSession) {
        $QueryParam.CimSession = $CimSession
    }
    $NameSpaceList = Get-CimInstance @QueryParam |
        Add-Member -MemberType ScriptProperty -Name 'Namespace' -Value $NameSpaceValue -PassThru
    $NameSpaceList
    if ($Recurse.IsPresent) {
        ForEach ($n in $NameSpaceList) {
            $QueryParam.Namespace = Join-Path -Path $NameSpace -ChildPath $n.Name
            $QueryParam.Remove('ClassName')
            Get-CimNameSpace @QueryParam
        }
    }
}

Get-CimNameSpace -Recurse | Format-Table -GroupBy Namespace
