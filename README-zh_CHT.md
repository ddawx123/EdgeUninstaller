## Edge 完全卸載工具

已在 Windows 11 Insider Preview 29576 和 Edge 核心 150 穩定版上測試

使用方法：執行 RunMe.bat

功能列表：
- 解除安裝 Edge（Chromium 版本）
- 解除安裝 Edge WebView
- 解除安裝 Edge Update
- 解除安裝 Edge Core
- 卸載 Copilot（針對 Edge 變體）

所有使用者建議：在執行 RunMe.bat 前，請先完全停用 Windows Defender 或其他安全軟體，因為某些進程可能會終止執行或進行檔案系統操作。在最新版本的 Windows 系統中，完全停用 Windows Defender 可能需要進入 Windows 復原環境 (Windows RE) 並進行登錄編輯。更多信息，請參閱相關文件或諮詢 AI 服務。

國際使用者建議：請使用 Windows 終端機（管理員模式）以避免中文繁體字顯示問題。
（右鍵單擊“開始”按鈕，選擇“終端機（管理員）”。）

本程式由本人設計，腳本由 AI 編寫。

補充資料：
- 此腳本基於 AI 提供的原理解釋。由於微軟對 EdgeInstaller 的更高版本進行了大幅修改，未經白名單批准的卸載請求將被忽略。此解決方案涉及單獨降級安裝程序，然後再次呼叫官方元件來實現卸載過程。
- 本專案的創作者堅定支援 Windows 7 的終身相容性，所有元件必須與 Windows 7 平台完全相容！懷舊至上，讓我們採取行動。
- 發布頁面已提供 Edge 109 的原始安裝程序，它相容於 NT6.1-6.3，是 NT10 的最佳版本！
- 您也可以為 Windows 11 21H2-23H2 部署 Edge Legacy（EdgeHTML 內核，Spartan 專案），但 24H1-26H2 版本不相容（根據我的測試結果）。
- 手動卸載命令列參考：（範例版本：150.0.4078.65，這些命令需要您先將 setup.exe 替換為舊版本）
    - Copilot：
        ```shell
        "C:\Program Files (x86)\Microsoft\Copilot\Application\150.0.4078.12\Installer\setup.exe" --uninstall --force-uninstall --mscopilot --channel=beta --system-level --verbose-logging
        ```
    - Edge：
        ```shell
        "C:\Program Files (x86)\Microsoft\Edge\Application\150.0.4078.65\Installer\setup.exe" --uninstall --force-uninstall --msedge --channel=stable --system-level --verbose-logging
        ```
    - Edge WebView2：
        ```shell
        "C:\Program Files (x86)\Microsoft\EdgeWebView\Application\150.0.4078.65\Installer\setup.exe" --uninstall --force-uninstall --msedgewebview --system-level --verbose-logging
        ```

日期：2026年7月15日 03:09:57 GMT+8
