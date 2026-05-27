<#
.SYNOPSIS
Toggles between Work Mode and Game Mode for displays and taskbar settings.
Automatically downloads MultiMonitorTool to C:\bin if it doesn't exist.
#>

# 1. Function to download and install MultiMonitorTool
function Install-MultiMonitorTool {
    $binPath = "C:\bin"
    $exePath = Join-Path -Path $binPath -ChildPath "MultiMonitorTool.exe"
    $zipPath = Join-Path -Path $binPath -ChildPath "multimonitortool.zip"
    $downloadUrl = "https://www.nirsoft.net/utils/multimonitortool-x64.zip"

    # Check if the tool is already installed
    if (-Not (Test-Path -Path $exePath)) {
        Write-Host "MultiMonitorTool not found. Preparing to download to $binPath..." -ForegroundColor Cyan
        
        # Create C:\bin\ if it doesn't exist
        if (-Not (Test-Path -Path $binPath)) {
            try {
                New-Item -Path $binPath -ItemType Directory -Force | Out-Null
            } catch {
                Write-Error "Failed to create $binPath. Please run this script as Administrator."
                return $false
            }
        }

        try {
            Write-Host "Downloading from NirSoft..." -ForegroundColor DarkGray
            Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -UseBasicParsing
            
            Write-Host "Extracting files..." -ForegroundColor DarkGray
            Expand-Archive -Path $zipPath -DestinationPath $binPath -Force
            
            Write-Host "Cleaning up zip file..." -ForegroundColor DarkGray
            Remove-Item -Path $zipPath -Force
            
            Write-Host "MultiMonitorTool successfully installed!" -ForegroundColor Green
        } catch {
            Write-Error "Failed to download or extract MultiMonitorTool. Check your internet connection or run as Administrator."
            return $false
        }
    }
    return $true
}

# 2. Function to check the current taskbar state
function Get-TaskbarMode {
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $currentState = (Get-ItemProperty -Path $regPath -Name "MMTaskbarEnabled" -ErrorAction SilentlyContinue).MMTaskbarEnabled
    
    # 1 means taskbar is on all displays. 0 or null means main display only.
    if ($currentState -eq 1) {
        return 'All'
    } else {
        return 'Main'
    }
}

# 3. Function to set the taskbar display mode
function Set-TaskbarMode {
    param (
        [ValidateSet('All', 'Main')]
        [string]$Mode
    )
    
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

    if ($Mode -eq 'All') {
        Write-Host "Taskbar: Configuring to show on ALL displays..." -ForegroundColor DarkGray
        Set-ItemProperty -Path $regPath -Name "MMTaskbarEnabled" -Value 1
    } else {
        Write-Host "Taskbar: Configuring to show on MAIN display only..." -ForegroundColor DarkGray
        Set-ItemProperty -Path $regPath -Name "MMTaskbarEnabled" -Value 0
    }

    Write-Host "Restarting Windows Explorer to apply taskbar changes (your screen will flash briefly)..." -ForegroundColor DarkGray
    Stop-Process -Name explorer -Force
    Start-Sleep -Seconds 2
}

# 4. Function to set the main display by name
function Set-MainDisplay {
    param (
        [string]$MonitorName
    )
    
    $ToolPath = "C:\bin\MultiMonitorTool.exe"

    Write-Host "Display: Setting primary monitor to '$MonitorName'..." -ForegroundColor DarkGray
    
    # Calls the utility with the /SetPrimary argument and waits for it to finish
    Start-Process -FilePath $ToolPath -ArgumentList "/SetPrimary `"$MonitorName`"" -Wait -NoNewWindow
    return $true
}

# 5. Master Function to evaluate state and toggle modes
function Toggle-GameWorkMode {
    Write-Host "=== Display & Taskbar Mode Toggler ===" -ForegroundColor Cyan

    # Ensure our dependency is met before doing anything
    if (-Not (Install-MultiMonitorTool)) {
        Write-Warning "Aborting toggle process due to missing MultiMonitorTool."
        return
    }

    # Fetch the current state using our dedicated check function
    $currentTaskbarMode = Get-TaskbarMode

    # If taskbar is on all screens -> Currently in GAME MODE
    if ($currentTaskbarMode -eq 'All') {
        Write-Host "Current State detected as: GAME MODE" -ForegroundColor Yellow
        Write-Host "Switching to: WORK MODE" -ForegroundColor Green
        
        $displaySwitched = Set-MainDisplay -MonitorName "XENEON EDGE"
        
        if ($displaySwitched) {
            Set-TaskbarMode -Mode 'Main'
            Write-Host "Successfully switched to Work Mode!" -ForegroundColor Green
        }
    } 
    # Otherwise -> Currently in WORK MODE
    else {
        Write-Host "Current State detected as: WORK MODE" -ForegroundColor Yellow
        Write-Host "Switching to: GAME MODE" -ForegroundColor Green
        
        $displaySwitched = Set-MainDisplay -MonitorName "Odyssey G95NC"
        
        if ($displaySwitched) {
            Set-TaskbarMode -Mode 'All'
            Write-Host "Successfully switched to Game Mode!" -ForegroundColor Green
        }
    }
}

# Execute the toggle function
Toggle-GameWorkMode