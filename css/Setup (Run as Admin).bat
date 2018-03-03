set CSS_CFG_DIR="C:\Program Files (x86)\Steam\userdata\19911248\240\remote\cfg"
set DOTFILES_DIR="C:\Users\Slackwise\src\dotfiles\css"

copy /y %CSS_CFG_DIR%\* %DOTFILES_DIR% &&^
 rmdir /s /q %CSS_CFG_DIR &&^
 mklink /d %CSS_CFG_DIR% %DOTFILES_DIR%

pause
