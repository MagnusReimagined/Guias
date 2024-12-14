cls
Write-Host
Write-Host "Forzando P0 y desactivando ULPS..."
$cambioRealizado = $false
Get-WmiObject Win32_VideoController | ForEach-Object {
    $pnpDeviceID = $_.PNPDeviceID
    if ($pnpDeviceID -like "PCI\VEN_*") {
        $driverKey = (Get-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Enum\$pnpDeviceID" -Name "Driver" -ErrorAction SilentlyContinue).Driver
        if ($driverKey -match "\{.*\}") {
            $guid = $Matches[0]
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\$guid" /v "DisableDynamicPstate" /t REG_DWORD /d 1 /f 
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\$guid" /v "EnableUlps" /t REG_DWORD /d 0 /f 
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\$guid" /v "EnableUlps_NA" /t REG_DWORD /d 0 /f 
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\$guid\UMD" /v "ShaderCache" /t REG_BINARY /d 3200 /f 
            $cambioRealizado = $true
        }
    }
}

if ($cambioRealizado) {
    Write-Host "La operación se completó correctamente."
} else {
    Write-Host "No se realizaron cambios."
}

Write-Host
Write-Host Desactivando MPO
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d 5 /f 

Write-Host
Write-Host Configurando TDR
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d 3 /f 
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d 8 /f 

Write-Host
Write-Host Activando HAGS
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 1 /f

Write-Host
Write-Host Todos los cambios han sido realizados. Reinicia tu PC para que los cambios surtan efecto.
