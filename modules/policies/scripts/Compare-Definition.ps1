[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $ManagementGroupId
)

function Write-Compare ([Parameter(Mandatory = $true)][String]$Label, $Object, $SideIndicator, $Prefix) {
    $compare = $Object | Where-Object SideIndicator -eq $SideIndicator | ForEach-Object { "$Prefix $($PSItem.InputObject)" }
    if ($compare) {
        Write-Output $Label
        Write-Output $compare
    }
}

$source = Get-ChildItem -Path "$PSScriptRoot/../definitions" -Filter "*.json" |
ForEach-Object {
    $template = $PSItem | Get-Content | ConvertFrom-Json
    $template.name
}

$cloud = Get-AzPolicyDefinition -ManagementGroupName $ManagementGroupId -Custom |
Where-Object Id -Match "^/providers/Microsoft.Management/managementGroups/$ManagementGroupId/providers/Microsoft.Authorization/policyDefinitions/" |
Select-Object -ExpandProperty Name

$compare = Compare-Object -ReferenceObject ($Cloud ?? @()) -DifferenceObject ($Source ?? @()) -IncludeEqual
Write-Compare -Label "Definitions to be created:" -Object $compare -SideIndicator "=>" -Prefix "+"
Write-Compare -Label "Definitions to be updated:" -Object $compare -SideIndicator "==" -Prefix "*"
Write-Compare -Label "Definitions to be deleted:" -Object $compare -SideIndicator "<=" -Prefix "-"

if ($compare | Where-Object SideIndicator -EQ "<=") {
    Write-Error "Delete detected. Manual intervention required."
}