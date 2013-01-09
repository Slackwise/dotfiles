@echo off

set github_dir=%LOCALAPPDATA%\GitHub

@rem Finds the newest version of PortableGit installed by GitHub.
for /F "tokens=*" %%f in ('dir /O:D /B %github_dir%\PortableGit_*') do set git=%%f

%github_dir%\%git%\bin\curl.exe %*
