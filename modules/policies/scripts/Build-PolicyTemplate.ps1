[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNull()]
    [String]
    $Path
)

function Join-Template {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [Object[]]
        $Path
    )

    begin {
        @"
targetScope = 'managementGroup'

var definitions = [
"@
    }

    process {
        $Path | ForEach-Object {
            "  loadJsonContent('$Path')"
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

Get-ChildItem -Path $Path -Filter *.json | Select-Object -ExpandProperty Name | Join-Template
