[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $Folder,

    [Parameter(Mandatory = $true)]
    [String]
    [ValidateNotNullOrEmpty()]
    $ManagementGroupId
)

function Write-Compare($Object, $SideIndicator, $Label, $Prefix, $ErrorMessage) {
    $output = $Object | Where-Object SideIndicator -eq $SideIndicator | ForEach-Object { "$Prefix $($PSItem.InputObject)" }

    if ($output) {
        Write-Output $Label
        Write-Output $output
        Write-Output ""

        if ($ErrorMessage) {
            Write-Error $ErrorMessage
        }
    }
}

$assignmentsFolder = Join-Path -Path $PSScriptRoot -ChildPath "../assignments/$Folder"

$source = Get-ChildItem -Path $assignmentsFolder -Filter "*.bicep" | ForEach-Object {
    $name = $PSItem | Get-Content -Raw | Select-String -Pattern "policyAssignmentName: '(.+)'"
    $name.Matches.Groups[1].Value
}

$cloud = Get-AzPolicyAssignment -Scope "/providers/Microsoft.Management/managementGroups/$ManagementGroupId" |
Where-Object ResourceId -Match "^/providers/Microsoft.Management/managementGroups/$ManagementGroupId/" |
Select-Object -ExpandProperty Name

$compare = Compare-Object -ReferenceObject ($cloud ?? @()) -DifferenceObject ($source ?? @()) -IncludeEqual

Write-Compare -Object $compare -SideIndicator "=>" -Label "Assignments to be created:" -Prefix "+"
Write-Compare -Object $compare -SideIndicator "==" -Label "Assignments to be updated:" -Prefix "*"
Write-Compare -Object $compare -SideIndicator "<=" -Label "Assignments to be deleted:" -Prefix "-" -ErrorMessage "Delete detected. Manual intervention required."
