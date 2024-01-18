BeforeDiscovery {
    $path = Resolve-Path "$PSScriptRoot/../policies"

    $script:policies = Get-ChildItem -Path "$path/*.json"
}

Describe "Test-Policy" {
    It "<PSItem.Name> name is same as file name" -ForEach $script:policies {
        $template = Get-Content -Path $PSItem | ConvertFrom-Json
        $template.name | Should -BeExactly $PSItem.BaseName
    }

    It "<PSItem.Name> is a policy definition" -ForEach $script:policies {
        $template = Get-Content -Path $PSItem | ConvertFrom-Json
        $template.type | Should -Be "Microsoft.Authorization/policyDefinitions"
    }
}