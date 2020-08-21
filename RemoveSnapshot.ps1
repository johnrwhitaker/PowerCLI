# Get a list of snapshots with their parents
$VMName = ""
Get-VM $VMName | Get-Snapshot | Select Name, Description, Created, Parent

# Remove snapshot, remember that deleting a snapshot that is a parent will delete its children
$SnaphotNameToRemove = ""
Get-VM $VMName | Get-Snapshot $SnaphotNameToRemove | Remove-Snapshot -Confirm:$false
