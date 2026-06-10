An AutoHotkey v2 automation tool designed for Forza Horizon 6, featuring a custom GUI, pixel-aware session tracking, and structured automation workflows to streamline repetitive in-game progression tasks.

<p align="center">
  <img width="278" height="827" alt="Screenshot 2026-06-11 030128" src="https://github.com/user-attachments/assets/cc2ce940-ee29-42fb-a972-6d39df4aa094">
  <img width="276" height="825" alt="Screenshot 2026-06-11 030139" src="https://github.com/user-attachments/assets/c20e98c0-9a2f-446e-985a-6b2e4232cb09">

</p>

---

## 📑 Table of Contents
- [Overview](#-overview)
- [Prerequisites](#%EF%B8%8F-prerequisites)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
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

The original base script was developed by **6ftFish**, and this version has been significantly redesigned and expanded with pixel-detection verification systems, custom UI improvements, and workflow safety enhancements.

---

## 🖥️ Prerequisites

Before installing, ensure your system strictly meets the following layout and control requirements:
* **Operating System:** Windows 10 / Windows 11
* **AutoHotkey:** [AutoHotkey v2](https://www.autohotkey.com) (v1 scripts will not run)
* **Game Language:** English (UI navigation and dynamic timing validation logic are optimized for the English game client).
* **🖥️ Display Settings (Strict Requirements):**
  * **Aspect Ratio:** Must be **16:9 Resolution** only (e.g., 1920x1080, 2560x1440, 3840x2160).
  * **Display Mode:** Must be set to **Fullscreen** only. Windowed or Borderless Window modes will disrupt the scaling math, throwing off pixel coordinates.
* **⌨️ Control Configuration:**
  * **Control Scheme:** Must use the native **WASD control layout** exclusively. Custom mappings or controller overlays will cause the automation routing to drop inputs.

---

## 📥 Installation

1. Download the latest version of AutoHotkey v2 and install it.
2. Clone this repository or download it as a ZIP file:
```bash
   git clone https://github.com/M-Haziq-Iqbal/Forza-Horizon-6-Wheelspin-Macro.git
```
3. Extract the files (if downloaded as a ZIP) to a dedicated folder.
4. Double-click the `FH6_Macro_CyberNoir.ahk` file to launch the application interface.

---

## 🚀 Quick Start

1. Launch Forza Horizon 6 and load into the Home Menu.
2. Ensure your game is set to **16:9 Resolution** and **Fullscreen**.
3. Verify your primary vehicle controls are bound to **WASD**.
4. Ensure the Subaru Impreza 22B-STi Version is your only Favorited vehicle.
5. Apply Tune Share Code `293 391 902` and disable the Skills HUD.
6. Start the macro application and trigger your desired mode.

---

## ✨ Key Features

* 🎨 Custom GUI layout with dark/light theme options on-the-fly.
* 👁️ **Pixel-Aware Engine:** Dynamic menu loading synchronization checks to systematically mitigate desync issues.
* 📊 Real-time session runtime telemetry and calculated progress logs.
* 🏁 Automated race loop execution with recovery checks.
* 🚗 Fast-navigation car purchasing routines.
* 🛞 Automated wheelspin and cash reward perk unlocking.
* 📈 Skill point estimation tracking and continuous calibration logic.
* ⚙️ Modular process state architecture built inside performance-oriented Switch nodes.
* ⌨️ Hotkey-driven script control mapping with instant pause tools.
* 📋 Click-to-copy in-game share code integration.
* 🛠️ **Developer Diagnostic Tool:** Integrated automated coordinate/color calibration utility.

---

## 🔁 Automation Modes

The automation workflow is split into three independent processes that can be executed separately or combined into a continuous cycle.  

### 🏁 Race Mode (Hotkey `\`)
Runs only the race automation process.
* Automatically interfaces with the custom EventLab menu spaces.
* Drives the configured layout automatically while evaluating estimated points.

### 🚗 Buy Mode (Hotkey `[`)
Runs only the vehicle purchasing process.
* Navigates to the designated vehicle layout efficiently based on your selection.
* Buys the exact matching vehicle configuration stack up to your target count.

### 🛞 Unlock Mode (Hotkey `]`)
Runs only the reward unlocking process.
* Enters the Car Mastery panels with precise verification states.
* Redeems wheelspins, super wheelspins, or credit payouts depending on the active car type.

### ♾️ Full Automation Loop (Hotkey `/`)
Combines all processes into a single continuous workflow (Race → Buy → Unlock → Repeat). The macro will continuously cycle through all stages, properly maintaining residual skill point offsets across full cycles.  
🎥 [Watch the Full Loop Demonstration](https://www.youtube.com/watch?v=6ezhyNeIYko)

---

## 🧠 Core Systems

### 🎛️ Automation Engine
Controls in-game navigation using predefined key sequences, featuring responsive color-sampling verification layers (`WaitForMenuRelative`) to ensure menus are fully rendered before issuing subsequent commands.

### 📊 Telemetry System
Actively tracks total running time, loop-specific session times, total acquired cars, and calculated point outputs.

### 🧮 Progress Estimation
Uses calculated internal algorithms to estimate real-world session metrics, required item counts, and completion windows.

* **Tested EventLab Results:** EventLab race consistently produces a minimum of 940 Skill Points and a maximum of 945 Skill Points, with a typical completion time of around 51 minutes. The application tracks updates safely using a baseline of 9.8 points per sequence interval.
* **Maximum Skill Point Calculation:** The in-game Skill Point cap is 999. The application calculates your target based on your current points plus the estimated session gain, capping out automatically.

### 🎁 The Reward Vehicles
You can choose which vehicle the macro purchases and unlocks perks for via the GUI dropdown menu depending on your budget and preferred reward density. Make sure to purchase and unlock the Soko 78 house to get a permanent 5% discount on Autoshow purchases.

| Dropdown Choice | Cost Per Unit | Cost after 5% Discount | Mastery Grid Rewards | Skill Points Cost | Optimal Strategy |
| --- | --- | --- | --- | --- | --- |
| **Subaru Impreza 22B-STi Version (1998)** | 86,000 CR | 81,700 CR | 1x Super Wheelspin | 30 Points | **Budget Wheelspins:** Low-cost entry point for farming steady Super Wheelspins. |
| **Lamborghini Revuelto (2024)** | 365,000 CR | 346,750 CR | 1x Super Wheelspin + 3x Regular Wheelspins | 39 Points | **Max Yield:** Dumps heavy credits to maximize total wheelspin volume as fast as possible. |
| **Dodge Viper GTS ACR (1999)** | 68,000 CR | 64,600 CR | 150,000 CR | 30 Points | **Credit Flipping:** Converts Skill Points back into raw cash for a quick return or a near-full vehicle refund. |

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

### ⚠️ IMPORTANT: Keep Left Half of Screen Uncovered!
> **CRITICAL RUNTIME WARNING:** Do **NOT** cover, overlay, or block the **left half of your monitor screen** while this macro is executing. 
> 
> The dynamic pixel engine samples hex color data across coordinates exclusively located on the left half of the display workspace. If background apps (e.g., Discord, browser windows, Spotify), streaming overlays, or Windows system notification banners obscure any section of the screen's left half, the `WaitForMenuRelative` scanner will read false values, resulting in an immediate **Sync Error / Menu Timeout**.

<p align="center">
  <img width="2563" height="1453" alt="Screenshot 2026-06-11 025901" src="https://github.com/user-attachments/assets/700ce2ab-6d03-474a-8dfb-fa6c46e263d9">
</p>

### 🏁 Starting Position
Make sure you are in the Home Menu, loaded fully into an active session (no loading screens), with active keyboard input before starting any session.  
📌 All sessions use this identical baseline starting structure.

<p align="center">
  <img width="2559" height="1439" alt="Starting Position" src="https://github.com/user-attachments/assets/e6c585b4-264e-4a4c-8cf8-8d4ed7144ffc"> 
</p>

### 🎯 EventLab Menu Setup
Ensure the EventLab system is accessible and the search-by-code feature is unlocked. The macro will automatically input the following EventLab code: `124 198 343`

<p align="center">
  <img width="1941" height="896" alt="EventLab Setup 1" src="https://github.com/user-attachments/assets/c0dab41f-01bf-4975-99a9-bf48ff36028a"> 
  <img width="2457" height="1268" alt="EventLab Setup 2" src="https://github.com/user-attachments/assets/ec334fc9-8e5f-4027-b7ff-3306b8d4c775"> 
</p>

---

## 🚗 Required Car Setup

The automation requires a highly specific vehicle configuration to function properly.

### ✔️ Required Vehicle Configuration
* Subaru Impreza 22B-STi Version must be set as your **ONLY** favorited vehicle inside your garage container.
* All skill tree perk allocations must be fully maxed out (all mastery upgrades unlocked) on that main vehicle.
* No other cars can be configured as favorites to avoid structural index selection conflicts during automation passes.

### 🧩 Tuning Setup
Apply the following tuning configuration parameters to your target tracking vehicle.  
📌 Tuning Code: `293 391 902`

<p align="center">
  <img width="2559" height="1439" alt="Tuning Setup" src="https://github.com/user-attachments/assets/13020a98-4b58-4c2d-862f-bf1f2982068b"> 
</p>

---

## ⚙️ Required Game Setting Setup

Verify your in-game configurations match the settings below for maximum consistency and reliability. 

### 🎮 Recommended Difficulty Settings
> **Note:** These layout options represent the development baseline. Deviations may impact tracking loops, physics processing windows, or target route validation structures.

| Setting | Recommended Value |
| --- | --- |
| Display Mode | **FULLSCREEN ONLY** |
| Resolution / Aspect Ratio | **16:9 ASPECT RATIO ONLY** |
| Driving Controls Scheme | **WASD KEYBOARD LAYOUT ONLY** |
| Drivatar Difficulty | UNBEATABLE |
| Braking | ASSISTED |
| Steering | AUTO-STEERING |
| Shifting | AUTOMATIC |

<p align="center">
  <img width="2559" height="1438" alt="Difficulty Settings" src="https://github.com/user-attachments/assets/43f2059b-4fb6-4540-a573-7ff43abfd561">
</p>

### 🚫 Disable Skills HUD
Navigate to **Settings → HUD & Gameplay → Skills HUD** and turn it **OFF**.

Disabling the Skills HUD stops screen pop-ups from causing pixel processing desyncs or frame evaluation micro-stutters during execution passes. Turning this module off is highly recommended for stable, long-running farming operations.

<p align="center">
  <img width="2456" height="1068" alt="Skills HUD Off" src="https://github.com/user-attachments/assets/c92a4501-a0f7-4af7-bc0a-ebe25ece19df"> 
</p>

---

## 🔧 Troubleshooting & FAQ

### Q: The script immediately errors out with a "Sync Error" loop.
**A:** Ensure your game is in dedicated **Fullscreen** mode, using a **16:9 resolution**, and verify that absolutely no window panels, overlays, or pop-ups are obscuring the **left half of your screen**. 

### Q: The vehicle does not turn or navigate menus properly.
**A:** Double-check your active controls configuration profile. The macro hooks onto default **WASD keyboard mappings** to manipulate menus and vehicles. If your key bindings differ, the actions will fail.

### Q: The vehicle collides with walls during the EventLab loop session.
**A:** Double-check your simulation preferences profile setup against the difficulty parameters. Both **Auto-Steering** and **Assisted Braking** must be enabled for the vehicle path automation routine to process cleanly without human inputs.

---

## ⚠️ Important Warning (READ BEFORE USE)

This tool simulates user actions and monitors menu pixel updates, meaning:
* ⏱️ System responsiveness parameters dictate real-world efficiency gains.
* 🖥️ Disk speed and processor throughput profiles (SSD vs HDD, background CPU spikes) affect raw UI drawing windows.
* 🌐 Background asset streams or overlays can affect pixel detection routines.

### ✔️ First-Time Setup Recommendation
Before leaving the macro completely unattended for extended windows, execute each mode independently for a few test cycles. Monitor structural execution loops, check for screen indexing alignment mismatches, and adjust script delay flags if your hardware profile requires longer execution windows.

---

## 🛠️ Customization Encouraged

Users are strongly encouraged to dive into the source architecture to adapt layout functions. You can easily tweak color bounds inside `WaitForMenuRelative`, update navigation key mappings to accommodate personalized button assignments, customize window parameters, or inject customized performance logic paths to tailor it to your setup.

---

## 🙏 Credits

* **Base Script:** Original automation foundation and sequence structures created by [6ftfish](https://github.com/6ftfish/Forza_Horizon_6_Skill_Point_Macro).
* **Modifications:** This version includes a full GUI overhaul, pixel check safety additions, data models, layout optimizations, and structured script architecture.
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
