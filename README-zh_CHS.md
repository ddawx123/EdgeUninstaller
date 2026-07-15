## Edge 完全卸除工具

已在 Windows 11 Insider Preview 29576 和 Edge 内核 150 稳定版上测试

使用方法：运行 RunMe.bat

功能列表：
- 卸载 Edge（Chromium 版本）
- 卸载 Edge WebView
- 卸载 Edge Update
- 卸载 Edge Core
- 卸载 Copilot（针对 Edge 变体）

所有用户建议：运行 RunMe.bat 前，请先完全禁用 Windows Defender 或其他安全软件，因为某些进程可能会终止运行或进行文件系统操作。在最新版本的 Windows 系统中，完全禁用 Windows Defender 可能需要进入 Windows 恢复环境 (Windows RE) 并进行注册表编辑。更多信息，请参阅相关文档或咨询 AI 服务。

国际用户建议：请使用 Windows 终端（管理员模式）以避免中文繁体字显示问题。
（右键单击“开始”按钮，选择“终端（管理员）”。）

本程序由本人设计，脚本由 AI 编写。

补充信息：
- 此脚本基于 AI 提供的原理解释。由于微软对 EdgeInstaller 的更高版本进行了大幅修改，未经白名单批准的卸载请求将被忽略。此解决方案涉及单独降级安装程序，然后再次调用官方组件来实现卸载过程。
- 本项目的创建者坚定支持 Windows 7 的终身兼容性，所有组件必须与 Windows 7 平台完全兼容！怀旧至上，让我​​们行动起来。
- 发布页面已提供 Edge 109 的原始安装程序，它兼容 NT6.1-6.3，是 NT10 的最佳版本！
- 您还可以为 Windows 11 21H2-23H2 部署 Edge Legacy（EdgeHTML 内核，Spartan 项目），但 24H1-26H2 版本不兼容（根据我的测试结果）。
- 手动卸载命令行参考：（示例版本：150.0.4078.65，这些命令需要您先将 setup.exe 替换为旧版本）
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
