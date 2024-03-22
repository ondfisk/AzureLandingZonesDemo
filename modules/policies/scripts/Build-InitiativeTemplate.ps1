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

var initiatives = [
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

resource policySetDefinitionResources 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = [for initiative in initiatives: {
  name: initiative.name
  properties: initiative.properties
}]
"@
    }
}

$initiativesFolder = Join-Path -Path $PSScriptRoot -ChildPath "../initiatives"
$outFile = Join-Path -Path $initiativesFolder -ChildPath "main.bicep"

New-Item -Path "$initiativesFolder/temp" -ItemType Directory -Force

Get-ChildItem -Path $initiativesFolder -Filter *.json | Join-Template -ManagementGroupId $ManagementGroupId | Out-File -FilePath $outFile
