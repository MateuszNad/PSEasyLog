<#
.EXAMPLE
    Write-Error $Error[0]

.EXAMPLE
    Write-Error $_.Exception.Message

.EXAMPLE
    Write-Error -Message 'Error message' -FilePath 'D:\test.log'

    Save a error message to custome the log file

.NOTES
    Author: Mateusz Nadobnik
    Link: akademiapowershell.pl

    Date: 11-09-2020
    Version: version
    eywords: keywords
    Notes:
    Changelog:
#>
function Write-Error
{
    [CmdletBinding(DefaultParameterSetName = 'NoException', HelpUri = 'https://go.microsoft.com/fwlink/?LinkID=113425', RemotingCapability = 'None')]
    param(
        [Parameter(ParameterSetName = 'WithException', Mandatory = $true)]
        [System.Exception]
        ${Exception},

        [Parameter(ParameterSetName = 'WithException')]
        [Parameter(ParameterSetName = 'NoException', Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [Alias('Msg')]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        ${Message},

        [Parameter(ParameterSetName = 'ErrorRecord', Mandatory = $true)]
        [System.Management.Automation.ErrorRecord]
        ${ErrorRecord},

        [Parameter(ParameterSetName = 'NoException')]
        [Parameter(ParameterSetName = 'WithException')]
        [System.Management.Automation.ErrorCategory]
        ${Category},

        [Parameter(ParameterSetName = 'NoException')]
        [Parameter(ParameterSetName = 'WithException')]
        [string]
        ${ErrorId},

        [Parameter(ParameterSetName = 'NoException')]
        [Parameter(ParameterSetName = 'WithException')]
        [System.Object]
        ${TargetObject},

        [string]
        ${RecommendedAction},

        [Alias('Activity')]
        [string]
        ${CategoryActivity},

        [Alias('Reason')]
        [string]
        ${CategoryReason},

        [Alias('TargetName')]
        [string]
        ${CategoryTargetName},

        [Alias('TargetType')]
        [string]
        ${CategoryTargetType},

        [Parameter(Mandatory = $false, Position = 1)]
        ${FilePath} = (Join-Path $PWD.Path -ChildPath 'logger.json')
    )

    begin
    {
        try
        {
            if ($null -ne $PSBoundParameters['FilePath'])
            {
                $PSBoundParameters.Remove('FilePath')
            }

            $Log = [PSCustomObject]@{
                'DateTime'         = (Get-Date).DateTime
                'Stream'           = 'Error'
                'ScriptName'       = $PSCmdlet.MyInvocation.ScriptName
                'ScriptLineNumber' = $PSCmdlet.MyInvocation.ScriptLineNumber
                'Message'          = $Message
            }
            Add-Content -Encoding UTF8 -Value ($Log | ConvertTo-Json -Compress) -Path $FilePath

            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Error', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = { & $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        }
        catch
        {
            throw
        }
    }
    process
    {
        try
        {
            $steppablePipeline.Process($_)
        }
        catch
        {
            throw
        }
    }

    end
    {
        try
        {
            $steppablePipeline.End()
        }
        catch
        {
            throw
        }
    }
    <#

.ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Error
.ForwardHelpCategory Cmdlet

#>
}
