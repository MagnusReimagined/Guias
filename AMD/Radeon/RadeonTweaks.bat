@echo off

echo.
echo Forzando P0 y desactivando ULPS...

set "cambioRealizado=0"

for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
    for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\ControlSet001\Enum\%%i" /v "Driver" 2^>nul') do (
        for /f %%j in ('echo %%a ^| findstr "{"') do (
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%j" /v "DisableDynamicPstate" /t REG_DWORD /d 1 /f >nul 2>&1
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%j" /v "EnableUlps" /t REG_DWORD /d 0 /f >nul 2>&1
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%j" /v "EnableUlps_NA" /t REG_DWORD /d 0 /f >nul 2>&1
            set "cambioRealizado=1"
        )
    )
)

if "%cambioRealizado%"=="1" (
    echo La operación se completó correctamente.
) else (
    echo No se realizaron cambios.
)

echo.

echo.
echo Desactivando MPO
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d 5 /f >nul

echo.
echo Configurando TDR
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d 3 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d 8 /f >nul

echo.
echo Activando HAGS
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 1 /f >nul

echo.
echo Cambios hechos. Reinicia tu PC para aplicar los cambios.
pause
