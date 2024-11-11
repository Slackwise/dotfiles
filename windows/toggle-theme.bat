@echo off
setlocal

REM Registry keys for light/dark mode
set key=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize
set light_theme=1
set dark_theme=0

REM Get the current AppsUseLightTheme value
for /f "tokens=3" %%A in ('reg query "%key%" /v AppsUseLightTheme') do set current_mode=%%A

if "%current_mode%"=="0x1" (
    REM Currently in light mode, switch to dark mode
    reg add "%key%" /v AppsUseLightTheme /t REG_DWORD /d %dark_theme% /f
    REM reg add "%key%" /v SystemUsesLightTheme /t REG_DWORD /d %dark_theme% /f
    echo Switched to dark mode.
) else (
    REM Currently in dark mode, switch to light mode
    reg add "%key%" /v AppsUseLightTheme /t REG_DWORD /d %light_theme% /f
    REM reg add "%key%" /v SystemUsesLightTheme /t REG_DWORD /d %light_theme% /f
    echo Switched to light mode.
)

REM Force an update by refreshing the theme
RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters


REM Check Windows version and restart Explorer only if Windows 11
for /f "tokens=6 delims=[.] " %%i in ('ver') do (
    :: Check build number:
    echo "%%i"
    if %%i GEQ 22000 (
        echo Windows 11 detected; restarting Explorer to apply theme changes...
        taskkill /f /im explorer.exe
        start explorer.exe
    )
)

endlocal
