<#
.DESCRIPTION
Remove specific assignment in a management group hierarchy starting from prefix
#>
[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $Prefix,

    [Parameter(Mandatory = $true)]
    [String]
    $AssignmentName
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
    Where-Object { $PSItem.Scope -eq $scope -and $PSItem.Name -eq $AssignmentName } |
    ForEach-Object {
        Write-Output "- $($PSItem.Id)"
        Remove-AzPolicyAssignment -Name $PSItem.Name -Scope $scope | Out-Null
    }
}
