[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet("canary", "prod")]
    [string]
    $Environment,

    [Parameter(Mandatory = $true)]
    [ValidateNotNull()]
    [String]
    $ManagementGroupId
)

function Join-Template {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [Object[]]
        $Assignment
    )

    begin {
        "targetScope = 'managementGroup'"
        $params = @()
    }

    process {
        $params += (Get-Content -Path $Assignment | Where-Object { $PSItem -match "^param " })
        Get-Content -Path $Assignment | Where-Object { $PSItem -ne "targetScope = 'managementGroup'" -and $PSItem -notmatch "^param " }
    }

    end {
        $params | Select-Object -Unique
    }
}

function Join-Parameter {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [Object[]]
        $Parameter,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("canary", "prod")]
        [string]
        $Environment,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]
        $ManagementGroupId
    )

    begin {
        "using './main.$Environment.bicep'"
        ""
        $parameters = New-Object -TypeName System.Collections.Generic.HashSet[string]
    }

    process {
        Get-Content -Path $Parameter |
        Where-Object { $PSItem } |
        Where-Object { $PSItem -notmatch "^using " } |
        ForEach-Object {
            $parameter = $PSItem.Trim() -replace "^param managementGroupId string$", "param managementGroupId string = '$ManagementGroupId'"
            if ($parameters.Add($parameter)) {
                $parameter
            }
        }
    }

    end {
    }
}

Get-ChildItem -Path "$PSScriptRoot/.." -Directory -Recurse | Where-Object FullName -Match "[/\\]assignments" | ForEach-Object {
    $templateFile = "$PSItem/main.$Environment.bicep"
    $parameterFile = "$PSItem/main.$Environment.bicepparam"

    $assignments = Get-ChildItem -Path $PSItem -Filter *.bicep | Where-Object { $PSItem.Name -notin "main.bicep", "main.canary.bicep", "main.prod.bicep" }
    if ($assignments) {
        $assignments | Join-Template | Out-File -Path $templateFile
        $parameters = Get-ChildItem -Path $PSItem -Filter *.$Environment.bicepparam | Where-Object { $PSItem.Name -notin "main.bicepparam", "main.canary.bicepparam", "main.prod.bicepparam" }
        $parameters | Join-Parameter -Environment $Environment -ManagementGroupId $ManagementGroupId | Out-File -Path $parameterFile
    }
}
