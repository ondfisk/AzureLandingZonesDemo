BeforeDiscovery {
    $path = Resolve-Path "$PSScriptRoot/../assignments"

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignment", "", Justification = "False positive (parameters)")]
    $parameters = Get-ChildItem -Path $path -Filter *.bicepparam -Recurse

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignment", "", Justification = "False positive (folders)")]
    $folders = Get-ChildItem -Path "$path/.." -Directory -Recurse
}

Describe "Test-AssignmentParameter" {
    It "<PSItem.Name> references assignment" -ForEach $parameters {
        $content = Get-Content -Path $PSItem -Raw
        $match = $content | Select-String -Pattern "using '\./([a-z0-9-]+\.bicep)'"

        $bicepFile = $PSItem.Name -replace "\.(canary|prod)\.bicepparam", ".bicep"

        $match.Matches.Groups[1].Value | Should -Be $bicepFile
    }
}

Describe "Test-AssignmentParameter" {
    It "<PSItem.Name> referenced assignment exists" -ForEach $parameters {
        $bicepFile = $PSItem.FullName -replace "\.(canary|prod)\.bicepparam", ".bicep"

        Test-Path -Path $bicepFile | Should -Be $true
    }
}

Describe "Test-AssignmentParameter" {
    It "Canary: <PSItem.Name> no parameters has same name but different value" -ForEach $folders {
        $parameters = Get-ChildItem -Path $PSItem.FullName -Filter *.canary.bicepparam

        if ($parameters) {
            $content = Get-Content -Path $parameters
            $match = $content | Select-String -Pattern "param ([a-z0-9-]+) = '(.+)'"

            $table = @{}

            $match.Matches | ForEach-Object {
                $parameter = $PSItem.Groups[1].Value
                $value = $PSItem.Groups[2].Value
                if ($table.ContainsKey($parameter) -and $table[$parameter] -ne $value) {
                    throw "Parameter $parameter has different values in canary"
                }
                else {
                    $table[$parameter] = $value
                }
            }
        }
    }

    It "Prod: <PSItem.Name> no parameters has same name but different value" -ForEach $folders {
        $parameters = Get-ChildItem -Path $PSItem.FullName -Filter *.prod.bicepparam

        if ($parameters) {
            $content = Get-Content -Path $parameters
            $match = $content | Select-String -Pattern "param ([a-z0-9-]+) = '(.+)'"

            $table = @{}

            $match.Matches | ForEach-Object {
                $parameter = $PSItem.Groups[1].Value
                $value = $PSItem.Groups[2].Value
                if ($table.ContainsKey($parameter) -and $table[$parameter] -ne $value) {
                    throw "Parameter $parameter has different values in prod"
                }
                else {
                    $table[$parameter] = $value
                }
            }
        }
    }
}
