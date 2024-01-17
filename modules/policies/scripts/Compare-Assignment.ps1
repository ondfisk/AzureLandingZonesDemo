[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $Prefix
)

function Write-Compare ([Parameter(Mandatory = $true)][String]$Label, $Object, $SideIndicator, $Prefix) {
    $compare = $Object | Where-Object SideIndicator -eq $SideIndicator | ForEach-Object { "$Prefix $($PSItem.InputObject)" }
    if ($compare) {
        Write-Output $Label
        Write-Output $compare
    }
}

function Get-ResourceNameFromTemplate ($Path, $Pattern) {
    Get-ChildItem -Path "$Path/*.bicep" -Filter "*.bicep" | Where-Object Name -NE ".deploy.bicep" | ForEach-Object {
        $name = $PSItem | Get-Content -Raw | Select-String -Pattern $Pattern
        $name.Matches.Groups[1].Value
    }
}

function Compare-Item ($Source, $Cloud, $ManagementGroupId) {
    Write-Output "Comparing assignments under '$ManagementGroupId'..."
    $compare = Compare-Object -ReferenceObject ($Cloud ?? @()) -DifferenceObject ($Source ?? @()) -IncludeEqual
    Write-Compare -Label "Assignments to be created:" -Object $compare -SideIndicator "=>" -Prefix "+"
    Write-Compare -Label "Assignments to be updated:" -Object $compare -SideIndicator "==" -Prefix "*"
    Write-Compare -Label "Assignments to be deleted:" -Object $compare -SideIndicator "<=" -Prefix "-"

    if ($compare | Where-Object SideIndicator -EQ "<=") {
        Write-Error "Delete detected. Manual intervention required."
    }
}

function Get-AssignmentGroup {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "", Justification = "False positive (Prefix)")]
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $Path,

        [Parameter(Mandatory = $true)]
        [String]
        $Prefix
    )

    $assignments = Get-ChildItem -Path $Path -Directory -Recurse | Sort-Object -Property FullName
    $root = Get-Item -Path $Path
    $assignments += $root
    $assignments | Sort-Object FullName | ForEach-Object {
        $managementGroupId = ($PSItem.FullName.Substring($root.FullName.Length) -replace "[\\/]", " ").Trim() -replace " ", "-"
        @{
            Path              = $PSItem.FullName
            ManagementGroupId = $managementGroupId ? "$Prefix-$managementGroupId" : $Prefix
        }
    }
}

Get-AssignmentGroup -Path "$PSScriptRoot/../assignments" -Prefix $Prefix | ForEach-Object {
    $path = $PSItem.Path
    $managementGroupId = $PSItem.ManagementGroupId
    $managementGroup = Get-AzManagementGroup -GroupName $managementGroupId
    $cloud = Get-AzPolicyAssignment -Scope $managementGroup.Id | Where-Object { $PSItem.Properties.Scope -eq $managementGroup.Id } | Select-Object -ExpandProperty Name
    $source = Get-ResourceNameFromTemplate -Path $path -Pattern "policyAssignmentName: '(.+)'"
    Compare-Item -Source $source -Cloud $cloud -ManagementGroupId $managementGroupId
}
