task . ReloadModule

if (-not ($PSBoundParameters.ModuleName))
{
    $ModuleName = Split-Path -Path $BuildRoot -Leaf
}

task ReloadModule {
    if (Get-Module $ModuleName)
    {
        Remove-Module -Name $ModuleName
    }
    Import-Module $BuildRoot
}
