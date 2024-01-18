[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNull()]
    [String]
    $ManagementGroupId,

    [Parameter(Mandatory = $true)]
    [ValidateNotNull()]
    [String]
    $ManagedIdentityId,

    [Parameter(Mandatory = $true)]
    [ValidateNotNull()]
    [String]
    $LogAnalyticsWorkspaceId
)

function Join-Template {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [Object[]]
        $Assignment,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]
        $ManagementGroupId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]
        $ManagedIdentityId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]
        $LogAnalyticsWorkspaceId
    )

    begin {
        "targetScope = 'managementGroup'"
        $params = @()

        $ManagementGroupId = $ManagementGroupId # Workaround for PSReviewUnusedParameter
        $ManagedIdentityId = $ManagedIdentityId # Workaround for PSReviewUnusedParameter
        $LogAnalyticsWorkspaceId = $LogAnalyticsWorkspaceId # Workaround for PSReviewUnusedParameter
    }

    process {
        $params += (Get-Content -Path $Assignment | Where-Object { $PSItem -match "^param " }) | ForEach-Object {
            $PSItem -replace "^param managementGroupId string$", "param managementGroupId string = '$ManagementGroupId'" `
                -replace "^param logAnalyticsWorkspaceId string$", "param logAnalyticsWorkspaceId string = '$LogAnalyticsWorkspaceId'" `
                -replace "^param managedIdentityId string$", "param managedIdentityId string = '$ManagedIdentityId'"
        }
        Get-Content -Path $Assignment | Where-Object { $PSItem -ne "targetScope = 'managementGroup'" -and $PSItem -notmatch "^param " }
    }

    end {
        $params | Sort-Object | Select-Object -Unique
    }
}

$ManagementGroupId = $ManagementGroupId # Workaround for PSReviewUnusedParameter
$ManagedIdentityId = $ManagedIdentityId # Workaround for PSReviewUnusedParameter
$LogAnalyticsWorkspaceId = $LogAnalyticsWorkspaceId # Workaround for PSReviewUnusedParameter

Get-ChildItem -Path "$PSScriptRoot/.." -Directory -Recurse | Where-Object FullName -Match "[/\\]assignments" | ForEach-Object {
    $templateFile = "$PSItem/main.bicep"

    $assignments = Get-ChildItem -Path $PSItem -Filter *.bicep | Where-Object { $PSItem.Name -notin "main.bicep", "main.canary.bicep", "main.prod.bicep" }
    if ($assignments) {
        $assignments | Join-Template -ManagementGroupId $ManagementGroupId -ManagedIdentityId $ManagedIdentityId -LogAnalyticsWorkspaceId $LogAnalyticsWorkspaceId | Out-File -Path $templateFile
    }
}
