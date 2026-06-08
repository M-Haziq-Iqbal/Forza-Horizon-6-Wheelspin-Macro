# 🌑 FH6 Wheelspin Macro – Cyber Noir Edition

An AutoHotkey v2 automation tool designed for *Forza Horizon 6*, featuring a custom GUI, session tracking, and structured automation workflows to streamline repetitive in-game progression tasks.

<p align="center">
  <img width="280" height="812" alt="Screenshot 2026-06-08 190710" src="https://github.com/user-attachments/assets/7442437d-6790-42e4-99f7-430218c32d11" />
  <img width="278" height="811" alt="Screenshot 2026-06-08 200155" src="https://github.com/user-attachments/assets/18e42cf4-d7d8-4222-9cbc-f2f72be44540" />
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

This project is a desktop automation tool built with **AutoHotkey v2**. It automates multiple in-game workflows such as racing loops, car purchasing, and reward claiming, while providing a fully custom graphical interface for monitoring progress in real time.

The original base script was developed by **6ftFish**, and this version has been significantly redesigned and expanded with new systems, UI improvements, and workflow enhancements.

---

## 🖥️ Prerequisites

Before installing, ensure your system meets the following requirements:
*   **Operating System:** Windows 10 / Windows 11
*   **AutoHotkey:** [AutoHotkey v2](https://www.autohotkey.com/) (v1 will **not** work)
*   **Game State:** *Forza Horizon 6* installed and running in **Borderless/Windowed Fullscreen**.
*   **Game Language:** English (UI navigation and timing logic are optimized for the English game client. Other languages may have different UI load times or layout structures).

---

## 📥 Installation

1. Download the latest version of AutoHotkey v2 and install it.
2. Clone this repository or download it as a ZIP file:
```bash
   git clone https://github.com/M-Haziq-Iqbal/Forza-Horizon-6-Wheelspin-Macro.git
```
3. Extract the files (if downloaded as ZIP) to a dedicated folder.
4. Double-click the `FH6_Macro_CyberNoir.ahk` file to launch the application.

---

## 🚀 Quick Start

1. Launch Forza Horizon 6 and load into the Home Menu.
2. Ensure the **Subaru Impreza 22B-STi Version** is your *only* Favorited vehicle.
3. Verify all Car Mastery perks are unlocked for the vehicle.
4. Apply Tune Share Code: `293 391 902`
5. Apply the recommended game settings (see Setup Guide below).
6. Disable the Skills HUD in the game settings.
7. Start the macro application.
8. Run individual modes or start the Full Automation Loop.

---

## ✨ Key Features

*   🎨 Fully custom GUI with dark/light theme support
*   📊 Real-time session tracking and runtime statistics
*   🏁 Automated race loop workflow
*   🚗 Automated car purchasing system
*   🛞 Wheelspin and reward claiming automation
*   📈 Skill point estimation and progression calculator
*   ⚙️ Structured process state management system
*   ⌨️ Hotkey-driven control system
*   📋 Click-to-copy in-game codes integration
*   🔁 Flexible automation modes (Race / Buy / Claim / Full Loop)

---

## 🔁 Automation Modes

The automation workflow is split into three independent processes that can be executed separately or combined into a continuous cycle.  

### 🏁 Race Mode (Hotkey: `[`)
Runs only the race automation process.
*   Launches and completes the configured EventLab race
*   Accumulates skill points
*   Repeats race sessions until manually stopped

### 🚗 Buy Mode (Hotkey: `]`)
Runs only the vehicle purchasing process.
*   Purchases Subaru Impreza 22B vehicles
*   Prepares vehicles for perk claiming
*   Repeats purchase cycles until manually stopped

### 🛞 Claim Mode (Hotkey: `\`)
Runs only the reward claiming process.
*   Redeems Car Mastery rewards
*   Claims wheelspins and skill point rewards
*   Repeats claim cycles until manually stopped

### ♾️ Full Automation Loop (Hotkey: `` ` ``)
Combines all processes into a single continuous workflow (Race → Buy → Claim → Repeat). The macro will continuously cycle through all stages until stopped by the user. This mode is highly recommended for long unattended farming sessions *only after* timing has been properly verified on your system.
🎥[Watch the Full Loop Demonstration](https://www.youtube.com/watch?v=6ezhyNeIYko)

### 🛑 Stopping Automation
Any running automation mode can be safely stopped through the GUI or designated stop controls. **Always supervise initial runs** to verify timing before leaving the macro unattended for extended periods.

---

## 🧠 Core Systems

### 🎛️ Automation Engine
Controls in-game navigation using predefined key sequences, featuring robust state validation to ensure safe execution and reliable stop conditions.

### 📊 Telemetry System
Actively tracks total runtime, race session duration, buy/claim cycles, and estimated skill point gains.

### 🧮 Progress Estimation
Uses internal logic to estimate skill point gains per session, optimal car purchase counts, and expected completion times. The built-in estimator is grounded in repeated testing of the recommended EventLab route and vehicle setup.

**Tested EventLab Results:**
After multiple test sessions, the EventLab race consistently produced a minimum of **940 Skill Points** and a maximum of **945 Skill Points**, with a typical completion time of under 51 minutes. The application uses **940 Skill Points** as a conservative target value to avoid overestimating rewards.

**Maximum Skill Point Calculation:**
The in-game Skill Point cap is **999**. The application calculates your target based on your current points plus the estimated session gain, capping out automatically.

| Current SP | Estimated Gain | Final Total |
| :--- | :--- | :--- |
| 0 | 940 | 940 |
| 50 | 940 | 990 |
| 100 | 940 | 999 (capped) |

### 🎨 Theme System
Dynamic UI switching between Dark Mode (Neon Void) and Light Mode (Neon Daylight).

---

## ⌨️ Controls

| Key | Action |
| :--- | :--- |
| `` ` `` | Toggle Full Automation Loop |
| `[` | Start Race Loop |
| `]` | Start Buy Loop |
| `\` | Start Claim Loop |
| `F12` | Reload Script |

---

## 📷 Setup Guide (Important Before Running)

Before using the macro, ensure your game is properly configured. The automation relies heavily on consistent menus, timing, and UI positioning.

### 🏁 Starting Position
Make sure you are in the **Home Menu**, loaded fully into an active session (no loading screens), with active keyboard input.

<p align="center">
  <img width="2559" height="1439" alt="Starting Position" src="https://github.com/user-attachments/assets/e6c585b4-264e-4a4c-8cf8-8d4ed7144ffc" />
</p>

### 🎯 EventLab Menu Setup
Ensure the EventLab system is accessible and the search-by-code feature is unlocked. The macro will automatically input the following EventLab code: **124 198 343**

<p align="center">
  <img width="1941" height="896" alt="EventLab Setup 1" src="https://github.com/user-attachments/assets/c0dab41f-01bf-4975-99a9-bf48ff36028a" />
  <img width="2457" height="1268" alt="EventLab Setup 2" src="https://github.com/user-attachments/assets/ec334fc9-8e5f-4027-b7ff-3306b8d4c775" />
</p>

---

## 🚗 Required Car Setup

The automation requires a highly specific vehicle configuration to function properly.

### ✔️ Required Vehicle Configuration
*   **Subaru Impreza 22B-STi Version** must be the ONLY favorite car in your garage.
*   All perk points must be fully maxed out (all mastery upgrades unlocked).
*   No other cars can be favorited to avoid selection conflicts during automation.

### 🧩 Tuning Setup
Apply the following tuning configuration to the vehicle.
> 📌 **Tuning Code:** `293 391 902`

<p align="center">
  <img width="2559" height="1439" alt="Tuning Setup" src="https://github.com/user-attachments/assets/13020a98-4b58-4c2d-862f-bf1f2982068b" />
</p>

---

## ⚙️ Required Game Setting Setup

Verify your in-game configurations match the settings below for maximum consistency and reliability. 

### 🎮 Recommended Difficulty Settings
*Note: These settings were used during development and testing. Deviating from them may negatively affect race timing and automation reliability.*

| Setting | Recommended Value |
| :--- | :--- |
| Drivatar Difficulty | UNBEATABLE |
| Braking | ASSISTED |
| Steering | AUTO-STEERING |
| Traction Control | OFF |
| Stability Control | OFF |
| Shifting | AUTOMATIC |

<p align="center">
  <img width="2559" height="1438" alt="Difficulty Settings" src="https://github.com/user-attachments/assets/43f2059b-4fb6-4540-a573-7ff43abfd561" />
</p>

### 🚫 Disable Skills HUD
Navigate to **Settings → HUD & Gameplay → Skills HUD** and set it to **OFF**.

Disabling the Skills HUD prevents visual pop-ups during gameplay that can cause minor timing inconsistencies. While the macro *may* function with it enabled, turning it off is highly recommended for stable, repeatable farming sessions.

<p align="center">
  <img width="2456" height="1068" alt="Skills HUD Off" src="https://github.com/user-attachments/assets/c92a4501-a0f7-4af7-bc0a-ebe25ece19df" />
</p>

---

## 🔧 Troubleshooting & FAQ

**Q: The macro keeps missing button presses in the menu.**
> **A:** Your system's loading times might be slower than the default timing in the script. Open the `.ahk` file in a text editor, locate the `Sleep()` functions within the navigation loops, and increase the millisecond values (e.g., change `Sleep(500)` to `Sleep(800)`).

**Q: The script is just typing random keys on my desktop.**
> **A:** The macro simulates raw keyboard input. If *Forza Horizon 6* loses window focus, the keys will be sent to whatever application is currently active. Ensure you do not click outside the game window while the macro is running.

**Q: My car keeps driving into walls during the EventLab.**
> **A:** Double-check that your game settings exactly match the [Required Game Setting Setup](#%EF%B8%8F-required-game-setting-setup). "Auto-Steering" and "Assisted Braking" are strictly required for the macro to navigate the track without manual input.

---

## ⚠️ Important Warning (READ BEFORE USE)

This tool relies on **timed inputs and UI navigation**, which means:
*   ⏱️ Performance will vary between systems.
*   🖥️ Loading times depend entirely on your hardware (SSD/HDD/CPU/GPU).
*   🌐 Background processes can interrupt or affect timing accuracy.

### ✔️ First-Time Setup Recommendation
Before committing to full automation, run each mode manually at least once. Observe the timing carefully, look out for UI desyncs or missed inputs, and adjust the `Sleep()` delays in the script if necessary for your hardware.

---

## 🛠️ Customization Encouraged

Users are strongly encouraged to dive into the code to modify and improve the script. You can adjust timing values (`Sleep()`), modify key sequences to adapt to UI changes, tune the overall performance for your specific system, and improve the underlying automation logic.

---

## 🙏 Credits

*   **Base Script:** Original framework developed by [6ftfish](https://github.com/6ftfish/Forza_Horizon_6_Skill_Point_Macro).
*   **Modifications:** This version brings a GUI redesign, feature expansion, automation improvements, a telemetry system, and an overhaul of the UI/UX.
*   **EventLab & Tuning:** EventLab design and tuning configurations provided by u/Ok-Pin-5704 on [Reddit](https://www.reddit.com/r/EventlabSubmissions/comments/1twfgk0/960_skill_point_race/).

---

## 💡 Contributions

Feedback and improvements are always welcome! If you have ideas for better timing optimization, more stable navigation routes, UI improvements, bug fixes, or additional car support, feel free to **Open an Issue** or **Submit a Pull Request**. This project is designed to evolve with community input.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details. 

---

## 📌 Safety & Responsibility Notice

This automation tool does **not** modify game files and strictly uses **input simulation (keyboard) only**. It requires active user supervision during setup and testing. Users are solely responsible for adjusting the macro timing for their systems, ensuring safe usage conditions, and monitoring execution during automated runs.
