BeforeDiscovery {
    $path = Resolve-Path "$PSScriptRoot/../policies"

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignment", "", Justification = "False positive (policies)")]
    $policies = Get-ChildItem -Path "$path/*.json"
}

Describe "Test-Policy" {
    It "<PSItem.Name> name is same as file name" -ForEach $policies {
        $template = Get-Content -Path $PSItem | ConvertFrom-Json
        $template.name | Should -BeExactly $PSItem.BaseName
    }

    It "<PSItem.Name> is a policy definition" -ForEach $policies {
        $template = Get-Content -Path $PSItem | ConvertFrom-Json
        $template.type | Should -Be "Microsoft.Authorization/policyDefinitions"
    }
}
