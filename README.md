# 🏎️ Forza Horizon 6 Wheelspin Macro

Welcome to the ultimate progression companion for Forza Horizon 6! This is a highly modular, high-performance automation tool built on **AutoHotkey v2** designed to eliminate repetitive in-game grinds. Whether you want to skip the race grind, farm credits, or stack up Super Wheelspins, this macro fully automates your workflow using smart screen text recognition (OCR), pixel-aware menu tracking, and background play execution.

<p align="center">
  <img width="272" height="872" alt="Main Dashboard UI" src="https://github.com/user-attachments/assets/e2373c74-a7de-40eb-a18a-df59f95d78a1" />
  <img width="272" height="995" alt="Targets & Telemetry" src="https://github.com/user-attachments/assets/3c3e5ee2-cbb7-460f-a015-044d53f72a92" />
</p>

---

## 📑 Table of Contents

* [🚀 Quick Start (TL;DR)](#-quick-start-tldr)
* [🖥️ System & Game Prerequisites](#%EF%B8%8F-system--game-prerequisites)
* [📊 Target Vehicles & Rewards Matrix](#-target-vehicles--rewards-matrix)
* [✨ Key Features & Architecture](#-key-features--architecture)
* [🔁 The Automation Modes](#-the-automation-modes)
* [⌨️ Keyboard Controls Masterlist](#%EF%B8%8F-keyboard-controls-masterlist)
* [📷 Step-by-Step Setup Guide](#-step-by-step-setup-guide)
  * [⚙️ 1. Difficulty Settings](#%EF%B8%8F-1-difficulty-settings)
  * [📟 2. HUD & Gameplay Settings](#-2-hud--gameplay-settings)
  * [🖥️ 3. Video & Graphics Settings](#%EF%B8%8F-3-video--graphics-settings)
  * [🎯 4. Challenge / EventLab Menu Configuration](#-4-challenge--eventlab-menu-configuration)
  * [🚗 5. Garage Car Tuning Configuration](#-5-garage-car-tuning-configuration)
  * [🌆 6. Special K Background Play Setup (Optional Alternative)](#-6-special-k-background-play-setup-optional-alternative)
  * [🏁 7. Choosing Your In-Game Starting Positions](#-7-choosing-your-in-game-starting-positions)
  * [📱 8. Controlling the GUI](#-8-controlling-the-gui)
* [🔧 Troubleshooting & FAQ](#-troubleshooting--faq)
* [⚠️ Safety & Customization](#%EF%B8%8F-safety--customization)

---

## 🚀 Quick Start (TL;DR)

### 📦 Option A: The Easy Route (Recommended)

1. Go to the **[Latest Release](https://github.com/M-Haziq-Iqbal/Forza-Horizon-6-Wheelspin-Macro/releases/latest)** page on GitHub.
2. Download the pre-compiled executable: `FH6-Wheelspin-Macro.exe`.
3. Right-click the downloaded file and select **Run as Administrator**. That's it!

### 💻 Option B: Run From Source (For Developers)

1. Make sure you have **AutoHotkey v2** installed on your PC.
2. Clone this repository or download the source files.
3. Keep the main application file, dependency assets (`OCR.ahk`), and library files (`lib\`) in the exact folder layout as downloaded.
4. Run `main.ahk` to open the control panel.

---

## 🖥️ System & Game Prerequisites

To ensure the macro's text recognition (OCR) and menu scanners work perfectly without errors, check that your system matches these requirements:

* **Game Language:** Must be set to **English** so the macro can read in-game menus and button text.
* **Permissions:** Always run the macro as an **Administrator** so its keyboard inputs successfully reach the game window.
* **Control Mapping:** You must use the game's default **WASD keyboard controls**. Custom keybinds or gamepads will conflict with the automation script.
* **Background Play Mode:** Supported out of the box! You can surf the web, scroll Discord, or watch YouTube while the game plays itself. For the best background setup, use the **Always On Top**, **Resize**, and **Lock** overlay features provided in the app's Mini GUI.

---

## 📊 Target Vehicles & Rewards Matrix

Choose a car profile from the dashboard dropdown depending on your current budget and progression strategy. You can easily add, adjust, or delete your own entries at any time using the built-in **Vehicle Database Editor**.

> *⚠️ **Note on Car Pack / DLC Cars:** Check the list below to ensure you own the required car pass or standalone DLC packs before picking a specialized target car.*

| Vehicle Choice | Base Cost | Cost (with 5% House Discount) | Mastery Tree Rewards | Skill Points Needed | Strategy Profile |
| --- | --- | --- | --- | --- | --- |
| **1998 Subaru Impreza 22B-STi Version** | 86,000 CR | 81,700 CR | 1x Super Wheelspin | 30 Points | **Budget Wheelspins:** Great low-cost choice for steady, reliable Super Wheelspins. |
| **2024 Lamborghini Revuelto** | 365,000 CR | 346,750 CR | 1x Super Wheelspin + 3x Regular Wheelspins | 39 Points | **Maximum Yield:** Dumps heavy credits to maximize total wheelspin volume as fast as possible. |
| **1999 Dodge Viper GTS ACR** | 68,000 CR | 64,600 CR | 150,000 Cash Credits | 30 Points | **Credit Flipping:** Quickly converts your banked skill points straight back into raw cash credits. |
| **1974 Mazda #123 Mad Mike 808 Wagon 'FURSTY' \*** | 100,000 CR | 95,000 CR | 1x Super Wheelspin | 21 Points | **Point-Efficient:** Requires the absolute lowest skill points per Super Wheelspin to drain your bank fast. |

> \* **Important Note on DLC / Premium Editions:** If your game contains DLC vehicles (such as the Car Pass or Premium Add-ons), your in-game Car Journal order may look different from a standard game installation. Because **Buy Mode** relies on navigating through a standard car grid layout, you may need to use the macro's built-in Editor to tweak the **Manufacturer Path** or **Car Path** to perfectly match your specific garage layout. (Note: Menu sequences have been heavily optimized in the latest update).

---

## ✨ Key Features & Architecture

This utility merges smart automation techniques with an accessible user interface to give you seamless, worry-free background farming:

* **True Background Automation:** Built with a specialized background screen-capture engine. The macro can read menus, check colors, and send keypresses **even when the game window is entirely covered or out of focus**.
* **Anti-Pause Protection:** Intercepts system focus changes. When you click away to work or browse, the macro keeps the game engine awake, bypassing the game's default rule that pauses the action when you switch windows.
* **Modern UI & Theme Options:** Built on a completely overhauled mode framework. You can switch between a sleek **Cyber Noir Dark Mode** and a clean **Light Mode** palette on the fly. Detailed **UI Tooltips** are available across the Main GUI for settings, buttons, and system toggles.
* **Live Discord Webhook Telemetry:** Built-in network engine hook that instantly pushes local updates straight to your private Discord channel. Features a live asynchronous dashboard, synchronous milestone tracking, and historical logging for loops, purchase validations, unlocks, and errors.
* **UWP/Gaming UI Injection:** Advanced input handling (`SendToGamingUI`, `TypeStringViaPressKey`) reliably sends keystrokes and pastes strings directly into Windows Gaming UI overlays.
* **Advanced OCR & Safety Intercepts:** Features `WaitForText` for multi-target OCR scanning and a `CarVerifyCheck` function to explicitly scan and validate vehicle stats numbers with a fuzzy matching threshold. If accuracy drops below safe levels, an emergency cutoff is triggered.
* **Live Statistics Overlay (Mini GUI):** When minimized, the control dashboard shrinks into a tiny, floating desktop overlay tracking live farming stats, total running time, and remaining prize queues. (Timer calculations dynamically adjust based on precise EventLab loading times).
* **Speed Multiplier Slider:** Adjust the overall macro processing speed from **0.25x to 4.0x** to perfectly match your PC's loading drive speed (SSD vs. HDD) and system power.
* **Integrated Update Checker:** Automatically compares your running build version (using strict semantic digit comparison) against the live GitHub repository to fetch, download, and apply performance updates instantly.

---

## 🔁 The Automation Modes

The macro is split into four core standalone modes that can be fired individually or chained into an automated infinite loop:

* **🏁 Race Mode (Hotkey: `\`):** Automates the skill point farming loop. It navigates directly into the **Creative Hub**, pulls up your custom Challenge map, and handles automatic steering and braking.
* **🚗 Buy Mode (Hotkey: `[`):** Automatically purchases target cars in bulk from the Autoshow. It calculates how many units it can afford based on your current balance and verifies every purchase using screen text recognition to avoid transaction mistakes.
* **🛞 Unlock Mode (Hotkey: `]`):** Opens your garage, navigates the vehicle skill trees, unlocks the targeted wheelspin or cash rewards, and safely cleans out used inventory.
* **🎰 Standalone Wheelspin Mode (Hotkey: `=`):** For burning through an existing backlog of accumulated wheelspins. Hover over your wheelspins tile in the game's **My Horizon** menu, choose your preferences (**KEEP** items, **SELL** duplicates for cash, or automatically **GIFT** rewards to other players), and let it run.
* **♾️ Full Loop Automation (Hotkey: `/`):** The ultimate hands-off farming sequence. This chains **Race ➔ Buy ➔ Unlock** modes into an endless loop. If **Full Loop Spinning** is checked, it will automatically pause between cycles to open all accumulated wheelspins before repeating.

---

## ⌨️ Keyboard Controls Masterlist

| Keybind | Action Performed |
| --- | --- |
| `/` | Start the infinite **Full Automation Loop** (`FULL LOOP`) |
| `\` | Run standalone **Race Mode** |
| `[` | Run standalone **Buy Mode** |
| `]` | Run standalone **Unlock Mode** |
| `=` | Run standalone **Wheelspin Mode** |
| `` ` `` (Backtick) | **Pause / Unpause** any active macro instantly |
| `F5` | Toggle visual **Diagnostic Overlay Boxes** [Shows what the macro sees] |
| `F12` | Force a complete emergency **Reload/Reset** of the macro software |
| `Ctrl + Shift + C` | Developer tool: Copy active screen coordinates and color hex code |
| `Alt + Left Click` | Easily drag the game client window around your desktop |
| `Ctrl + Click` | Use on Race, Buy, and Unlock UI segments to trigger isolated, independent tasks |

---

## 📷 Step-by-Step Setup Guide

### ⚙️ 1. Difficulty Settings

Set your difficulty options exactly as shown below to ensure the game can successfully drive itself.

| Setting | Required Value |
| --- | --- |
| Drivatar Difficulty | **UNBEATABLE** |
| Driving Assists Preset | **FULL ASSISTS** |
| Braking | **ASSISTED** |
| Steering | **AUTO-STEERING** |
| Traction Control | **ON** |
| Stability Control | **ON** |
| Shifting | **AUTOMATIC** |

<p align="center">
  <img width="2559" height="1439" alt="Setting Menu" src="https://github.com/user-attachments/assets/3d48c1f9-904d-434b-8bcf-fe21cc16cffc" />
</p>

### 📟 2. HUD & Gameplay Settings

#### 🚫 Turn Off the Skills HUD

Go to **Settings ➔ HUD & Gameplay ➔ Skills HUD** and turn it **OFF**.
> This stops pop-up combo notifications from stacking up on screen, which reduces visual lag and keeps menu detection snappy.

#### 🛑 Turn Off the "What's Next" Prompt

Go to **Settings ➔ HUD & Gameplay ➔ What's Next** and turn it **OFF**.
> **CRITICAL:** This feature must be disabled. If left on, unexpected pop-up map markers will interrupt and break the macro's navigation flow.

<p align="center">
  <img width="2456" height="1068" alt="Skills HUD Off" src="https://github.com/user-attachments/assets/c92a4501-a0f7-4af7-bc0a-ebe25ece19df" />
</p>

### 🖥️ 3. Video & Graphics Settings

To maintain accurate screen parsing and tracking timing, match these options:

* **Brightness:** Must be set precisely to **50**.
* **HDR / Windows Night Light:** Must be turned **OFF**.
* **Game Resolution:** Optimized for **1920x1080 (1080p)** inside a 16:9 aspect ratio window. [If you use an Ultrawide or 4K screen, run the game in a **Windowed** container and use the Mini GUI scaling options to snap it correctly].
* **Framerate:** Lock the game to a stable **60 FPS**.
* **Graphics Quality:** Set to **Very Low / Lowest** settings to strip out shadows and motion blur that can throw off image scans.

---

### 🎯 4. Challenge / EventLab Menu Configuration

Following the July 13th, 2026 FH6 update, standard EventLab farming was heavily nerfed (legacy maps like AMMAGEDON and LIQUIDPOTATO will now only yield 1 SP no matter how long you play). **Challenge farms like AAMIRUSMANDUS are now the only functional options.**

You now have two options to launch the AAMIRUSMANDUS Challenge farm, selectable via a toggle in the **Options -> Farm Profile** section of the GUI:

* **Method A: Select by Creator (Recommended):** The script navigates to your "Followed Creators" page and selects the Challenge. This is **100% compatible with background play**.
  * *Setup:* You must manually search the event code once, View Profile, Follow the creator, and restart your game if the creator has not immediately appeared in your followed list.
* **Method B: Search by Code:** The script manually enters the share code every loop.
  * *Note:* Entering the code requires the Xbox non-native virtual keyboard, which causes **around 1 second of background play interruption** every time a new loop starts. This may be inconvenient if you are actively working in another window.

<p align="center">
  <img width="1941" height="896" alt="Favorites Layout Mapping" src="https://github.com/user-attachments/assets/c0dab41f-01bf-4975-99a9-bf48ff36028a" />
</p>

---

### 🚗 5. Garage Car Tuning Configuration

You can now have multiple favorited vehicles in your garage (though keeping the list short is highly recommended for speed). The script will automatically scan and navigate through your favorited cars to select the **Subaru Impreza 22B-STi** (either running the provided tune or stock).

* **Requirement:** The Subaru will still need all mastery perks unlocked for the SP multiplication bonus.
* **Critical Limit:** You can only favorite up to a **maximum of 3 cars from the Subaru manufacturer**. Having more will break the script's selection logic.

#### Track Share & Upgrade Setup Codes

> ⚠️ **JULY 13th, 2026 UPDATE NOTICE:** The recent FH6 update heavily nerfed legacy EventLabs. The Challenge farm below is now required.

*(You can click these directly inside the macro window footer to copy them instantly)*

* **AAMIRUSMANDUS Profile (Active):** Tune Code: `206 657 706` | Event Code: `140 849 306`
* ~~**AMMAGEDON Profile (Patched):**~~ Tune Code: `206 657 706` | EventLab Map Code: `102 089 819`
* ~~**LIQUIDPOTATO Profile (Patched):**~~ Tune Code: `293 391 902` | EventLab Map Code: `124 198 343`

<p align="center">
  <img width="2559" height="1439" alt="Tuning Application Layout" src="https://github.com/user-attachments/assets/ad315cec-1740-4984-9902-8cd97be366df" />
</p>

---

### 🌆 6. Special K Background Play Setup (Optional Alternative)

If your PC drops inputs or refuses to accept background inputs natively, you can use the optional Special K wrapper tools:

1. Press `Ctrl + Shift + Backspace` to load the Special K mod control overlay panel.
2. Go to **Input Management ➔ Enable/Disable Devices**.
3. **Uncheck** or disable the feature labeled **Disable Keyboard Input to Game**.
4. Close the Special K overlay panel.

<p align="center">
  <img width="2559" height="1439" alt="Special K Control Board Layout" src="https://github.com/user-attachments/assets/e8e9e749-8515-4cb0-afaa-5af52fd89e07" />
</p>

---

### 🏁 7. Choosing Your In-Game Starting Positions

Always position your character inside the correct in-game menu structure before launching a macro mode:

#### For Automatic Full Loop / Race / Buy / Unlock / Spin Modes

Thanks to the integrated **Heuristic Menu Awareness Engine (`ScanMenu()`)**, the macro dynamically identifies your active in-game environment [whether you are in the Home Menu, Free Roam, or the Pause Menu].

* **Starting Position:** You can launch the macro from within Free Roam session, Free Roam menu or Home menu.
* **How it works:** Instead of relying on rigid, blind delays that require you to be on a precise tile, the script scans your screen, detects its current alignment, and gracefully routes its own path to the correct menu loop automatically. Just ensure there are no active loading screens or network disconnect alerts blocking the view before you press the hotkey.

<p align="center">
  <img width="1280" height="720" alt="FreeRoam" src="https://github.com/user-attachments/assets/bd414d82-c751-47c6-9e95-87759cc55b6d" />
  <img width="1280" height="720" alt="FreeRoamMenu" src="https://github.com/user-attachments/assets/e186280f-73c0-4d4d-91f4-1a0caa6068d6" />
  <img width="1280" height="720" alt="HomeMenu" src="https://github.com/user-attachments/assets/24128b71-7a4f-4cab-b995-01db556bfed8" />
</p>

#### For Custom Unlock Mode

1. Open the game menu, go to **Buy & Sell**, select the **Auction House**, and choose **Start Auction**.
2. Press `X` to filter, set your sorting filter explicitly to **Recently Added**, and accept.
3. **CRITICAL STEP:** Use your keyboard arrows to **hover over and highlight the specific vehicle slot you want the unlocker to begin processing—but do NOT press Enter to open it.** Leave the box highlighted, and then hit your unlock hotkey (`]`).
4. *Reminder:* Ensure you are hovering over the middle vehicle entry in the first column to not break the grid navigation system. Also make sure the car's stats numbers, as featured in the red box, are shown on the screen!

<p align="center">
  <img width="2559" height="1439" alt="Unlock Mode Base Position" src="https://github.com/user-attachments/assets/d824e130-6672-4a3c-a7bd-94dc4f0155fb" />
</p>

---

### 📱 8. Controlling the GUI

#### 🎛️ Master Control Dashboard Overview

Use the main dashboard application window to calibrate timing delays, adjust session targets, customize vehicle presets, and run automation loops. The Main GUI acts dynamically, automatically adjusting window height and tab compensation to keep stats perfectly centered. *(Note: The Car Editor acts as a modal owner to prevent background misclicks while active).*

#### 1. Session Parameter Setup

<p align="center">
  <img width="272" height="128" alt="Target Matrix" src="https://github.com/user-attachments/assets/1cea8704-0a11-409e-abdd-2b12490fb411" />
</p>

* **Current Skill Points:** Type in or check your active skill point total balance.
* **Desired Skill Points:** Set your goal ceiling target (e.g., `980`). The macro will auto-exit once this point calculation limit is met.
* **Custom Car Values:** Manually define car purchase/unlock target counts instead of relying on auto-calculations.
* **Car Amount:** Define exactly how many vehicles the macro should purchase back-to-back during a standalone Buy loop.
* **Sequence Loop:** Sets how many times the overall multi-stage continuous loops repeat.

#### 2. Vehicle Database Editor

<p align="center">
  <img width="272" height="50" alt="Vehicle Selection" src="https://github.com/user-attachments/assets/369dce08-c1e4-465f-8b2a-d637d9d4239a" />
</p>

* Tap the `＋` (Add New) or `✎` (Edit Selected) utility buttons next to the vehicle dropdown menu to open up the interactive **Vehicle Profile Editor Canvas**.

<p align="center">
  <img width="312" height="492" alt="Add car" src="https://github.com/user-attachments/assets/2c820d8e-2ca5-4c62-88dd-a2f064b5dc99" />
  <img width="312" height="492" alt="Edit car" src="https://github.com/user-attachments/assets/6e39f84e-48c2-4ad0-8d11-61636f1198ef" />
</p>

You can add / edit custom reward cars or adjust underlying movement paths effortlessly:

* **Vehicle Name / AltName:** The text strings read by OCR to verify the macro is buying the correct car.
* **Stats Number:** A unique 12-digit structural identity layout scanned during unlock steps to prevent deleting the wrong profile.
* **Rewards & Economy:** The maximum amount of skill points used to yield certain type of rewards for each car.
* **Manufacturer / Buy / Unlock Paths:** The multi-directional movement button patterns executed by the automation engine to navigate menus. Core baseline factory setups come locked to protect critical recovery profiles from accidental deletions.

#### 3. Core Operation Triggers

<p align="center">
  <img width="272" height="240" alt="primary control buttons" src="https://github.com/user-attachments/assets/abcc932c-3b56-448c-8023-a7497f87a1c6" />
</p>

* **Loop Entry Selection:** Choose where your automated loop begins (`🏁 RACE`, `🚗 BUY`, or `🛞 UNLOCK`).
* **Dynamic Primary Button:** The start button actively updates its text string (e.g., "START FULL LOOP" vs. "START FROM BUY") based on your active mode.
* **FULL LOOP:** Launches the continuous endless chain sequence [**Race ➔ Buy ➔ Unlock**].
* **Isolated Execution:** Use `Ctrl + Click` on the RACE, BUY, or UNLOCK UI segments to trigger isolated, independent single tasks.
* **OPEN SPIN INTERFACE:** Spawns the dedicated prize clearing interface panel.

#### 4. Automated Bulk Wheelspin Terminal

<p align="center">
  <img width="252" height="352" alt="Wheelspin Interface" src="https://github.com/user-attachments/assets/0232d8be-2036-439f-b1f5-f178550088f1" />
</p>

* **Spins Count:** Enter your desired target volume to open.
* **Full Loop Inclusion Checkbox:** Toggle whether wheelspin routines run automatically inside background farming loops.
* **Spin Type Selection:** Set your target selection mode explicitly to **SUPER** or **REGULAR** spins.
* **KEEP / GIFT / SELL Filter Optimization:** Select what happens to duplicate prize cars: **KEEP** them in your collection, **SELL** them for quick in-game credits, or **GIFT** them away to randomized other players automatically.

#### 5. Speed Calibration Slider

<p align="center">
  <img width="272" height="68" alt="image" src="https://github.com/user-attachments/assets/0c6ec90b-b999-4f1e-b137-b620c6feddc7" />
</p>

* Drag the safety analog multiplier slider up or down. If your network connection hitches or your storage drive experiences slow scene loading times, drag the slider to **1.5x or 2.0x** to add safe delay padding to all virtual keystrokes.

#### 6. Dynamic Track Profile & Click-To-Copy Share Codes

<p align="center">
  <img width="272" height="210" alt="footer" src="https://github.com/user-attachments/assets/94dcd57d-df05-4c4d-ab86-41d24b2e2cf2" />
</p>

* Switch your track selection dropdown to update underlying script paths automatically.
* Simply click directly on the interactive layout text codes (`Tune Code` or `Race Code`) to instantly save that precise numeric sequence to your Windows clipboard for quick in-game pasting.
* The application bar also handles real-time semantic tracking and background updating alongside the GitHub API.

#### 7. Advanced Launch & Integration Controls (Collapsible Panel)

<p align="center">
  <img width="268" height="178" alt="image" src="https://github.com/user-attachments/assets/ed6b1cc2-b4fd-478e-a7c1-8e834574d4d2" />
</p>

Clicking the **⚙️ OPTIONS** chevron button reveals the streamlined micro-configuration tray:

* **Game Resolution Selector:** Lock or select the optimized render resolution profile matching your window configuration.
* **Farm Profile Options (Search By Code):** Toggle how the script enters Challenge maps (via Followed Creator or by typing the Share Code directly) and configure dedicated switches for Desktop and Discord notifications.
* **Set Game Path / Launch:** Instantly point to your local installation directories to boot, center, and align your automation loops directly out of the interface.
* **Special K Integration Engine:** Safe UI-bound toggle to hook global background inputs directly via injected wrappers if native keyboard handling fails on your hardware.
* **Discord Notification Integration:** Paste your Discord channel webhook URL into the input panel and click the interactive button. When active, it toggles into a bright theme accent state (**▰ DISCORD NOTIFICATIONS: ON**) and sends live remote toasts of your macro events, rewards, and connection drops directly to your server.

#### 🗗 Floating Mini GUI Widget Overview

<p align="center">
  <img width="237" height="331" alt="MiniGUI" src="https://github.com/user-attachments/assets/b7596488-605c-4520-b274-8313fe4ca3fd" />
</p>

Minimize the main menu dashboard to transition to this clean desktop overlay widget:

* **🗗 (Window Sizer):** Commands the game client window to instantly drop into a perfect 16:9 borderless box.
* **📌 (Pin Overlay):** Locks the mini tracker widget to stay permanently visible on top of other software windows.
* **🔒 (Game Handle Lock):** Explicitly links unique engine window tags so inputs route perfectly while you browse other apps.
* **🎞️ (Live Preview Cam):** Uses Windows Desktop Window Manager APIs to embed a live, hardware-accelerated fluid preview camera box showing you exactly what your background game client is doing in real-time.

* **⭮ / ⛶ (Reload & Expand):** Emergency refresh operations or return to the master panel.

Session Controls:

* 🟢 Full Loop Start: Starts the complete automation loop, continuously running races, purchases, and rewards until stopped.
* ❚❚ Pause / Resume: Temporarily pauses the automation and resumes exactly where it left off without losing your current progress.
* ⏹ Stop & Reset: Immediately stops all automation, resets the current session, and returns the application to its default state.

---

## 🔧 Troubleshooting & FAQ

### Q: The script runs but keys don't register inside the game

**A:** Windows security protection rules often block background scripts from communicating with high-priority games. Close the macro entirely, right-click the file, and choose **Run as Administrator** to restore input control.

### Q: The macro clicks early or misses menu slots

**A:** This happens if your game drops frames or experiences loading lag. Increase the dashboard **Delay Multiplier** slider to `1.5x` or `2.0x` to give the game wider, safer time buffers to load menus.

### Q: Why does the macro show a **"Menu Timed Out!"** or **"Sync Error"** message?

**A:** These messages appear when the macro detects that the game is no longer in the expected state. Since the macro relies on pixel color detection, even small visual changes can cause it to lose synchronization.

To prevent this, make sure that:

* **In-game Brightness** is set to **50**.
* **HDR** is completely **Off**.
* **Windows Night Light** (or any blue-light/color filter) is **disabled**.
* You are using the **Third-Person Camera** only, as the macro detects changes in the ground color during the vehicle turnaround.
* The game is running at your configured resolution without any visual filters or overlays that alter colors.

If the message still appears after checking these settings, simply restart the macro to resynchronize with the game.

### Q: Can I turn off my display monitor while farming overnight?

**A:** **Yes, but only by pressing the physical power button on your monitor frame.** Do **NOT** let Windows put your PC display to sleep, trigger power-saving mode, or lock your user account (`Win + L`). If Windows suspends the video stream, the graphics card stops drawing frames, blinding the macro's color sensors.

### Q: Why is the background play / mode not working on my device?

**A:** If you click away to background apps for the very first time while your car is driving in the open world, the game engine automatically forces a pause menu state that breaks automation tracking. To avoid this, **always click away to your browser or Discord while your character is sitting inside a static menu** [like the home garage or main pause hub]. Once the focus is broken there, the macro handles background play beautifully.

---

## ⚠️ Safety & Customization

Before leaving the application completely unattended for long farming cycles, run through each standalone mode manually for a few test passes to ensure everything lines up with your PC's hardware response timings. All user configurations save securely to your local settings `.ini` file across sessions.

This tool operates strictly by simulating standard hardware keyboard commands into your operating system window environment. **It does not modify game memory, inject files, or alter game saves.** All configuration choices remain the sole responsibility of the end user.

<br/><br/>

<p align="center">
  <a href="https://ko-fi.com/mhaziqiqbal">
    <img width="350" height="190" alt="Support on Ko-fi" src="https://github.com/user-attachments/assets/3791e71d-9ecb-4e81-811a-6e153118db1d" />
  </a>
</p>
