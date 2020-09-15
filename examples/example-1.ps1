function New-CustomVm
{
    [cmdletbinding()]
    param()

    try
    {
        # ...
        Write-Verbose -Message 'Verbose message' -Verbose

        # ...
        Write-Warning -Message 'Warning message'

        1 / 0
    }
    catch
    {
        Write-Error -Message $_.Exception.Message
    }
}

Import-Module PSEasyLog
New-CustomVm -Verbose
