; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

;@Ahk2Exe-SetVersion 1.9.5
;@Ahk2Exe-SetDescription MHI - FH6 Wheelspin Macro
;@Ahk2Exe-SetMainIcon assets\icon.ico

; ══════════════════════════════════════════════
;  ENVIRONMENT & GAME SETTINGS
; ══════════════════════════════════════════════

; Define state tracking variables in one neat package
; global MacroState := {
;     PointsGain: 0,
;     PointsTotal: 0,
;     CarsToTarget: 0,
;     CarsToBuy: 0,
;     CarsToUnlock :0,
;     RunSeconds: 0,
;     ActiveMode: "None",
;     MasterMode: false,
;     Spin: {
;         Count: 0,
;         Name: "Super Wheelspin",
;         OpenCount: 0,
;         LeftCount: 0
;     }
; }

; Create an empty container for UI elements
global UI := {}

global CurrentVersion   := "v1.9.5"
global RepoOwner        := "M-Haziq-Iqbal"
global RepoName         := "Forza-Horizon-6-Wheelspin-Macro"

global GameExe      := "forzahorizon6.exe"
global GameTitle    := "ahk_exe" GameExe
global MacroIni     := "mhiacro.ini"
global MacroCarIni  := "mhicar.ini"
global GameDir      := FindGameDirFromProfiles()
global GameMonitor  := 1
global GameHwnd     := 0

global IsGameWindowed       := CheckWindowed()
global IsGameLocked         := CheckLocked()
global IsGameAlwaysOnTop    := CheckAlwaysOnTop()

global NotifEnabled := ReadMacroIni("Settings", "NotifEnabled", 1)
global SearchByCode := ReadMacroIni("Settings", "SearchByCode", false)

; ══════════════════════════════════════════════
;  EVENTLAB PRESETS & DATA SOURCING
; ══════════════════════════════════════════════
global EventLabList     := ["JWRREN", "AAMIRUSMANDUS", "AMMAGEDON", "LIQUIDPOTATO"]
global EventLabData     := Map(
    "JWRREN", {
        CodeTune: "",
        CodeEvent: "170967418",
        Type: "Challenge",
        Keyword: "AFK skill point",
        MaxPoints: 990,
        MaxSections: 99,
        AveragePoints: 10,
        SecPerSection: 32,
        SecPerRow: 0,
        SectionsPerRow: 9,
        StartLoadingTime : 42,
        MidLoadingTime : 25,
        FinLoadingTime : 33,
    },
    "AAMIRUSMANDUS", {
        CodeTune: "",
        CodeEvent: "415085169", ; "140849306" (14 July ver.)
        Type: "Challenge",
        Keyword: "Always Lose",
        MaxPoints: 999,
        MaxSections: 110,
        AveragePoints: 9.4,
        SecPerSection: 20,
        SecPerRow: 0,
        SectionsPerRow: 1,
        StartLoadingTime : 42,
        MidLoadingTime : 25,
        FinLoadingTime : 33,
    },
    "AMMAGEDON", {
        CodeTune: "206657706",
        CodeEvent: "102089819",
        Type: "EventLab",
        MaxPoints: 980,
        MaxSections: 100,
        AveragePoints: 9.8,
        SecPerSection: 20,
        SecPerRow: 4,
        SectionsPerRow: 1,
        StartLoadingTime : 52,
        MidLoadingTime : 20,
        FinLoadingTime : 40,
    },
    "LIQUIDPOTATO", {
        CodeTune: "293391902",
        CodeEvent: "124198343",
        Type: "EventLab",
        MaxPoints: 940,
        MaxSections: 96,
        AveragePoints: 9.8,
        SecPerSection: 30,
        SecPerRow: 7,
        SectionsPerRow: 4,
        StartLoadingTime : 52,
        MidLoadingTime : 20,
        FinLoadingTime : 40,
    }
)

global EventLab         := ReadMacroIni("Settings", "EventLab", false)
global EventCar         := [816997639471, 594970474057, 725598108369]
global EventManufact    := "SUBARU"
global MaxPoints        := EventLabData[EventLab].MaxPoints

; ══════════════════════════════════════════════
;  HARDWARE & PROFILE TUNING
; ══════════════════════════════════════════════
global ResoList         := ["854 x 480", "960 x 540", "1024 x 576", "1280 x 720", "1366 x 768", "1920 x 1080", "2048 x 1152", "3200 x 1800", "3840 x 2160", "5120 x 2880", "7680 x 4320"]
global SelectedReso     := ReadMacroIni("Settings", "Resolution", ResoList[4])

global CarList := []
global CarData := Map()

global DefaultProfiles := []   ; Holds the automatically collected default names
global IsScriptStarting := true ; Track if the script is running its initial startup setup

RegisterCar("Impreza 22B-STi", {
    AltName: "1998 Subaru",
    StatsNum: 594970474057,
    BuyMfrPath: [["Up", 2]],
    BuyCarPath: [["Down", 1]],
    UnlockPath: [["Right", 1], ["Up", 3], ["Left", 1]],
    SkillPtsCost: 30,
    UnlockSWheel: 1,
    UnlockWheel: 0,
    UnlockCredit: 0
})

RegisterCar("Revuelto", {
    AltName: "2024 Lamborghini",
    StatsNum: 867299107749,
    BuyMfrPath: [["Down", 10], ["Right", 2]],
    BuyCarPath: [["Left", 1]],
    UnlockPath: [["Up", 3], ["Right", 2]],
    SkillPtsCost: 39,
    UnlockSWheel: 1,
    UnlockWheel: 3,
    UnlockCredit: 0
})

RegisterCar("Viper GTS ACR", {
    AltName: "1999 Dodge",
    StatsNum: 694952414050,
    BuyMfrPath: [["Down", 5], ["Right", 3]],
    BuyCarPath: [["Down", 1]],
    UnlockPath: [["Right", 1], ["Up", 3], ["Right", 1]],
    SkillPtsCost: 30,
    UnlockSWheel: 0,
    UnlockWheel: 0,
    UnlockCredit: 85400
})

RegisterCar("#123 Mad Mike 808", {
    AltName: "1974 Mazda",
    StatsNum: 725047495145,
    BuyMfrPath: [["Up", 10], ["Right", 1]],
    BuyCarPath: [["Down", 1], ["Left", 2]],  
    UnlockPath: [["Right", 2], ["Up", 3]],
    SkillPtsCost: 21,
    UnlockSWheel: 1,
    UnlockWheel: 0,
    UnlockCredit: 0
})

IsScriptStarting := false

global SelectedCar      := ReadMacroIni("Settings", "Car", CarList[1])
global SpinInFullLoop   := ReadMacroIni("Settings", "SpinInFullLoop", 0)
global SpinType         := ReadMacroIni("Settings", "SpinType", "SUPER")
global SpinMode         := ReadMacroIni("Settings", "SpinMode", "SELL")
global StartLoopMode    := ReadMacroIni("Settings", "StartLoopMode", "Race")

; ══════════════════════════════════════════════
;  MACRO RUNTIME & OPERATIONAL STATES
; ══════════════════════════════════════════════
global MasterMode       := false
global ActiveMode       := ""
global PauseMode        := ""

global SkillPtsCount := 0
global SkillPtsWant  := EventLabData[EventLab].MaxPoints
global LoopCount     := 99

; Split into separate configuration parameters
global CarsToTarget  := Floor(EventLabData[EventLab].MaxPoints / CarData[SelectedCar].SkillPtsCost)
global CarsActual  := Floor(SkillPtsCount / CarData[SelectedCar].SkillPtsCost)
global CarsToBuy     := CarsActual
global CarsToUnlock  := CarsActual
global CustomCarCount := false

global BuyCount      := 0
global UnlockCount   := 0

global PointsGain       := GetMinScore(SkillPtsWant)
global PointsTotal      := Min(PointsGain + SkillPtsCount, 999)
global TimeTotal        := CalcTotalTime(PointsGain, CarsToTarget)

global CustomSkillPts   := false
global SkillPtsScanSuccess := false

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

global Multipliers      := [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5, 2.75, 3, 3.25, 3.5, 3.75, 4]
global KeyMultiplier    := ReadMacroIni("Settings", "KeyMultiplier", 1)
global PixelMultiplier  := ReadMacroIni("Settings", "PixelMultiplier", 1)

global OCRCoords := Map(
    "ANNA",         {x: 0.052, y: 0.932, w: 0.100, h: 0.028},
    "Challenge",    {x: 0.260, y: 0.635, w: 0.413-0.260, h: 0.776-0.635},
    "Retry",        {x: 0.071, y: 0.912, w: 0.120-0.071, h: 0.947-0.912},
    "My Cars",      {x: 0.060, Y: 0.090, W: 0.096, h: 0.045},

    "MENU_HOME_MAIN",       {x: 0.027, y: 0.190, w: 0.221, h: 0.091},
    "MENU_FREE_ROAM_MAIN",  {x: 0.130, y: 0.508, w: 0.137, h: 0.105},
    "MENU_FREE_ROAM_STORE", {x: 0.730, y: 0.240, w: 0.134, h: 0.063},
)

global MenuProfiles := [
    { 
        coordKey: "MENU_HOME_MAIN", 
        menu: "Home Menu", 
        keywords: Map(
            "Campaign", "Home Menu - Campaign", 
            "Buy & Sell", "Home Menu - Buy & Sell", 
            "Cars", "Home Menu - Cars", 
            "Custom", "Home Menu - Customizable Garage", 
            "Character", "Home Menu - Character"
        ) 
    },
    { 
        coordKey: "MENU_FREE_ROAM_MAIN", 
        menu: "Free Roam Menu", 
        keywords: Map(
            "Collection Journal", "Free Roam Menu - Campaign", 
            "Buy New & Used", "Free Roam Menu - Cars", 
            "Super Wheelspin", "Free Roam Menu - My Horizon", 
            "Convoy", "Free Roam Menu - Online", 
            "Estates", "Free Roam Menu - Creative Hub"
        ) 
    },
    { 
        coordKey: "MENU_FREE_ROAM_STORE", 
        menu: "Free Roam Menu", 
        keywords: Map(
            "Car Pass", "Free Roam Menu - Store"
        ) 
    },
    { 
        coordKey: "ANNA", 
        menu: "Free Roam", 
        keywords: Map(
            "ANNA", "Free Roam"
        ) 
    }
]

; TestCoords("ANNA")

TestCoords(target) {
    ui := OCRCoords[target]
    MsgBox(ScanOCR(ui.x, ui.y, ui.w, ui.h))
}

; ══════════════════════════════════════════════
;  SPECIAL K INJECTION SETTINGS
; ══════════════════════════════════════════════
global SpecialKEnabled      := "0"
global TargetDLL            := "" 
global WindowHook           := 0

; ══════════════════════════════════════════════
;  DISCORD WEBHOOK SETTINGS
; ══════════════════════════════════════════════
global DiscordEnabled       := ReadMacroIni("Settings", "DiscordEnabled", 0)
global DiscordWebhookUrl    := ReadMacroIni("Settings", "DiscordWebhookUrl", "")
global DiscordWebhookRunning := false

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