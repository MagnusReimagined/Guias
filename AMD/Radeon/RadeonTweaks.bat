@echo off

echo.
echo Forzando P0 y desactivando ULPS
set "cambioRealizado=0"
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID ^| findstr /L "PCI\VEN_"') do (
    for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\ControlSet001\Enum\%%i" /v "Driver" 2^>nul') do (
        for /f %%j in ('echo %%a ^| findstr "{"') do (
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%j" /v "DisableDynamicPstate" /t REG_DWORD /d 1 /f  2>&1
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%j" /v "EnableUlps" /t REG_DWORD /d 0 /f  2>&1
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%j" /v "EnableUlps_NA" /t REG_DWORD /d 0 /f  2>&1
            set "cambioRealizado=1"
        )
    )
)

if "%cambioRealizado%"=="1" (
    echo.
) else (
    echo No se realizaron cambios. Asegúrate de tener privilegios de administrador o de que los controladores sean detectados correctamente.
)

echo.
echo Desactivando MPO
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d 5 /f 

echo.
echo Configurando TDR
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d 3 /f 
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d 8 /f 

echo.
echo Activando HAGS
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 1 /f

echo.
echo Todos los cambios han sido realizados. Reinicia tu PC para que los cambios surtan efecto.
pause
