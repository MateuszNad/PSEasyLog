# PSEasyLog

![Publish](https://github.com/MateuszNad/PSEasyLog/workflows/Publish%20PowerShell%20module/badge.svg)

The module overwrites natives Write-Verbose, Write-Warning, and Write-Error cmdlet which helps easily add logging to scripts.

## Install Module

Copy and Paste the following command to install PSEasyLog.

```
Install-Module -Name PSEasyLog
```

## Examples

If you want to add logging to your script you only need to import the module.

Write-Verbose, Write-Warning, and Write-Error commands will have an additional feature.  Commands will save messages to a file where a default file name is logger.json.

```powershell
function New-CustomVm
{
    [cmdletbinding()]
    param()

    try {
        # ...
        Write-Verbose -Message 'Verbose message' -Verbose

        # ...
        Write-Warning -Message 'Warning message'

        1/0
    }
    catch {
        Write-Error -Message $_.Exception.Message
    }
}
Import-Module PSEasyLog
New-CustomVm -Verbose
```
Result in the file:

```json
{
    "DateTime":  "wtorek, 15 września 2020 21:25:17",
    "Stream":  "Verbose",
    "Message":  "Verbose message"
}
{
    "DateTime":  "wtorek, 15 września 2020 21:25:17",
    "Stream":  "Warning",
    "Message":  "Warning message"
}
{
    "DateTime":  "wtorek, 15 września 2020 21:25:17",
    "Stream":  "Error",
    "Message":  "Nastąpiła próba podzielenia przez zero."
}
```

You can change the default path. Use -FilePath parameter to change path.

```powershell
Write-Verbose -Message 'Verbose message' -FilePath 'D:\test.log' -Verbose
Write-Error -Message 'Error message' -FilePath 'D:\test.log'
Write-Warning -Message 'Warning message' -FilePath 'D:\test.log'
```
