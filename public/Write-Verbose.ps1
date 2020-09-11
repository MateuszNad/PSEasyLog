<#
.EXAMPLE
    Write-Verbose -Message 'Verbose' -Verbose

.EXAMPLE
    Write-Verbose -Message 'Verbose'

.NOTES
    Author: Mateusz Nadobnik
    Link: akademiapowershell.pl

    Date: 09-09-2020
    Version: version
    Keywords: keywords
    Notes:
    Changelog:
#>
function Write-Verbose
{
    [CmdletBinding(HelpUri = 'https://go.microsoft.com/fwlink/?LinkID=113429', RemotingCapability = 'None')]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [Alias('Msg')]
        [AllowEmptyString()]
        [string]
        ${Message},
        [Parameter(Mandatory = $false, Position = 1)]
        ${$FilePath} = $PWD.Path
    )

    begin
    {
        try
        {
            if ($VerbosePreference -eq 'Continue')
            {
                $FilePath = Join-Path $PWD.Path -ChildPath 'logger.json'
                $Log = [PSCustomObject]@{
                    'DateTime' = (Get-Date).DateTime
                    'Stream'   = 'Verbose'
                    'Message'  = $Message
                }
                Add-Content -Encoding UTF8 -Value ($Log | ConvertTo-Json) -Path $FilePath
            }

            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Verbose', [System.Management.Automation.CommandTypes]::Cmdlet)
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

.ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Verbose
.ForwardHelpCategory Cmdlet

#>
}
