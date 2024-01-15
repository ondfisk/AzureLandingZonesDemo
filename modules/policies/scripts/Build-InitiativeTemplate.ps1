[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNull()]
    [String]
    $ManagementGroupId
)

function Join-Template {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "", Justification = "False positive (ManagementGroupId)")]
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
            (Get-Content -Path $PSItem -Raw) -replace "<prefix>", $ManagementGroupId | Out-File -Path "$PSScriptRoot/../initiatives/temp/$($PSItem.Name)"
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

New-Item -Path "$PSScriptRoot/../initiatives/temp" -ItemType Directory -Force

Get-ChildItem -Path "$PSScriptRoot/../initiatives" -Filter *.json | Join-Template -ManagementGroupId $ManagementGroupId | Out-File -Path "$PSScriptRoot/../initiatives/main.bicep"
