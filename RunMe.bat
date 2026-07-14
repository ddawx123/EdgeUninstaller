@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ==================== UAC 管理員權限提升 ====================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [需要管理員權限] 正在請求提升權限...
    powershell.exe -Command "Start-Process -Verb RunAs -FilePath '%~f0'"
    exit /b
)

echo ========================================
echo   Edge / WebView2 / Copilot 移除工具
echo ========================================
echo.

:: ==================== 步驟1：取得 Uninstall 變數 ====================
powershell.exe -ExecutionPolicy Bypass -File "%~dp0Get-UninstallInfo.ps1"

if not exist "%TEMP%\EdgeUninstallVars.bat" (
    echo [錯誤] 找不到變數檔！
    pause
    exit /b 1
)

call "%TEMP%\EdgeUninstallVars.bat"

:: ==================== 步驟2：處理 Copilot ====================
echo ========================================
echo [Copilot] 開始處理...
echo ========================================

if defined CopilotUninstallString (
    if not "!CopilotUninstallString!"=="" (
        set "uninstallCmd=!CopilotUninstallString!"
        echo !uninstallCmd! | findstr /i "--force-uninstall" >nul
        if errorlevel 1 set "uninstallCmd=!uninstallCmd! --force-uninstall"
        
        echo [執行指令] !uninstallCmd!
        cmd /c !uninstallCmd!
        echo [返回碼] !errorlevel!
    )
)

:: ==================== 步驟3：替換 Edge / EdgeWebView 的 setup.exe ====================
powershell.exe -ExecutionPolicy Bypass -File "%~dp0Replace-SetupExe.ps1"

:: ==================== 步驟4：執行 Edge 與 EdgeWebView 移除 ====================
echo.
echo ========================================
echo [準備執行] 先終止相關進程...
echo ========================================
taskkill /f /im SearchHost.exe >nul 2>&1
taskkill /f /im msedgewebview2.exe >nul 2>&1

:: Edge
echo.
echo [Edge] 開始處理...
if defined EdgeUninstallString (
    if not "!EdgeUninstallString!"=="" (
        set "uninstallCmd=!EdgeUninstallString!"
        echo !uninstallCmd! | findstr /i "--force-uninstall" >nul
        if errorlevel 1 set "uninstallCmd=!uninstallCmd! --force-uninstall"
        echo [執行指令] !uninstallCmd!
        cmd /c !uninstallCmd!
        echo [返回碼] !errorlevel!
    )
)

:: EdgeWebView
echo.
echo [EdgeWebView] 開始處理...
if defined WebViewUninstallString (
    if not "!WebViewUninstallString!"=="" (
        set "uninstallCmd=!WebViewUninstallString!"
        echo !uninstallCmd! | findstr /i "--force-uninstall" >nul
        if errorlevel 1 set "uninstallCmd=!uninstallCmd! --force-uninstall"
        echo [執行指令] !uninstallCmd!
        cmd /c !uninstallCmd!
        echo [返回碼] !errorlevel!
    )
)

taskkill /f /im SearchHost.exe >nul 2>&1

:: ==================== 最後一步：使用 PowerShell 刪除 Microsoft 目錄（已修正不存在情況） ====================
echo.
echo ========================================
echo [最終清理] 嘗試刪除 Edge 相關目錄...
echo ========================================

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
    "$target = '%ProgramFiles(x86)%\Microsoft';" ^
    "Write-Host \"正在檢查目錄：$target\" -ForegroundColor Cyan;" ^
    "if (-not (Test-Path $target)) {" ^
    "    Write-Host '[資訊] 目錄不存在，無需刪除。' -ForegroundColor Green;" ^
    "    exit 0;" ^
    "}" ^
    "Write-Host \"正在嘗試刪除：$target\" -ForegroundColor Cyan;" ^
    "try {" ^
    "    Remove-Item -Path $target -Recurse -Force -ErrorAction Stop;" ^
    "    Write-Host '[成功] 已成功刪除目錄' -ForegroundColor Green;" ^
    "} catch {" ^
    "    Write-Host '[第一次刪除失敗] 再次終止 SearchHost.exe 後重試...' -ForegroundColor Yellow;" ^
    "    taskkill /f /im SearchHost.exe | Out-Null;" ^
    "    Start-Sleep -Milliseconds 800;" ^
    "    try {" ^
    "        Remove-Item -Path $target -Recurse -Force -ErrorAction Stop;" ^
    "        Write-Host '[成功] 第二次嘗試已成功刪除目錄' -ForegroundColor Green;" ^
    "    } catch {" ^
    "        Write-Host '';" ^
    "        Write-Host '[警告] Edge 相關目錄未完全移除，建議手動前往以下目錄處理：' -ForegroundColor Red;" ^
    "        Write-Host $target -ForegroundColor Yellow;" ^
    "    }" ^
    "}"

echo.
echo ========================================
echo 所有處理已完成
echo ========================================
pause