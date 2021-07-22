<#
    .SYNOPSIS
        Module 08 samples
    .DESCRIPTION
        This file contains sample commands from course 10961 for
        Module 08 - Basic scripting
    .LINK
        https://github.com/peetrike/10961-examples
    .LINK
        https://diigo.com/profile/peetrike/?query=%23MOC-10961+%23M8
#>

#region Safety to prevent the entire script from being run instead of a selection
    throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1: Introduction to scripting

#region Overview of Windows PowerShell scripts

Get-Help Scripts -Category HelpFile -ShowWindow

get-date
whoami

'get-date; whoami' | Set-Content -Path käsud.txt -Encoding utf8BOM
Start-Process cmd.exe -ArgumentList '/k powershell < käsud.txt'
Invoke-Expression (gc .\käsud.txt)
Invoke-Item .\käsud.txt

Get-Content .\käsud.txt | powershell -command -
pwsh -c (gc .\käsud.txt)

#endregion

#region Modifying scripts

# https://github.com/janikvonrotz/awesome-powershell#editors-and-ides

# https://code.visualstudio.com
# https://docs.microsoft.com/powershell/scripting/windows-powershell/ise/how-to-write-and-run-scripts-in-the-windows-powershell-ise
# https://www.sapien.com/software/powershell_studio
# https://visualstudio.microsoft.com/vs/community/

# https://www.sublimetext.com/
# https://atom.io/
# https://github.com/neoclide/coc.nvim
# https://emacs-lsp.github.io/lsp-mode/
# https://plugins.jetbrains.com/plugin/10249

# https://code.labstack.com/powershell
# https://poshgui.com/
# https://docs.github.com/en/codespaces

# https://notepad-plus-plus.org/

#endregion

#region What is the PowerShellGet module?

# https://www.powershellgallery.com/
# https://docs.microsoft.com/powershell/scripting/gallery/getting-started

Get-Module PowerShellGet -ListAvailable

if ($PSVersionTable.PSVersion.Major -lt 6) {
    if (-not ([Net.ServicePointManager]::SecurityProtocol -band [Net.SecurityProtocolType]::Tls12)) {
        [Net.ServicePointManager]::SecurityProtocol =
            [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }
}

Find-Script Send-PasswordNotification -Repository PSGallery
find-module UserProfile -Repository PSGallery
Find-Module -Command get-user -Repository PSGallery

Get-InstalledScript
Get-InstalledModule

#endregion

#region Running scripts

powershell.exe -?

    # this doesn't work
powershell.exe -file käsud.txt
    # but this works
Copy-Item -Path käsud.txt -Destination käsud.ps1
powershell.exe -file käsud.ps1
pwsh -f käsud.ps1

powershell.exe -command .\käsud.ps1
.\käsud.ps1
.\käsud

Get-Help Command_Precedence -ShowWindow

Get-Help Run_With_PowerShell -ShowWindow

#endregion

#region The script execution policy

Get-Help Execution_Policies -ShowWindow
Get-Command -noun ExecutionPolicy
Get-ExecutionPolicy -List

Set-ExecutionPolicy Restricted -Scope Process
.\käsud.ps1
powershell.exe -ExecutionPolicy RemoteSigned -file käsud.ps1
Set-ExecutionPolicy RemoteSigned -Scope Process

#endregion

#region PowerShell and AppLocker/WDAC

Get-Help Language_Modes -ShowWindow

$ExecutionContext.SessionState.LanguageMode

# https://docs.microsoft.com/windows/security/threat-protection/windows-defender-application-control/select-types-of-rules-to-create#table-1-windows-defender-application-control-policy---policy-rule-options

#endregion

#region Digitally signing scripts

Get-Help Signing -Category HelpFile -ShowWindow

Get-Command -Noun AuthenticodeSignature

Get-AuthenticodeSignature -FilePath käsud.ps1

Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert
Get-Help Set-AuthenticodeSignature -Examples

Get-Command -Noun FileCatalog

#endregion

#endregion


#region Lesson 2: Scripting constructs

Get-Help about_foreach -ShowWindow

foreach ($i in 1..1KB) {
    "number on $i"
}

#endregion


#region Lesson 3: Importing data from files

Get-Help Get-Content -ShowWindow

Get-Content -Path C:\Scripts\* -Include *.txt, *.log
Get-Content C:\Scripts\computers.txt -TotalCount 10
Get-Content file.txt -Tail 10


Get-Help Import-Csv -ShowWindow

Import-Csv kasutajad.csv | Select-Object name, e-mail



# lisamaterjal, Out-GridView kui kasutajaliidese element:
Get-Help Out-GridView -ShowWindow

Get-ChildItem |
    Out-GridView -Title 'mis failid soovid kustutada' -PassThru |
    Remove-Item -WhatIf

Get-ADUser -filter { City -like 'Tallinn' } |
    Out-GridView -Title 'mis kasutaja gruppi lisame' -OutputMode Single |
    Add-ADPrincipalGroupMembership -MemberOf 'minu sobrad' -WhatIf

#endregion
