[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $Folder,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $PolicyDefinitionManagementGroupId,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $ManagedIdentityId,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
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
        $PolicyDefinitionManagementGroupId,

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

        $PolicyDefinitionManagementGroupId = $PolicyDefinitionManagementGroupId # Workaround for PSReviewUnusedParameter
        $ManagedIdentityId = $ManagedIdentityId # Workaround for PSReviewUnusedParameter
        $LogAnalyticsWorkspaceId = $LogAnalyticsWorkspaceId # Workaround for PSReviewUnusedParameter
    }

    process {
        $params += (Get-Content -Path $Assignment | Where-Object { $PSItem -match "^param " }) | ForEach-Object {
            $PSItem -replace "^param policyDefinitionManagementGroupId string$", "param policyDefinitionManagementGroupId string = '$PolicyDefinitionManagementGroupId'" `
                -replace "^param logAnalyticsWorkspaceId string$", "param logAnalyticsWorkspaceId string = '$LogAnalyticsWorkspaceId'" `
                -replace "^param managedIdentityId string$", "param managedIdentityId string = '$ManagedIdentityId'"
        }
        Get-Content -Path $Assignment | Where-Object { $PSItem -ne "targetScope = 'managementGroup'" -and $PSItem -notmatch "^param " }
    }

    end {
        $params | Sort-Object | Select-Object -Unique
    }
}

$assignmentsFolder = Join-Path -Path $PSScriptRoot -ChildPath "../assignments/$Folder"
$outFile = Join-Path -Path $assignmentsFolder -ChildPath "main.bicep"

Get-ChildItem -Path $assignmentsFolder -Filter *.bicep |
Where-Object { $PSItem.Name -ne "main.bicep" } |
Join-Template -PolicyDefinitionManagementGroupId $PolicyDefinitionManagementGroupId -ManagedIdentityId $ManagedIdentityId -LogAnalyticsWorkspaceId $LogAnalyticsWorkspaceId |
Out-File -FilePath $outFile
