<#
.DESCRIPTION
Remove all policies in a management group hierarchy starting from prefix
#>
[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $Prefix
)

$hierarchy = @(
    $Prefix
    "$Prefix-platform"
    "$Prefix-platform-management"
    "$Prefix-platform-connectivity"
    "$Prefix-platform-identity"
    "$Prefix-landing-zones"
    "$Prefix-landing-zones-corp"
    "$Prefix-landing-zones-online"
    "$Prefix-landing-zones-online-onboarding"
    "$Prefix-sandbox"
    "$Prefix-decommissioned"
)

Get-AzManagementGroup | Where-Object Name -in $hierarchy |
Sort-Object Name -Descending |
ForEach-Object {
    $scope = $PSItem.Id
    $displayName = $PSItem.DisplayName

    Write-Output "Removing policy assignments from management group '$displayName'..."

    Get-AzPolicyAssignment -Scope $scope |
    Where-Object { $PSItem.Scope -eq $scope } |
    ForEach-Object {
        Write-Output "- $($PSItem.Id)"
        Remove-AzPolicyAssignment -Name $PSItem.Name -Scope $scope | Out-Null
    }
}

$managementGroup = Get-AzManagementGroup -GroupName $Prefix
$displayName = $managementGroup.DisplayName

Write-Output "Removing initiatives from management group '$displayName'..."

Get-AzPolicySetDefinition -ManagementGroupName $Prefix -Custom |
Where-Object Id -Match "^/providers/Microsoft.Management/managementGroups/$Prefix/" |
ForEach-Object {
    Write-Output "- $($PSItem.Id)"
    Remove-AzPolicySetDefinition -Name $PSItem.Name -ManagementGroupName $Prefix -Force | Out-Null
}

Write-Output "Removing policy definitions from management group '$displayName'..."

Get-AzPolicyDefinition -ManagementGroupName $Prefix -Custom |
Where-Object Id -Match "^/providers/Microsoft.Management/managementGroups/$Prefix/" |
ForEach-Object {
    Write-Output "- $($PSItem.Id)"
    Remove-AzPolicyDefinition -Name $PSItem.Name -ManagementGroupName $Prefix -Force | Out-Null
}
