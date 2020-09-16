
function New-CustomVm
{
    [cmdletbinding()]
    param(
    )

    try
    {
        # Remove-Item -Verbose -Path 'C:\mgotest.txt' -ErrorAction Stop
        # ...
        Write-Verbose -Message 'Verbose message'

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
New-CustomVm
