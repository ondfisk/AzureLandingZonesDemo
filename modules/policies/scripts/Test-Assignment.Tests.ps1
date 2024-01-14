BeforeDiscovery {
    $path = Resolve-Path "$PSScriptRoot/../assignments"
    $assignments = Get-ChildItem -Path $path -Filter *.bicep -Recurse
}

Describe "Test-Assignment" {
    It "<PSItem.Name> module name matches file name" -ForEach $assignments {
        $content = Get-Content -Path $PSItem -Raw
        $match = $content | Select-String -Pattern "\nmodule ([a-zA-Z0-9_]+)"

        $moduleName = $PSItem.BaseName -replace "-", "_"

        $match.Matches.Groups[1].Value | Should -Be $moduleName
    }

    It "<PSItem.Name> deployment name matches file name" -ForEach $assignments {
        $content = Get-Content -Path $PSItem -Raw
        $match = $content | Select-String -Pattern "\n +name: '([a-z0-9-]+)'"

        $deploymentName = "$($PSItem.BaseName)-assignment"

        $match.Matches.Groups[1].Value | Should -BeExactly $deploymentName
    }

    It "<PSItem.Name> assignment name matches file name" -ForEach $assignments {
        $content = Get-Content -Path $PSItem -Raw
        $match = $content | Select-String -Pattern "\n +policyAssignmentName: '([a-z0-9-]+)'"

        $assignmentName = $PSItem.BaseName

        $match.Matches.Groups[1].Value | Should -BeExactly $assignmentName
    }
}
