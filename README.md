# 🏎️ Forza Horizon 6 Wheelspin Macro

Welcome to the ultimate progression companion for Forza Horizon 6! This is a highly modular, high-performance automation tool built on **AutoHotkey v2** designed to eliminate repetitive in-game tasks. Whether you want to skip the grind, farm credits, or stack up Super Wheelspins, this macro fully automates your workflow using optical character recognition (OCR), pixel-aware session tracking, and background play execution.

<p align="center">
  <img width="274" height="808" alt="Main Dashboard UI" src="https://github.com/user-attachments/assets/0fd06883-ec59-439c-8efb-c03155ae297b" />
  <img width="275" height="938" alt="Settings Configuration" src="https://github.com/user-attachments/assets/34b25bb0-0e3b-4576-90af-b29aee57dbbf" />
  <img width="274" height="811" alt="Track & Profile Sub-panel" src="https://github.com/user-attachments/assets/ecb8dc82-b856-4ce0-8719-1ad3cf49e751" />
</p>

---

## 📑 Table of Contents
* [🚀 Quick Start (TL;DR)](#-quick-start-tldr)
* [🖥️ System & Game Prerequisites]([#%EF%B8%8F-system--game-prerequisites)
* [📊 The Reward Vehicle Matrix](#-the-reward-vehicle-matrix)
* [✨ Key Features & Architecture](#-key-features--architecture)
* [🔁 The Automation Modes](#-the-automation-modes)
* [⌨️ Keyboard Controls Masterlist](#%EF%B8%8F-keyboard-controls-masterlist)
* [📷 Step-by-Step Setup Guide](#-step-by-step-setup-guide)
  * [⚙️ 1. Difficulty Settings](#%EF%B8%8F-1-difficulty-settings)
  * [📟 2. HUD & Gameplay Settings](#-2-hud--gameplay-settings)
  * [🖥️ 3. Video & Graphics Settings](#%EF%B8%8F-3-video--graphics-settings)
  * [🎯 4. EventLab Menu Configuration](#-4-eventlab-menu-configuration)
  * [🚗 5. Garage Car Tuning Configuration](#-5-garage-car-tuning-configuration)
  * [🌆 6. Special K Background Play Setup (Optional Alternative)](#-6-special-k-background-play-setup-optional-alternative)
  * [🏁 7. Choosing Your In-Game Starting Positions](#-7-choosing-your-in-game-starting-positions)
  * [📱 8. Controlling the GUI](#-8-controlling-the-gui)
* [🔧 Troubleshooting & FAQ](#-troubleshooting--faq)
* [⚠️ Safety & Customization]([#%EF%B8%8F-safety--customization)

## 🚀 Quick Start (TL;DR)

### The Easy Route (No Setup Needed)
1. Head over to the **[Latest Release](https://github.com/M-Haziq-Iqbal/Forza-Horizon-6-Wheelspin-Macro/releases/latest)** page on GitHub.
2. Download the pre-compiled executable file: `FH6_Macro_CyberNoir.exe`.
3. Right-click the file, select **Run as Administrator**, and enjoy the custom interface!

### The Developer Route (Running from Source)
1. Download and install **AutoHotkey v2** on your machine.
2. Clone this repository directly into your local directory:
   * `git clone https://github.com/M-Haziq-Iqbal/Forza-Horizon-6-Wheelspin-Macro.git`
3. Extract the workspace files, ensuring the main file, dependency engines (`OCR.ahk`), and library scripts (`modules/SpecialK.ahk`) remain in the same directory layout.
4. Double-click `main.ahk` to launch the application dashboard.

## 🖥️ System & Game Prerequisites

To guarantee that the macro's pixel detection and text-matching systems synchronize perfectly, verify your PC configuration meets these guidelines:

* **Operating System:** Windows 10 or Windows 11.
* **Game Language:** Must be set to **English** for the UI navigation checks and OCR text validation logic to function.
* **Permissions:** Running the macro as an **Administrator** is highly recommended to ensure virtual keyboard inputs register correctly in-game.
* **Control Mapping:** You must use the game's default **WASD keyboard controls layout**. Using custom key mappings or controller overlays will cause input routing issues.

> ⚠️ **Background Play Rule:** Want to scroll Discord or watch YouTube while farming? The macro completely supports background execution! For the best background play experience, it is highly recommended to use the **Always On Top**, **Resize**, and **Lock** features through the buttons on the mini overlay interface.

<p align="center">
  <img width="2559" height="1439" alt="Background Visualization" src="https://github.com/user-attachments/assets/0c1f0345-0267-415d-9a8b-5fd261c300d3" />
</p>

## 📊 The Reward Vehicle Matrix

Select your preferred target car on the dashboard dropdown menu depending on your progression strategy and budget:

| Vehicle Choice | Base Cost | Cost with 5% Discount | Mastery Perk Rewards | Skill Points Needed | Strategy Profile |
| --- | --- | --- | --- | --- | --- |
| **Subaru Impreza 22B-STi Version (1998)** | 86,000 CR | 81,700 CR | 1x Super Wheelspin | 30 Points | **Budget Wheelspins:** Great low-cost choice for farming steady Super Wheelspins. |
| **Lamborghini Revuelto (2024)** | 365,000 CR | 346,750 CR | 1x Super Wheelspin + 3x Regular Wheelspins | 39 Points | **Max Yield Fast:** Dumps heavy credits to maximize total wheelspin volume as fast as possible. |
| **Dodge Viper GTS ACR (1999)**\* | 68,000 CR | 64,600 CR | 150,000 Cash Credits | 30 Points | **Credit Flipping:** Quickly converts your skill points back into raw cash credits. |

> \* **Note on Premium Edition:** If you are running a premium edition account that alters this vehicle's placement layout inside the Journal, make sure to click the **PREMIUM** button layout on the UI dashboard to safely adjust menu tracking layers.

## ✨ Key Features & Architecture

This automation utility balances low-level Windows API hooks with a highly refined, feature-rich control dashboard to ensure optimal background play performance and ease of use:

### 🎮 Advanced Background Play & Window Management
* **Low-Level Windows Shell Hook Integration:** Registers a dedicated system shell hook to monitor active foreground application changes across the OS thread environment. By listening directly for the exact millisecond any window shift occurs, the macro catches focus events immediately.
* **Proactive Anti-Pause Window Spammer:** Intercepts specific focus activation signals—specifically checking for certain Windows Shell Hook event message. If the game client loses focus, the macro instantly bypasses the game engine's default window-focus suspension loop by flooding the application thread with explicit activation directives before the game can register the defocus state and pause itself.
* **Strict Handle Pointer Targeting:** Abandons fragile text title tracking in favor of binding directly to a unique window descriptor identification token (`HWND`). This ensures background micro-automation sequences remain fully isolated from desktop focus changes, overlapping apps, or title string renames.

### 🎨 CyberNoir UI & Feature-Rich Dashboard Suite
* **Dynamic Theme Engine:** Switch seamlessly between a customized, cyber-styled **Dark Mode** and **Light Mode** workspace layout on-the-fly.
* **Execution Speed Control (Analog Delay Multiplier):** Features a highly adjustable analog slider supporting expanded **0.25x to 5.0x** scaling. This allows users to dynamically expand or contract script menu delay buffers and pixel detection timeouts to match their storage drive speed (SSD vs. HDD) and system throughput performance.
* **DPI-Safe Interface Elements:** Replaced native OS slider and configuration components with an entirely custom system, fully protecting the application window from layout clipping bugs or offset rendering caused by Windows display scaling settings.
* **Sleek Tier Toggle Buttons:** Features dedicated, stylized **STANDARD** and **PREMIUM** buttons to quickly adjust the internal menu navigation paths to align with your specific game edition layout instead of clunky old checkboxes.
* **Wheelspin Panel Subsystem:** Wheelspins controller reside in a modular, independent sub-panel interface. This auxiliary window automatically computes its layout to spawn centered relative to the master UI, supports fluid click-and-drag re-positioning, and inherits global active styles.
* **Integrated Keep or Sell Choice:** Built-in UI toggles for **KEEP** and **SELL** rules allow you to choose whether the macro automatically liquidates duplicate prize cars for quick cash credits or saves them to your garage backlog.
* **Responsive MiniGUI Overlay:** Minimizing the primary dashboard shrinks the environment into a highly responsive, floating overlay widget tracking runtime, key states, credits, and wheelspins. It features state-driven icon glyphs (Flashing Green for execution, Amber for Paused, Burning Red for hard stops) alongside quick-access action toggles to trigger diagnostics, game locks, or environment resets. To achieve the best background play experience, users are highly recommended to leverage the **Always On Top**, **Resize**, and **Lock** feature configurations directly through the buttons provided on this overlay panel.
* **Interactive Share Code Footer:** Includes a click-to-copy integration built right into the GUI footer. Selecting your active track profile from the dropdown menu dynamically updates the footer text with the correct blueprint and tuning codes, copying them instantly to your clipboard for effortless in-game pasting.

### 📊 Telemetry & Resource Management Automation
* **Deterministic Math Models & Data Mapping:** Maps track metadata and vehicle configurations into explicit dictionary structures (`EventLabData` and `CarData`), allowing the pipeline to easily scale and adapt to custom records. Rather than relying on volatile runtime estimates, the program utilizes internal mathematical formulas based on empirical loading baselines to accurately project session completion times.
* **Dual-Phase Validation Scans:** Captures an OCR area snapshot right **before a race initializes** to log your starting balance, and runs a mirror calculation check **immediately after the match finishes**. This calculates exact performance updates per sequence interval and verifies that network disconnects didn't drop your match rewards.
* **Smart Overestimation Cap:** While the true in-game skill point balance caps out at 999, the macro limits its internal single-loop target ceiling to a conservative max score of **980**. This buffer prevents mathematical overestimations from forcing the loop routine to purchase redundant, surplus vehicles.
* **Custom Desired Target Override:** You can bypass the automatic calculation engine at any time by typing a target value directly into the **Desired Skill Points** input field on the dashboard, forcing the automated loops to halt precisely when your manual limit is reached.

### 👁️ Intelligence & Safety Guardrails
* **Real-Time Pixel Detection Engine:** Employs precise color-matching and pixel-detection loops to dynamically evaluate state-changes across specific HUD safe frames. By sampling exact Hex color codes in real-time, the engine verifies loading states and UI flags instantly, preventing the macro from firing inputs out of sequence or proceeding blindly into unexpected game states.
* **Fuzzy Optical Character Recognition (OCR):** Integrates `OCR.ahk` alongside a specialized **Fuzzy Edit-Distance String Recognition Pipeline**. This replaces rigid exact-string matches with a case-insensitive mathematical similarity scoring system, letting the macro safely absorb subtle OCR misreads without halting operations.
* **Visual Bounding Zone Overlay:** Pressing `F5` triggers an adjustable, semi-transparent colored bounding box overlay that hooks directly onto your game window dimensions. This outlines exactly where automated color-scanning and optical text parsing routines are scraping data in real-time for effortless user calibration.
* **Application Health Guardrails:** Pre-execution verification checks run prior to firing macros; if the game client crashes or closes unexpectedly, the macro steps out of execution states instead of firing keys randomly into empty desktop space.

### 🛠️ Developer & Configuration Tools
* **Centralized File Configuration Sync:** Standardizes a local persistent `.ini` file configuration framework to cache structural variable settings (custom tracks, car indices, loop multipliers, viewport configurations, licensing tiers) across reboots.
* **Heuristic Application Path Discovery Matrix:** An autonomous background engine scanner that queries local Windows Registry keys, traces registered App Paths, and checks default system directories across multiple storage drives to locate the game executable without requiring manual path specification.

## 🔁 The Automation Modes

The core macro pipeline is divided into independent operational modules that can be launched as standalone processes or chained into a continuous loop:

### 🏁 Race Mode (Hotkey: `\`)
* **Purpose:** Automates your skill point farming loops.
* **Logic:** Automatically targets and launches the EventLab track positioned at the **very top of your Favorites list**. It drives using profile-specific telemetry parameters and handles loading state menus to avoid lockups.

### 🚗 Buy Mode (Hotkey: `[`)
* **Purpose:** Automates volume vehicle purchasing from the Autoshow.
* **Logic:** Performs an initial pre-flight OCR balance check to ensure you have enough resources. It dynamically calculates your purchase budget based on available skill points, shifts navigation paths based on your **Standard / Premium** tier toggle layout, and uses an asset buffer over-correction padding adjustment to prevent menu indexing errors. You can choose exactly which car slot the macro begins processing from.

### 🛞 Unlock Mode (Hotkey: `]`)
* **Purpose:** Unlocks targeted car mastery rewards and cleans out your garage.
* **Logic:** Runs a pre-flight resource validation and invokes an **Optical Car Validation Safety Framework**. If the macro detects a mismatch between the expected target car and the active on-screen vehicle title header, it fires an emergency loop shutdown to safeguard your skill points.

### ♾️ Full Automation Loop (Hotkey: `/`)
* **Purpose:** Fully unattended, continuous farming.
* **Logic:** Continuously chains all three main modes together (**Race → Buy → Unlock → Repeat**) for your specified count of loops, safely managing your residual skill point offsets across full cycles.

    🎥 [Watch the Full Loop Demonstration](https://www.youtube.com/watch?v=6ezhyNeIYko)

### 🎰 Spin Mode (Hotkey: `=`)
* **Purpose:** Automatically burns through your backlog of accumulated wheelspins.
* **Logic:** Designed to be activated while hovering over your wheelspin tiles inside the game's **My Horizon** pause menu. It logs live reward statistics and respects your GUI toggle settings to automatically **KEEP** new prize vehicles or **SELL** duplicates for cash.

## ⌨️ Keyboard Controls Masterlist

| Keybind | Action Performed |
| --- | --- |
| `\` | Start standalone **Race Loop** |
| `[` | Start standalone **Buy Loop** |
| `]` | Start standalone **Unlock Loop** |
| `/` | Initialize Continuous **Full Automation Loop** (`INIT SEQUENCE`) |
| `` ` `` (Backtick) | **Pause / Unpause** active macro tracking states instantly |
| `F5` | Toggle visual **Detection Zone Diagnostic Overlay** panels |
| `F12` | Force a complete hard **Reload** of the application workspace modules |
| `Ctrl + Shift + C` | Developer Calibration Utility: Copy normalized screen coordinates and Hex color code |
| `Alt + Left Click` | Move the game client window around your desktop via click-and-drag |

## 📷 Step-by-Step Setup Guide

### ⚙️ 1. Difficulty Settings

Verify your in-game configurations match the settings below for maximum consistency and reliability.

| Setting | Recommended Value |
| --- | --- |
| Drivatar Difficulty | UNBEATABLE |
| Drving Assists Preset | FULL ASSISTS |
| Braking | ASSISTED |
| Steering | AUTO-STEERING |
| Traction Control | ON |
| Stability Control | ON |
| Shifting | AUTOMATIC |

<p align="center">
  <img width="2559" height="1439" alt="Setting Menu" src="https://github.com/user-attachments/assets/3d48c1f9-904d-434b-8bcf-fe21cc16cffc" />
</p>

### 📟 2. HUD & Gameplay Settings

#### 🚫 Disable Skills HUD
Navigate to **Settings → HUD & Gameplay → Skills HUD** and set it to **OFF**.

> Disabling the Skills HUD prevents visual pop-ups during gameplay that cause delays in building up skill points. While the macro may function with it enabled, turning it off is highly recommended for fastest farming sessions.

#### 🛑 Disable "What's Next" Feature
Navigate to **Settings → HUD & Gameplay → What's Next** and turn it **OFF**.

> **FLOW INTERRUPTION WARNING:** The "What's Next" feature must be disabled completely. Leaving it active allows the game client to break the automation flow by forcing unexpected menu states.

<p align="center">
  <img width="2456" height="1068" alt="Skills HUD Off" src="https://github.com/user-attachments/assets/c92a4501-a0f7-4af7-bc0a-ebe25ece19df"> 
</p>

### 🖥️ 3. Video & Graphics Settings

#### Required Video Configuration

| Game Setting | Required Target Value |
| :--- | :--- |
| **Brightness** | `50` |
| **HDR** | `Off` |
| **Resolution** | `1920 x 1080` *(Recommended)* |
| **Framerate** | `60 FPS Lock` *(Almost Mandatory)* |
| **Graphics Quality** | `Lowest Settings` |

#### Technical Implications (OCR & Pixel Search)

* **Color Matching Stability (Brightness & HDR):** The pixel detection engine samples exact hexadecimal color coordinates to handle menu transitions. Activating HDR or moving the brightness slider warps these color codes, rendering the scanner blind and causing "Sync Errors".
* **OCR Text Recognition Matrix (Resolution):** 
  * **Scale Calculations:** The macro dynamically recalculates scanning coordinates across standard **16:9 layouts** (1080p, 1440p, 4K). 
  * **Peak Accuracy:** The underlying OCR engine is optimized for a native **1920x1080** canvas; running at this resolution delivers the highest character recognition success rate.
  * **Ultrawide & Custom Shapes:** Non-native screen arrays (such as **21:9** or **16:10**) will break coordinate mapping unless the game client is run inside a restricted **windowed container**.
* **Input Timing & Engine Sync (Framerate):** The script's operational delay buffers, telemetry verification tracking, and turning physics calculations are tightly synchronized to a fixed **60Hz update loop**. Running an unstable or higher framerate will cause the macro to drop key inputs.
* **Visual Noise Reduction (Graphics Quality):** Setting your graphics to the lowest values strips out volatile environmental factors like dynamic shadows, motion blur, and anti-aliasing artifacts. This clean image stream significantly boosts the processing speed and reliability of both pixel scanning and OCR utilities.

<p align="center">
  <img width="2559" height="1439" alt="Screenshot 2026-06-17 215625" src="https://github.com/user-attachments/assets/46265802-0e86-4b81-90fe-5329ab5245e9" />
</p>

**Screen Clearance Safeguard:** The **left 1/3 of your monitor screen must be completely clear and uncovered** when running in a foreground configuration. Turn off floating windows, chat widgets, or system notification boxes, as they block the script from sampling hex colors.

<p align="center">
  <img width="2559" height="1439" alt="Safe Area Layout" src="https://github.com/user-attachments/assets/1f8464f8-db8f-4093-8504-ba8fe5f423b0" />
</p>

### 🎯 4. EventLab Menu Configuration
The automated text entry share-code systems have been removed to improve speed and reliability. You must configure your track list layout manually:

* **CRITICAL REQUIREMENT:** You **must** manually add your preferred farming track to your in-game Favorites list and make sure it is positioned as the **very first entry (index 1)** in that view. The macro is coded to select the first entry in your favorites list.
* **AMMAGEDON (Recommended Default Profile):** Highly optimized using precise pixel color evaluation nodes for automated turning adjustments and braking parameters. This profile safely prevents wall crashes and yields up to **980 points** per 100 sections. Ensure your game client is locked to **60 FPS** to preserve timing loops.
* **LIQUIDPOTATO:** Available via your dashboard dropdown menu as a legacy profile choice optimized for overnight consistency.

<p align="center">
  <img width="1941" height="896" alt="Favorites Layout Mapping" src="https://github.com/user-attachments/assets/c0dab41f-01bf-4975-99a9-bf48ff36028a" />
  <img width="2559" height="1439" alt="EventLab Selection Screen" src="https://github.com/user-attachments/assets/540441f0-6f5a-462e-a355-b3a47a333015" />
</p>

### 🚗 5. Garage Car Tuning Configuration
The script relies on a specific vehicle setup to navigate menus correctly:

* The target Subaru Impreza 22B-STi must be set as your **ONLY favorited car** inside your main garage container.
* All skill tree perk allocations on this main vehicle must be fully maxed out.
* Remove any other favorites from your garage to avoid selection index errors during automation transitions.

#### Blueprint & Tuning Parameters
Apply the appropriate upgrades and find your blueprints using these codes (which can also be copied directly from the application's GUI footer):

* **AMMAGEDON Profile:** Tuning Code: `206 657 706` | EventLab Share Code: `102 089 819`
* **LIQUIDPOTATO Profile:** Tuning Code: `293 391 902` | EventLab Share Code: `124 198 343`

<p align="center">
  <img width="2559" height="1439" alt="Tuning Application Layout" src="https://github.com/user-attachments/assets/ad315cec-1740-4984-9902-8cd97be366df" />
</p>

### 🌆 6. Special K Background Play Setup (Optional Alternative)
The utility contains built-in automated directory checks and files to deploy **Special K Mod Wrapper Asset Managers** to handle background rendering. If your background inputs do not process smoothly by default, confirm the following steps inside the wrapper overlay:

1. Press `Ctrl + Shift + Backspace` to open up the Special K configuration manager dashboard overlay.
2. Expand the following option tabs: **Input Management** > **Enable / Disable Devices**.
3. Uncheck or turn off the option labeled **Disable Keyboard Input to Game**.
4. Press `Ctrl + Shift + Backspace` to close down the configuration overlay panel.

<p align="center">
  <img width="2559" height="1439" alt="Special K Control Board Layout" src="https://github.com/user-attachments/assets/e8e9e749-8515-4cb0-afaa-5af52fd89e07" />
</p>

### 🏁 7. Choosing Your In-Game Starting Positions

Make sure your game client is positioned at the correct baseline menu structure before launching an automation script:

#### For Full Loop / Race / Buy / Unlock Modes
1. Ensure you are fully loaded into an active session (standing in your player home menu, highlighting Drive selection).
2. Confirm there are no loading screens present and that standard keyboard inputs are responsive.

<p align="center">
  <img width="2559" height="1439" alt="Home Menu Base Position" src="https://github.com/user-attachments/assets/e6c585b4-264e-4a4c-8cf8-8d4ed7144ffc" />
</p>

#### For Custom Unlock Mode
When running the unlock mode sequence manually, you have the option to choose the starting car. To do so, you must sort your vehicle view beforehand:
1. Open the **Buy & Sell** tab, navigate into the **Auction House**, and select **Start Auction**.
2. Press `X` to adjust your listing sort configurations, select **Recently Added**, and confirm the menu layout.
3. Open your vehicle list grid.
4. **CRITICAL STEP:** Use your directional arrow keys to **hover over and highlight the specific car you want the macro to start with—but do not click Enter to select it**. Leave the cursor highlighted on that vehicle slot, then trigger your script.

<p align="center">
  <img width="2559" height="1439" alt="Unlock Mode Base Position" src="https://github.com/user-attachments/assets/2e145722-efb6-4307-95b9-1039f3d9c1fc" />
</p>

#### For Spin Mode
1. Open the pause menu and navigate over to the **My Horizon** tab layout.
2. Use your controls to highlight or hover directly over your preferred wheelspin tile (Regular Wheelspin or Super Wheelspin) **without actually opening the menu selection**. Keep your dashboard panel snapped nearby to track your rewards.

<p align="center">
  <img width="2559" height="1439" alt="My Horizon Base Selection" src="https://github.com/user-attachments/assets/3a4ce3b7-f695-4cf4-a174-64ee42cd2c29" />
</p>

### 📱 8. Controlling the GUI

#### 🎛️ Master GUI Control Dashboard Guide

The master interface serves as the centralized command center for configuring automated workflows, calibrating execution delays, balancing in-game budgets, and initializing independent farming routines.

#### 1. Session Parameter Inputs (Target Matrix)

<p align="center">
  <img width="271" height="139" alt="Target Matrix" src="https://github.com/user-attachments/assets/569140dd-ca8a-43cc-a5a1-f51fb80a3cc4" />
</p>

The upper portion of the **Input** tab visible allows you to define processing boundaries before deploying a script loop:

* **Current Skill Points:** Displays or allows manual override entry for your active vehicle mastery balance.
* **Desired Skill Points:** Sets your ultimate resource ceiling target (e.g., `980`). Once reached, the automation engine cleanly finishes its active cycle and transitions out of racing states.
* **Car Purchase:** Specifies the exact volumetric block size of inventory assets to purchase in bulk during a single standalone "Buy" routine loop.
* **Sequence Loop:** Sets the total absolute iteration count for continuous automated cycles when running multi-stage loops.

#### 2. Vehicle Selection, Edition Tier, & Delay Engine Calibration

<p align="center">
  <img width="270" height="132" alt="optimization switches" src="https://github.com/user-attachments/assets/d26e6009-6e3e-4cb0-ac42-6e69f1c4ce30" />
</p>

Directly underneath the parameter matrix are the optimization switches used to align the macro's navigation paths with your specific game profile:

* **Vehicle Dropdown Menu:** Selects the precise target vehicle schema (e.g., `Subaru Impreza 22B-STi`) to ensure the underlying OCR and mastery node layouts align correctly.
* **STANDARD / PREMIUM Toggles:** Switches between different in-game car list menu alignments. If your game edition includes DLC car layout additions that shift grid coordinates, selecting **PREMIUM** recalibrates the menu tracking layer.
* **Delay Multiplier Slider:** Provides an analog scaling slider ranging from **0.25x to 4.0x**. If your system experiences sudden background frame drops, disk read latency, or server connection lag, slide this modifier upward to scale all internal sleep buffers of key input safely.

#### 3. Core Automation Execution Triggers

<p align="center">
  <img width="270" height="164" alt="primary control buttons" src="https://github.com/user-attachments/assets/e9de7250-2774-4ac4-aea0-9242ee451938" />
</p>

The primary control buttons launch individual automation modes or initialize the full continuous macro pipeline:

* **RACE (`\`):** Launches the automated EventLab farming loop.
* **BUY (`[`):** Executes the bulk vehicle acquisition macro sequence.
* **UNLOCK (`]`):** Initializes the vehicle perk grid mastery loop to claim hidden wheelspin assets.
* **INIT SEQUENCE (`/`):** Daisy-chains all core modes into a continuous, self-sustaining loop (Race → Buy → Unlock → Repeat).
* **OPEN SPIN INTERFACE:** Spawns the embedded prize delivery panel directly within the dashboard.

#### 4. Embedded Spin Controller Panel

<p align="center">
  <img width="250" height="229" alt="image" src="https://github.com/user-attachments/assets/50f7683c-0487-42b0-9b66-e5bae0fefd3e" />
</p>

Clicking the purple interface trigger transforms the center of the dashboard into an isolated bulk opening terminal.

* **Live Teleview Readouts:** Tracks real-time session statistics including total **Spin Runtime**, total **Spins Opened**, and **Spins Remaining** in the active backlog queue.
* **KEEP / SELL Optimization Buttons:** Sets the structural rule engine for duplicate prize car drops. Choosing **SELL** auto-converts duplicates back to liquid in-game credits instantly, while **KEEP** passes them into your garage structure.
* **RUN WHEELSPIN (`=`):** Fires the automated hardware routine to continuously clear out your accumulated wheelspin cache.

#### 5. Profile Selection & Quick-Copy Share Codes

Located right below the running telemetry state readouts is the integrated track configuration and code utility footer:

<p align="center">
  <img width="268" height="80" alt="image" src="https://github.com/user-attachments/assets/ac521149-fb72-4565-954a-cb609af6b1ca" />
</p>

* **Track Profile Dropdown Menu:** Allows you to swap seamlessly between different pre-configured automated driving routes, such as `AMMAGEDON` or `LIQUIDPOTATO`. Selecting a track profile immediately updates the underlying path calculations, timing variables, and telemetry color nodes to match that specific layout.
* **Dynamic Click-to-Copy Share Codes:** Features interactive, clickable text links for both the vehicle mechanics configuration (`Subaru 22B Tune Code`) and the blueprint layout (`EventLab Race Code`).
* **Instant Clipboard Integration:** Clicking on either text link instantly copies the respective multi-digit in-game share code straight to your Windows clipboard. This completely removes the need to manually write down or type long numeric strings when searching for assets inside the game client.
* **Automated Footer Synchronization:** The structural share codes switch and update automatically in real time based on your active selection in the track profile dropdown menu, ensuring you always copy the correct matching tune and map combinations.

#### 6. Advanced System Options & Launch Utility

<p align="center">
  <img width="268" height="178" alt="image" src="https://github.com/user-attachments/assets/ed6b1cc2-b4fd-478e-a7c1-8e834574d4d2" />
</p>

Expanding the **OPTIONS** toggle dropdown at the bottom of the dashboard grants access to background management and initialization hooks:

* **Resolution Configuration Dropdown:** Configures target canvas viewport sizes (e.g., `854 x 480`) for windowed rendering scaling calculations.
* **SET GAME PATH:** Links the automation suite directly to your local installation directory for automated startup sequences.
* **LAUNCH GAME:** Autonomously executes the target software executable while preparing local configuration settings.
* **SPECIAL K Core Status:** Displays real-time API connection flags (e.g., `SPECIAL K (GAME RUNNING)`) to verify background play input translation wrappers are working smoothly.

#### 🗲 Compact Mini GUI Overlay

<p align="center">
  <img width="238" height="202" alt="MiniGUI" src="https://github.com/user-attachments/assets/bfcc48eb-f4cb-4ae4-8d53-4143cefa6feb" />
</p>

When the main configuration dashboard is minimized, the tool shrinks into a highly responsive, floating overlay tracking live automation data and structural execution tasks in real time.

The icon row positioned along the top header of Mini GUI provides low-level window hook management directly into the background engine:
* Window Mode Transformation (🗗): Instantly commands the game window client to shift into a standardized 16:9 bordered resolution space based on selected resolution dropdown.
* Always-On-Top Layer Lock (📌): Toggles an absolute visual priority layering state. This ensures the game window or overlay remains structurally visible without focus degradation.
* Game Lock Engine Pipeline (🔒): Explicitly binds the unique window handle descriptor (HWND). This enables the system to continuously route input sequences into the background even while you interact with other desktop apps.
* Environment Core Reload (⭮): Dispatches an emergency global reload command to instantly refresh script dependencies, clean stack buffers, and reset running metrics.
* Restore Toggle (⛶): Spawns the Main GUI and hides the Mini GUI.

Session Controls:
* Init Sequence Start Button (🟢): Instantly triggers the Init Sequence loop. Cannot be used to start other independent modes.
* Pause/Resume Button (❚❚): Gracefully parks execution threads mid-race without wiping session tracking states.
* Hard Stop Emergency Reset (⏹): Forcibly stops hardware loops, zeroes temporary tracking variables, and resets the interface state.

## 🔧 Troubleshooting & FAQ

#### Q: The macro runs and clicks on the dashboard, but keys don't register inside the game.
**A:** Windows security rules often prevent background scripts from sending keypresses into high-privilege game applications. Close your macro entirely, right-click your `FH6_Macro_CyberNoir.exe` or `main.ahk` source file, and choose **Run as Administrator** to solve this.

#### Q: The macro is dropping inputs, skipping menu loops, or clicking buttons too early.
**A:** This happens if your PC encounters lag or if your drive takes longer to load scenes. To fix this, adjust the analog **Delay Multiplier** slider on the dashboard up to `1.5x` or `2.0x`. This adds wider safety buffers to keep the script and game synchronized.

#### Q: Why does the script keep triggering a "Menu timed out!" or "Sync Error" popup box?
**A:** This indicates that the macro's pixel scanner read an unexpected color code. Verify that your HUD Safe Frames are set exactly to `5` and `9`, your in-game brightness is set to `50`, and graphics options like HDR or Windows "Night Light" filters are turned off, as they warp hex color values.

#### Q: Can I turn off my physical monitor display while running farming loops overnight?
**A:** **Yes, but only by pressing the physical power button directly on your monitor chassis.** Do **NOT** let Windows enter Power Saving Mode, put the display to sleep, or lock your system account (`Win + L`). Doing so stops the graphics card from updating its frame buffer rendering loops, which turns the macro's vision completely black.

#### Q: What does the log note "Sync Warning: Pixel missed. Proceeding blindly..." mean?
**A:** This is a built-in soft-fail safety feature. If your system hitches or experiences a minor frame drop, the script identifies that it missed a precise pixel marker. Instead of halting your entire session, it logs a warning, waits a brief scaled buffer interval, and continues running the automation sequence safely.

#### Q: How can I run this tool on an Ultrawide (21:9) or non-standard aspect ratio screen?
**A:** Use the macro dashboard dropdown menu to choose a standard 16:9 window scale resolution, and press the "🗗" icon layout button on the mini interface widget to apply windowed configurations. Since the tool targets relative window coordinates rather than absolute monitor lines, execution tracks perfectly across bordered window boxes.

#### Q: What is the "First-Time Unfocus" quirk and how do I prevent the game from auto-pausing?
**A:** The background window execution framework has a minor quirk: if the game loses focus for the very first time while you are actively driving in Free Roam or mid-race, it triggers an automatic game pause state that breaks the macro loop. To prevent this, **always click away to your background apps while your character is resting inside a static menu structure** (such as the main pause screen or your home garage). Once unfocused there, the macro will run smoothly in the background. Do not click back and forth onto the game window once your session starts.

## ⚠️ Safety & Customization

Before leaving the macro unattended for long periods, run through each mode manually for a few test cycles to verify your configuration scales perfectly with your hardware performance profile. You can modify layout structures or performance options within the modular source files, and all key parameters save cleanly inside the centralized `.ini` configuration framework for quick setups across reboots.

This tool operates entirely by simulating virtual hardware keyboard inputs and **does not modify game memory blocks, inject structural payloads, or alter your local game save files**. All execution paths and monitoring profiles remain the responsibility of the end user.

<br/><br/>

<p align="center">
  <a href="https://ko-fi.com/mhaziqiqbal">
    <img width="350" height="190" alt="Support on Ko-fi" src="https://github.com/user-attachments/assets/3791e71d-9ecb-4e81-811a-6e153118db1d" />
  </a>
</p>
