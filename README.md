# Forza Horizon 6 Wheelspin Macro

An AutoHotkey v2 automation tool designed for Forza Horizon 6, featuring a modular architecture, custom GUI, optical character recognition (OCR), pixel-aware session tracking, and structured automation workflows to streamline repetitive in-game progression tasks.

<p align="center">
  <img width="277" height="1162" alt="Screenshot 2026-06-17 032307" src="https://github.com/user-attachments/assets/0d939947-2cf9-4ac3-89ad-2247654b03a3" />
  <img width="276" height="1160" alt="Screenshot 2026-06-17 032322" src="https://github.com/user-attachments/assets/3d3733cc-311c-4646-89ba-c064a09ffa47" />
</p>

---

## 📑 Table of Contents
- [Overview](#-overview)
- [Prerequisites](#%EF%B8%8F-prerequisites)
- [Installation](#-installation)
- [Key Features](#-key-features)
- [Automation Modes](#-automation-modes)
- [Core Systems](#-core-systems)
- [Controls](#%EF%B8%8F-controls)
- [Setup Guide](#-setup-guide-important-before-running)
- [Troubleshooting & FAQ](#-troubleshooting--faq)
- [Warning & Customization](#%EF%B8%8F-important-warning-read-before-use)
- [Credits & Contributions](#-credits)
- [License](#-license)

---

## 📌 Overview

This project is a desktop automation tool built with **AutoHotkey v2**. It automates multiple in-game workflows such as racing loops, car purchasing, and reward unlocking, while providing a fully custom graphical interface for monitoring progress in real time. 

The application features a modern, modular script structure separating UI configuration, OCR management, track profiles, and core execution macros into independent files for significantly easier codebase maintenance.

The original base script was developed by **6ftFish**, and this version has been significantly redesigned and expanded with pixel-detection verification systems, OCR asset tracking, custom UI improvements, and background play capabilities.

---

## 🖥️ Prerequisites

Before installing, ensure your system meets the following layout and control requirements:
* **Operating System:** Windows 10 / Windows 11
* **AutoHotkey:** [AutoHotkey v2](https://www.autohotkey.com) (v1 scripts will not run)
* **Execution Permissions:** You must run the script as **Administrator** if the macro does not execute or register inputs as intended.
* **Game Language:** English (UI navigation and dynamic timing validation logic are optimized for the English game client).
* **🖥️ Display & Scaling Settings:**
  * **Aspect Ratio:** Must be **16:9 Resolution** only (e.g., 1920x1080, 2560x1440, 3840x2160).
  * **Display Mode:** Must be set to **Fullscreen** only (Alternatively, set to **Borderless Fullscreen** if you are utilizing Special K for background play configuration).
  * **Windows Display Scaling:** Fully supports high-DPI scaling configurations (above 100%) and multi-monitor arrays. Fixes have been applied to keep text layouts consistent and prevent off-screen GUI spawning anomalies.
* **⌨️ Control Configuration:**
  * **Control Scheme:** Must use the native **WASD control layout** exclusively. Custom mappings or controller overlays will cause the automation routing to drop inputs.
  * **Background Execution:** Fully supports background play alongside **Special K**. Keyboard inputs can target the game exclusively using background hardware routing.

---

## 📥 Installation

> 🚀 **Don't want to deal with scripts?** 
> You don't need to install AutoHotkey! Just head over to the **[Latest Release](https://github.com/M-Haziq-Iqbal/Forza-Horizon-6-Wheelspin-Macro/releases/latest)**, download the pre-compiled `FH6_Macro_CyberNoir.exe`, and double-click to run.

### ⚡ Option A: The Easy Way (Recommended)
1. Navigate to the **[Releases](https://github.com/M-Haziq-Iqbal/Forza-Horizon-6-Wheelspin-Macro/releases/latest)** section on the right-hand sidebar of this page.
2. Click on the latest version (e.g., `v1.5.0`).
3. Under the **Assets** dropdown at the bottom of the release notes, click on `FH6_Macro_CyberNoir.exe` to download it.
4. Right-click the downloaded file launch the application interface.

### 💻 Option B: Running from Source (For Devs)
1. Download and install [AutoHotkey v2](https://www.autohotkey.com).
2. Clone this repository or download it as a ZIP file:
```bash
   git clone https://github.com/M-Haziq-Iqbal/Forza-Horizon-6-Wheelspin-Macro.git
```
3. Extract the files (if downloaded as a ZIP) into a dedicated folder, ensuring all modular script files and dependencies (including `OCR.ahk`) remain in the same directory.
4. Double-click the `main.ahk` file to launch the application interface.

**Note:** If the macro inputs do not register properly in-game, right-click the file and select **Run as Administrator**.

---

## ✨ Key Features

* 🎨 Custom GUI layout with dark/light theme options on-the-fly.
* 🔘 **Sleek Tier Toggle Buttons:** Features dedicated **STANDARD** and **PREMIUM** buttons to quickly toggle your game edition layout instead of clunky old checkboxes.
* 🛞 **Automated Wheelspin Module:** Built-in automation loop that handles both regular and Super Wheelspins, automatically detecting the spin type, skipping animations, and tracking totals.
* 🔄 **Keep or Sell Choice:** Integrated UI toggles for **KEEP** and **SELL** rules, allowing you to choose whether the macro automatically sells duplicate prize cars for credits or saves them to your garage.
* 👁️ **Optical Character Recognition (OCR):** Integrates `OCR.ahk` alongside specialized functions to scan screen regions, parse text strings, and extract real-time numeric data via regex matching.
* 🔒 **Targeted Window Routing:** Enforces game-scoped hotkeys and leverages background-compatible arrays mapped directly and exclusively to `ForzaHorizon6.exe`.
* ⏱️ **Execution Speed Control:** Integrated a Delay Multiplier slider supporting 0.25x to 2.5x scaling to dynamically adjust input delays and pixel detection timeouts based on system performance.
* 🔁 **Sequence Looping:** Features a dedicated loop counter input allowing the main initialization sequence to cycle automatically for a specified duration.
* 🗺️ **Track Profiles:** Dropdown track selection supporting distinct configurations for layouts like "LIQUIDPOTATO" and "AMMAGEDON".
* 🏁 **Bespoke Race Logic:** Tailored acceleration/braking intervals and an automated 50-race continuation mechanic optimized specifically for advanced profiles like AMMAGEDON.
* ⌨️ **Hardware-Level Input:** Employs low-level physical scan codes inside `PressKey()` for absolute reliability, minimizing input drops and bypassing focus errors.
* 👁️ **Pixel-Aware Engine:** Dynamic menu loading synchronization checks to systematically mitigate desync issues.
* 📦 **System Tray Icon:** Features a dedicated application icon in the system tray for seamless background minimization and tool management.
* 📊 Real-time session runtime telemetry, progress calculations, and live wheelspin tracking rows (*Wheelspins Opened*, *Wheelspins Left*, and *Spin Time Running*).
* 🏁 Automated race loop execution with structural timing cushions and recovery checks.
* 🚗 Fast-navigation car purchasing routines.
* 🛞 Automated wheelspin and cash reward perk unlocking.
* 📈 Skill point calibration tracking with dynamic profile-based calculations.
* 📋 Click-to-copy in-game share code integration that updates dynamically based on the active track profile.
* 🛠️ **Developer Diagnostic Tool:** Integrated automated coordinate/color calibration utility.

---

## 🔁 Automation Modes

The automation workflow is split into three independent processes that can be executed separately or combined into a continuous cycle.  

### 🏁 Race Mode (Hotkey `\`)
Runs only the race automation process.
* Automatically target the user's preferred EventLab track, which **must be positioned as the first entry in your Favorites list**.
* Drives the configured layout automatically using profile-specific telemetry and automated turning color nodes.

### 🚗 Buy Mode (Hotkey `[`)
Runs only the vehicle purchasing process.
* **Pre-Flight Resource Verification:** Instantly checks via OCR whether current skill points are sufficient to purchase the chosen vehicle before initializing.
* **Resource-Driven Budgets:** Dynamically calculates the maximum number of cars to process based strictly on active skill points, triggering an immediate early-exit safeguard if resources run thin.
* Dynamically shifts execution pathways based on whether the **STANDARD** or **PREMIUM** tier toggle button is engaged.

### 🛞 Unlock Mode (Hotkey `]`)
Runs only the reward unlocking process.
* **Pre-Flight Resource Verification:** Automatically scans and checks if skill points are sufficient before starting standalone cycles.
* Unlock the required mastery perks for specific rewards using different cars, and remove the unlocked cars from garage afterwards.

### ♾️ Full Automation Loop (Hotkey `/`)
Combines all processes into a single continuous workflow (Race → Buy → Unlock → Repeat). The macro will continuously cycle through all stages for the designated number of sequence loops, properly maintaining residual skill point offsets across full cycles.  
🎥 [Watch the Full Loop Demonstration](https://www.youtube.com/watch?v=6ezhyNeIYko)

---

## 🧠 Core Systems

### 🎛️ Automation Engine
Controls in-game navigation via rock-solid hardware scan codes, routing inputs to background targets. Features responsive color-sampling verification layers (fully scaled by the selected speed multiplier) to ensure menus are rendered before issuing subsequent commands.

### 📊 Telemetry System
Actively tracks total running time, loop-specific session times, total acquired cars, open/remaining wheelspins, and granular sector updates with a clean, unified presentation.

### 🧮 Progress Estimation
Uses optimized deterministic internal functions to calculate real-world session metrics and completion windows based on fixed empirical loading baselines instead of volatile runtime estimates.

* **Dynamic Performance Scaling:** Tracks exact math-driven profile variables to log performance updates per sequence interval.
* **Maximum Skill Point Calculation:** The in-game Skill Point cap is 999. The application calculates your target based on your current scanned points plus the estimated session gain, capping out automatically.

### 🎁 The Reward Vehicles
You can choose which vehicle the macro purchases and unlocks perks for via the GUI dropdown menu depending on your budget and preferred reward density. Make sure to purchase and unlock the Soko 78 house to get a permanent 5% discount on Autoshow purchases.

| Dropdown Choice | Cost Per Unit | Cost after 5% Discount | Mastery Grid Rewards | Skill Points Cost | Optimal Strategy |
| --- | --- | --- | --- | --- | --- |
| **Subaru Impreza 22B-STi Version (1998)** | 86,000 CR | 81,700 CR | 1x Super Wheelspin | 30 Points | **Budget Wheelspins:** Low-cost entry point for farming steady Super Wheelspins. |
| **Lamborghini Revuelto (2024)** | 365,000 CR | 346,750 CR | 1x Super Wheelspin + 3x Regular Wheelspins | 39 Points | **Max Yield:** Dumps heavy credits to maximize total wheelspin volume as fast as possible. |
| **Dodge Viper GTS ACR (1999)**\* | 68,000 CR | 64,600 CR | 150,000 CR | 30 Points | **Credit Flipping:** Converts Skill Points back into raw cash for a quick return or a near-full vehicle refund. |

> \* **Note on Dodge Viper GTS ACR:** If you are running a premium account that adjusts this vehicle's placement menu position, ensure you click the **PREMIUM** button layout on the UI to safely adjust menu tracking layers.

---

## ⌨️ Controls

| Key | Action |
| --- | --- |
| `\` | Start Race Loop |
| `[` | Start Buy Loop |
| `]` | Start Unlock / Unlock Loop |
| `/` | Toggle Continuous Full Automation Cycle (`INIT SEQUENCE`) |
| `` ` `` | Toggle Pause / Unpause Script State |
| `Ctrl + Shift + C` | Developer Utility: Sample & Copy Normalized Screen Coordinates (x / width, y / height) & Hex Color Code |
| `F12` | Force Reload Script Module |

---

## 📷 Setup Guide (Important Before Running)

Before using the macro, ensure your game is properly configured. The automation relies on consistent menus, pixel checking, and layout positioning.

### 🏁 Starting Position
Make sure you are in the Home Menu, loaded fully into an active session (no loading screens), with active keyboard input before starting any session. 

📌 All sessions use this identical baseline starting structure.

<p align="center">
  <img width="2559" height="1439" alt="Starting Position" src="https://github.com/user-attachments/assets/e6c585b4-264e-4a4c-8cf8-8d4ed7144ffc"> 
</p>

### 🔁 Special K Background Play Setup (Optional)
To enable background execution so that the macro functions seamlessly while you use your machine for other workflows, you must install the **Special K** mod engine on your device. Once Special K is installed, configure your game and mod settings using the following steps:

1. Ensure your in-game display layout is set to **Borderless Fullscreen** (standard Exclusive Fullscreen blocks background focused input loops).
2. Launch your game with the Special K mod injected.
3. Press `Ctrl + Shift + Backspace` to open the Special K control panel overlay.
4. Expand **Input Management** > **Enable / Disable Devices**.
5. Uncheck or toggle off **Disable Keyboard Input to Game**.
6. Press `Ctrl + Shift + Backspace` again to close the control panel.

<p align="center">
  <img width="2559" height="1439" alt="Screenshot 2026-06-15 135022" src="https://github.com/user-attachments/assets/e8e9e749-8515-4cb0-afaa-5af52fd89e07">
</p>

### 🎯 EventLab Menu Setup
Ensure the EventLab system is accessible. **The automatic share-code entry mechanism has been completely removed.**

*   **CRITICAL ENTRY SELECTION REQUIREMENT:** You **must** add your preferred EventLab track to your in-game Favorites list and make sure it is sorted as the **very first entry (index 1)** in that list. The script uses precise grid paging (`pgDn`) to select the first option instantly.
*   **AMMAGEDON (Default Profile):** Now the default track profile. Highly optimized using dynamic pixel color evaluations for automated turning adjustments and structured braking parameters to prevent wall crashing. This profile delivers reliable max-score processing of up to 990 points across 100 sections, averaging 9.9 points per section. Ensure your game is locked to a **minimum of 60 FPS** to preserve physics timing and prevent synchronization drops.
*   **LIQUIDPOTATO:** Available as an alternate legacy profile layout known for high structural path consistency during long overnight runs.

<p align="center">
  <img width="1941" height="896" alt="EventLab Setup 1" src="https://github.com/user-attachments/assets/c0dab41f-01bf-4975-99a9-bf48ff36028a"> 
  <img width="2559" height="1439" alt="Screenshot 2026-06-15 135120" src="https://github.com/user-attachments/assets/540441f0-6f5a-462e-a355-b3a47a333015">
</p>

---

## 🚗 Required Car Setup

The automation requires a highly specific vehicle configuration to function properly.

### ✔️ Required Vehicle Configuration
* Subaru Impreza 22B-STi must be set as your **ONLY** favorited vehicle inside your garage container.
* All skill tree perk allocations must be fully maxed out (all mastery upgrades unlocked) on that main vehicle.
* No other cars can be configured as favorites to avoid structural index selection conflicts during automation passes.

### 🧩 Tuning Setup
Apply the appropriate tuning configuration parameters to your Subaru depending on your chosen track layout:
*(Note: These codes can be conveniently copied directly from the GUI footer within the application)*

*   **For AMMAGEDON:** Tuning Code `206 657 706`
*   **For LIQUIDPOTATO:** Tuning Code `293 391 902`

<p align="center">
  <img width="2559" height="1439" alt="Screenshot 2026-06-15 135651" src="https://github.com/user-attachments/assets/ad315cec-1740-4984-9902-8cd97be366df" />
</p>

---

## ⚙️ Required Game Setting Setup

Verify your in-game configurations match the settings below for maximum consistency and reliability. 

### 🎮 Recommended Difficulty Settings
> **Note:** These layout options represent the development baseline. Deviations may impact tracking loops, physics processing windows, or target route validation structures.

| Setting | Recommended Value |
| --- | --- |
| Driving Controls Scheme | **WASD KEYBOARD LAYOUT ONLY** (or Special K Background routing) |
| Drivatar Difficulty | UNBEATABLE |
| Braking | ASSISTED |
| Steering | AUTO-STEERING |
| Shifting | AUTOMATIC |
| Framerate | **60 FPS Minimum** |

<p align="center">
  <img width="2559" height="1438" alt="Difficulty Settings" src="https://github.com/user-attachments/assets/43f2059b-4fb6-4540-a573-7ff43abfd561">
</p>

### 🚫 Disable Skills HUD
Navigate to Settings → HUD & Gameplay → Skills HUD and set it to OFF.

> Disabling the Skills HUD prevents visual pop-ups during gameplay that cause delays in building up skill points. While the macro may function with it enabled, turning it off is highly recommended for fastest farming sessions.

### 🛑 Disable "What's Next" Feature
Navigate to **Settings → HUD & Gameplay → What's Next** and turn it **OFF**.

> **FLOW INTERRUPTION WARNING:** The "What's Next" feature must be disabled completely. Leaving it active allows the game client to break the automation flow by forcing unexpected menu states.

<p align="center">
  <img width="2456" height="1068" alt="Skills HUD Off" src="https://github.com/user-attachments/assets/c92a4501-a0f7-4af7-bc0a-ebe25ece19df"> 
</p>

---

## 🖥️ Recommended Screen Setting Setup
For the pixel colour synchronization system to work at maximum speed and accuracy, your setup **must** meet these conditions:
* **Display Mode:** Fullscreen Only (Or Borderless Fullscreen when using Special K setup)
* **Aspect Ratio:** 16:9 Only (1280×720, 1920×1080, 2560×1440, etc.)
* **HUD Safe Frame:** Default Calibration
* **Screen Clearance:** The **left half of your screen must be completely clear**. Turn off any Discord overlays, stream chat widgets, or floating windows, as they may block the script from reading the HUD pixels.
 
> *Note: If these requirements are not met, the script will automatically switch to a slower, time-based fallback mode to prevent crashing, but your farming speed will drop noticably and some flows might not work correctly.*

### ⚠️ Keep Left Half of Screen Uncovered!
**CRITICAL RUNTIME WARNING:** Do **NOT** cover, overlay, or block the **left half of your monitor screen** while this macro is executing. 

The dynamic pixel engine samples hex color data across coordinates located on the left half of the display workspace. If background apps, streaming overlays, or Windows system notification banners obscure any section of the screen's left half, the pixel scanner will read false values, resulting in a **Sync Error / Menu Timeout**.

<p align="center">
  <img width="2563" height="1453" alt="Screenshot 2026-06-11 025901" src="https://github.com/user-attachments/assets/700ce2ab-6d03-474a-8dfb-fa6c46e263d9">
</p>

### 🗺️ HUD Safe Frame Calibration
Navigate to **Settings → HUD & Gameplay** and adjust the UI boundaries to the following exact values:
* **HUD Safe Frame Horizontal:** `5`
* **HUD Safe Frame Vertical:** `9`

> **CRITICAL ALIGNMENT WARNING:** Modifying the default HUD Safe Frame values alters the physical anchor placement of on-screen UI components. Because the macro's pixel detection loops scan exact coordinate arrays, changing these frame bounds will misalign the sensor engine, resulting in color identification errors and menu synchronization timeouts.

---

## 🔧 Troubleshooting & FAQ

### Q: The script immediately errors out with a "Sync Error" loop.
**A:** Ensure your game is in dedicated **Fullscreen** mode (or configured **Borderless Fullscreen** if using Special K background setups), using a **16:9 resolution**, and verify that absolutely no window panels, overlays, or pop-ups are obscuring the **left half of your screen**. The pixel coordinate used for identifying a successful free roam return relies on checking the active **ANNA** UI button instead of the old House icon. If issues persist, consider shifting the Delay Multiplier slider to a higher value to scale up detection timeouts.

### Q: The macro runs but clicks or keystrokes do not register in-game.
**A:** Windows security policies often block automated inputs within high-privilege applications like games. Close the macro, right-click `FH6 Wheelspin Macro - CyberNoir.exe or` `Main.ahk`, and select **Run as Administrator** to grant the execution loop necessary device input privileges.

### Q: The vehicle does not turn or navigate menus properly.
**A:** The macro hooks into default background mappings using hardware scan codes (`ControlSend`) targeted directly to `ahk_exe ForzaHorizon6.exe`. Ensure the target process name matches exactly. If you are attempting background execution, confirm that keyboard input has been enabled in Special K's Input Management settings.

### Q: The vehicle collides with walls during the EventLab loop session.
**A:** Ensure you are running the optimized **AMMAGEDON** configuration profile with **Auto-Steering** and **Assisted Braking** enabled. AMMAGEDON uses dynamic pixel color nodes to track turns, reducing crashes significantly compared to standard timed loops.

## ❓ Pixel Detection FAQ

### Q: The script keeps giving me a "Menu timed out!" error, but the menu is clearly open. What's wrong?
**A:** There are two common culprits for a false timeout:
1. **Incorrect HUD Scale / Safe Frame:** If you adjusted your UI scale or safe frame bounds in the game settings, the menus will physically move, causing the script to look at the wrong coordinates. Reset them to **Default**.
2. **Graphics Filters:** Programs like GeForce Experience (Alt+F3 filters), f.lux, or Windows "Night Light" alter screen colors in real time, blinding the script. Turn them off while farming.

### Q: Can I turn off my monitor while running the macro overnight?
**A:** **Yes, but only by pressing the physical power button on your monitor.**
* **Do NOT** let Windows put the display to sleep (Power Saving Mode).
* **Do NOT** lock your PC (`Win + L`) or sign out. 
Doing either of these stops Windows from rendering the game engine to your graphics card's frame buffer, turning the script's vision completely black. If you want to go completely headless (unplugged), use an **HDMI Dummy Plug / EDID Emulator**.

### Q: Can I use Discord, watch YouTube, or stream while it runs?
**A:** Yes, especially since v1.4.0 fully supports background execution alongside **Special K** using targeted background routing. If running in the foreground, just ensure those windows do not cover the **left half of your screen**.

### Q: Why does this macro require a 16:9 aspect ratio?
**A:** The script uses absolute screen-percentage math to find menu elements. On an Ultrawide (21:9) or older office monitor (16:10/4:3), the game stretches or adds black bars. This physics shift pushes the UI buttons away from their standard 16:9 geometric positions, making the script look in empty space.

### Q: I keep seeing "Sync Warning: Pixel missed. Proceeding blindly..." in the console. Is the script broken?
**A:** No! This is the built-in **Soft-Fail Safety Net**. If your PC lags or your graphic settings cause a slight color mismatch, the script recognizes it missed the pixel. Instead of crashing out and breaking the farm loop, it logs a warning, waits a brief scaled buffer for safety, and continues running the sequence normally.

---

## ⚠️ Important Warning (READ BEFORE USE)

This tool simulates user actions and monitors menu pixel updates, meaning:
* ⏱️ System responsiveness parameters dictate real-world efficiency gains.
* 🖥️ Disk speed and processor throughput profiles (SSD vs HDD, background CPU spikes) affect raw UI drawing windows.
* 🌐 Background asset streams or overlays can affect pixel detection routines.

### ✔️ First-Time Setup Recommendation
Before leaving the macro completely unattended for extended windows, execute each mode independently for a few test cycles. Monitor structural execution loops, check for screen indexing alignment mismatches, and adjust the execution speed multiplier slider if your hardware profile requires expanded safety cushions.

---

## 🛠️ Customization Encouraged

Users are strongly encouraged to dive into the modular source architecture to adapt layout functions. You can easily tweak color bounds inside `WaitForMenuRelative`, update navigation tracking components, customize window parameters, adjust the global UI updater parameters, or inject customized performance logic paths within the track profile configs to tailor it to your setup.

---

## 🙏 Credits

* **Base Script:** Original automation foundation and sequence structures created by [6ftfish](https://github.com/6ftfish/Forza_Horizon_6_Skill_Point_Macro).
* **Modifications:** This version includes a modular codebase split, complete GUI overhaul, high-DPI scaling corrections, OCR tracking engine additions, background input capability, and Ammagedon track run optimizations.
* **EventLab & Tuning:** Custom race layout and vehicle mechanical configuration parameters provided by u/Ok-Pin-5704 on [Reddit](https://www.reddit.com/r/EventlabSubmissions/comments/1twfgk0/960_skill_point_race).

---

## 💡 Contributions

Feedback and architectural upgrades are always welcome! If you find optimization improvements for interface scanning, route stability adjustments, layout additions, or vehicle support matrices, feel free to open a detailed issue tracker file or create a pull request.

---

## 📄 License

This project is licensed under the terms of the [MIT License](LICENSE) - check the file indicators for expanded breakdowns.

---

## 📌 Safety & Responsibility Notice

This automation tool operates entirely via keyboard simulation methods and does not alter memory blocks or inject structural payload modifications into internal game file assets. Active tracking, deployment execution paths, and supervision targets fall completely under the responsibility of the end user.

<p align="center">
  <a href="https://ko-fi.com/mhaziqiqbal">
    <img src="https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white" width="200" alt="Support me on Ko-fi">
  </a>
</p>
