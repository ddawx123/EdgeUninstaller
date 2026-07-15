## Edge All In One Remover

Test on Windows 11 Insider Preview 29576 and Edge Kernel 150 Stable Version

Usage: execute RunMe.bat

Feature List:
- Remove Edge (Chromium Version)
- Remove Edge WebView
- Remove Edge Update
- Remove Edge Core
- Remove Copilot (By Edge Variant)

For all users recommendation: Before execute the RunMe.bat, please fully disable the Windows Defender or another guard software due to some process terminate operation or filesystem operation. In the latest versions of Windows, completely disabling Windows Defender may require entering the Windows RE environment and performing registry editing operations. For more information on this, please refer to other relevant documents or consult AI services.

For international users recommendation: Use windows terminal (administrator mode) to avoid Chinese traditional font display issue.
(Right click the start button, and select "Terminal (Admin)".)

Design by myself, but script written by artificial intelligence.

Additional information:
- This script is based on the principle explanation provided by AI. Due to MSFT has heavily modified higher versions of EdgeInstaller, uninstallation requests not approved by the whitelist will be ignored. This solution involves downgrading the Installer separately and then calling the official component again to implement the uninstallation process.
- The creators of this project firmly support the lifetime compatibility of Windows 7, all components must be fully compatible with the Windows 7 platform! Nostalgia comes first, let's take action.
- Original installer for Edge 109 has been provided in release page, it's compatible with NT6.1-6.3, the best version for nt10!
- Also you can deploy the Edge Legacy (EdgeHTML kernel, the Spartan project) for Windows 11 21H2-23H2, but 24H1-26H2 is not compatible (for my test result).
- Manual uninstall command line reference: (Example version: 150.0.4078.65, these commands require you to first replace setup.exe with an older version)
    - Copilot:
        ```shell
        "C:\Program Files (x86)\Microsoft\Copilot\Application\150.0.4078.12\Installer\setup.exe" --uninstall --force-uninstall --mscopilot --channel=beta --system-level --verbose-logging
        ```
    - Edge:
        ```shell
        "C:\Program Files (x86)\Microsoft\Edge\Application\150.0.4078.65\Installer\setup.exe" --uninstall --force-uninstall --msedge --channel=stable --system-level --verbose-logging
        ```
    - Edge WebView2:
        ```shell
        "C:\Program Files (x86)\Microsoft\EdgeWebView\Application\150.0.4078.65\Installer\setup.exe" --uninstall --force-uninstall --msedgewebview --system-level --verbose-logging
        ```

Date: 2026.7.15 03:09:57 GMT+8
