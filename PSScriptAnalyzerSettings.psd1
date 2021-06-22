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
    <# ExcludeRules = @(
        'PSAvoidUsingWriteHost'
    ) #>

    IncludeDefaultRules = $true

    # You can use rule configuration to configure rules that support it:
    Rules               = @{
        PSAlignAssignmentStatement                = @{
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/AlignAssignmentStatement.md
            Enable         = $true
            CheckHashtable = $true
        }

        <# PSAvoidUsingCmdletAliases = @{
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/AvoidUsingCmdletAliases.md
            # Do not flag 'cd' alias.
            AllowList = @('cd')
        } #>

        PSAvoidUsingDoubleQuotesForConstantString = @{
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/AvoidUsingDoubleQuotesForConstantString.md
            Enable = $true
        }

        PSPlaceCloseBrace                         = @{
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/PlaceCloseBrace.md
            Enable            = $true
            NoEmptyLineBefore = $true
            NewLineAfter      = $false
        }

        PSPlaceOpenBrace                          = @{
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/PlaceOpenBrace.md
            Enable = $true
        }

        PSProvideCommentHelp                      = @{
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/ProvideCommentHelp.md
            Placement = 'begin'
        }

        # Check if your script uses cmdlets that are compatible
        PSUseCompatibleCmdlets                    = @{
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/UseCompatibleCmdlets.md
            Compatibility = @(
                #'desktop-2.0-windows'
                #'desktop-3.0-windows'
                #'desktop-4.0-windows'
                'desktop-5.1.14393.206-windows'
                'core-6.1.0-windows'
            )
        }

        PSUseCompatibleCommands                   = @{
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/UseCompatibleCommands.md
            Enable         = $true
            TargetProfiles = @(
                'win-8_x64_6.2.9200.0_3.0_x64_4.0.30319.42000_framework' # Server 2012
                'win-8_x64_6.3.9600.0_4.0_x64_4.0.30319.42000_framework' # Server 2012 R2
                'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework' # Server 2016
                'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # Server 2019
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # Win10
                #'win-8_x64_10.0.14393.0_7.0.0_x64_3.1.2_core' # Server 2016 PS 7
                #'win-8_x64_10.0.17763.0_7.0.0_x64_3.1.2_core' # Server 2019 PS 7
                'win-4_x64_10.0.18362.0_7.0.0_x64_3.1.2_core' # Win10 PS 7
                #'ubuntu_x64_18.04_7.0.0_x64_3.1.2_core'
            )
            # You can specify commands to not check like this, which also will ignore its parameters:
            <# IgnoreCommands = @(
                'Install-Module'
            ) #>
        }

        PSUseCompatibleSyntax                     = @{
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/UseCompatibleSyntax.md
            Enable           = $true
            TargetedVersions = @(
                '6.0'
                '5.1'
                #'3.0'
                #'2.0'
            )
        }

        PSUseCompatibleTypes                      = @{
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/UseCompatibleTypes.md
            Enable         = $true
            TargetProfiles = @(
                'win-8_x64_6.2.9200.0_3.0_x64_4.0.30319.42000_framework' # Server 2012
                'win-8_x64_6.3.9600.0_4.0_x64_4.0.30319.42000_framework' # Server 2012 R2
                'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework' # Server 2016
                'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # Server 2019
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # Win10
                #'win-8_x64_10.0.14393.0_7.0.0_x64_3.1.2_core' # Server 2016 PS 7
                #'win-8_x64_10.0.17763.0_7.0.0_x64_3.1.2_core' # Server 2019 PS 7
                'win-4_x64_10.0.18362.0_7.0.0_x64_3.1.2_core' # Win10 PS 7
                #'ubuntu_x64_18.04_7.0.0_x64_3.1.2_core'
            )
            # You can specify types to not check like this, which will also ignore methods and members on it:
            <# IgnoreTypes = @(
                'System.IO.Compression.ZipFile'
            ) #>
        }

        <# PSUseConsistentIndentation = @{
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/UseConsistentIndentation.md
            Enable = $true
        } #>

        PSUseConsistentWhitespace                 = @{
            # https://github.com/PowerShell/PSScriptAnalyzer/blob/master/RuleDocumentation/UseConsistentWhitespace.md
            Enable                          = $true
            CheckOperator                   = $false  # doesn't work with PSAlignAssignmentStatement enabled
            #IgnoreAssignmentOperatorInsideHashTable = $true
            CheckPipeForRedundantWhitespace = $true
            #CheckParameter                  = $true
        }
    }
}
