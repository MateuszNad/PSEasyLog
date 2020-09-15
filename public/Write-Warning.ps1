<#
.EXAMPLE
    Write-Warning -Message  'Warning'

.EXAMPLE
    Write-Warning -Message 'Warning message' -FilePath 'D:\test.log'

    Save a warning message to custome the log file
.NOTES
    Author: Mateusz Nadobnik
    Link: akademiapowershell.pl

    Date: 11-09-2020
    Version: version
    eywords: keywords
    Notes:
    Changelog:
#>
function Write-Warning
{
    [CmdletBinding(HelpUri = 'https://go.microsoft.com/fwlink/?LinkID=113430', RemotingCapability = 'None')]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [Alias('Msg')]
        [AllowEmptyString()]
        [string]
        ${Message},
        [Parameter(Mandatory = $false, Position = 1)]
        ${FilePath} = (Join-Path $PWD.Path -ChildPath 'logger.json')
    )

    begin
    {
        try
        {
            if ($null -ne $FilePath)
            {
                $PSBoundParameters.Remove('FilePath')
            }

            $Log = [PSCustomObject]@{
                'DateTime' = (Get-Date).DateTime
                'Stream'   = 'Warning'
                'Message'  = $Message
            }
            Add-Content -Encoding UTF8 -Value ($Log | ConvertTo-Json) -Path $FilePath

            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Warning', [System.Management.Automation.CommandTypes]::Cmdlet)
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

.ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Warning
.ForwardHelpCategory Cmdlet

#>
}
