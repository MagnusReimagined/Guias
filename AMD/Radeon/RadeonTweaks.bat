@echo off

echo.
echo Activando P0
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
    for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\ControlSet001\Enum\%%i" /v "Driver"') do (
        for /f %%i in ('echo %%a ^| findstr "{"') do (
            Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f > nul 2>&1
            set "cambioRealizado=1"
        )
    )
)

if %cambioRealizado%==1 (
    echo La operacion se completo correctamente.
) else (
    echo No se realizaron cambios.
)

echo.
Echo Desactivando MPO
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d 5 /f

echo.
echo Configurando TDR 
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d 3 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d 8 /f

echo.
echo Desactivando HAGS
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 0 /f

echo.
echo Desactivando ULPS
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AMDKMDAG" /v "EnableUlps" /t REG_DWORD /d 0 /f

echo.
Echo Cambios hechos, reinicia tu perfil para aplicar los cambios.
echo.
pause