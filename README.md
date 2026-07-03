# 🏎️ Forza Horizon 6 Wheelspin Macro

Welcome to the ultimate progression companion for Forza Horizon 6! This is a highly modular, high-performance automation tool built on **AutoHotkey v2** designed to eliminate repetitive in-game tasks. Whether you want to skip the grind, farm credits, or stack up Super Wheelspins, this macro fully automates your workflow using optical character recognition (OCR), pixel-aware session tracking, and background play execution.

<p align="center">
  <img width="272" height="828" alt="Main Dashboard UI" src="https://github.com/user-attachments/assets/43944c7d-e954-4643-8763-3e8fc481dda2" />
  <img width="274" height="953" alt="Settings Configuration" src="https://github.com/user-attachments/assets/993f22f2-7095-4538-a710-bdc098750774" />
  <img width="272" height="828" alt="Targets & Telemetry" src="https://github.com/user-attachments/assets/001cc969-0b0f-40ba-a797-22db6bc01621" />
</p>

---

## 📑 Table of Contents
* [🚀 Quick Start (TL;DR)](#-quick-start-tldr)
* [🖥️ System & Game Prerequisites](#%EF%B8%8F-system--game-prerequisites)
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
* [⚠️ Safety & Customization](#%EF%B8%8F-safety--customization)

---

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

---

## 🖥️ System & Game Prerequisites

To guarantee that the macro's pixel detection and text-matching systems synchronize perfectly, verify your PC configuration meets these guidelines:

* **Operating System:** Windows 10 or Windows 11.
* **Game Language:** Must be set to **English** for the UI navigation checks and OCR text validation logic to function.
* **Permissions:** Running the macro as an **Administrator** is highly recommended to ensure virtual keyboard inputs register correctly in-game.
* **Control Mapping:** You must use the game's default **WASD keyboard controls layout**. Using custom key mappings or controller overlays will cause input routing issues.

> ⚠️ **Background Play Rule:** Want to scroll Discord or watch YouTube while farming? The macro completely supports background execution! For the best background play experience, it is highly recommended to use the **Always On Top**, **Resize**, and **Lock** features through the buttons on the mini overlay interface.

---

## 📊 The Reward Vehicle Matrix

Select your preferred target car on the dashboard dropdown menu depending on your progression strategy and budget:

| Vehicle Choice | Base Cost | Cost with 5% Discount | Mastery Perk Rewards | Skill Points Needed | Strategy Profile |
| --- | --- | --- | --- | --- | --- |
| **1998 Subaru Impreza 22B-STi Version** | 86,000 CR | 81,700 CR | 1x Super Wheelspin | 30 Points | **Budget Wheelspins:** Great low-cost choice for farming steady Super Wheelspins. |
| **2024 Lamborghini Revuelto** | 365,000 CR | 346,750 CR | 1x Super Wheelspin + 3x Regular Wheelspins | 39 Points | **Max Yield Fast:** Dumps heavy credits to maximize total wheelspin volume as fast as possible. |
| **1999 Dodge Viper GTS ACR** | 68,000 CR | 64,600 CR | 150,000 Cash Credits | 30 Points | **Credit Flipping:** Quickly converts your skill points back into raw cash credits. |
| **1974 Mazda #123 Mad Mike 808 Wagon 'FURSTY'** | 100,000 CR | 95,000 CR | 1x Super Wheelspin | 21 Points |Point-Efficient Wheelspins: Requires the fewest skill points to unlock a Super Wheelspin, making it the fastest way to burn through a point bank.

> \* **Note on 1974 Mazda #123 Mad Mike 808 Wagon 'FURSTY':** This is a Car Pass only car! Make sure to select it only if you owned it via Premium Edition, Car Pass pack or single add-on purchase.  
> \* **Note on Premium Edition:** If you are running a premium edition account that alters this vehicle's placement layout inside the Journal, make sure to click the **PREMIUM** button layout on the UI dashboard to safely adjust menu tracking layers.  
> \* **Note on Standard Edition with Car Pass:** If you are running a standard edition account with additional Car Pass, Buy Mode might not work properly as the vehicle's placement layout inside the Journal might be different than usual, make sure to raise Issues if that happens.

---

## ✨ Key Features & Architecture

This automation utility balances low-level Windows API hooks with a highly refined, feature-rich control dashboard to ensure optimal background play performance and ease of use:

### 🎮 Advanced Hardware-Accelerated Background Processing
* **Direct Background Composition OCR:** Fully replaced legacy foreground-dependent hooks (`OCR.FromWindow`) with an integrated low-level GDI Canvas rendering engine (`GetBackgroundOCR`). It captures background window frames via `PrintWindow` utilizing composition flag `2`, executing fast hardware crop transfers via `BitBlt` even when the game window is entirely covered or out of focus.
* **Direct Memory Pixel Color Engine:** Refactored `WaitForPixel` and `GetPixelColor` subsystems to intercept graphics buffers directly from memory device contexts using `gdi32\GetPixel`. It translates native GDI BGR structures into an RGB conversion array utilizing native BGR-to-RGB color matrix transformation blocks.
* **Precise Client Coordinate Calibration:** Refactored the `CheckWindowed()` calibration system to query canvas boundaries via `WinGetClientPos` instead of relying on standard application window properties (`WinGetPos`). This strips out inconsistent OS-level window borders and title bars, stabilizing background canvas evaluation tracking.
* **Guaranteed Memory & Handle Protection:** Enforces clean memory states using structural `try...finally` resource disposition routines tracking all dynamic GDI canvas resource handlers to completely eliminate handle tracking or thread leaks across all GDI Bitmaps and Device Contexts (`DeleteObject`, `DeleteDC`, `ReleaseDC`).
* **Proactive Anti-Pause Window Spammer:** Intercepts specific focus activation signals—specifically checking for certain Windows Shell Hook event messages. If the game client loses focus, the macro instantly bypasses the game engine's default window-focus suspension loop by flooding the application thread with explicit activation directives before the game can register the defocus state and pause itself.
* **Strict Handle Pointer Targeting:** Abandons fragile text title tracking in favor of binding directly to a unique window descriptor identification token (`HWND`). This ensures background micro-automation sequences remain fully isolated from desktop focus changes, overlapping apps, or title string renames.

### 🎨 CyberNoir UI & Feature-Rich Dashboard Suite
* **Dynamic Theme Engine:** Switch seamlessly between a customized, cyber-styled **Dark Mode** and **Light Mode** workspace layout on-the-fly. The manual theme selector toggle is cleanly located within the top-left window header utility space.
* **Execution Speed Control (Analog Delay Multiplier):** Features a highly adjustable analog slider supporting expanded **0.25x to 4.0x** scaling based natively on multiplier array bounds. This allows users to dynamically expand or contract script menu delay buffers and pixel detection timeouts to match their storage drive speed (SSD vs. HDD) and system throughput performance.
* **DPI-Safe Interface:** Replaced native OS slider and configuration components with an entirely custom system, fully protecting the application window from layout clipping bugs or offset rendering caused by Windows display scaling settings.
* **Sleek Control Switches:** Replaced clunky selection checkboxes with dedicated layout control switches, providing refined **STANDARD / PREMIUM** game tier adjustments and explicit **KEEP / SELL** spin rules.
* **Responsive MiniGUI Overlay:** Minimizing the primary dashboard shrinks the environment into a highly responsive, floating overlay widget tracking runtime, key states, credits, and wheelspins. It features an optimized **2x2 alignment grid tree** to clean up overlapping elements alongside quick-access action toggles to trigger diagnostics, game locks, or environment resets.
* **Interactive Share Code Footer:** Includes a click-to-copy integration built right into the GUI footer. Selecting your active track profile from the dropdown menu dynamically updates the footer text with the correct blueprint and tuning codes, copying them instantly to your clipboard for effortless in-game pasting.

### 📊 Telemetry, Safety, & Async Update Lifecycles
* **Asynchronous GitHub Updater Engine:** Implements an integrated software update checker pipeline mapping into the GitHub Releases API. It evaluates live semantic version arrays, detects system architectures (x32/x64), streams data packages in the background, and dynamically invokes local PowerShell scripts to extract assets, cleanly overwrite running binaries, and reboot.
* **Pre-Purchase OCR Verification Tripwire:** Integrates a real-time optical verification sweep (`ScanOCR`) directly before finalizing any transaction loop inside `Task_Buy.ahk`. This acts as a protective shield to guarantee the script never accidentally buys an unmapped vehicle profile or gets stuck on misaligned index entries.
* **Accidental Deletion & Auction Interceptor:** Triggers a hard modal intercept, plays an audible system alarm, and kills the runtime loop instantly if a `"Remove Car From Garage"` text or a dangerous `"Create Auction"` prompt is caught by the background scanning thread.
* **Deterministic Math Models & Data Mapping:** Maps track metadata and vehicle configurations into explicit dictionary structures, allowing the pipeline to easily scale and adapt to custom records. Rather than relying on volatile runtime estimates, the program utilizes internal mathematical formulas based on empirical loading baselines to accurately project session completion times.
* **Dual-Phase Validation Scans:** Captures an OCR area snapshot right **before a race initializes** to log your starting balance, and runs a mirror calculation check **immediately after the match finishes**. This calculates exact performance updates per sequence interval and verifies that network disconnects didn't drop your match rewards.
* **Smart Overestimation Cap:** While the true in-game skill point balance caps out at 999, the macro limits its internal single-loop target ceiling to a conservative max score of **980**. This buffer prevents mathematical overestimations from forcing the loop routine to purchase redundant, surplus vehicles.
* **Fuzzy Optical Character Recognition (OCR):** Integrates `OCR.ahk` alongside a specialized **Fuzzy Edit-Distance String Recognition Pipeline**. This replaces rigid exact-string matches with a case-insensitive mathematical similarity scoring system, letting the macro safely absorb subtle OCR misreads without halting operations.
* **Application Health Guardrails:** Pre-execution verification checks run prior to firing macros; if the game client crashes or closes unexpectedly, the macro steps out of execution states instead of firing keys randomly into empty desktop space.

### 🛠️ Developer & Configuration Tools
* **Centralized File Configuration Sync:** Standardizes a local persistent `.ini` file configuration framework to cache structural variable settings (custom tracks, car indices, loop multipliers, viewport configurations, licensing tiers) across reboots.
* **Heuristic Application Path Discovery Matrix:** An autonomous background engine scanner that queries local Windows Registry keys, traces registered App Paths, and checks default system directories across multiple storage drives to locate the game executable without requiring manual path specification.

---

## 🔁 The Automation Modes

The core macro pipeline is divided into independent operational modules that can be launched as standalone processes or chained into a continuous loop:

### 🏁 Race Mode (Hotkey: `\`)
* **Purpose:** Automates your skill point farming loops.
* **Logic:** Automatically targets and launches the EventLab track positioned at the **very top of your Favorites list**. It drives using profile-specific telemetry parameters and handles loading state menus to avoid lockups.

### 🚗 Buy Mode (Hotkey: `[`)
* **Purpose:** Automates volume vehicle purchasing from the Autoshow.
* **Logic:** Performs an initial pre-flight OCR balance check to ensure you have enough resources. It dynamically calculates your purchase budget based on available skill points, shifts navigation paths based on your **Standard / Premium** tier toggle layout, and validates transactions via an OCR verification scan to eliminate menu indexing errors.

### 🛞 Unlock Mode (Hotkey: `]`)
* **Purpose:** Unlocks targeted car mastery rewards and cleans out your garage.
* **Logic:** Runs pre-flight resource validation and invokes the **Two-Phase Emergency Safety Framework**. Guided by the active `CarSorted` tracker, it scans layout parameters using `GetTextSimilarity`. If text correspondence falls below an **80% match**, or if a dangerous prompt is caught, the script triggers an emergency hard shutdown to safeguard your account.

### ♾️ Full Loop Automation (Hotkey: `/`)
* **Purpose:** Fully unattended, continuous farming.
* **Logic:** Continuously chains all three main modes together (**Race → Buy → Unlock → Repeat**) for your specified count of loops, safely managing your residual skill point offsets across full cycles.

    🎥 [Watch the Full Loop Demonstration](https://www.youtube.com/watch?v=6ezhyNeIYko)

### 🎰 Spin Mode (Hotkey: `=`)
* **Purpose:** Automatically burns through your backlog of accumulated wheelspins.
* **Logic:** Designed to be activated while hovering over your wheelspin tiles inside the game's **My Horizon** pause menu. It logs live reward statistics and respects your GUI toggle settings to automatically **KEEP** new prize vehicles or **SELL** duplicates for cash.

---

## ⌨️ Keyboard Controls Masterlist

| Keybind | Action Performed |
| --- | --- |
| `\` | Start standalone **Race Loop** |
| `[` | Start standalone **Buy Loop** |
| `]` | Start standalone **Unlock Loop** |
| `/` | Initialize Continuous **Full Automation Loop** (`FULL LOOP`) |
| `` ` `` (Backtick) | **Pause / Unpause** active macro tracking states instantly |
| `F5` | Toggle visual **Detection Zone Diagnostic Overlay** panels |
| `F12` | Force a complete hard **Reload** of the application workspace modules |
| `Ctrl + Shift + C` | Developer Calibration Utility: Copy normalized screen coordinates and Hex color code |
| `Alt + Left Click` | Move the game client window around your desktop via click-and-drag |

---

## 📷 Step-by-Step Setup Guide

### ⚙️ 1. Difficulty Settings

Verify your in-game configurations match the settings below for maximum consistency and reliability.

| Setting | Recommended Value |
| --- | --- |
| Drivatar Difficulty | UNBEATABLE |
| Driving Assists Preset | FULL ASSISTS |
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
  <img width="2456" height="1068" alt="Skills HUD Off" src="https://github.com/user-attachments/assets/c92a4501-a0f7-4af7-bc0a-ebe25ece19df" />
</p>

### 🖥️ 3. Video & Graphics Settings

#### Required Video Configuration

| Game Setting | Required Target Value |
| :--- | :--- |
| **Brightness** | `50` |
| **HDR** | `Off` |
| **Resolution** | `1920 x 1080` *(Recommended / See Fallbacks)* |
| **Framerate** | `60 FPS Lock` *(Almost Mandatory)* |
| **Graphics Quality** | `Lowest Settings` |

#### Technical Implications (OCR & Pixel Search)

* **Color Matching Stability (Brightness & HDR):** The pixel detection engine samples exact hexadecimal color coordinates to handle menu transitions. Activating HDR or moving the brightness slider warps these color codes, rendering the scanner blind and causing "Sync Errors".
* **OCR Text Recognition Matrix (Resolution):**
  * **Scale Calculations:** The macro dynamically recalculates scanning coordinates across standard **16:9 layouts** (1080p, 1440p, 4K). 
  * **Peak Accuracy:** The underlying OCR engine is optimized for a native **1920x1080** canvas; running at this resolution delivers the highest character recognition success rate. Internal local fallbacks support scaling to **1280 x 720** for enhanced processing fidelity on lower setups.
  * **Ultrawide & Custom Shapes:** Non-standard screen arrays (such as **21:9** or **16:10**) require running the game client inside a restricted **windowed container** to maintain proper element coordinate mapping.
* **Input Timing & Engine Sync (Framerate):** The script's operational delay buffers, telemetry verification tracking, and turning physics calculations are tightly synchronized to a fixed **60Hz update loop**. Running an unstable or higher framerate will cause the macro to drop key inputs.
* **Visual Noise Reduction (Graphics Quality):** Setting your graphics to the lowest values strips out volatile environmental factors like dynamic shadows, motion blur, and anti-aliasing artifacts. This clean image stream significantly boosts the processing speed and reliability of both pixel scanning and OCR utilities.

> 🛡️ **Screen Coverage Freedom:** Thanks to our rewritten rendering architecture utilizing a low-level GDI Canvas framework, **the game window can be completely covered or hidden out of focus** by other overlapping applications without blocking color scanning or optical character parsing routines.

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

---

### 🏁 7. Choosing Your In-Game Starting Positions

Make sure your game client is positioned at the correct baseline menu structure before launching an automation script:

#### For Full Loop / Race / Buy Modes
1. Ensure you are fully loaded into an active session (standing in your player home menu, highlighting Drive selection).
2. Confirm there are no loading screens present and that standard keyboard inputs are responsive.

<p align="center">
  <img width="2559" height="1439" alt="Home Menu Base Position" src="https://github.com/user-attachments/assets/e6c585b4-264e-4a4c-8cf8-8d4ed7144ffc" />
</p>

#### For Unlock Mode
When executing the **Unlock Mode** standalone macro sequence manually (Hotkey: `]`), you have two options depending on the starting car chosen.
* **Automatic**: Same starting point as For Full Loop / Race / Buy Modes. Will automatically scan current skill points, sort and choose the newest car added to garage.
* **Custom**: Need to manually enter current skill points, sort your vehicle list and position your highlight cursor explicitly beforehand.
  1. Open the game's **Buy & Sell** tab layout, navigate directly into the **Auction House**, and select **Start Auction**.
  2. Press `X` to adjust your listing filter parameters, switch your sort layout structure to **Recently Added**, and confirm the layout.
  3. Enter your active vehicle collection grid view.
  4. **CRITICAL BASELINE STEP:** Use your directional arrow keys to **hover over and highlight the specific car slot you want the macro to start processing with—but DO NOT press Enter to select it.** Keep the cursor cleanly highlighting that specific car square, and then fire your standalone unlock script via your hotkey.
  5. **REMINDER:** Choose only the first or second car in the row!!!

<p align="center">
  <img width="2559" height="1439" alt="Unlock Mode Base Position" src="https://github.com/user-attachments/assets/d824e130-6672-4a3c-a7bd-94dc4f0155fb" />
</p>

> **Reminder**: During Unlock mode, make sure the car's stats numbers, as featured in the red box, are shown on the screen! It is necessary for car verification to work properly.

#### For Spin Mode
1. Open the pause menu and navigate over to the **My Horizon** tab layout.
2. Use your controls to highlight or hover directly over your preferred wheelspin tile (Regular Wheelspin or Super Wheelspin) **without actually opening the menu selection**. Keep your dashboard panel snapped nearby to track your rewards.

<p align="center">
  <img width="2559" height="1439" alt="My Horizon Base Selection" src="https://github.com/user-attachments/assets/3a4ce3b7-f695-4cf4-a174-64ee42cd2c29" />
</p>

---

### 📱 8. Controlling the GUI

#### 🎛️ Master GUI Control Dashboard Guide

The master interface serves as the centralized command center for configuring automated workflows, calibrating execution delays, balancing in-game budgets, and initializing independent farming routines.

#### 1. Session Parameter Inputs (Target Matrix)

<p align="center">
  <img width="271" height="139" alt="Target Matrix" src="https://github.com/user-attachments/assets/569140dd-ca8a-43cc-a5a1-f51fb80a3cc4" />
</p>

The upper portion of the **Input** tab allows you to define processing boundaries before deploying a script loop:

* **Current Skill Points:** Displays or allows manual override entry for your active vehicle mastery balance.
* **Desired Skill Points:** Sets your ultimate resource ceiling target (e.g., `980`). Once reached, the automation engine cleanly finishes its active cycle and transitions out of racing states.
* **Car Purchase:** Specifies the exact volumetric block size of inventory assets to purchase in bulk during a single standalone "Buy" routine loop.
* **Sequence Loop:** Sets the total absolute iteration count for continuous automated cycles when running multi-stage loops.

#### 2. Vehicle Selection, Edition Tier, & Delay Engine Calibration

<p align="center">
  <img width="270" height="132" alt="optimization switches" src="https://github.com/user-attachments/assets/d26e6009-6e3e-4cb0-ac42-6e69f1c4ce30" />
</p>

Directly underneath the parameter matrix are the optimization switches used to align the macro's navigation paths with your specific game profile:

* **Vehicle Dropdown Menu:** Selects the precise target vehicle schema (e.g., `Subaru Impreza 22B-STi` or `Mazda #123 Mad Mike 808`) to ensure the underlying OCR and mastery node layouts align correctly.
* **STANDARD / PREMIUM Toggles:** Switches between different in-game car list menu alignments. If your game edition includes DLC car layout additions that shift grid coordinates, selecting **PREMIUM** recalibrates the menu tracking layer.
* **Delay Multiplier Slider:** Provides an analog scaling slider ranging from **0.25x to 4.0x** mapped directly to the active multiplier list bounds. If your system experiences sudden background frame drops, disk read latency, or server connection lag, slide this modifier upward to scale all internal sleep buffers of key inputs safely.

#### 3. Core Automation Execution Triggers

<p align="center">
  <img width="268" height="161" alt="primary control buttons" src="https://github.com/user-attachments/assets/d4bae11a-97e5-4b0a-b114-c5bdc9945955" />
</p>

The primary control buttons launch individual automation modes or initialize the full continuous macro pipeline:

* **FULL LOOP (`/`):** Daisy-chains all core operational modes into a continuous, self-sustaining loop (Race → Buy → Unlock → Repeat).
* **RACE (`\`):** Launches the automated EventLab farming loop.
* **BUY (`[`):** Executes the bulk vehicle acquisition macro sequence.
* **UNLOCK (`]`):** Initializes the vehicle perk grid mastery loop, strictly governed by the new double-phase validation state checking.
* **OPEN SPIN INTERFACE:** Spawns the embedded prize delivery panel directly within the dashboard.

#### 4. Embedded Spin Controller Panel

<p align="center">
  <img width="253" height="292" alt="image" src="https://github.com/user-attachments/assets/3a50c8b0-ce41-48f5-a298-c147b1642217" />
</p>

Clicking the purple interface trigger transforms the center of the dashboard into an isolated bulk opening terminal.

* **Spin Loop Input Box:** The number of wheelspins that will be opened before returning to free roam to avoid inactivity warning.
* **Desired Spins Input Box:** The number of total wheelspins throughout the whole process that will opened before ending the mode.
* **Live Teleview Readouts:** Tracks real-time session statistics including total **Spin Runtime**, total **Spins Opened**, and **Spins Remaining** in the active backlog queue.
* **KEEP / SELL Optimization Buttons:** Sets the structural rule engine for duplicate prize car drops. Choosing **SELL** auto-converts duplicates back to liquid in-game credits instantly, while **KEEP** passes them into your garage structure.
* **RUN WHEELSPIN (`=`):** Fires the automated hardware routine to continuously clear out your accumulated wheelspin cache.

#### 5. Profile Selection, Quick-Copy Share Codes and Auto Updater

Located right below the running telemetry state readouts is the integrated track configuration and code utility footer:

<p align="center">
  <img width="270" height="181" alt="footer" src="https://github.com/user-attachments/assets/10180cbf-b658-4620-a57c-c825b7abc9e7" />
</p>

* **Track Profile Dropdown Menu:** Allows you to swap seamlessly between different pre-configured automated driving routes, such as `AMMAGEDON` or `LIQUIDPOTATO`. Selecting a track profile immediately updates the underlying path calculations, timing variables, and telemetry color nodes to match that specific layout.
* **Dynamic Click-to-Copy Share Codes:** Features interactive, clickable text links for both the vehicle mechanics configuration (`Subaru 22B Tune Code`) and the blueprint layout (`EventLab Race Code`).
* **Instant Clipboard Integration:** Clicking on either text link instantly copies the respective multi-digit in-game share code straight to your Windows clipboard. This completely removes the need to manually write down or type long numeric strings when searching for assets inside the game client.
* **Automated Footer Synchronization:** The structural share codes switch and update automatically in real time based on your active selection in the track profile dropdown menu, ensuring you always copy the correct matching tune and map combinations.
* **Smart Auto-Updater** Featuring a seamless, built-in background update engine that communicates directly with the GitHub Releases API to ensure you are always running the optimal build.
  * **Semantic Version Parsing:** Intelligently compares your local version against the latest GitHub release to determine your exact state: `Up to Date ✓`, `Update Available ⚠`, or `Beta Build 🧪` (for local development).
  * **Architecture-Aware Downloads:** Automatically detects your system environment and fetches the correct asset—whether it's a raw script `.zip` package or a compiled `x64`/`x32` executable.
  * **Streamlined UI Integration:** Integrated directly into the borderless footer status bar. Clicking the notification dynamically routes you to the automated in-app installer or opens the latest changelog in your default browser.

#### 6. Advanced System Options & Launch Utility

<p align="center">
  <img width="268" height="178" alt="image" src="https://github.com/user-attachments/assets/ed6b1cc2-b4fd-478e-a7c1-8e834574d4d2" />
</p>

Expanding the **OPTIONS** toggle dropdown at the bottom of the dashboard grants access to background management and initialization hooks:

* **Resolution Configuration Dropdown:** Configures target canvas viewport sizes (default scaling set to **1280 x 720** for minimum OCR character fidelity) for windowed scaling metrics.
* **SET GAME PATH:** Links the automation suite directly to your local installation directory for automated startup sequences.
* **LAUNCH GAME:** Autonomously executes the target software executable while preparing local configuration settings.
* **SPECIAL K Core Status:** Displays real-time API connection flags (e.g., `SPECIAL K (GAME RUNNING)`) to verify background play input translation wrappers are working smoothly.

#### 🗲 Compact Mini GUI Overlay

<p align="center">
  <img width="237" height="331" alt="MiniGUI" src="https://github.com/user-attachments/assets/b7596488-605c-4520-b274-8313fe4ca3fd" />
</p>

When the main configuration dashboard is minimized, the tool shrinks into a highly responsive, floating overlay tracking live automation data and structural execution tasks in real time.

The icon row positioned along the top header of Mini GUI provides low-level window hook management directly into the background engine:
* **Window Mode Transformation (🗗):** Instantly commands the game window client to shift into a standardized 16:9 bordered resolution space. Calculations feature precise bounding adjustments to drop the canvas layout completely flush with screen boundaries, eliminating pixel alignment offsets entirely.
* **Always-On-Top Layer Lock (📌):** Toggles an absolute visual priority layering state. This ensures the game window or overlay remains structurally visible without focus degradation.
* **Game Lock Engine Pipeline (🔒):** Explicitly binds the unique window handle descriptor (HWND). This enables the system to continuously route input sequences into the background even while you interact with other desktop apps.
* **DWM Hardware-Accelerated Live Preview Subsystem (🎞️):** Harnesses the native **Windows Desktop Window Manager (DWM) Thumbnail API** (`dwmapi.dll`) through the `TogglePreview()` core trigger. It mirrors a hardware-accelerated, real-time preview stream of the out-of-focus background game canvas directly inside an auxiliary AutoHotkey GUI window container.
* **Environment Core Reload (⭮):** Dispatches an emergency global reload command to instantly refresh script dependencies, clean stack buffers, and reset running metrics.
* **Restore Toggle (⛶):** Spawns the Main GUI and hides the Mini GUI.

Session Controls:
* **Full Loop Start Button (🟢):** Instantly triggers the integrated continuous Full Loop automation sequence.
* **Pause/Resume Button (❚❚):** Gracefully parks execution threads mid-race without wiping session tracking states.
* **Hard Stop Emergency Reset (⏹):** Forcibly stops hardware loops, zeroes temporary tracking variables, and resets the interface state.

---

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

---

## ⚠️ Safety & Customization

Before leaving the macro unattended for long periods, run through each mode manually for a few test cycles to verify your configuration scales perfectly with your hardware performance profile. You can modify layout structures or performance options within the modular source files, and all key parameters save cleanly inside the centralized `.ini` configuration framework for quick setups across reboots.

This tool operates entirely by simulating virtual hardware keyboard inputs and **does not modify game memory blocks, inject structural payloads, or alter your local game save files**. All execution paths and monitoring profiles remain the responsibility of the end user.

<br/><br/>

<p align="center">
  <a href="https://ko-fi.com/mhaziqiqbal">
    <img width="350" height="190" alt="Support on Ko-fi" src="https://github.com/user-attachments/assets/3791e71d-9ecb-4e81-811a-6e153118db1d" />
  </a>
</p>
