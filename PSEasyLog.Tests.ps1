$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$module = 'PSEasyLog'

Describe "$module Module Tests" {

    Context 'Module Setup' {
        It "has the root module $module.psm1" {
            "$here\$module.psm1" | Should -Exist
        }

        It "has the a manifest file of $module.psd1" {
            "$here\$module.psd1" | Should -Exist
            "$here\$module.psd1" | Should -FileContentMatch "$module.psm1"
        }

        It "$module folder has functions" {
            "$here\public\*.ps1" | Should -Exist
        }

        It "$module is valid PowerShell code" {
            $psFile = Get-Content -Path "$here\$module.psm1" `
                -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
            $errors.Count | Should -Be 0
        }

    } # Context 'Module Setup'
}
