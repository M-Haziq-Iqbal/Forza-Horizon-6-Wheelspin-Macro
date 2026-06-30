; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║        Cyber Noir Edition v1.8.0        ║
; ╚═════════════════════════════════════════╝

; ══════════════════════════════════════════════
;  ENVIRONMENT & GAME SETTINGS
; ══════════════════════════════════════════════
global GameExe          := "forzahorizon6.exe"
global GameTitle        := "ahk_exe " GameExe
global MacroIni         := "mhiacro.ini"
global GameDir          := FindGameDirFromProfiles()
global GameMonitor      := 1
global GameHwnd         := 0  ; Initializes the permanent window pointer handle

global IsGameWindowed       := CheckWindowed()
global IsGameLocked         := CheckLocked()
global IsGameAlwaysOnTop    := CheckAlwaysOnTop()

; ══════════════════════════════════════════════
;  EVENTLAB PRESETS & DATA SOURCING
; ══════════════════════════════════════════════
global EventLabList     := ["AMMAGEDON", "LIQUIDPOTATO"]
global EventLabData     := Map(
    "AMMAGEDON", {
        CodeTune: "206657706",
        CodeEvent: "102089819",
        MaxPoints: 980,
        MaxSections: 100,
        AveragePoints: 9.8,
        SecPerSection: 20,
        SecPerRow: 4,
        SectionsPerRow: 1
    },
    "LIQUIDPOTATO", {
        CodeTune: "293391902",
        CodeEvent: "124198343",
        MaxPoints: 940,
        MaxSections: 96,
        AveragePoints: 9.8,
        SecPerSection: 30,
        SecPerRow: 7,
        SectionsPerRow: 4
    }
)

; Read and initialize active EventLab configuration
_iniEventLab            := ReadMacroIni("Settings", "EventLab", "")
global EventLab         := _iniEventLab ? _iniEventLab : EventLabList[1]

global CodeTune         := EventLabData[EventLab].CodeTune
global CodeEventLab     := EventLabData[EventLab].CodeEvent
global AveragePoints    := EventLabData[EventLab].AveragePoints
global MaxPoints        := EventLabData[EventLab].MaxPoints
global MaxSections      := EventLabData[EventLab].MaxSections

; ══════════════════════════════════════════════
;  HARDWARE & PROFILE TUNING
; ══════════════════════════════════════════════
global ResoList         := ["854 x 480", "960 x 540", "1024 x 576", "1280 x 720", "1366 x 768", "1920 x 1080", "2048 x 1152", "3200 x 1800", "3840 x 2160", "5120 x 2880", "7680 x 4320"]
_iniReso                := ReadMacroIni("Settings", "Resolution", "")
global SelectedReso     := _iniReso ? _iniReso : ResoList[1]

global CarList          := ["Subaru Impreza 22B-STi", "Lamborghini Revuelto", "Dodge Viper GTS ACR"]
global CarData          := Map(
    "Subaru Impreza 22B-STi", {
        SkillPtsCost: 30,
        AltName: "1998 Subaru"
    },
    "Lamborghini Revuelto", {
        SkillPtsCost: 39,
        AltName: "2024 Lamborghini"
    },
    "Dodge Viper GTS ACR", {
        SkillPtsCost: 30,
        AltName: "1999 Dodge"
    }
)
_iniCar                 := ReadMacroIni("Settings", "Car", "")
global SelectedCar      := _iniCar ? _iniCar : CarList[1]
global SelectedCarPoint := CarData[SelectedCar].SkillPtsCost

_iniTier                := ReadMacroIni("Settings", "UserTier", "")
global UserTier         := _iniTier ? _iniTier : "STANDARD"

; ══════════════════════════════════════════════
;  MACRO RUNTIME & OPERATIONAL STATES
; ══════════════════════════════════════════════
global ActiveMode       := ""
global PauseMode        := ""
global MasterMode       := ""
global MasterStart      := ""
global RaceStart        := ""
global SpinMode         := "KEEP"

global SkillPtsCount_In := 0
global SkillPtsWant_In  := 0
global CarCount_In      := 0
global LoopCount_In     := 0
global CustomSkillPts   := false
global SkillPtsScanSuccess := false

; Performance Tracking Metrics
global PointsTotal      := 0
global PointsGain       := 0
global TimeTotal        := 0

global TotalRunSeconds  := 0
global RaceRunSeconds   := 0
global BuyRunSeconds    := 0
global UnlockRunSeconds := 0
global SpinRunSeconds   := 0

; ══════════════════════════════════════════════
;  USER INTERFACE & VISUALS
; ══════════════════════════════════════════════
global DarkMode         := true
global MainGUI          := ""
global StatusText       := ""
global GuiWidth         := "w270"

global Key_UI           := ""
global Process_UI       := ""
global SpeedLabel_UI    := ""
global DelaySlider_UI   := ""

; Color Palette (Cyber Noir Theme)
global cActive          := "FF8FAB"
global cHighlight       := "39FF14"
global cIdle            := "7A4A60"
global cTextDim         := "7A4A60"

global Multipliers      := [0.25, 0.5, 0.75, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]
_iniMultiplier          := ReadMacroIni("Settings", "CurrentMultiplier", "")
global CurrentMultiplier := _iniMultiplier ? _iniMultiplier : 1

; ══════════════════════════════════════════════
;  SPECIAL K INJECTION SETTINGS
; ══════════════════════════════════════════════
global SpecialKEnabled      := "0"
global TargetDLL            := "" 
global WindowHook           := 0

global SK_ConfigMap     := Map(
    "SpecialK.System", Map("Silent", "true"),
    "Render.FrameRate", Map("TargetFPS", "60.0"),
    "Window.System", Map(
        "RenderInBackground", "true",
        "TreatForegroundAsActive", "false",
        "AlwaysOnTop", "-1",
        "MuteInBackground", "true",
        "Center", "false",
        "Borderless", "false"
    ),
    "Display.Output", Map(
        "ForceWindowed", "false",
        "ForceFullscreen", "false"
    ),
    "Input.Mouse", Map("DisabledToGame", "0"),
    "Input.Keyboard", Map("DisabledToGame", "0"),
    "Input.Gamepad", Map("DisabledToGame", "2")
)

global SK_GlobalOSDMap  := Map(
    "SpecialK.VersionBanner", Map("Duration", "0.0"),
    "SpecialK.OSD", Map("Show", "false")
)