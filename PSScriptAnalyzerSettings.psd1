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
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/AlignAssignmentStatement
            Enable         = $true
            CheckHashtable = $true
        }

        PSAvoidLongLines                          = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/AvoidLongLines
            Enable            = $true
            MaximumLineLength = 115
        }

        <# PSAvoidOverwritingBuiltInCmdlets = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/avoidoverwritingbuiltincmdlets
            'PowerShellVersion' = @(
                #'desktop-2.0-windows'
                #'desktop-3.0-windows'
                #'desktop-4.0-windows'
                'desktop-5.1.14393.206-windows'
                'core-6.1.0-windows'
                #'core-6.1.0-linux'
                #'core-6.1.0-macos'
            )
        } #>

        PSAvoidSemicolonsAsLineTerminators        = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/avoidsemicolonsaslineterminators
            Enable = $true
        }

        <# PSAvoidUsingCmdletAliases = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/AvoidUsingCmdletAliases
            # Do not flag 'cd' alias.
            AllowList = @('cd')
        } #>

        PSAvoidUsingDoubleQuotesForConstantString = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/AvoidUsingDoubleQuotesForConstantString
            Enable = $true
        }

        PSPlaceCloseBrace                         = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/PlaceCloseBrace
            Enable            = $true
            NoEmptyLineBefore = $true
            NewLineAfter      = $false
        }

        PSPlaceOpenBrace                          = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/PlaceOpenBrace
            Enable = $true
        }

        PSProvideCommentHelp                      = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/ProvideCommentHelp
            Placement = 'begin'
        }

        PSUseCompatibleCmdlets                    = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/UseCompatibleCmdlets
            Compatibility = @(
                'desktop-2.0-windows'
            )
        }

        PSUseCompatibleCommands                   = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/UseCompatibleCommands
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
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/UseCompatibleSyntax
            Enable         = $true
            TargetVersions = @(
                '6.0'
                '5.1'
                '3.0'
            )
        }

        PSUseCompatibleTypes                      = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/UseCompatibleTypes
            Enable         = $true
            TargetProfiles = @(
                'win-8_x64_6.2.9200.0_3.0_x64_4.0.30319.42000_framework' # Server 2012
                'win-8_x64_6.3.9600.0_4.0_x64_4.0.30319.42000_framework' # Server 2012 R2
                'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework' # Server 2016
                'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # Server 2019
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # Win10
                'win-8_x64_10.0.14393.0_7.0.0_x64_3.1.2_core' # Server 2016 PS 7
                'win-8_x64_10.0.17763.0_7.0.0_x64_3.1.2_core' # Server 2019 PS 7
                'win-4_x64_10.0.18362.0_7.0.0_x64_3.1.2_core' # Win10 PS 7
                #'ubuntu_x64_18.04_7.0.0_x64_3.1.2_core'
            )
            # You can specify types to not check like this, which will also ignore methods and members on it:
            <# IgnoreTypes = @(
                'System.IO.Compression.ZipFile'
            ) #>
        }

        <# PSUseConsistentIndentation                = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/UseConsistentIndentation
            Enable = $true
        } #>

        PSUseConsistentWhitespace                 = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/UseConsistentWhitespace
            Enable                                  = $true
            CheckParameter                          = $true
            CheckPipeForRedundantWhitespace         = $true
            IgnoreAssignmentOperatorInsideHashTable = $true
        }

        PSUseCorrectCasing                        = @{
            # https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/usecorrectcasing
            Enable = $true
        }
    }
}
