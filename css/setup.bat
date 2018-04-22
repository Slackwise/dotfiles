@echo off
set CONFIG_FILE="slackwise.cfg"
set CSS_DIR="C:\Program Files (x86)\Steam\userdata\19911248\240\remote\cfg"
set DOTFILES_DIR="C:\Users\Slackwise\src\dotfiles\css"
set CSS_FILE=%CSS_DIR%\%CONFIG_FILE%
set DOTFILE=%DOTFILES_DIR%\%CONFIG_FILE%

del %CSS_FILE%
mklink /h %CSS_FILE% %DOTFILE%

pause
