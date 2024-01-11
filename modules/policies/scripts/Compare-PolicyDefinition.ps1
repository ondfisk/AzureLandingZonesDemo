[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $Path,

    [Parameter(Mandatory = $true)]
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

function Get-ResourceNameFromTemplate ($Path, $Pattern) {
    Get-ChildItem -Path "$Path/*.json" | ForEach-Object {
        $template = $PSItem | Get-Content | ConvertFrom-Json
        $template.name
    }
}

function Compare-Item ($Source, $Cloud, $ManagementGroupId) {
    Write-Output "Comparing definitions under '$ManagementGroupId'..."
    $compare = Compare-Object -ReferenceObject ($Cloud ?? @()) -DifferenceObject ($Source ?? @()) -IncludeEqual
    Write-Compare -Label "Policy definitions to be created:" -Object $compare -SideIndicator "=>" -Prefix "+"
    Write-Compare -Label "Policy definitions to be updated:" -Object $compare -SideIndicator "==" -Prefix "*"
    Write-Compare -Label "Policy definitions to be deleted:" -Object $compare -SideIndicator "<=" -Prefix "-"

    if ($compare | Where-Object SideIndicator -EQ "<=") {
        Write-Error "Delete detected. Manual intervention required."
    }
}

$cloud = Get-AzPolicyDefinition -ManagementGroupName $ManagementGroupId -Custom |
Where-Object ResourceId -Match "^/providers/Microsoft.Management/managementGroups/$ManagementGroupId/" |
Select-Object -ExpandProperty Name
$source = Get-ResourceNameFromTemplate -Path $Path
Compare-Item -Source $source -Cloud $cloud -ManagementGroupId $ManagementGroupId
