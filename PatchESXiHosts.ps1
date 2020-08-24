# Select which vCenter you want to connect to
$vcenter = Read-Host "What vCenter server would you like to connect to: "

Connect-VIServer $vcenter

# List hosts to select
Write-Host ""
Write-Host "Choose which host to deploy patches to: "
Write-Host ""
$IHOST = Get-VMHost | Select-Object Name | Sort-Object Name
$i = 1
$IHOST | ForEach-Object{Write-Host $i": " $_.Name; $i++}
$DSHost = Read-Host "Enter the number for the host to patch: "
$SHOST = $IHOST[$DSHost - 1].Name
Write-Host "You have selected $($SHOST)."

# List patch baselines to select
Write-Host ""
Write-Host "Choose which patch baseline to apply: "
Write-Host ""
$IBASELINE = Get-Baseline | Select-Object Name | Sort Name
$i = 1
$IBASELINE | ForEach-Object{Write-Host $i": " $_.Name; $i++}
$DSBaseline = Read-Host "Enter the number for the baseline to apply: "
$SBASELINE = $IBASELINE[$DSBaseline - 1].Name
Write-Host "You have selected $($SBASELINE)"

# Scan selected host
Test-Compliance -Entity $SHOST

# Display compliance results and wait 15 seconds
Get-Compliance -Entity $SHOST
Start-Sleep -s 15

# Place selected host into maintenance mode
Write-Host "Placing $($SHOST) in maintenance mode"
Get-VMHost -Name $SHOST | Set-VMHost -State Maintenance

# Remediate selected host
Get-Baseline -Name $SBASELINE | Update-Entity -Entity $SBASELINE -confirm:$false

# Remove selected host from maintenance mode
Write-Host "Removing host from maintenance mode"
Get-VMHost -Name $SHOST | Set-VMHost -State Connected

# Display popup when finished
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.MessageBox]::Show("The patching for $($HOST) is now complete")