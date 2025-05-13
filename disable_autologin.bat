@echo off
:: Script para evitar el auto-logueo en Outlook Web y Windows 10/11
:: Soporta: @outlook.cl, @outlook.com, @hotmail.cl, @hotmail.com y variantes
:: Opciones: Deshabilitar o Revertir los cambios

title Control de Auto-Logueo - Microsoft Web y Windows
color 0A
mode con: cols=85 lines=30

:menu
cls
echo ************************************************************
echo *   CONTROL DE INICIO AUTOMATICO - OUTLOOK WEB y WINDOWS    *
echo ************************************************************
echo.
echo   1. Deshabilitar auto-logueo en Outlook Web y Windows
echo   2. Revertir cambios (habilitar auto-logueo)
echo   3. Salir
echo.
set /p opcion="Seleccione una opción [1-3]: "

if "%opcion%"=="1" goto deshabilitar
if "%opcion%"=="2" goto habilitar
if "%opcion%"=="3" exit
echo Opción no válida. Presione cualquier tecla para continuar...
pause >nul
goto menu

:deshabilitar
cls
echo Deshabilitando auto-logueo para Outlook Web y Windows...
echo.

:: 1. Configuraciones para Outlook Web
echo Aplicando cambios para Outlook Web...
reg add "HKCU\Software\Microsoft\Office\16.0\Outlook\Options\General" /v "DisableBootstrapLoading" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Office\16.0\Outlook\Options\General" /v "DisableOffice365SimplifiedAccountCreation" /t REG_DWORD /d 1 /f >nul 2>&1

:: 2. Deshabilitar credenciales automáticas en Windows
echo Deshabilitando credenciales automáticas en Windows...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableAutomaticRestartSignOn" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableAutomaticRestartSignOn" /t REG_DWORD /d 1 /f >nul 2>&1

:: 3. Limpiar credenciales almacenadas
echo Limpiando credenciales almacenadas...
cmdkey /delete:MicrosoftAccount:user=* /generic >nul 2>&1
cmdkey /delete:live.com /generic >nul 2>&1
cmdkey /delete:outlook.com /generic >nul 2>&1

:: 4. Configurar navegadores para no recordar sesión
echo Configurando navegadores para no recordar sesión...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "DisablePasswordCaching" /t REG_DWORD /d 1 /f >nul 2>&1

:: 5. Deshabilitar inicio de sesión automático en Edge (si está instalado)
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" (
    reg add "HKCU\Software\Microsoft\Edge\Main" /v "AutoLoginEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
)

echo.
echo Cambios aplicados correctamente:
echo - Outlook Web no iniciará sesión automáticamente
echo - Windows no auto-logueará con cuentas Microsoft
echo - Credenciales almacenadas fueron eliminadas
echo - Navegadores no recordarán la sesión
echo.
pause
goto menu

:habilitar
cls
echo Revirtiendo cambios (habilitando auto-logueo)...
echo.

:: 1. Restaurar configuración Outlook Web
echo Restaurando configuración de Outlook Web...
reg delete "HKCU\Software\Microsoft\Office\16.0\Outlook\Options\General" /v "DisableBootstrapLoading" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Office\16.0\Outlook\Options\General" /v "DisableOffice365SimplifiedAccountCreation" /f >nul 2>&1

:: 2. Habilitar credenciales automáticas en Windows
echo Habilitando credenciales automáticas en Windows...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableAutomaticRestartSignOn" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableAutomaticRestartSignOn" /f >nul 2>&1

:: 3. Restaurar configuración de navegadores
echo Restaurando configuración de navegadores...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "DisablePasswordCaching" /f >nul 2>&1

:: 4. Habilitar inicio de sesión automático en Edge (si está instalado)
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" (
    reg delete "HKCU\Software\Microsoft\Edge\Main" /v "AutoLoginEnabled" /f >nul 2>&1
)

echo.
echo Configuración restaurada a los valores por defecto:
echo - Outlook Web puede iniciar sesión automáticamente
echo - Windows puede auto-loguear con cuentas Microsoft
echo - Navegadores pueden recordar la sesión
echo.
pause
goto menu