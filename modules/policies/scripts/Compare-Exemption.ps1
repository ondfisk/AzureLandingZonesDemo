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
    $name = $PSItem | Get-Content -Raw | Select-String -Pattern "policyExemptionName: '(.+)'"
    if ($name.Matches.Groups) {
        $name.Matches.Groups[1].Value
    }
}

$cloud = Get-AzPolicyExemption -Scope "/providers/Microsoft.Management/managementGroups/$ManagementGroupId" |
Where-Object Id -Match "/providers/Microsoft.Management/managementGroups/$ManagementGroupId/providers/Microsoft.Authorization/policyExemptions" |
Select-Object -ExpandProperty Name

$compare = Compare-Object -ReferenceObject ($cloud ?? @()) -DifferenceObject ($source ?? @()) -IncludeEqual

Write-Compare -Object $compare -SideIndicator "=>" -Label "Exemptions to be created:" -Prefix "+"
Write-Compare -Object $compare -SideIndicator "==" -Label "Exemptions to be updated:" -Prefix "*"
Write-Compare -Object $compare -SideIndicator "<=" -Label "Exemptions to be deleted:" -Prefix "-" -ErrorMessage "Delete detected. Manual intervention required."
