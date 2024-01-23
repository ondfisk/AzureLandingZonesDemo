BeforeDiscovery {
    $path = Resolve-Path "$PSScriptRoot/../initiatives"

    $script:Initiatives = Get-ChildItem -Path "$path/*.json"
}

Describe "Test-Initiative" {
    It "<PSItem.Name> name is same as file name" -ForEach $script:Initiatives {
        $template = Get-Content -Path $PSItem | ConvertFrom-Json
        $template.name | Should -BeExactly $PSItem.BaseName
    }

    It "<PSItem.Name> is an initiative definition" -ForEach $script:Initiatives {
        $template = Get-Content -Path $PSItem | ConvertFrom-Json
        $template.type | Should -Be "Microsoft.Authorization/policySetDefinitions"
    }

    It "<PSItem.Name> refers to custom initiatives by prefix" -ForEach $script:Initiatives {
        $template = Get-Content -Path $PSItem | ConvertFrom-Json

        $managementGroupIds = $template.properties.policyDefinitions.policyDefinitionId | Select-String -Pattern "^/providers/Microsoft.Management/managementGroups/(.+)/providers/Microsoft.Authorization/policyDefinitions/.+$"

        if ($managementGroupIds.Matches) {
            $managementGroupIds.Matches | ForEach-Object {
                $PSItem.Groups[1].Value | Should -Be "<prefix>"
            }
        }
    }
}
