[CmdletBinding()]
param ()

function Join-Template {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [Object[]]
        $Definition
    )

    begin {
        @"
targetScope = 'managementGroup'

var definitions = [
"@
    }

    process {
        $Definition | ForEach-Object {
            "  loadJsonContent('$($PSItem.Name)')"
        }
    }

    end {
        @"
]

resource policyDefinitionResources 'Microsoft.Authorization/policyDefinitions@2023-04-01' = [for definition in definitions: {
  name: definition.name
  properties: definition.properties
}]
"@
    }
}

$definitionsFolder = Join-Path -Path $PSScriptRoot -ChildPath "../definitions"
$outFile = Join-Path -Path $definitionsFolder -ChildPath "main.bicep"

Get-ChildItem -Path $definitionsFolder -Filter *.json | Join-Template | Out-File -FilePath $outFile
