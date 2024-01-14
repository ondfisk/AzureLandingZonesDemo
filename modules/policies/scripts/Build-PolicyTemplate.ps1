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

resource policyDefinitionResources 'Microsoft.Authorization/policyDefinitions@2021-06-01' = [for definition in definitions: {
  name: definition.name
  properties: definition.properties
}]
"@
    }
}

Get-ChildItem -Path "$PSScriptRoot/../policies" -Filter *.json | Join-Template | Out-File -Path "$PSScriptRoot/../policies/main.bicep"
