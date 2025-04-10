@echo off

echo.
echo Activando DisableDynamicPstate, ShaderCache y desactivando ULPS

for /f %%i in ('powershell -Command "Get-CimInstance Win32_VideoController | ForEach-Object { $_.PNPDeviceID }"') do (
    for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\ControlSet001\Enum\%%i" /v "Driver" 2^>nul') do (
        for /f %%j in ('echo %%a ^| findstr "{"') do (
            Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%j" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f > nul 2>&1
            Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%j" /v "EnableUlps" /t REG_DWORD /d "0" /f > nul 2>&1
            Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%j" /v "EnableUlps_NA" /t REG_DWORD /d "0" /f > nul 2>&1
            Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%j\UMD" /v "ShaderCache" /t REG_BINARY /d "3200" /f > nul 2>&1
        )
    )
)

echo.
echo Desactivando MPO
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d 5 /f 

echo.
echo Configurando TDR
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d 3 /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d 8 /f 

echo.
echo Activando HAGS
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 1 /f

echo.
echo Todos los cambios han sido realizados. Reinicia tu PC para que los cambios surtan efecto.
pause
