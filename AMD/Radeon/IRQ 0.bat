@echo off
echo.
echo Desactivando HPET
wmic path Win32_PnPEntity where "name='Temporizador de eventos de alta precisión'" call disable
wmic path Win32_PnPEntity where "name='High precision event timer'" call disable

echo.
echo Desinstalando msisadrv
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\msisadrv" /f

echo.
echo Cambios hechos, reinicie su sistema.
pause
