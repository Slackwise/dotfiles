set CSS_CFG_DIR="C:\Program Files (x86)\Steam\userdata\19911248\240\remote\cfg"

copy /y %CSS_CFG_DIR%\config.cfg . &&^
 rmdir /s /q %CSS_CFG_DIR &&^
 mklink /d %CSS_CFG_DIR% .

pause
