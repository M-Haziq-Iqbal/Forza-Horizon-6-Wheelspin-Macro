# Forza Horizon 6 Wheelspin Macro

An AutoHotkey v2 automation tool designed for Forza Horizon 6, featuring a modular architecture, custom GUI, optical character recognition (OCR), pixel-aware session tracking, and structured automation workflows to streamline repetitive in-game progression tasks.

<p align="center">
  <img width="274" height="808" alt="Screenshot 2026-06-26 040818" src="https://github.com/user-attachments/assets/0fd06883-ec59-439c-8efb-c03155ae297b" />
  <img width="275" height="938" alt="Screenshot 2026-06-26 040751" src="https://github.com/user-attachments/assets/34b25bb0-0e3b-4576-90af-b29aee57dbbf" />
  <img width="274" height="811" alt="Screenshot 2026-06-26 040854" src="https://github.com/user-attachments/assets/ecb8dc82-b856-4ce0-8719-1ad3cf49e751" />
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

The application features a modern, modular script structure separating UI configuration, OCR management, track profiles, and core execution macros into independent files for significantly easier codebase maintenance. Version 1.8.0 expands this framework with independent window control wrappers, mathematical multi-resolution scaling support, heuristic asset location discovery, and custom diagnostic overlay layouts.

The original base script was developed by **6ftFish**, and this version has been significantly redesigned and expanded with pixel-detection verification systems, OCR asset tracking, custom UI improvements, and background play capabilities.

---

## 🖥️ Prerequisites

Before installing, ensure your system meets the following layout and control requirements:
* **Operating System:** Windows 10 / Windows 11
* **AutoHotkey:** [AutoHotkey v2](https://www.autohotkey.com) (v1 scripts will not run)
* **Execution Permissions:** You must run the script as **Administrator** if the macro does not execute or register inputs as intended.
* **Game Language:** English (UI navigation and dynamic timing validation logic are optimized for the English game client).
* **🖥️ Display, Resolution & Framerate Settings:**
  * **Aspect Ratio & Resolution:** Tested for standard **16:9 Resolutions** (e.g., 1920x1080, 2560x1440, 3830x2160). Version 1.8.0 introduces native **Multi-Target Math Scaling** options to dynamically adjust coordinate mappings. However, **the internal OCR text recognition system works best and delivers the highest reliability on a native 1080p (1920x1080) resolution**, though other rescaled 16:9 layouts may still function. Non-native arrays (such as 21:9 Ultrawide) are supported exclusively via windowed mode configurations.
  * **Display Mode:** Fullscreen, Borderless Fullscreen, and Borderless Windowed are all structurally supported.
  * **Windows Display Scaling:** Fully supported across multi-monitor arrays. Custom interface elements neutralize OS display scaling interference, ensuring layouts remain pristine and functional.
  * **Framerate:** Locking your game client to **60 FPS is almost mandatory** for the physics calculations, script delay buffers, and pixel-aware telemetry synchronization rules to align flawlessly.
* **⌨️ Control Configuration:**
  * **Control Scheme:** Must use the native **WASD control layout** exclusively. Custom mappings or controller overlays will cause the automation routing to drop inputs.
  * **Background Execution:** Fully supports advanced background play. Armed with a **Game Lock Engine**, input instructions transmit native activation signals directly to the target canvas window, forcing the game to process macro routines uninterrupted even when out of focus. **CRITICAL:** An unfocused windowed game client will **NOT** run the script properly unless it is explicitly targeted and locked using the interface's dedicated **Lock Button**.

 <p align="center">
  <img width="2559" height="1439" alt="Screenshot 2026-06-26 041047" src="https://github.com/user-attachments/assets/0c1f0345-0267-415d-9a8b-5fd261c300d3" />
</p>

---

## 📥 Installation

> 🚀 **Don't want to deal with scripts?**
> You don't need to install AutoHotkey! Just head over to the **[Latest Release](https://github.com/M-Haziq-Iqbal/Forza-Horizon-6-Wheelspin-Macro/releases/latest)**, download the pre-compiled `FH6_Macro_CyberNoir.exe`, and double-click to run.

### ⚡ Option A: The Easy Way (Recommended)
1. Navigate to the **[Releases](https://github.com/M-Haziq-Iqbal/Forza-Horizon-6-Wheelspin-Macro/releases/latest)** section on the right-hand sidebar of this page.
2. Click on the latest version (e.g., `v1.8.0`).
3. Under the **Assets** dropdown at the bottom of the release notes, click on `FH6_Macro_CyberNoir.exe` to download it.
4. Right-click the downloaded file and launch the application interface.

### 💻 Option B: Running from Source (For Devs)
1. Download and install [AutoHotkey v2](https://www.autohotkey.com).
2. Clone this repository or download it as a ZIP file:

    git clone https://github.com/M-Haziq-Iqbal/Forza-Horizon-6-Wheelspin-Macro.git

3. Extract the files (if downloaded as a ZIP) into a dedicated folder, ensuring all modular script files and dependencies (including `OCR.ahk` and the newly integrated `modules/SpecialK.ahk` engine library) remain in the same directory structure.
4. Double-click the `main.ahk` file to launch the application interface.

---

## ✨ Key Features

* 🚀 **Advanced Game Lock & Background Rendering Engine:** Introduced a specialized system window state control mechanism that forces the game client to continue running inputs uninterrupted while completely minimized or out of focus. By continuously transmitting native activation signals straight to the canvas execution window thread, the macro system fully bypasses default window-focus suspension behaviors.
* 📊 **Resolution Control Configurations & Multi-Target Math Scaling:** Implemented structural options allowing users to configure target screen resolutions directly within the dashboard settings. This runs alongside a rewritten coordinate processing model that mathematically rescales coordinates and text bounding box tracking grids on the fly across different window sizes.
* 🎨 **Dynamic Theme Engine (`GetPalette`):** Switch seamlessly between a customized, cyber-styled **Dark Mode** and **Light Mode** workspace layout on-the-fly.
* 🗲 **Comprehensive MiniGUI Layout Overhaul:** Minimizing the main dashboard shrinks the environment into a highly responsive, floating overlay widget tracking runtime, key states, credits, and wheelspins.
  * 🟢 **State-Driven Icon Glyphs:** Built-in UI layer assets mutate shapes and colors instantly (Flashing Green for execution, Amber for Paused, Burning Red for hard stops).
  * 🔘 **Integrated Action Toggles:** Low-level clickable control hooks built right into the minimized layout to quickly toggle diagnostic overlays, activate game locks, or trigger on-the-fly window transformations.
  * ⚙️ **System Control Actions:** Quick-access hooks to dispatch global environment resets, reloads, and hard script aborts without opening the main window.
* 🗮 **DPI-Safe Structural Elements:** Replaced native OS slider components with an entirely custom system, fully protecting the window from layout clipping bugs caused by Windows display scaling.
* 🔘 **Sleek Tier Toggle Buttons:** Features dedicated **STANDARD** and **PREMIUM** buttons to quickly toggle your game edition layout instead of clunky old checkboxes.
* 🛞 **Draggable Wheelspin Panel Subsystem:** Loop sequences and tracking for farming regular/Super Wheelspins have been moved into a modular, independent sub-panel interface. This auxiliary window automatically computes its layout to spawn centered relative to the master UI, supports fluid click-and-drag re-positioning, and inherits global dark/light styles.
* 🔄 **Keep or Sell Choice:** Integrated UI toggles for **KEEP** and **SELL** rules, allowing you to choose whether the macro automatically sells duplicate prize cars for credits or saves them to your garage.
* 👁️ **Fuzzy Optical Character Recognition (OCR):** Integrates `OCR.ahk` alongside specialized parsing functions. Features a **Fuzzy Edit-Distance String Recognition Pipeline** which replaces rigid exact-string matches with a case-insensitive mathematical similarity scoring system, letting the macro safely absorb subtle OCR misreads without halting operations. Optimized extensively for **1080p target canvas monitors**.
* 🔒 **Strict Handle Pointer Targeting (`HWND`):** Abandons fragile text title tracking in favor of binding directly to a unique window descriptor identification token (`HWND`). Background micro-automation sequences remain fully isolated from desktop focus changes, overlapping apps, or title string renames.
* 🛡️ **Runaway Input Prevention & Health Guardrails:** Upgraded hardware fallback routines forcefully send a `W up` release command to eliminate throttle-stick issues. Additionally, **Pre-Execution Application Health Guardrails** run verification checks prior to tasks; if the game client crashes or ceases running, the macro steps out of execution states instead of firing keys randomly into empty desktop space.
* ⏱️ **Execution Speed Control:** Integrated an analog Delay Multiplier slider supporting expanded **0.25x to 5.0x** scaling to dynamically adjust input delays and pixel detection timeouts based on system performance.
* 🔁 **Sequence Looping & Buffer Corrections:** The multi-stage queue loop counter (`ToggleAll`) evaluates decrements linearly step-by-step (`-= 1`). It incorporates an **Asset Purchase Increment Buffer Over-Correction** (off-by-one padding adjustment) to purchase exactly one extra asset beyond calculated bounds, mitigating visual recognition skips during heavy batch operations.
* 🗺️ **Track Profiles:** Dropdown track selection supporting distinct configurations for layouts like "LIQUIDPOTATO" and "AMMAGEDON".
* 🏁 **Bespoke Race Logic & Recovery:** Automated 50-race continuation mechanics optimized using dynamic pixel evaluations for automated turning adjustments and structured braking. Features an integrated **Leaderboard Recovery Protocol**—if post-race menus fail to load despite hitting sector markers, the engine auto-restarts the match and gracefully docks tracked values to adjust corrective run counts.
* ⌨️ **Hardware-Level Input:** Employs low-level physical scan codes for absolute reliability, minimizing input drops and bypassing focus errors.
* 👁️‍🗨️ **Pixel-Aware Engine:** Dynamic menu loading synchronization checks to systematically mitigate desync issues.
* 🔔 **Accent-Driven Notifications:** Integrated color-coded status bars into the toast notification sub-system (`ShowNotif()`) to quickly communicate runtime flags (🟢 Success / 🔴 Timeout / 🔵 Warning).
* 📉 **Advanced Skill Point Verification:** Real-time pre-flight and post-race character logic to securely track skill investments and prevent zero-balance loop crashes.
* 🛠️ **Developer Diagnostic Tool:** Integrated automated coordinate/color calibration utility.
* 🔍 **Visual Bounding Zone Diagnostic Overlay:** Provides an adjustable, semi-transparent colored bounding box overlay that hooks directly onto your game window dimensions to outline exactly where automated color-scanning and optical text parsing routines are scraping data in real-time.
* 📁 **Centralized File System Configuration Sync:** Standardizes a local `.ini` configuration framework to cache structural variable settings (custom tracks, car indices, loop multipliers, viewport configurations, licensing tiers) on your machine for seamless initialization across reboots.
* 🚀 **Heuristic Application Path Discovery Matrix:** An autonomous background engine scanner that queries local Windows Registry keys, traces registered App Paths, and checks default system directories across multiple storage drives to locate the game executable without requiring manual path specifications.
* 🖼️ **Viewport Placement & State Transformation Suite:** Functional hotkeys allowing immediate windowed-to-fullscreen layout modifications, assigning absolute "Always On Top" layering hierarchies to the target canvas, and granting users mouse-bound click-and-drag spatial displacement to fluidly move the viewport.

<p align="center">
  <img width="233" height="202" alt="Screenshot 2026-06-26 040918" src="https://github.com/user-attachments/assets/076c9f87-f0d8-422e-9ce1-88814e6648a8" />
</p>

---

## 🔁 Automation Modes

The automation workflow is split into three independent processes that can be executed separately or combined into a continuous cycle.

### 🏁 Race Mode (Hotkey `\`)
Runs only the race automation process.
* Automatically targets the user's preferred EventLab track, which **must be positioned as the first entry in your Favorites list**.
* Drives the configured layout automatically using profile-specific telemetry and automated turning color nodes.
* Employs conditional logic branch corrections to tracking handshakes, preventing lockups inside unhandled loading states or race scoreboard pauses.

### 🚗 Buy Mode (Hotkey `[`)
Runs only the vehicle purchasing process.
* **Pre-Flight Resource Verification:** Instantly checks via OCR whether current skill points are sufficient to purchase the chosen vehicle before initializing.
* **Resource-Driven Budgets:** Dynamically calculates the maximum number of cars to process based strictly on active skill points, triggering an immediate early-exit safeguard if resources run thin.
* Dynamically shifts execution pathways based on whether the **STANDARD** or **PREMIUM** tier toggle button is engaged.
* Employs off-by-one buffer padding adjustments to purchase an extra safety asset, preventing menu recognition tracking errors.
* **Flexible Starting Car Choice:** You are no longer forced to start from the absolute first vehicle in your garage. You have full control to choose exactly which car the macro begins processing from in standalone mode.

### 🛞 Unlock Mode (Hotkey `]`)
Runs only the reward unlocking process.
* **Pre-Flight Resource Verification:** Automatically scans and checks if skill points are sufficient before starting standalone cycles.
* **Optical Car Validation Safety Framework:** Introduces an automated header validation scan before assigning perk points. If a structural discrepancy is detected between the target vehicle and the on-screen asset, it fires an emergency loop exit to safeguard your hard-earned skill points.
* Unlocks the required mastery perks for specific rewards using different cars, and removes the unlocked cars from the garage afterward.

### ♾️ Full Automation Loop (Hotkey `/`)
Combines all processes into a single continuous workflow (Race → Buy → Unlock → Repeat). The macro will continuously cycle through all stages for the designated number of sequence loops, properly maintaining residual skill point offsets across full cycles.  
🎥 [Watch the Full Loop Demonstration](https://www.youtube.com/watch?v=6ezhyNeIYko)

### 🛞 Spin Mode (Hotkey `=`)
Runs only the reward-opening process.
* **Menu Hook:** Designed to run while hovering over the wheelspin tiles inside the **My Horizon** pause menu.
* **Prize Management:** Automatically handles duplicate car rewards based on your chosen **KEEP** or **SELL** toggle configuration.
* **Backlog Clearing:** Continuously burns through standard or Super Wheelspins while logging real-time statistics on the display overlay.

---

## 🧠 Core Systems

### 🎛️ Automation Engine & Game Lock
Controls in-game navigation via rock-solid hardware scan codes. Utilizes strict `HWND` identification pointers to lock input transmission sequences directly onto the target application thread canvas, insulating execution paths from focus shifts, user clicks, or monitor adjustments. 

### 📊 Telemetry System
Actively tracks total running time, loop-specific session times, total acquired cars, open/remaining wheelspins, and granular sector updates with a clean, unified presentation.

### 🧮 Progress Estimation & Data Schemas
Uses optimized deterministic internal functions to calculate real-world session metrics and completion windows based on fixed empirical loading baselines instead of volatile runtime estimates.

* **Typed Hash Mapping:** Reengineered into explicit dictionary structures (`EventLabData` and `CarData`) ensuring track metadata and vehicle configurations scale reliably with customized additions.
* **Dynamic Performance Scaling:** Tracks exact math-driven profile variables to log performance updates per sequence interval.
* **Maximum Skill Point Calculation:** The in-game Skill Point cap is 999. The application calculates your target based on your current scanned points plus the estimated session gain, capping out automatically.
* **Overestimation Prevention Cap:** The maximum score achievable in one full loop iteration is restricted to a conservative ceiling of **980**. This directly counters mathematical overestimations, preventing the loop routine from buying or unlocking redundant surplus vehicles.

### 📉 Skill Point Scanning & Target Overrides
The macro handles skill point validation with high-precision scanning and user configuration:

* **Dual-Phase Racing Scans:** The script automatically invokes an OCR screen capture area directly **before a race initializes** to log your starting balance, and runs an equivalent calculation parse **immediately after the race finishes**. This allows the program to track progression windows accurately and prevent reward loop initialization if the race was skipped or dropped due to network issues.
* **Custom Desired Target Override:** By default, the application automatically calculates your target metrics based on active scans. However, users can utilize the custom input field in the GUI to manually type in a specific **Desired Skill Points** target. Setting a custom value completely overrides the deterministic calculation engine, forcing the loop cycles to target your manual limit.

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
| `]` | Start Unlock Loop |
| `/` | Toggle Continuous Full Automation Cycle (`INIT SEQUENCE`) |
| `` ` `` | Toggle Pause / Unpause Script State |
| `Ctrl + Shift + C` | Developer Utility: Sample & Copy Normalized Screen Coordinates (x / width, y / height) & Hex Color Code |
| `F5`  | Toggle Detection Zone Overlay |
| `F12` | Force Reload Script Module |
| `Alt + Left Click` | Drag Game Window Client |

---

## 📷 Setup Guide (Important Before Running)

Before using the macro, ensure your game is properly configured. The automation relies on consistent menus, pixel checking, and layout positioning.

### 🏁 Starting Position

Depending on the automation mode you intend to execute, make sure your game client is positioned at the correct baseline menu structure:

#### For Full Loop / Race / Buy / Unlock Modes
Make sure you are in the Home Menu, loaded fully into an active session (no loading screens), with active keyboard input before starting any session.

<p align="center">
  <img width="2559" height="1439" alt="Starting Position" src="https://github.com/user-attachments/assets/e6c585b4-264e-4a4c-8cf8-8d4ed7144ffc"> 
</p>

#### For Unlock Mode
In standalone Unlock mode, you have the freedom to choose your starting car, **you must handle the menu navigation and sorting manually** before triggering the Unlock Mode script:

1. Navigate to the **Buy & Sell** tab, enter the **Auction House**, and select **Start Auction**.
2. Press `X` to change the sorting order, scroll down to select **Recently Added**, and confirm.
3. Open the vehicle grid list.
4. **CRITICAL STEP:** Use your arrow keys to **hover over or highlight the specific car you want to start the process with—but do not press Enter to select it.** 
5. With the target starting car highlighted in the menu, launch the Unlock Mode script to let the macro safely take over the automated pipeline from that exact spot.

#### For Wheelspin / Spin Mode
Open the pause menu and navigate over to the **My Horizon** tab. Use your keyboard controls to highlight/hover over the specific wheelspin tile (Regular Wheelspin or Super Wheelspin) that you intend to farm, **without actually entering or clicking into the menu selection**. The detached draggable wheelspin panel can be snapped nearby for convenient monitoring.

<p align="center">
  <img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/3a4ce3b7-f695-4cf4-a174-64ee42cd2c29" />
</p>

### 🔁 Special K Background Play Setup (Optional, only install if default background play is not working properly)
Version 1.8.0 includes a **Special K Mod Wrapper Deployment Asset Manager**. The macro automates runtime folder checks and auto-injects required Special K wrappers into the environment space to support borderless background input parsing natively.

Recommended settings will be implemented automatically if Special K is enabled through the app. However, in case automatic settings are not working properly, confirm the following options are checked:
1. Press `Ctrl + Shift + Backspace` to open the Special K control panel overlay.
2. Expand **Input Management** > **Enable / Disable Devices**.
3. Uncheck or toggle off **Disable Keyboard Input to Game**.
4. Press `Ctrl + Shift + Backspace` again to close the control panel.

<p align="center">
  <img width="2559" height="1439" alt="Screenshot 2026-06-15 135022" src="https://github.com/user-attachments/assets/e8e9e749-8515-4cb0-afaa-5af52fd89e07">
</p>

### 🎯 EventLab Menu Setup
Ensure the EventLab system is accessible. **The automatic share-code entry mechanism has been completely removed.**

* **CRITICAL ENTRY SELECTION REQUIREMENT:** You **must** add your preferred EventLab track to your in-game Favorites list and make sure it is sorted as the **very first entry (index 1)** in that list. The script will select the first option.
* **AMMAGEDON (Default Profile):** Highly optimized using dynamic pixel color evaluations for automated turning adjustments and structured braking parameters to prevent wall crashing. This profile delivers reliable max-score processing of up to **980 points** across 100 sections. Ensure your game is locked to **60 FPS (Almost Mandatory)** to preserve physics timing and prevent synchronization drops.
* **LIQUIDPOTATO:** Available as an alternate legacy profile layout for higher consistency and reliability.

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

### 🧩 Tuning & EventLab Share Codes
Apply the appropriate tuning configurations and locate the EventLab blueprints using the parameters below:
*(Note: These codes can be conveniently copied directly from the GUI footer within the application)*

| Profile Blueprint | Tuning Code | EventLab Share Code | Profile Strategy |
| --- | --- | --- | --- |
| **AMMAGEDON** | `206 657 706` | `723 451 098` | **Default / Recommended:** High scoring, dynamic wall prevention, and precise braking parameters. |
| **LIQUIDPOTATO** | `293 391 902` | `415 892 331` | **Legacy Choice:** Consistent structural paths designed for continuous overnight farming. |

<p align="center">
  <img width="2559" height="1439" alt="Screenshot 2026-06-15 135651" src="https://github.com/user-attachments/assets/ad315cec-1740-4984-9902-8cd97be366df" />
</p>

---

## 🚗 Required Game Setting Setup

Verify your in-game configurations match the settings below for maximum consistency and reliability.

| Setting | Recommended Value |
| --- | --- |
| Driving Controls Scheme | **WASD KEYBOARD LAYOUT ONLY**|
| Drivatar Difficulty | UNBEATABLE |
| Braking | ASSISTED |
| Steering | AUTO-STEERING |
| Shifting | AUTOMATIC |

<p align="center">
  <img width="2559" height="1439" alt="Screenshot 2026-06-17 215443" src="https://github.com/user-attachments/assets/3d48c1f9-904d-434b-8bcf-fe21cc16cffc" />
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
* **HDR:** Off
* **Brightness:** 50
* **Framerate:** 60 FPS (Almost Mandatory)
* **Display Mode:** Fullscreen, Borderless Fullscreen, or Windowed configurations. Use the in-app **Resolution Dropdown** to configure Windowed mode resolution and the "🗗" button on the mini overlay to activate the mode.
* **Aspect Ratio:** 16:9 Only.
* **Resolution:**
  * In-Game Video Settings: Highly recommended to be set to at most 1920x1080. This ensures internal UI elements and text assets render at the exact scale the OCR engine expects.
  * Game Client (Window Size): Can be any 16:9 resolution. The macro's math engine will automatically rescale its coordinate tracking grid to match whatever size your desktop window container is stretched to.
* **HUD Safe Frame:** Default Calibration
* **Graphics Quality:** Lowest possible is highly recommended
* **Screen Clearance:** The **left 1/3 of your screen must be completely clear**. Turn off any Discord overlays, stream chat widgets, or floating windows, as they may block the script from reading the HUD pixels.

<p align="center">
  <img width="2559" height="1439" alt="Screenshot 2026-06-17 215625" src="https://github.com/user-attachments/assets/46265802-0e86-4b81-90fe-5329ab5245e9" />
</p>

> *Note: If these requirements are not met, the script will automatically switch to a slower, time-based fallback mode to prevent crashing, but your farming speed will drop noticeably and some flows might not work correctly.*

### ⚠️ Keep Left 1/3 of Screen Uncovered!
**CRITICAL RUNTIME WARNING:** Do **NOT** cover, overlay, or block the **left 1/3 of your monitor screen** while this macro is executing in foreground configuration.

The dynamic pixel engine samples hex color data across coordinates located on the left 1/3 of the display workspace. If background apps, streaming overlays, or Windows system notification banners obscure any section of the screen's left half, the pixel scanner will read false values, resulting in a **Sync Error / Menu Timeout**. Press F5 to toggle the Detection Zone layout; the area covered in red is the safe zone.

<p align="center">
  <img width="2559" height="1439" alt="Screenshot 2026-06-26 043303" src="https://github.com/user-attachments/assets/1f8464f8-db8f-4093-8504-ba8fe5f423b0" />
</p>

### 📏 HUD Safe Frame Calibration
Navigate to **Settings → HUD & Gameplay** and adjust the UI boundaries to the following exact values:
* **HUD Safe Frame Horizontal:** `5`
* **HUD Safe Frame Vertical:** `9`

> **CRITICAL ALIGNMENT WARNING:** Modifying the default HUD Safe Frame values alters the physical anchor placement of on-screen UI components. Because the macro's pixel detection loops scan exact coordinate arrays, changing these frame bounds will misalign the sensor engine, resulting in color identification errors and menu synchronization timeouts.

---

## 🔧 Troubleshooting & FAQ

### Q: The macro runs, but clicks or keystrokes do not register in-game.
**A:** Windows security policies frequently block automated virtual inputs within high-privilege applications like games. Close the macro entirely, right-click `FH6_Macro_CyberNoir.exe` or `main.ahk`, and select **Run as Administrator** to grant the execution loop the necessary hardware-level input privileges.

### Q: Why is the macro missing menu transitions, breaking its flow, or pressing keys out of order?
**A:** This happens when the script's default timing intervals are too fast for your PC configuration. If your storage drive (HDD/SSD) takes a moment to load scenes, or if you experience sudden background CPU spikes, the macro will desync. Open the dashboard and increase the analog **Delay Multiplier** slider (e.g., to `1.5x` or `2.0x`) to add wider safety cushions until the menus sync perfectly.

### Q: Why does the macro drop inputs or break loop steps when I click out of the game?
**A:** The macro fully supports running in an unfocused game window, but you must configure it correctly to avoid layout or focus issues:
* **Enable Always On Top:** If you are playing in windowed mode, make sure to enable **Always on Top** mode via the macro interface. This ensures the game client continues rendering correctly in the background without getting buried or suspended by other application windows.
* **The "First-Time Unfocus" Quirk:** The background execution engine has a minor quirk—if the game loses focus for the very first time while you are actively in Free Roam or mid-race during an EventLab, the game will automatically pause itself, breaking the macro's flow.
* **How to Avoid Pausing:** To prevent this, **always unfocus the game while you are sitting in a menu** (such as the main pause menu or house menu). Once the game is unfocused from within a menu, it will run smoothly in the background. 
* **Hands-Off Rule:** Do **NOT** click back onto the game window once your background farming session has started. Re-focusing the game means you will eventually have to unfocus it again, which re-triggers the pause quirk and interrupts the automated workflow.

### Q: Why does the OCR function fail or skip loops when running on high-resolution displays?
**A:** While v1.8.0 uses a Multi-Target Math Scaling engine to scale text tracking grids across standard 16:9 configurations, **the internal OCR library works best and achieves peak recognition accuracy on a native 1080p (1920x1080) resolution**. If you encounter recurrent OCR parsing drops on 1440p or 4K, setting your game rendering engine natively to 1080p will resolve the problem.

### Q: Can I run this macro at 144Hz or with an uncapped framerate?
**A:** Locking your game client to **60 FPS is almost mandatory**. The automation script's multi-stage delay systems, turn profiles, loading intervals, and pixel engine checking loops are closely timed to a 60Hz physics update cycle. Running higher or unstable frame rates will trigger immediate desynchronization and tracking errors on the tracks.

### Q: The script keeps giving me a "Menu timed out!" or "Sync Error" message.
**A:** Check that:
1. **HUD Safe Frames** match the required `5` (Horizontal) and `9` (Vertical) adjustments.
2. Direct **Resolution Configuration** settings on your dashboard perfectly match the resolution of your game client so the coordinate scaling math lines up.
3. Graphics filters like GeForce Experience overlays, HDR, or Windows "Night Light" are disabled, as they warp hex color values entirely.

### Q: I keep seeing "Sync Warning: Pixel missed. Proceeding blindly..." in the console. Is the script broken?
**A:** No! This is the built-in **Soft-Fail Safety Net**. If your PC lags or your graphic settings cause a slight color mismatch, the script recognizes it missed the pixel. Instead of crashing out and breaking the farm loop, it logs a warning, waits a brief scaled buffer for safety, and continues running the sequence normally.

### Q: How do I easily get the correct share codes for the EventLab tracks or car tunes?
**A:** You don't need to manually type them out! The app features a **📋 Click-to-copy in-game share code integration** right in the GUI footer. Simply select your active track profile from the dropdown menu, and the footer will dynamically update with the correct blueprint and tuning codes. Just click them to instantly copy them to your clipboard for easy pasting into the game.

### Q: Can I turn off my monitor while running the macro overnight?
**A:** **Yes, but only by pressing the physical power button on your monitor.**
* **Do NOT** let Windows put the display to sleep (Power Saving Mode).
* **Do NOT** lock your PC (`Win + L`) or sign out. 
Doing either of these stops Windows from rendering the game engine to your graphics card's frame buffer, turning the script's vision completely black.

### Q: Can I use Discord, watch YouTube, or stream while it runs?
**A:** Yes, since the software fully supports background execution. If running in the foreground, just ensure those windows do not cover the **left 1/3 of your screen**.

### Q: Do I still need a native 16:9 monitor layout to run the application?
**A:** No longer mandatory! While the internal matrix remains mapped onto a 16:9 ratio grid, users with non-native display arrays (e.g., Ultra-wide 21:9 or 16:10) can deploy windowed mode through "🗗" button on the macro interface dashboard. Because the macro evaluates input data relative strictly to the bounding window handles rather than monitor coordinates, execution tracks perfectly across bordered 16:9 setups.

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

Users are strongly encouraged to dive into the modular source architecture to adapt layout functions. All primary preferences are written cleanly to the centralized `.ini` file configuration framework, allowing you to synchronize custom event paths, adjust multiplier scales, swap target viewport sizes, or customize baseline performance paths across script initializations safely.

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
    <img width="350" height="190" alt="image" src="https://github.com/user-attachments/assets/3791e71d-9ecb-4e81-811a-6e153118db1d" width="180" alt="Support me on Ko-fi"/>
  </a>
</p>
