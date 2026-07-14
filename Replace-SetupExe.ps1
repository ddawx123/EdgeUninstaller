# Replace-SetupExe.ps1
param()

$ErrorActionPreference = "SilentlyContinue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Edge / WebView2 setup.exe 替換工具   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 偵測架構
$arch = $env:PROCESSOR_ARCHITECTURE
if ($arch -eq "AMD64") {
    $setupFile = "setup-amd64.exe"
} elseif ($arch -eq "ARM64") {
    $setupFile = "setup-aarch64.exe"
} else {
    Write-Host "[錯誤] 本程式不支持此處理器架構: $arch" -ForegroundColor Red
    exit 1
}
Write-Host "[架構] $arch → 使用 $setupFile" -ForegroundColor Green

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 讀取之前 Get-UninstallInfo.ps1 產生的變數檔
$varFile = "$env:TEMP\EdgeUninstallVars.bat"
if (-not (Test-Path $varFile)) {
    Write-Host "[錯誤] 找不到變數檔，請先執行 Get-UninstallInfo.ps1" -ForegroundColor Red
    exit 1
}

# 解析變數檔
$vars = @{}
Get-Content $varFile | ForEach-Object {
    if ($_ -match '^set "(.+?)=(.+?)"$') {
        $vars[$matches[1]] = $matches[2]
    }
}

function Replace-Setup {
    param($name, $uninstallStr, $fallbackPath)
    
    $target = $uninstallStr
    if (-not $target) { $target = $fallbackPath }
    if (-not $target) {
        Write-Host "[$name] 沒有找到路徑，跳過" -ForegroundColor Yellow
        return
    }

    # 取出第一個引號內的路徑
    if ($target -match '^"([^"]+)"') {
        $exePath = $matches[1]
    } else {
        $exePath = ($target -split ' ')[0].Trim('"')
    }

    if (-not (Test-Path $exePath)) {
        Write-Host "[$name] 找不到原始檔案: $exePath" -ForegroundColor Red
        return
    }

    $targetDir = Split-Path $exePath -Parent
    $source = Join-Path $scriptDir $setupFile
    $dest = Join-Path $targetDir "setup.exe"

    Write-Host "[$name] 原始位置: $exePath"
    Write-Host "[$name] 目標資料夾: $targetDir"

    if (Test-Path $source) {
        Copy-Item $source $dest -Force
        Write-Host "[$name] ✓ 已成功替換 setup.exe" -ForegroundColor Green
    } else {
        Write-Host "[$name] ✗ 在資料夾中找不到 $setupFile" -ForegroundColor Red
    }
}

Replace-Setup "Edge"      $vars['EdgeUninstallString']   $vars['EdgeSetupPath']
Replace-Setup "EdgeWebView" $vars['WebViewUninstallString'] $vars['WebViewSetupPath']

Write-Host "`n處理完成" -ForegroundColor Cyan