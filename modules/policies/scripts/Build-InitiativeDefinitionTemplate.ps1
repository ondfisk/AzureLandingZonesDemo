[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNull()]
    [String]
    $ManagementGroupId,

    [Parameter(Mandatory = $true)]
    [ValidateNotNull()]
    [String]
    $OutFile
)

function Join-Template {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [Object[]]
        $Definition,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]
        $ManagementGroupId
    )

    begin {
        @"
targetScope = 'managementGroup'

var definitions = [
"@
    }

    process {
        $Definition | ForEach-Object {
            (Get-Content -Path $PSItem -Raw) -replace "<prefix>", $ManagementGroupId | Out-File -Path "$PSScriptRoot/../initiative-definitions/temp/$($PSItem.Name)"
            "  loadJsonContent('temp/$($PSItem.Name)')"
        }
    }

    end {
        @"
]

resource policySetDefinitionResources 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = [for definition in definitions: {
  name: definition.name
  properties: definition.properties
}]
"@
    }
}

New-Item -Path "$PSScriptRoot/../initiative-definitions/temp" -ItemType Directory -Force

Get-ChildItem -Path "$PSScriptRoot/../initiative-definitions" -Filter *.json | Join-Template -ManagementGroupId $ManagementGroupId | Out-File -Path "$PSScriptRoot/../initiative-definitions/$OutFile"
