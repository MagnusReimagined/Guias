@echo off
echo.
echo Desactivando HPET
powershell -Command "Get-PnpDevice | Where-Object { $_.FriendlyName -like '*High Precision Event Timer*' } | Disable-PnpDevice -Confirm:$false"
powershell -Command "Get-PnpDevice | Where-Object { $_.FriendlyName -like '*Temporizador de eventos de alta precisión*' } | Disable-PnpDevice -Confirm:$false"

echo.
echo Desinstalando msisadrv
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\msisadrv" /f

echo.
echo Cambios hechos, reinicie su sistema.
pause
