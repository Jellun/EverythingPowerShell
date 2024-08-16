#This script install or updates Configuration files on a list of remote machines

$list = New-Object Collections.Generic.List[String]
$list.Add("BXXX001")
$list.Add("BXXX001")
$list.Add("BXXX001")

$Source = "\\sample.com\technology\Software\VizrtNLEplugin\ConfigFile\Vizrt"
Write-Host "Source: $Source"

foreach ($aHost in $list) {
   $Destination = "\\$aHost\C$\Users\*\AppData\Roaming"
   Write-Host $Destination
   Get-ChildItem $Destination | ForEach-Object {Write-Host "Copying source to $_"; Copy-Item -Path $Source -Destination $_ -Force -Recurse}
}
