#Requires AutoHotkey v2.0
#SingleInstance Force

; Set the system tray tooltip
A_IconTip := "Slackeys"

; --- CONFIGURATION VARIABLES ---
Global WorkMainDisplay := "CRXED00"   ; Xeneon Edge
Global GameMainDisplay := "SAM7474"   ; Odyssey G95NC

; Fetch the %USERPROFILE% environment variable
Global BinPath := EnvGet("USERPROFILE") . "\.bin"
Global ExePath := BinPath . "\MultiMonitorTool.exe"

Global TaskbarRegPath := "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Global ThemeRegPath := "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
Global DwmRegPath := "HKCU\Software\Microsoft\Windows\DWM"

; --- WIN32 API CONSTANTS ---
Global HWND_BROADCAST := 0xFFFF
Global WM_SETTINGCHANGE := 0x1A
Global SMTO_ABORTIFHUNG := 0x0002
Global TIMEOUT_MS := 100
; ---------------------------------------

; =======================================
; GLOBAL KEYBINDS
; =======================================

; Win + Shift + Ctrl + P : Toggles Game/Work Display Mode
^+#p::ToggleGameWorkMode()

; Win + Shift + Ctrl + O : Toggles Light/Dark Theme
^+#o::ToggleTheme()

; =======================================
; THEME FUNCTIONS
; =======================================

ToggleTheme() {
    currentMode := 1
    try {
        currentMode := RegRead(ThemeRegPath, "AppsUseLightTheme")
    } catch {
        currentMode := 1 ; Default to light if registry key is somehow missing
    }
    
    if (currentMode == 1) {
        SetTheme("Dark")
        TrayTip("Switched to Dark Mode", "Switch Theme")
    } else {
        SetTheme("Light")
        TrayTip("Switched to Light Mode", "Switch Theme")
    }
}

SetTheme(Mode) {
    ; 1 = Light Theme, 0 = Dark Theme
    themeValue := (Mode == "Light") ? 1 : 0
    
    ; Update Registry for Apps only (Taskbar/System theme remains unchanged)
    RegWrite(themeValue, "REG_DWORD", ThemeRegPath, "AppsUseLightTheme")
    
    ; Update the DWM color settings
    RegWrite(0, "REG_DWORD", DwmRegPath, "ColorPrevalence")
    
    ; Force an update by natively calling User32.dll
    DllCall("user32\UpdatePerUserSystemParameters")
    
    ; Notify Explorer about the theme change using defined constants
    DllCall("user32\SendMessageTimeout", "Ptr", HWND_BROADCAST, "UInt", WM_SETTINGCHANGE, "Ptr", 0, "Str", "ImmersiveColorSet", "UInt", SMTO_ABORTIFHUNG, "UInt", TIMEOUT_MS, "Ptr*", 0)
}

; =======================================
; DISPLAY & TASKBAR FUNCTIONS
; =======================================

ToggleGameWorkMode() {
    if !InstallMultiMonitorTool() {
        MsgBox("Failed to install MultiMonitorTool.", "Slackeys", "IconX")
        return
    }

    currentTaskbarMode := GetTaskbarMode()

    if (currentTaskbarMode == "All") {
        ; Staged FIRST: Taskbar Registry
        SetTaskbarMode(0) ; 0 = Main Display Only
        
        ; Staged SECOND: Display Switch & Refresh
        SetMainDisplay(WorkMainDisplay)
        
        TrayTip("Switched to Work Mode", "Switch Display Config")
    } else {
        ; Staged FIRST: Taskbar Registry
        SetTaskbarMode(1) ; 1 = All Displays
        
        ; Staged SECOND: Display Switch & Refresh
        SetMainDisplay(GameMainDisplay)
        
        TrayTip("Switched to Game Mode", "Switch Display Config")
    }
}

InstallMultiMonitorTool() {
    ZipPath := A_Temp . "\multimonitortool.zip"
    DownloadUrl := "https://www.nirsoft.net/utils/multimonitortool-x64.zip"

    if !FileExist(ExePath) {
        TrayTip("Downloading MultiMonitorTool...", "Slackeys Setup")
        
        if !DirExist(BinPath) {
            DirCreate(BinPath)
        }

        try {
            ; Download to Temp
            Download(DownloadUrl, ZipPath)
            
            ; Use Format() to safely inject variables into the PowerShell command without syntax conflicts
            psCmd := Format("powershell -NoProfile -Command `"Expand-Archive -Path '{1}' -DestinationPath '{2}' -Force`"", ZipPath, BinPath)
            RunWait(psCmd, , "Hide")
            
            ; Clean up the temp file
            FileDelete(ZipPath)
        } catch {
            return false
        }
    }
    return true
}

GetTaskbarMode() {
    currentState := 0
    try {
        currentState := RegRead(TaskbarRegPath, "MMTaskbarEnabled")
    } catch {
        currentState := 0
    }
    
    return (currentState == 1) ? "All" : "Main"
}

SetTaskbarMode(modeValue) {
    RegWrite(modeValue, "REG_DWORD", TaskbarRegPath, "MMTaskbarEnabled")
}

SetMainDisplay(monitorIdentifier) {
    ; Use Format() to cleanly build the execution string
    toolCmd := Format("`"{1}`" /SetPrimary `"{2}`"", ExePath, monitorIdentifier)
    RunWait(toolCmd, , "Hide")
}