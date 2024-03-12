#Requires -Version 5.1

<#
    .SYNOPSIS
        Creates PowerShell remote session to course VM
    .DESCRIPTION
        This script establishes remote PowerShell session to course VMs.

        When PowerShell has module for saving credentials and credential is not
        provided from command line, the saved credential is used or newly
        entered credential can be saved for future use.
    .EXAMPLE
        $Session = .\Connect-VM.ps1 -VmName Cl1

        This example creates remote session to client OS VM
    .EXAMPLE
        .\Connect-VM.ps1 -VmName Cl1 -Enter

        This example creates remote session and connects to it.
    .LINK
        New-PSSession
#>
[CmdletBinding(
    SupportsShouldProcess
)]
[OutputType([Management.Automation.Runspaces.PSSession])]
param (
        [Parameter(
            Mandatory,
            HelpMessage = 'Choose VM: Cl1, Dc1 or Svr1'
        )]
        [ValidateSet('Cl1', 'Dc1', 'Svr1')]
        [string]
        # Specifies VM name to connect.  Possible values: Cl1, Dc1, Svr1
    $VmName,
        [pscredential]
        [Management.Automation.Credential()]
        # Specifies the user account credentials to use when performing this task.
    $Credential,
        [switch]
        # Starts an interactive session to VM
    $Enter,
        [ValidateSet('AZ-040T00', '10961C')]
        [string]
    $CourseName = 'AZ-040T00'
)

switch ($CourseName) {
    'AZ-040T00' {
        $CourseDomain = 'Contoso'
        $VMCity = 'SEA'
    }
    default {
        $CourseDomain = 'Adatum'
        $VMCity = 'LON'
    }
}

if (-not $Credential) {
    $CredentialProps = @{}
    if ($cmd = Get-Command Get-Secret -ErrorAction SilentlyContinue) {
        Write-Verbose -Message 'Using SecretManagement module'
        $CredentialProps.Name = $CourseName
        $CredentialProps.ErrorAction = [Management.Automation.ActionPreference]::SilentlyContinue
    } elseif ($cmd = Get-Command Get-SavedCredential -ErrorAction SilentlyContinue) {
        Write-Verbose -Message 'Using telia.savedcredential module'
        $CredentialProps.Id = $CourseName
        $CredentialProps.WarningAction = [Management.Automation.ActionPreference]::SilentlyContinue
    }
    if ($cmd) {
        $SavedCred = & $cmd @CredentialProps
    }

    if ($SavedCred) {
        $Credential = $SavedCred
    } else {
        $CredentialParams = @{
            Message  = 'Please enter credentials for VM connection'
            UserName = '{0}\Administrator' -f $CourseDomain
        }
        if ($NewCredential = Microsoft.PowerShell.Security\Get-Credential @CredentialParams) {
            $Credential = $NewCredential
        }

        if ($Credential -and $PSCmdlet.ShouldContinue('Credential', 'Save entered credential for future')) {
            switch ($cmd.Name) {
                'Get-Secret' {
                    Set-Secret -Name $CourseName -Secret $Credential
                    break
                }
                'Get-SavedCredential' {
                    Save-Credential -Id $CourseName -Credential $Credential
                }
            }
        }
    }
}

if ($Credential) {
    $Name = '{0}-{1}-{2}' -f $CourseName, $VMCity, $VmName

    $Session = Get-PSSession -VMName $Name
    switch ($Session.State) {
        'Broken' {
            Remove-PSSession -Session $Session
            $Session = $null
        }
        'Disconnected' {
            $Session = Connect-PSSession -Session $Session
        }
    }

    if (-not $Session) {
        $Session = New-PSSession -Name $VmName -VMName $Name -Credential $Credential
    }
    if ($Enter) {
        Invoke-Command -Session $Session -ScriptBlock {
            $Host.UI.RawUI.WindowTitle = 'PowerShell {0} - {1} @ {2}' -f @(
                $PSVersionTable.PSVersion.Major
                $env:USERNAME
                $env:COMPUTERNAME
            )
        }
        Enter-PSSession -Session $Session
    } else {
        $Session
    }
}
