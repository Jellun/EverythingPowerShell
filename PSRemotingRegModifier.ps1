# This script modifies remote hosts registry keys and values to EnableActiveProbing
# Can be modified to manipulate any registry key and value
# Can be modified to run other remote PS commands
# Note that Windows Remote Management (WS-Management) service needs to be running on the remote hosts
# Run Enable-PSRemoting as admin on the remote hosts if needed
# Run a command prompt as admin and enter the following command and confirm whether the IPv4Filter or IPv6Filter is configured to block the IP
# winrm get winrm/config
# By Jun Ye - 13/07/2022

$creds = Get-Credential

#Region
$computers = @(
"remotehost01"
"remotehost02"
)

# Remotely start WS-Management service
$computers | Foreach-Object {
	Write-Host "PSRemoting on $_"
	Get-Service -ComputerName $_ -Name "WinRM" | Restart-Service -Force
}

$computers | Foreach-Object {
    $params = @{
        "ComputerName" = $_
        "ScriptBlock"  = {
            $regkey = "HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet"
            $regparam = "EnableActiveProbing"
            if(!(Test-Path $regkey)){
                New-Item $regkey -Force;
            }

            if (Get-ItemProperty -Path $regkey -Name $regparam -ErrorAction Ignore) {
                Set-ItemProperty -Path $regkey -Name $regparam -Value 1;
            }
            else {
                New-ItemProperty -Path $regkey -Name $regparam -Value 1  -PropertyType "DWord";
            }
        }
    }
    Invoke-Command @params -Credential $creds
}
#EndRegion