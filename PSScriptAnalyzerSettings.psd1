# Use the PowerShell extension setting `powershell.scriptAnalysis.settingsPath` to get the current workspace
# to use this PSScriptAnalyzerSettings.psd1 file to configure code analysis in Visual Studio Code.
# This setting is configured in the workspace's `.vscode\settings.json`.
#
# For more information on PSScriptAnalyzer settings see:
# https://github.com/PowerShell/PSScriptAnalyzer/blob/master/README.md#settings-support-in-scriptanalyzer
#
# You can see the predefined PSScriptAnalyzer settings here:
# https://github.com/PowerShell/PSScriptAnalyzer/tree/master/Engine/Settings
@{
    # Only diagnostic records of the specified severity will be generated.
    # Uncomment the following line if you only want Errors and Warnings but
    # not Information diagnostic records.
    #Severity = @('Error','Warning')

    # Analyze **only** the following rules. Use IncludeRules when you want
    # to invoke only a small subset of the default rules.
    <# IncludeRules = @(
        'PSAvoidDefaultValueSwitchParameter'
        'PSMisleadingBacktick'
        'PSMissingModuleManifestField'
        'PSReservedCmdletChar'
        'PSReservedParams'
        'PSShouldProcess'
        'PSUseApprovedVerbs'
        'PSAvoidUsingCmdletAliases'
        'PSUseDeclaredVarsMoreThanAssignments'
    ) #>

    # Do not analyze the following rules. Use ExcludeRules when you have
    # commented out the IncludeRules settings above and want to include all
    # the default rules except for those you exclude below.
    # Note: if a rule is in both IncludeRules and ExcludeRules, the rule
    # will be excluded.
    #ExcludeRules = @('PSAvoidUsingWriteHost')

    # You can use rule configuration to configure rules that support it:
    Rules = @{
        # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/AvoidUsingCmdletAliases.md
        <# PSAvoidUsingCmdletAliases = @{
            # Do not flag 'cd' alias.
            Whitelist = @("cd")
        } #>

        # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/AlignAssignmentStatement.md
        PSAlignAssignmentStatement = @{
            Enable = $true
            CheckHashtable = $true
        }

        # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/PlaceCloseBrace.md
        PSPlaceCloseBrace = @{
            Enable = $true
            NoEmptyLineBefore = $true
            NewLineAfter = $false
        }
        # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/PlaceOpenBrace.md
        PSPlaceOpenBrace = @{
            Enable = $true
        }

        # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/ProvideCommentHelp.md
        PSProvideCommentHelp = @{
            Placement = "begin"
        }

        # Check if your script uses cmdlets that are compatible
        # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/UseCompatibleCmdlets.md
        PSUseCompatibleCmdlets = @{
            Compatibility = @(
                #'desktop-2.0-windows'
                #'desktop-3.0-windows'
                #'desktop-4.0-windows'
                'desktop-5.1.14393.206-windows'
                'core-6.1.0-windows'
            )
        }

        # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/UseConsistentIndentation.md
        <# PSUseConsistentIndentation = @{
            Enable = $true
        } #>

        # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/UseConsistentWhitespace.md
        PSUseConsistentWhitespace = @{
            Enable = $true
            CheckOperator = $false
        }

        UseCompatibleCommmands = @{
            Enable = $true
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/UseCompatibleCommands.md
            TargetProfiles = @(
                'win-8_x64_6.2.9200.0_3.0_x64_4.0.30319.42000_framework' # Server 2012
                'win-8_x64_6.3.9600.0_4.0_x64_4.0.30319.42000_framework' # Server 2012 R2
                'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework' # Server 2016
                'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # Server 2019
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # Win10
                'win-48_x64_10.0.17763.0_6.1.3_x64_4.0.30319.42000_core' # Win10 PS Core
            )
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/UseCompatibleSyntax.md
            TargetedVersions = @(
                "6.0"
                "5.1"
                #"3.0"
                #"2.0"
            )
            # You can specify commands to not check like this, which also will ignore its parameters:
            <# IgnoreCommands = @(
                'Install-Module'
            ) #>
        }

        # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/UseCompatibleTypes.md
        UseCompatibleTypes = @{
            Enable = $true
            TargetProfiles = @(
                'win-8_x64_6.2.9200.0_3.0_x64_4.0.30319.42000_framework' # Server 2012
                'win-8_x64_6.3.9600.0_4.0_x64_4.0.30319.42000_framework' # Server 2012 R2
                'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework' # Server 2016
                'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # Server 2019
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # Win10
                'win-48_x64_10.0.17763.0_6.1.3_x64_4.0.30319.42000_core' # Win10 PS Core
            )
            # You can specify types to not check like this, which will also ignore methods and members on it:
            <# IgnoreTypes = @(
                'System.IO.Compression.ZipFile'
            ) #>
        }
    }
}
