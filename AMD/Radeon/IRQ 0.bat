@echo off
wmic path Win32_PnPEntity where "name='Temporizador de eventos de alta precisión'" call disable
wmic path Win32_PnPEntity where "name='High precision event timer'" call disable
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\msisadrv" /v Start /t REG_DWORD /d 4 /f
echo Los cambios se completaron con exito. Reinicie su sistema.
pause
