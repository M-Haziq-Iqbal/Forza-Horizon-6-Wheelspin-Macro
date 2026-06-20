; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║        Cyber Noir Edition v1.7.0        ║
; ╚═════════════════════════════════════════╝

; ══════════════════════════════════════════════
;  GLOBAL UI HANDLES
; ══════════════════════════════════════════════
global PointsCount_UI   := ""
global CarCount_UI      := ""
global SWheelCount_UI   := ""
global WheelCount_UI    := ""
global CreditCount_UI   := ""
global CodeTune_UI      := ""
global TotalRunTime_UI  := ""
global RaceRunTime_UI   := ""
global BuyRunTime_UI    := ""
global UnlockRunTime_UI := ""
global CarSelect_UI     := ""
global CarsLabel_UI     := ""
global PointsLabel_UI   := ""
global TimeLabel_UI     := ""
global SectorLabel_UI   := ""
global PixelCheck_UI    := ""
global PremiumCheck_UI  := ""
global CodeSelect_UI    := ""
global SectorCount_UI   := ""
global SpinRunTime_UI   := ""
global SpinOpenCount_UI := ""
global SpinLeftCount_UI := ""
global MonitorSelect_UI := ""
global DarkMode         := true 

; ══════════════════════════════════════════════
;  RESOLUTION-RELATIVE MATRIX INITIALIZATION
; ══════════════════════════════════════════════
; Fetch dimensions for workspace coordinates mapping
MonitorGetWorkArea(, &mLeft, &mTop, &mRight, &mBottom)
Global MonWidth   := mRight - mLeft
Global MonHeight  := mBottom - mTop

; Anchor layout engine coordinates to your 1440p reference baseline
Global ScaleX     := MonWidth / 2560
Global ScaleY     := MonHeight / 1440
Global FontScale  := ScaleX / (A_ScreenDPI / 96)

; ══════════════════════════════════════════════
;  PALETTE COMPOSER
; ══════════════════════════════════════════════
GetPalette() {
    global DarkMode
    p := Map()

    if DarkMode {
        p["bg"]          := "0B0F14"
        p["panel"]       := "111826"
        p["accent"]      := "00E5FF"
        p["accent2"]     := "7C4DFF"
        p["text"]        := "E6F1FF"
        p["textDim"]     := "6B7C93"
        p["editBg"]      := "0F1624"
        p["btnBg"]       := "111826"
        p["btnText"]     := "00E5FF"
        p["btnBg2"]      := "0C1320"
        p["btnText2"]    := "6B7C93"
        p["divider"]     := "1F2A3A"
        p["cActive"]     := "00E5FF"
        p["cHighlight"]  := "39FF14"
        p["cPaused"]     := "FFD54F"
        p["cIdle"]       := "6B7C93"
        p["cTextDim"]    := "6B7C93"
        p["footer"]      := "1F2A3A"
        p["header"]      := "4289B6"
        p["activeBg"]    := "4B5563"
        p["inactiveBg"]  := "1F2937"
    } else {
        p["bg"]          := "F5F7FA"
        p["panel"]       := "E8EEF5"
        p["accent"]      := "0066FF"
        p["accent2"]     := "7C4DFF"
        p["text"]        := "0B1220"
        p["textDim"]     := "4B5B73"
        p["editBg"]      := "FFFFFF"
        p["btnBg"]       := "DCE8FF"
        p["btnText"]     := "003A99"
        p["btnBg2"]      := "CFE0FF"
        p["btnText2"]    := "4B5B73"
        p["divider"]     := "C9D6E5"
        p["cActive"]     := "0066FF"
        p["cHighlight"]  := "1DB954"
        p["cPaused"]     := "C68400"
        p["cIdle"]       := "4B5B73"
        p["cTextDim"]    := "4B5B73"
        p["footer"]      := "C9D6E5"
        p["header"]      := "4289B6"
        p["activeBg"]    := "BFDBFE"
        p["inactiveBg"]  := "F1F5F9"
    }
    return p
}

; ══════════════════════════════════════════════
;  TOGGLE BUTTON PAIR
; ══════════════════════════════════════════════
TogglePair(chosenValue, &targetVar, activeBtn, inactiveBtn, p) {
    targetVar := chosenValue
    activeBtn.Opt("Background" p["activeBg"])
    inactiveBtn.Opt("Background" p["inactiveBg"])
    activeBtn.Redraw()
    inactiveBtn.Redraw()
}

; ══════════════════════════════════════════════
;  FONT HELPER
; ══════════════════════════════════════════════
SetFixedFont(guiObj, pointSize, options := "", fontName := "Segoe UI") {
    global FontScale
    switch fontName {
        case "Light":    fontName := "Segoe UI Light"
        case "Semibold": fontName := "Segoe UI Semibold"
        case "Emoji":    fontName := "Segoe UI Emoji"
        default:         fontName := "Segoe UI"
    }
    fixedSize   := pointSize * FontScale
    guiObj.SetFont("s" fixedSize " " options, fontName)
}

; ══════════════════════════════════════════════
;  THEME TOGGLE
; ══════════════════════════════════════════════
ToggleTheme() {
    global DarkMode, MainGUI, SkillPtsCount_In, SkillPtsWant_In, CarCount_In, ActiveMode, LoopCount_In
    saved := [SkillPtsCount_In.Value, SkillPtsWant_In.Value, CarCount_In.Value, LoopCount_In.Value]

    if ActiveMode {
        ActiveMode  := ""
        MasterMode  := ""
        MasterStart := ""
        Sleep(1250)
    }

    DarkMode := !DarkMode
    MainGUI.Destroy()
    BuildGui(saved)
}

; ══════════════════════════════════════════════
;  INTERFACE GENERATION ENGINE
; ══════════════════════════════════════════════
BuildGui(savedVals := "") {
    global MainGUI, StatusText
    global PointsCount_UI, CarCount_UI, SWheelCount_UI, WheelCount_UI, CreditCount_UI
    global SpinRunTime_UI, SpinOpenCount_UI, SpinLeftCount_UI
    global TotalRunTime_UI, RaceRunTime_UI, BuyRunTime_UI, UnlockRunTime_UI, SectorCount_UI
    global PointsLabel_UI, TimeLabel_UI, CarsLabel_UI, SectorLabel_UI
    global CodeSelect_UI, DelaySlider_UI, SpeedLabel_UI, MonitorSelect_UI
    global Key_UI, Process_UI, CodeTune_UI, CodeEventLab_UI, CarSelect_UI
    global SkillPtsCount_In, SkillPtsWant_In, CarCount_In, LoopCount_In
    global AveragePoints, MaxPoints, PointsTotal, PointsGain, TimeTotal
    global ActiveMode, DarkMode, cActive, cHighlight, cIdle, cTextDim, cPaused, cStat
    global CodeEventLab, CodeTune, SpinMode, UserTier
    global CarList, CodeList
    global ScaleX, ScaleY
    
    ; Custom Slider Globals
    global SliderCfg, SliderKnob, SliderTrack

    p          := GetPalette()
    cActive    := p["cActive"]
    cHighlight := p["cHighlight"]
    cIdle      := p["cIdle"]
    cTextDim   := p["cTextDim"]
    cPaused    := p["cPaused"]
    cStat      := ActiveMode ? p["accent"] : p["textDim"]
    sLabel     := ActiveMode ? "⬤   Running..." : "⬤   Stopped"

    ; ── Window Container ──
    MainGUI := Gui("+AlwaysOnTop -MaximizeBox -DPIScale -Caption +Border", "MHI | FH6 MACRO")
    MainGUI.BackColor := p["bg"]

    ; ── Custom Window Controls ──
    SetFixedFont(MainGUI, 10, "bold")
    CustomMin := MainGUI.Add("Text", "x" Round(225*ScaleX) " y" Round(12*ScaleY) " w" Round(16*ScaleX) " h" Round(16*ScaleY) " Center BackgroundTrans c" p["textDim"], "─")
    CustomMin.OnEvent("Click", (*) => MainGUI.Minimize())

    CustomX := MainGUI.Add("Text", "x" Round(245*ScaleX) " y" Round(12*ScaleY) " w" Round(16*ScaleX) " h" Round(16*ScaleY) " Center BackgroundTrans c" p["textDim"], "✕")
    CustomX.OnEvent("Click", (*) => ExitApp())

    ; ── Header Layout ──
    SetFixedFont(MainGUI, 14, "bold", "Light")
    MainGUI.Add("Text", "x0 y" Round(30*ScaleY) " w" Round(270*ScaleX) " Center BackgroundTrans c" p["accent"], "WHEELSPIN MACRO")
    SetFixedFont(MainGUI, 7, "norm")
    MainGUI.Add("Text", "x0 y+" Round(1*ScaleY) " w" Round(270*ScaleX) " Center BackgroundTrans c" p["textDim"], "FORZA HORIZON 6   ✦   AFK FARM")

    ; ── Status Layout ──
    SetFixedFont(MainGUI, 10, "bold", "Semibold")
    StatusText := MainGUI.Add("Text", "x0 y+" Round(10*ScaleY) " w" Round(270*ScaleX) " Center BackgroundTrans c" cStat, sLabel)

    ; ── Tab Control Engine ──
    tabW := Round(260 * ScaleX)
    tabH := Round(450 * ScaleY)
    TabControl := MainGUI.Add("Tab2", "x" Round(5*ScaleX) " y+" Round(15*ScaleY) " w" tabW " h" tabH " +Buttons +0x400 c" p["accent"], ["Input", "Stats"])
    
    itemW := Floor((tabW - 12) / 2)
    itemH := Round(26 * ScaleY)
    SendMessage(0x1329, 0, itemW | (itemH << 16), TabControl)

    ; ══════════════════════════════════════════
    ;  TAB 1 — INPUT
    ; ══════════════════════════════════════════
    TabControl.UseTab(1)

    MainGUI.Add("Text", "x0 y+" Round(5*ScaleY) " w" Round(270*ScaleX) " h" Round(5*ScaleY) " BackgroundTrans c" p["footer"], "")

    ; ── Numeric Inputs ──
    SetFixedFont(MainGUI, 9, "norm", "Light")
    SkillPtsCount_In := MainGUI.Add("Edit", "x" Round(179*ScaleX) " y" Round(162*ScaleY) " w" Round(63*ScaleX) " h" Round(20*ScaleY) " -E0x200 Center Number Background" p["editBg"] " c" p["text"], savedVals ? savedVals[1] : 0)
    MainGUI.Add("Text", "x" Round(30*ScaleX) " yp+" Round(3*ScaleY) " w" Round(155*ScaleX) " BackgroundTrans c" p["text"], "⟡   Current Skill Points")

    SkillPtsWant_In := MainGUI.Add("Edit", "x" Round(179*ScaleX) " y" Round(188*ScaleY) " w" Round(63*ScaleX) " h" Round(20*ScaleY) " -E0x200 Center Number Background" p["editBg"] " c" p["text"], savedVals ? savedVals[2] : MaxPoints)
    MainGUI.Add("Text", "x" Round(30*ScaleX) " yp+" Round(3*ScaleY) " w" Round(155*ScaleX) " BackgroundTrans c" p["text"], "⟡   Desired Skill Points")

    CarCount_In := MainGUI.Add("Edit", "x" Round(179*ScaleX) " y" Round(214*ScaleY) " w" Round(63*ScaleX) " h" Round(20*ScaleY) " -E0x200 Center Number Background" p["editBg"] " c" p["text"], savedVals ? savedVals[3] : Floor(MaxPoints / SelectedCarPoint))
    MainGUI.Add("Text", "x" Round(30*ScaleX) " yp+" Round(3*ScaleY) " w" Round(155*ScaleX) " BackgroundTrans c" p["text"], "⟡   Car Purchase")

    LoopCount_In := MainGUI.Add("Edit", "x" Round(179*ScaleX) " y" Round(240*ScaleY) " w" Round(63*ScaleX) " h" Round(20*ScaleY) " -E0x200 Center Number Background" p["editBg"] " c" p["text"], savedVals ? savedVals[4] : 99)
    MainGUI.Add("Text", "x" Round(30*ScaleX) " yp+" Round(3*ScaleY) " w" Round(155*ScaleX) " BackgroundTrans c" p["text"], "⟡   Sequence Loop")

    ; ── Cyber Dropdown: Car Selector ──────────
    SetFixedFont(MainGUI, 9, "bold")
    CarSelect_UI := MainGUI.Add("Text", "x" Round(45*ScaleX) " y" Round(278*ScaleY) " w" Round(180*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["editBg"] " c" p["text"])
    CarSelect_UI.DefineProp("Value", {
        get: (this) => this.HasOwnProp("ctrlIndex") ? this.ctrlIndex : 1,
        set: (this, val) => (this.ctrlIndex := val, ControlSetText(CarList[val] "   ▼", this.Hwnd, this.Gui.Hwnd))
    })
    CarSelect_UI.DefineProp("Text", {
        get: (this) => CarList[this.Value],
        set: (this, val) => ControlSetText(val, this.Hwnd, this.Gui.Hwnd)
    })
    CarSelect_UI.Value := 1 
    CarSelect_UI.OnEvent("Click", ShowCarMenu)

    ; ── Tier Toggle ───────────────────────────
    SetFixedFont(MainGUI, 9, "bold", "Semibold")
    StandardBtn := MainGUI.Add("Text", "x" Round(14*ScaleX) " y" Round(308*ScaleY) " w" Round(119*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["activeBg"]   " c" p["text"], "😎   STANDARD")
    PremiumBtn  := MainGUI.Add("Text", "x" Round(137*ScaleX) " yp w" Round(119*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["inactiveBg"] " c" p["text"], "🜲   PREMIUM")
    StandardBtn.OnEvent("Click", (*) => TogglePair("STANDARD", &UserTier, StandardBtn, PremiumBtn, p))
    PremiumBtn.OnEvent("Click",  (*) => TogglePair("PREMIUM",  &UserTier, PremiumBtn, StandardBtn, p))

    ; ── Custom Slider Matrix (Repositioned into Input Tab) ──
    SliderCfg := {
        TrackX: Round(45 * ScaleX),
        TrackY: Round(380 * ScaleY),
        TrackW: Round(180 * ScaleX),
        TrackH: Round(4 * ScaleY),
        KnobW:  Round(10 * ScaleX),
        KnobH:  Round(16 * ScaleY),
        MinVal: 1,
        MaxVal: 12
    }

    SetFixedFont(MainGUI, 9, "norm")
    SpeedLabel_UI := MainGUI.Add("Text", "x0 y" Round(355*ScaleY) " w" Round(270*ScaleX) " Center c" p["text"], "Delay Multiplier: 1x")
    
    global DelaySlider_UI := { Value: 4 }
    knobY := SliderCfg.TrackY - (SliderCfg.KnobH // 2) + (SliderCfg.TrackH // 2)
    minX  := SliderCfg.TrackX - (SliderCfg.KnobW // 2)
    maxX  := SliderCfg.TrackX + SliderCfg.TrackW - (SliderCfg.KnobW // 2)
    startProgress := (DelaySlider_UI.Value - SliderCfg.MinVal) / (SliderCfg.MaxVal - SliderCfg.MinVal)
    startKnobX    := minX + (startProgress * (maxX - minX))

    SetFixedFont(MainGUI, 7, "norm") 
    MainGUI.Add("Text", "x" Round(22*ScaleX) " y" (SliderCfg.TrackY - Round(12*ScaleY)) " w" Round(12*ScaleX) " Center BackgroundTrans c" p["textDim"], "1")
    MainGUI.Add("Text", "x" Round(22*ScaleX) " y" (SliderCfg.TrackY - Round(6*ScaleY))  " w" Round(12*ScaleX) " Center BackgroundTrans c" p["textDim"], "─")
    MainGUI.Add("Text", "x" Round(22*ScaleX) " y" SliderCfg.TrackY " w" Round(12*ScaleX) " Center BackgroundTrans c" p["textDim"], "4")
    
    SetFixedFont(MainGUI, 8, "norm") 
    MainGUI.Add("Text", "x" Round(35*ScaleX) " y" (SliderCfg.TrackY - Round(6*ScaleY))  " w" Round(10*ScaleX) " Left BackgroundTrans c" p["textDim"], "x")
    
    SliderTrack := MainGUI.Add("Text", "x" SliderCfg.TrackX " y" SliderCfg.TrackY " w" SliderCfg.TrackW " h" SliderCfg.TrackH " +0x100 Background" p["divider"])
    SliderKnob  := MainGUI.Add("Text", "x" startKnobX " y" knobY " w" SliderCfg.KnobW " h" SliderCfg.KnobH " +0x100 Background" p["accent"])
    MainGUI.Add("Text", "x" Round(230*ScaleX) " y" (SliderCfg.TrackY - Round(6*ScaleY)) " w" Round(25*ScaleX) " Left c" p["textDim"], "5x")

    ; ── Action Buttons (Locked to bottom quadrant of Tab 1) ──
    SetFixedFont(MainGUI, 9, "bold", "Semibold")
    RaceBtn   := MainGUI.Add("Text", "x" Round(14*ScaleX) " y" Round(410*ScaleY) " w" Round(242*ScaleX) " h" Round(32*ScaleY) " Center 0x200 Background" p["btnBg"] " c" p["btnText"], "🏁   RACE      \")
    BuyBtn    := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+" Round(6*ScaleY) " w" Round(119*ScaleX) " h" Round(32*ScaleY) " Center 0x200 Background" p["btnBg"] " c" p["btnText"], "🚗   BUY     [")
    UnlockBtn := MainGUI.Add("Text", "x" Round(137*ScaleX) " yp w" Round(119*ScaleX) " h" Round(32*ScaleY) " Center 0x200 Background" p["btnBg"] " c" p["btnText"], "🛞   UNLOCK     ]")
    AllBtn    := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+" Round(6*ScaleY) " w" Round(242*ScaleX) " h" Round(32*ScaleY) " Center 0x200 Background" p["btnBg"] " c" p["btnText"], "⟲   INIT SEQUENCE     /")

    RaceBtn.OnEvent("Click",    (*) => StartRace())
    BuyBtn.OnEvent("Click",     (*) => StartBuy())
    UnlockBtn.OnEvent("Click",  (*) => StartUnlock())
    AllBtn.OnEvent("Click",     (*) => ToggleAll())

    ; ══════════════════════════════════════════
    ;  TAB 2 — STATS
    ; ══════════════════════════════════════════
    TabControl.UseTab(2)

    ; ── Targets ──
    SetFixedFont(MainGUI, 9, "bold")
    MainGUI.Add("Text", "x" Round(14*ScaleX) " y" Round(150*ScaleY) " w" Round(242*ScaleX) " Center BackgroundTrans c" p["header"],  "TARGETS")
    MainGUI.Add("Text", "x" Round(14*ScaleX) " y+0 w" Round(242*ScaleX) " Center BackgroundTrans c" p["divider"], "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

    PointsGain  := GetMinScore(SkillPtsWant_In.Value)
    PointsTotal := Min(PointsGain + SkillPtsCount_In.Value, 999)
    TimeTotal   := CalcTimeRace(SkillPtsWant_In.Value) + CalcTimeBuy(CarCount_In.Value) + CalcTimeUnlock(CarCount_In.Value)

    SetFixedFont(MainGUI, 9, "norm", "Light")
    MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(6*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "⟡   Est. Points Gain")
    PointsLabel_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), PointsGain)

    MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "⟡   Est. Sectors")
    SectorLabel_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), Ceil(PointsGain / AveragePoints))

    MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "⟡   Est. Total Time")
    TimeLabel_UI   := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), Format("{:02}:{:02}", Floor(TimeTotal), Round((TimeTotal - Floor(TimeTotal)) * 60)))

    MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "⟡   Recommended Car")
    CarsLabel_UI   := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), Floor(PointsTotal / SelectedCarPoint))

    SkillPtsCount_In.OnEvent("Change",    UpdateSkillPts)
    SkillPtsCount_In.OnEvent("LoseFocus", ValidateSkillPts)
    SkillPtsWant_In.OnEvent("Change",     UpdateSkillPtsWant)
    SkillPtsWant_In.OnEvent("LoseFocus",  ValidateSkillPtsWant)

    ; ── Live Progress Telemetry ──
    SetFixedFont(MainGUI, 9, "bold")
    MainGUI.Add("Text", "x" Round(14*ScaleX) " y+" Round(18*ScaleY) " w" Round(242*ScaleX) " Center BackgroundTrans c" p["header"],  "LIVE TELEMETRY")
    MainGUI.Add("Text", "x" Round(14*ScaleX) " y+0 w" Round(242*ScaleX) " Center BackgroundTrans c" p["divider"], "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

    SetFixedFont(MainGUI, 9, "norm", "Light")
    MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(6*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🕓   Race Runtime")
    RaceRunTime_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "00:00")

    MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "💡   Points Gained")
    PointsCount_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["accent"]), "0")

    MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🏁   Sectors Cleared")
    SectorCount_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "0")

    MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(12*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🚗   Buy Runtime")
    BuyRunTime_UI  := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "00:00")

    MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "📦   Cars Purchased")
    CarCount_UI    := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "0")

    MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(12*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🕓   Unlock Runtime")
    UnlockRunTime_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "00:00")

    MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🌟   Super Wheelspins")
    SWheelCount_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["accent"]), "0")

    MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🛞   Regular Wheelspins")
    WheelCount_UI  := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["accent"]), "0")

    MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "💲   Credits Earned")
    CreditCount_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["accent"]), "0 CR")

    ; ── Shared Content (outside tabs) ──────────
    TabControl.UseTab()

    MainGUI.Add("Text", "x" Round(14*ScaleX) " y" Round(525*ScaleY) " w" Round(242*ScaleX) " Center BackgroundTrans c" p["divider"], "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

    ; ── Persistent Dashboard Session Info (Moved to Global Footer Layout) ──
    SetFixedFont(MainGUI, 9, "norm", "Light")
    Key_UI          := MainGUI.Add("Text", "x0 y" Round(550*ScaleY) " w" Round(270*ScaleX) " Center BackgroundTrans c" p["cIdle"], "⌨   [   ]")
    Process_UI      := MainGUI.Add("Text", "x0 y+" Round(4*ScaleY) " w" Round(270*ScaleX) " Center BackgroundTrans c" p["cIdle"], "⚙️   Waiting...")
    TotalRunTime_UI := MainGUI.Add("Text", "x0 y+" Round(4*ScaleY) " w" Round(270*ScaleX) " Center BackgroundTrans c" p["cIdle"], "🕓   00:00")

    ; ── Cyber Dropdown: Code Selector ─────────
    SetFixedFont(MainGUI, 8, "bold")
    CodeSelect_UI := MainGUI.Add("Text", "x" Round(85*ScaleX) " y+" Round(14*ScaleY) " w" Round(100*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["editBg"] " c" p["text"])
    CodeSelect_UI.DefineProp("Value", {
        get: (this) => this.HasOwnProp("ctrlIndex") ? this.ctrlIndex : 1,
        set: (this, val) => (this.ctrlIndex := val, ControlSetText(CodeList[val] "   ▼", this.Hwnd, this.Gui.Hwnd))
    })
    CodeSelect_UI.DefineProp("Text", {
        get: (this) => CodeList[this.Value],
        set: (this, val) => ControlSetText(val, this.Hwnd, this.Gui.Hwnd)
    })
    CodeSelect_UI.Value := 1
    CodeSelect_UI.OnEvent("Click", ShowCodeMenu)

    ; ── Clickable Code Labels ─────────────────
    SetFixedFont(MainGUI, 9, "norm", "Emoji")
    CodeTune_UI     := MainGUI.Add("Text", "x" Round(60*ScaleX) " y+" Round(5*ScaleY) " w" Round(150*ScaleX) " Center BackgroundTrans c" p["cIdle"], "Subaru 22B Tune Code")
    CodeEventLab_UI := MainGUI.Add("Text", "x" Round(60*ScaleX) " y+0 w" Round(150*ScaleX) " Center BackgroundTrans c" p["cIdle"], "EventLab Race Code")

    CodeTune_UI.OnEvent("Click", (*) => _CopyToClip(CodeTune, "Subaru 22B Tune Code"))
    CodeEventLab_UI.OnEvent("Click", (*) => _CopyToClip(CodeEventLab, "EventLab Race Code"))

    ; ── Cyber-Noir Styled Toggle Trigger ────────────────
    SetFixedFont(MainGUI, 8, "bold", "Semibold")
    ToggleBtn := MainGUI.Add("Text", "x" Round(65*ScaleX) " y+" Round(15*ScaleY) " w" Round(140*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" p["btnText"], "⚙️   SPIN OPTIONS   ⏷")

    ; ── Collapsible Spin Section Grouping ─────
    SpinControls := []
    SetFixedFont(MainGUI, 9, "norm", "Light")
    SpinControls.Push(lbl1 := MainGUI.Add("Text", "x" Round(22*ScaleX) " y+" Round(10*ScaleY) " w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "¼   Spin Runtime"))
    SpinControls.Push(SpinRunTime_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "00:00"))

    SpinControls.Push(lbl2 := MainGUI.Add("Text", "x" Round(22*ScaleX) " y+0 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🎊   Spins Opened"))
    SpinControls.Push(SpinOpenCount_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "0"))

    SpinControls.Push(lbl3 := MainGUI.Add("Text", "x" Round(22*ScaleX) " y+0 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🎁   Spins Remaining"))
    SpinControls.Push(SpinLeftCount_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "0"))

    SetFixedFont(MainGUI, 9, "bold", "Semibold")
    SpinControls.Push(KeepBtn := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+" Round(16*ScaleY) " w" Round(119*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["activeBg"]   " c" p["text"], "💾   KEEP"))
    SpinControls.Push(SellBtn := MainGUI.Add("Text", "x" Round(137*ScaleX) " yp  w" Round(119*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["inactiveBg"] " c" p["text"], "🏷️   SELL"))

    SetFixedFont(MainGUI, 9, "bold", "Semibold")
    SpinControls.Push(SpinBtn := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+" Round(6*ScaleY) " w" Round(242*ScaleX) " h" Round(32*ScaleY) " Center 0x200 Background" p["btnBg"] " c" p["btnText"], "🎲   SPIN     ="))

    ; ── Sticky Bottom Footer Grouping ─────────
    FooterControls := []
    FooterControls.Push(F_Divider := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+" Round(12*ScaleY) " w" Round(242*ScaleX) " h" Round(1*ScaleY) " BackgroundTrans", ""))
    
    SetFixedFont(MainGUI, 8, "norm")
    FooterControls.Push(ThemeBtn := MainGUI.Add("Text", "x" Round(14*ScaleX) " yp+" Round(5*ScaleY) " w" Round(30*ScaleX) " h" Round(26*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" p["btnText2"], DarkMode ? "☀" : "🌙"))
    ThemeBtn.OnEvent("Click", (*) => ToggleTheme())

    FooterControls.Push(VersionLink := MainGUI.Add("Link", "x" Round(224*ScaleX) " yp+" Round(12*ScaleY) " Right", '<a href="https://github.com/M-Haziq-Iqbal/Forza-Horizon-6-Wheelspin-Macro/releases/tag/v1.7.0">v1.7.0</a>'))
    FooterControls.Push(BottomSpacer := MainGUI.Add("Text", "x0 y+" Round(5*ScaleY) " w" Round(270*ScaleX) " h" Round(1*ScaleY) " BackgroundTrans c" p["footer"], ""))

    KeepBtn.OnEvent("Click", (*) => TogglePair("KEEP", &SpinMode, KeepBtn, SellBtn, p))
    SellBtn.OnEvent("Click", (*) => TogglePair("SELL", &SpinMode, SellBtn, KeepBtn, p))
    SpinBtn.OnEvent("Click", (*) => StartSpin())

    MainGUI.Show("w" Round(270*ScaleX) " Hide")
    
    ToggleBtn.GetPos(, &tY, , &tH)
    F_Divider.GetPos(, &fY)
    shiftY := fY - (tY + tH + Round(15*ScaleY))
    
    footerOrigY := []
    for ctrl in FooterControls {
        ctrl.GetPos(, &cY)
        footerOrigY.Push(cY)
    }
    
    MainGUI.GetPos(,, &w, &expandedH)
    compactH := expandedH - shiftY

    _OnOptionsToggle(btnObj, *) {
        static isOpen := false
        isOpen := !isOpen
        
        for ctrl in SpinControls
            ctrl.Visible := isOpen
            
        for i, ctrl in FooterControls {
            ctrl.Move(, isOpen ? footerOrigY[i] : (footerOrigY[i] - shiftY))
        }
        
        MainGUI.Move(,,, isOpen ? expandedH : compactH)
        btnObj.Opt("Background" (isOpen ? p["activeBg"] : p["btnBg2"]))
        btnObj.Text := isOpen ? "⚙️   SPIN OPTIONS   ⏶" : "⚙️   SPIN OPTIONS   ⏷"
        btnObj.Redraw()
    }
    ToggleBtn.OnEvent("Click", _OnOptionsToggle)

    for ctrl in SpinControls
        ctrl.Visible := false
    for i, ctrl in FooterControls
        ctrl.Move(, footerOrigY[i] - shiftY)

    MainGUI.OnEvent("Close", (*) => ExitApp())
    MainGUI.OnEvent("Size",  MainGUI_SizeChange)

    MonitorGetWorkArea(, &Left, &Top, &Right, &Bottom)
    monWidth  := Right  - Left
    monHeight := Bottom - Top
    
    MainGUI.Move(Left + (monWidth // 2) + ((monWidth // 2) - w) // 2, Top + (monHeight - compactH) // 2, w, compactH)
    MainGUI.Show()
}

; ══════════════════════════════════════════════
;  BACKGROUND ASYNC WORKER LOOPS
; ══════════════════════════════════════════════
DragSliderTimer() {
    global SliderCfg, SliderKnob, SpeedLabel_UI, DelaySlider_UI
    
    if !GetKeyState("LButton", "P") {
        SetTimer(, 0)
        return
    }
    
    oldMouseMode := CoordMode("Mouse", "Window")
    MouseGetPos(&mouseX)
    CoordMode("Mouse", oldMouseMode)
    
    minX := SliderCfg.TrackX - (SliderCfg.KnobW // 2)
    maxX := SliderCfg.TrackX + SliderCfg.TrackW - (SliderCfg.KnobW // 2)
    newX := mouseX - (SliderCfg.KnobW // 2)
    
    if (newX < minX) {
        newX := minX
    } else if (newX > maxX) {
        newX := maxX
    }
    
    SliderKnob.Move(newX)
    
    currentProgress := newX - minX
    maxProgress := maxX - minX
    
    rawVal := SliderCfg.MinVal + ((currentProgress / maxProgress) * (SliderCfg.MaxVal - SliderCfg.MinVal))
    currentValue := Round(rawVal)
    
    DelaySlider_UI.Value := currentValue
    
    if IsSet(SpeedLabel_UI)
        SpeedLabel_UI.Value := "Delay Multiplier: " currentValue "x"
    
    try UpdateSpeed(DelaySlider_UI, "")
}

DragMainGUI() {
    global MainGUI, MainDragOffsetX, MainDragOffsetY
    
    if !GetKeyState("LButton", "P") {
        SetTimer(, 0)
        return
    }
    
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)
    MainGUI.Move(mouseX - MainDragOffsetX, mouseY - MainDragOffsetY)
}

; ══════════════════════════════════════════════
;  DROPDOWN EMULATION CONTROLLERS
; ══════════════════════════════════════════════
ShowCarMenu(ctrl, *) {
    global CarList
    carMenu := Menu()
    for index, carName in CarList {
        carMenu.Add(carName, MenuSelectCar.Bind(index))
    }
    carMenu.Show()
}

MenuSelectCar(index, *) {
    global CarSelect_UI
    CarSelect_UI.Value := index 
    try UpdateCar(CarSelect_UI, "")
}

ShowCodeMenu(ctrl, *) {
    global CodeList
    codeMenu := Menu()
    for index, codeName in CodeList {
        codeMenu.Add(codeName, MenuSelectCode.Bind(index))
    }
    codeMenu.Show()
}

MenuSelectCode(index, *) {
    global CodeSelect_UI
    CodeSelect_UI.Value := index 
    try UpdateCode(CodeSelect_UI, "")
}

_LinkNoirTelemetry(ctrl, initialValue) {
    ctrl.DefineProp("Text", {
        get: (this) => ControlGetText(this.Hwnd, this.Gui.Hwnd),
        set: (this, val) => (
            RegExMatch(val, "[—–-]\s*(.*)$", &match) 
            ? ControlSetText(match[1], this.Hwnd, this.Gui.Hwnd) 
            : ControlSetText(val, this.Hwnd, this.Gui.Hwnd)
        )
    })
    ctrl.Text := initialValue
    return ctrl
}

_CopyToClip(text, label) {
    A_Clipboard := text
    ToolTip(label " Copied!`n" text)
    SetTimer(() => ToolTip(), -2000)
}

; ══════════════════════════════════════════════
;  INITIALIZATION
; ══════════════════════════════════════════════
OnMessage(0x0201, WM_LBUTTONDOWN)
BuildGui()