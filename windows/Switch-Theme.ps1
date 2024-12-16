# Define registry keys and values for light/dark mode
$themeKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$dwmKey = "HKCU:\Software\Microsoft\Windows\DWM"
$appsUseLightTheme = "AppsUseLightTheme"
$lightTheme = 1
$darkTheme = 0

# Get the current AppsUseLightTheme value
$currentMode = (Get-ItemProperty -Path $themeKey -Name $appsUseLightTheme).$appsUseLightTheme

if ($currentMode -eq $lightTheme) {
    # Currently in light mode, switch to dark mode
    Set-ItemProperty -Path $themeKey -Name $appsUseLightTheme -Value $darkTheme
    # Uncomment to also switch system theme
    # Set-ItemProperty -Path $themeKey -Name "SystemUsesLightTheme" -Value $darkTheme
    Write-Host "Switched to dark mode."
} else {
    # Currently in dark mode, switch to light mode
    Set-ItemProperty -Path $themeKey -Name $appsUseLightTheme -Value $lightTheme
    # Uncomment to also switch system theme
    # Set-ItemProperty -Path $themeKey -Name "SystemUsesLightTheme" -Value $lightTheme
    Write-Host "Switched to light mode."
}

# Update the DWM color settings
Set-ItemProperty -Path $dwmKey -Name "ColorPrevalence" -Value 0

# Force an update by refreshing the theme
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class User32 {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern void UpdatePerUserSystemParameters();
}
"@
[User32]::UpdatePerUserSystemParameters()

# Refresh Desktop Ability
# $definition = @'
#     [System.Runtime.InteropServices.DllImport("Shell32.dll")] 
#     private static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);
#     public static void Refresh() {
#         SHChangeNotify(0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero);    
#     }
# '@
# Add-Type -MemberDefinition $definition -Namespace WinAPI -Name Explorer

# Refresh desktop icons
# [WinAPI.Explorer]::Refresh()

# Define the P/Invoke method
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class NativeMethods
{
    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr SendMessageTimeout(
        IntPtr hWnd, 
        int Msg, 
        IntPtr wParam, 
        string lParam, 
        uint fuFlags, 
        uint uTimeout, 
        IntPtr lpdwResult);
}
"@ -PassThru

# Constants
$HWND_BROADCAST = [IntPtr]::new(0xffff)
$WM_SETTINGCHANGE = 0x1a
$SMTO_ABORTIFHUNG = 0x0002

# # Call the SendMessageTimeout function
# [NativeMethods]::SendMessageTimeout(
#     $HWND_BROADCAST,
#     $WM_SETTINGCHANGE,
#     [IntPtr]::Zero,
#     $null,
#     $SMTO_ABORTIFHUNG,
#     100,
#     [IntPtr]::Zero
# )

# Notify Explorer about the theme change
[NativeMethods]::SendMessageTimeout(
    $HWND_BROADCAST,
    $WM_SETTINGCHANGE,
    [IntPtr]::Zero,
    "ImmersiveColorSet",
    $SMTO_ABORTIFHUNG,
    100,
    [IntPtr]::Zero
)

# Check Windows version and restart Explorer only if Windows 11
# $buildNumber = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "CurrentBuildNumber").CurrentBuildNumber
# if ($buildNumber -ge 22000) {
#     Write-Host "Windows 11 detected; restarting Explorer to apply theme changes..."
#     Stop-Process -Name "explorer" -Force
#     Start-Process "explorer"
# }
