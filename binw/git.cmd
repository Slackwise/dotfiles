@echo off

set github_dir=%LOCALAPPDATA%\GitHub

@rem Finds the newest version of PortableGit instlled by GitHub.
for /F "tokens=*" %%f in ('dir /O:D /B %github_dir%\PortableGit_*') do set git=%%f

%github_dir%\%git%\cmd\git.exe %*
