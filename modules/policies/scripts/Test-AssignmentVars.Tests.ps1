BeforeDiscovery {
    $script:Environments = @(
        @{
            DisplayName = "Canary"
            Name        = "canary"
        },
        @{
            DisplayName = "Production"
            Name        = "prod"
        }
    )
}

Describe "Test-AssignmentVars" {
    It "<PSItem.DisplayName>: vars.yml policyAssignmentFolders should match actual folders" -ForEach $script:Environments {
        $varsPath = Resolve-Path "$PSScriptRoot/../../../environments/$($PSItem.Name)"
        $yml = Get-Content -Path "$varsPath/vars.yml"
        $managementGroupId = ($yml | Select-String "^  managementGroupId: (.+)$").Matches.Groups[1].Value
        $policyAssignmentFolders = ($yml | Select-String "^  policyAssignmentFolders: (.+)$").Matches.Groups[1].Value -split ", " | Sort-Object

        $assignmentsPath = Resolve-Path "$PSScriptRoot/../assignments"
        $actualFolders = Get-ChildItem -Path $assignmentsPath -Filter *.bicep -Recurse | ForEach-Object { $PSItem.Directory.FullName.Replace($assignmentsPath, $managementGroupId) -replace "\\", "/" } | Sort-Object | Select-Object -Unique

        $policyAssignmentFolders | Should -Be $actualFolders
    }
}
