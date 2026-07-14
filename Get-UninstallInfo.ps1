# Get-UninstallInfo.ps1
# 適用於 Windows 10 / Windows 11
# 第一步：自動獲取 Microsoft Edge、Edge WebView2、Copilot 的 UninstallString 或 setup.exe 路徑
# 已修正語法錯誤版本

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "SilentlyContinue"
Set-StrictMode -Version Latest

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Microsoft Edge / WebView2 / Copilot   " -ForegroundColor Cyan
Write-Host "        Uninstall 資訊擷取工具 (第一步)   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$regPaths = @(
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
)

function Get-UninstallFromRegistry {
    param([string]$Pattern)
    foreach ($path in $regPaths) {
        $result = Get-ChildItem -Path $path -ErrorAction SilentlyContinue |
                  Get-ItemProperty |
                  Where-Object { $_.DisplayName -like $Pattern } |
                  Select-Object -First 1
        if ($result) { return $result }
    }
    return $null
}

function Find-SetupExe {
    param(
        [string[]]$BasePaths,
        [string]$Keyword
    )
    foreach ($base in $BasePaths) {
        if (Test-Path $base) {
            $found = Get-ChildItem -Path $base -Recurse -Filter "setup.exe" -ErrorAction SilentlyContinue |
                     Where-Object { 
                         $_.FullName -like "*$Keyword*" -or 
                         $_.DirectoryName -like "*\Installer*" 
                     } |
                     Select-Object -First 1 -ExpandProperty FullName
            if ($found) { return $found }
        }
    }
    return $null
}

# ==================== Microsoft Edge ====================
Write-Host "[1/3] 正在查詢 Microsoft Edge ..." -ForegroundColor Yellow
$edgeReg = Get-UninstallFromRegistry -Pattern "Microsoft Edge"
$EdgeUninstallString = $null
$EdgeSetupPath = $null

if ($edgeReg -and $edgeReg.UninstallString) {
    $EdgeUninstallString = $edgeReg.UninstallString.Trim()
    Write-Host "  ✓ 從註冊表找到 UninstallString：" -ForegroundColor Green
    Write-Host "    $EdgeUninstallString" -ForegroundColor White
} else {
    Write-Host "  ✗ 註冊表未找到，開始檔案搜尋..." -ForegroundColor Yellow
    $edgePaths = @(
        "$env:ProgramFiles\Microsoft\Edge",
        "$env:ProgramFiles(x86)\Microsoft\Edge"
    )
    $EdgeSetupPath = Find-SetupExe -BasePaths $edgePaths -Keyword "Edge"
    if ($EdgeSetupPath) {
        Write-Host "  ✓ 找到 setup.exe：" -ForegroundColor Green
        Write-Host "    $EdgeSetupPath" -ForegroundColor White
    } else {
        Write-Host "  ✗ 未找到 Edge 的 setup.exe" -ForegroundColor Red
    }
}

# ==================== Microsoft Edge WebView2 ====================
Write-Host "`n[2/3] 正在查詢 Microsoft Edge WebView2 ..." -ForegroundColor Yellow
$webviewReg = Get-UninstallFromRegistry -Pattern "*Edge WebView2*"
$WebViewUninstallString = $null
$WebViewSetupPath = $null

if ($webviewReg -and $webviewReg.UninstallString) {
    $WebViewUninstallString = $webviewReg.UninstallString.Trim()
    Write-Host "  ✓ 從註冊表找到 UninstallString：" -ForegroundColor Green
    Write-Host "    $WebViewUninstallString" -ForegroundColor White
} else {
    Write-Host "  ✗ 註冊表未找到，開始檔案搜尋..." -ForegroundColor Yellow
    $webviewPaths = @(
        "$env:ProgramFiles\Microsoft\EdgeWebView",
        "$env:ProgramFiles(x86)\Microsoft\EdgeWebView",
        "$env:ProgramFiles\Microsoft\Edge WebView",
        "$env:ProgramFiles(x86)\Microsoft\Edge WebView"
    )
    $WebViewSetupPath = Find-SetupExe -BasePaths $webviewPaths -Keyword "WebView"
    if ($WebViewSetupPath) {
        Write-Host "  ✓ 找到 setup.exe：" -ForegroundColor Green
        Write-Host "    $WebViewSetupPath" -ForegroundColor White
    } else {
        Write-Host "  ✗ 未找到 WebView2 的 setup.exe" -ForegroundColor Red
    }
}

# ==================== Microsoft Copilot ====================
Write-Host "`n[3/3] 正在查詢 Microsoft Copilot ..." -ForegroundColor Yellow
$copilotReg = Get-UninstallFromRegistry -Pattern "*Copilot*"
$CopilotUninstallString = $null

if ($copilotReg -and $copilotReg.UninstallString) {
    $CopilotUninstallString = $copilotReg.UninstallString.Trim()
    Write-Host "  ✓ 從註冊表找到 UninstallString：" -ForegroundColor Green
    Write-Host "    $CopilotUninstallString" -ForegroundColor White
} else {
    Write-Host "  ✗ 註冊表中未找到 Microsoft Copilot" -ForegroundColor Yellow
    Write-Host "    (Copilot 通常為 Windows Appx 套件或系統整合功能，無法用傳統 UninstallString 移除)" -ForegroundColor DarkYellow
    
    $copilotAppx = Get-AppxPackage -Name "*Copilot*" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($copilotAppx) {
        Write-Host "    發現 Appx 套件：$($copilotAppx.Name) (版本 $($copilotAppx.Version))" -ForegroundColor Cyan
    }
}

# ==================== 產生變數檔（供主 .bat 使用） ====================
$varFile = "$env:TEMP\EdgeUninstallVars.bat"

$varContent = @(
    '@echo off',
    'REM 由 Get-UninstallInfo.ps1 自動產生 - 已修正版',
    "set `"EdgeUninstallString=$EdgeUninstallString`"",
    "set `"WebViewUninstallString=$WebViewUninstallString`"",
    "set `"CopilotUninstallString=$CopilotUninstallString`"",
    "set `"EdgeSetupPath=$EdgeSetupPath`"",
    "set `"WebViewSetupPath=$WebViewSetupPath`""
)

$varContent | Set-Content -Path $varFile -Encoding ASCII -Force

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "變數已寫入暫存檔：" -ForegroundColor Green
Write-Host "  $varFile" -ForegroundColor White
Write-Host ""
Write-Host "您可以在主 .bat 檔中使用以下指令載入變數：" -ForegroundColor Yellow
Write-Host "  call `"$varFile`"" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan

# 輸出摘要
Write-Host "`n【最終摘要】" -ForegroundColor Magenta
Write-Host "EdgeUninstallString    = $EdgeUninstallString"
Write-Host "WebViewUninstallString = $WebViewUninstallString"
Write-Host "EdgeSetupPath          = $EdgeSetupPath"
Write-Host "WebViewSetupPath       = $WebViewSetupPath"