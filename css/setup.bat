@echo off
set CSS_DIR="C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Source\cstrike\cfg"
set DOTFILES_DIR="C:\Users\Slackwise\src\dotfiles\css"
set CONFIG_FILE="slackwise.cfg"
set AUTOBUY_FILE="autobuy.txt"
set CT_BUY_FILE="buypresets_ct.vdf"
set T_BUY_FILE="buypresets_ter.vdf"

del %CSS_DIR%\%CONFIG_FILE% 
del %CSS_DIR%\%AUTOBUY_FILE%
del %CSS_DIR%\%CT_BUY_FILE% 
del %CSS_DIR%\%T_BUY_FILE%  

mklink /h %CSS_DIR%\%CONFIG_FILE%          %DOTFILES_DIR%\%CONFIG_FILE%
mklink /h %CSS_DIR%\%AUTOBUY_FILE%         %DOTFILES_DIR%\%AUTOBUY_FILE%
mklink /h %CSS_DIR%\%CT_BUY_FILE%          %DOTFILES_DIR%\%CT_BUY_FILE%
mklink /h %CSS_DIR%\%T_BUY_FILE%           %DOTFILES_DIR%\%T_BUY_FILE% 

echo ==============================================
echo === Make sure to set your LAUNCH OPTIONS!" ===
echo ==============================================
pause
