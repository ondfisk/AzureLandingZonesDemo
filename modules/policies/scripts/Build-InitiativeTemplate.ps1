[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $ManagementGroupId
)

function Join-Template {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [Object[]]
        $Definition,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
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
        $ManagementGroupId = $ManagementGroupId # Workaround for PSReviewUnusedParameter
        $Definition | ForEach-Object {
            (Get-Content -Path $PSItem -Raw) -replace "<prefix>", $ManagementGroupId | Out-File -Path "$PSScriptRoot/../initiatives/temp/$($PSItem.Name)"
            "  loadJsonContent('temp/$($PSItem.Name)')"
        }
    }

    end {
        @"
]

resource policySetDefinitionResources 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = [for definition in definitions: {
  name: definition.name
  properties: definition.properties
}]
"@
    }
}

New-Item -Path "$PSScriptRoot/../initiatives/temp" -ItemType Directory -Force

Get-ChildItem -Path "$PSScriptRoot/../initiatives" -Filter *.json | Join-Template -ManagementGroupId $ManagementGroupId | Out-File -Path "$PSScriptRoot/../initiatives/main.bicep"
