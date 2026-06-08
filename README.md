# 🌑 FH6 Wheelspin Macro – Cyber Noir Edition

An AutoHotkey v2 automation tool designed for *Forza Horizon 6*, featuring a custom GUI, session tracking, and structured automation workflows to streamline repetitive in-game progression tasks.

<p align="center">
  <img width="280" height="812" alt="Screenshot 2026-06-08 190710" src="https://github.com/user-attachments/assets/7442437d-6790-42e4-99f7-430218c32d11" />
  <img width="278" height="811" alt="Screenshot 2026-06-08 200155" src="https://github.com/user-attachments/assets/18e42cf4-d7d8-4222-9cbc-f2f72be44540" />
</p>

---

## 📌 Overview

This project is a desktop automation tool built with **AutoHotkey v2**. It automates multiple in-game workflows such as racing loops, car purchasing, and reward claiming, while providing a fully custom graphical interface for monitoring progress in real time.

The original base script was developed by **6ftFish**, and this version has been significantly redesigned and expanded with new systems, UI improvements, and workflow enhancements.

---

## 🚀 Quick Start

1. Launch Forza Horizon 6 and load into Free Roam.
2. Ensure the Subaru Impreza 22B-STi Version is your only Favorited vehicle.
3. Verify all Car Mastery perks are unlocked.
4. Apply Tune Share Code: `293 391 902`
5. Apply the recommended game settings.
6. Disable Skills HUD.
7. Start the macro.
8. Run individual modes or start the Full Automation Loop.

## ✨ Key Features

- 🎨 Fully custom GUI with dark/light theme support  
- 📊 Real-time session tracking and runtime statistics  
- 🏁 Automated race loop workflow  
- 🚗 Automated car purchasing system  
- 🛞 Wheelspin and reward claiming automation  
- 📈 Skill point estimation and progression calculator  
- ⚙️ Structured process state management system  
- ⌨️ Hotkey-driven control system  
- 📋 Click-to-copy in-game codes integration  
- 🔁 Flexible automation modes (Race / Buy / Claim / Full Loop)

---

## 🔁 Automation Modes

The automation workflow is split into three independent processes that can be executed separately or combined into a continuous automation cycle.

### 🏁 Race Mode

Runs only the race automation process.

- Launches and completes the configured EventLab race
- Accumulates skill points
- Repeats race sessions until stopped

**Hotkey:** `[`

---

### 🚗 Buy Mode

Runs only the vehicle purchasing process.

- Purchases Subaru Impreza 22B vehicles
- Prepares vehicles for perk claiming
- Repeats purchase cycles until stopped

**Hotkey:** `]`

---

### 🛞 Claim Mode

Runs only the reward claiming process.

- Redeems Car Mastery rewards
- Claims wheelspins and skill point rewards
- Repeats claim cycles until stopped

**Hotkey:** `\`

---

### ♾️ Full Automation Loop

Combines all processes into a single continuous workflow.

Workflow:

Race → Buy → Claim → Repeat

The macro will continuously cycle through all stages until manually stopped by the user.

This mode is recommended for long unattended farming sessions after timing has been properly verified on your system.

**Hotkey:** `` ` ``

---

### 🛑 Stopping Automation

Any running automation mode can be stopped through the GUI or designated stop controls.

For safety, users should supervise initial runs and verify timing before leaving the automation running for extended periods.

## 🧠 Core Systems

### 🎛️ Automation Engine
Controls in-game navigation using predefined key sequences with state validation to ensure safe execution and stop conditions.

---

### 📊 Telemetry System
Tracks:
- Total runtime  
- Race session duration  
- Buy/claim cycles  
- Estimated skill point gains  

---

### 🧮 Progress Estimation
Uses internal logic to estimate:
- Skill point gains per session  
- Optimal car purchase count  
- Expected completion time

The built-in estimator is based on repeated testing of the recommended EventLab route and vehicle setup.

#### 📊 Tested EventLab Results

After multiple test sessions, the EventLab race consistently produced:

- Minimum observed gain: **940 Skill Points**
- Maximum observed gain: **945 Skill Points**
- Typical completion time: **Under 51 minutes**

Due to the small variation between runs, the application uses **940 Skill Points** as the maximum target value for a single farming session. This provides a conservative estimate and helps avoid overestimating expected rewards.

#### 🎯 Maximum Skill Point Calculation

The in-game Skill Point cap is **999**.

Because players may already have existing Skill Points before starting a session, the application calculates the desired target using:

Current Skill Points + Estimated Session Gain

While a single session estimate is capped at **940**, the resulting total can reach the in-game maximum of: 999 Skill Points

| Current SP | Estimated Gain | Final Total  |
| ---------- | -------------- | ------------ |
| 0          | 940            | 940          |
| 50         | 940            | 990          |
| 100        | 940            | 999 (capped) |

The estimator automatically accounts for this cap when calculating purchase recommendations and expected completion progress.

---

### 🎨 Theme System
Dynamic UI switching between:

- 🌙 Dark mode (Neon Void)  
- ☀️ Light mode (Neon Daylight)  

---

## ⌨️ Controls

| Key | Action |
|-----|--------|
| / | Toggle Full Automation Loop |
| [ | Start Race Loop |
| ] | Start Buy Loop |
| \ | Start Claim Loop |
| F12 | Reload Script |

---

# 📷 Setup Guide (Important Before Running)

Before using the macro, ensure your game is in the correct state. The automation relies on consistent menus, timing, and UI positioning.

---

## 🏁 Starting Position

Make sure you are in:

- Home Menu  
- Fully loaded session (no loading screens)  
- Active keyboard input  

<p align="center">
  <img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/e6c585b4-264e-4a4c-8cf8-8d4ed7144ffc" />
</p>

---

## 🎯 EventLab Menu Setup

Ensure the EventLab system is accessible and ready.

- EventLab menu available  
- Search-by-code feature unlocked  

<p align="center">
  <img width="1941" height="896" alt="image" src="https://github.com/user-attachments/assets/c0dab41f-01bf-4975-99a9-bf48ff36028a" />
</p>

The macro automatically inputs this EventLab code: 124 198 343

<p align="center">
  <img width="2457" height="1268" alt="image" src="https://github.com/user-attachments/assets/ec334fc9-8e5f-4027-b7ff-3306b8d4c775" />
</p>

---

## 🚗 Required Car Setup

The automation is designed to work correctly with a specific vehicle configuration.

### ✔️ Required Vehicle Setup

You **must** have:

- Subaru Impreza 22B-STi Version (ONLY favorite car in garage)
- All perk points fully maxed out (all mastery upgrades unlocked)
- No other cars set as favorite (to avoid selection conflicts)

This is required because the macro assumes consistent car selection behavior during automation.

---

### 🧩 Tuning Setup

Use the following tuning configuration:

📌 **Tuning Code:** 293 391 902

<p align="center">
  <img width="2559" height="1439" alt="image" src="https://github.com/user-attachments/assets/13020a98-4b58-4c2d-862f-bf1f2982068b" />
</p>

---

## ⚙️ Required Game Setting Setup

Before running the macro, verify the following configuration.

### 🎮 Recommended Difficulty Settings

For maximum consistency, use the following settings:

| Setting | Recommended Value |
|----------|----------|
| Drivatar Difficulty | UNBEATABLE |
| Braking | ASSISTED |
| Steering | AUTO-STEERING |
| Traction Control | OFF |
| Stability Control | OFF |
| Shifting | AUTOMATIC |

> These settings were used during development and testing. Different settings may affect race timing and automation reliability.

<p align="center">
  <img width="2559" height="1438" alt="image" src="https://github.com/user-attachments/assets/43f2059b-4fb6-4540-a573-7ff43abfd561" />
</p>

### 🎮 Additional Recommended Settings

For the most reliable automation experience, the following setting is strongly recommended:

#### Skill Score / Skills HUD

Navigate to:

**Settings → HUD & Gameplay → Skills HUD**

Set:

**Skills HUD: OFF**

### Why?

During testing, disabling the Skills HUD resulted in more consistent performance and smoother Skill Point accumulation.

Keeping the Skills HUD enabled may:

- Introduce additional visual pop-ups during gameplay
- Cause minor timing inconsistencies on some systems
- Affect the consistency of long farming sessions

While the macro may still function with the Skills HUD enabled, turning it off is recommended for maximum stability and repeatability.

<p align="center">
  <img width="2456" height="1068" alt="image" src="https://github.com/user-attachments/assets/c92a4501-a0f7-4af7-bc0a-ebe25ece19df" />
</p>

---

## ⚠️ Important Warning (READ BEFORE USE)

This tool relies on **timed inputs and UI navigation**, meaning:

- ⏱️ Performance varies between systems  
- 🖥️ Loading times depend on hardware (SSD/HDD/CPU/GPU)    
- 🌐 Background processes can affect timing accuracy  

---

### ✔️ First-Time Setup Recommendation

Before running full automation:

- Run each mode manually once  
- Observe timing carefully  
- Adjust `Sleep()` delays if needed  
- Watch for UI desync or missed inputs  

---

## 🛠️ Customization Encouraged

Users are encouraged to modify and improve the script:

- Adjust timing values (`Sleep()`)  
- Modify key sequences for UI changes  
- Tune performance for their system  
- Improve automation logic  

---

## 🙏 Credits

### Base Script
Original framework by:  
👉 https://github.com/6ftfish/Forza_Horizon_6_Skill_Point_Macro  

### Modifications
This version includes:

- GUI redesign  
- Feature expansion  
- Automation improvements  
- Telemetry system implementation  
- UI/UX restructuring  

### EventLab & Tuning
EventLab design and tuning configurations by:  
👉 u/Ok-Pin-5704 on [Reddit Post](https://www.reddit.com/r/EventlabSubmissions/comments/1twfgk0/960_skill_point_race/)

---

## 💡 Contributions

Feedback and improvements are welcome.

If you have ideas like:

- Better timing optimization  
- More stable navigation routes  
- UI improvements  
- Bug fixes  
- Additional car support  

Feel free to:

- Open an Issue  
- Submit a Pull Request  

This project is designed to evolve with community input.

---

## 📌 Safety & Responsibility Notice

This automation tool:

- Does **not modify game files**  
- Uses **input simulation only (keyboard)**  
- Requires **user supervision during setup/testing**  

Users are responsible for:

- Adjusting timing for their system  
- Ensuring safe usage conditions  
- Monitoring execution during automation  
