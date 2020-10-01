#Documentation: https://github.com/PowerShell/PSScriptAnalyzer/blob/master/docs/markdown/Invoke-ScriptAnalyzer.md#-settings
@{
    Severity     = @(
        'Error'
        'Warning'
    )
    ExcludeRules = @(
        'PSUseDeclaredVarsMoreThanAssignments'
        , 'PSAvoidOverwritingBuiltInCmdlets'
    )
}
