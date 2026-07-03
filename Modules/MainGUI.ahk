; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

; ══════════════════════════════════════════════
;  GLOBAL UI HANDLES
; ══════════════════════════════════════════════
; Declare foundational objects at the root execution scope
Global MainGUI := 0, SpinGUI := 0, DarkMode := true

; Track structures globally for runtime cross-talk
Global SliderCfg := {}, SliderKnob := "", SliderTrack := "", SpeedLabel_UI := "", DelaySlider_UI := {}

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
        p["text"]        := "E6F1FF"
        p["textDim"]     := "6B7C93"
        p["editBg"]      := "0F1624"
        
        ; Sub-process buttons (Muted background, accent text)
        p["btnBg"]       := "111826"
        p["btnText"]     := "00E5FF"
        p["btnBg2"]      := "0C1320"
        p["btnText2"]    := "6B7C93"
        p["btnBg3"]      := "7C4DFF"
        p["btnText3"]    := "FFFFFF"
        
        ; Main Button (Inverted: Accent background, dark text)
        p["btnMainBg"]   := "00E5FF"
        p["btnMainText"] := "0B0F14"
        
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
        p["text"]        := "0B1220"
        p["textDim"]     := "4B5B73"
        p["editBg"]      := "FFFFFF"
        
        ; Sub-process buttons (Soft background, deep text)
        p["btnBg"]       := "DCE8FF"
        p["btnText"]     := "003A99"
        p["btnBg2"]      := "CFE0FF"
        p["btnText2"]    := "4B5B73"
        p["btnBg3"]      := "7C4DFF"
        p["btnText3"]    := "FFFFFF"
        
        ; Main Button (Solid vibrant background, white text)
        p["btnMainBg"]   := "0066FF"
        p["btnMainText"] := "FFFFFF"
        
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
ToggleUserTier(chosenValue, &targetVar, activeBtn, inactiveBtn, p) {
    targetVar := chosenValue
    activeBtn.Opt("Background" p["activeBg"])
    inactiveBtn.Opt("Background" p["inactiveBg"])
    activeBtn.Redraw()
    inactiveBtn.Redraw()

    WriteMacroIni("Settings", "UserTier", targetVar)
}

ToggleSpinMode(chosenValue, &targetVar, activeBtn, inactiveBtn, p) {
    targetVar := chosenValue
    activeBtn.Opt("Background" p["activeBg"])
    inactiveBtn.Opt("Background" p["inactiveBg"])
    activeBtn.Redraw()
    inactiveBtn.Redraw()

    WriteMacroIni("Settings", "SpinMode", targetVar)
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
    global SpinGUI 
    
    saved := [SkillPtsCount_In.Value, SkillPtsWant_In.Value, CarCount_In.Value, LoopCount_In.Value]

    if ActiveMode {
        ActiveMode  := ""
        MasterMode  := ""
        MasterStart := ""
        Sleep(1250)
    }

    spinWasOpen := false
    try {
        if IsSet(SpinGUI) && SpinGUI && WinExist("ahk_id " SpinGUI.Hwnd) {
            spinWasOpen := true
            SpinGUI.Destroy()
            SpinGUI := 0 
        }
    } catch {
        ; Discard windowless errors
    }

    DarkMode := !DarkMode
    MainGUI.Destroy()
    BuildMainGui(saved)
    
    if (spinWasOpen) {
        try {
            OpenSpinPanel() 
        }
    }
}

; ══════════════════════════════════════════════
;  INTERFACE GENERATION ENGINE
; ══════════════════════════════════════════════
BuildMainGui(savedVals := "") {
    ; Elevates all internal assignments to global scope automatically
    global 

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

    ; ── Top-Left Header Window Utility ─────────
    SetFixedFont(MainGUI, 10, "norm") ; Slightly larger icon fits nicely at the top
    ThemeBtn := MainGUI.Add("Text", "x" Round(12*ScaleX) " y" Round(12*ScaleY) " w" Round(20*ScaleX) " h" Round(20*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" p["btnText2"], DarkMode ? "☀" : "🌙")
    ThemeBtn.OnEvent("Click", (*) => ToggleTheme())

    ; ── Custom Window Controls ──
    SetFixedFont(MainGUI, 10, "bold")
    CustomMin := MainGUI.Add("Text", "x" Round(225*ScaleX) " y" Round(12*ScaleY) " w" Round(16*ScaleX) " h" Round(16*ScaleY) " Center BackgroundTrans c" p["textDim"], "─")
    ; FIXED: Replaced non-existent internal .Minimize() method with safe Win API control
    CustomMin.OnEvent("Click", (*) => WinMinimize(MainGUI.Hwnd))

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
    tabH := Round(485 * ScaleY) 
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

    SkillPtsCount_In.OnEvent("Change", (ctrl, *) => UpdateSkillPts(ctrl))
    SkillPtsCount_In.OnEvent("LoseFocus", (ctrl, *) => ValidateSkillPts(ctrl))
    SkillPtsWant_In.OnEvent("Change", (ctrl, *) => UpdateSkillPtsWant(ctrl))
    SkillPtsWant_In.OnEvent("LoseFocus", (ctrl, *) => ValidateSkillPtsWant(ctrl))

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
    startupIndex := 1
    for index, name in CarList {
        if (name == SelectedCar) {
            startupIndex := index
            break
        }
    }
    CarSelect_UI.Value := startupIndex
    CarSelect_UI.OnEvent("Click", ShowCarMenu)

    ; ── Tier Toggle ───────────────────────────
    SetFixedFont(MainGUI, 9, "bold", "Semibold")
    StandardBtnBG := UserTier = "STANDARD" ? p["activeBg"] : p["inactiveBg"]
    PremiumBtnBG := UserTier = "PREMIUM" ? p["activeBg"] : p["inactiveBg"]
    StandardBtn := MainGUI.Add("Text", "x" Round(14*ScaleX) " y" Round(308*ScaleY) " w" Round(119*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" StandardBtnBG   " c" p["text"], "😎   STANDARD")
    PremiumBtn  := MainGUI.Add("Text", "x" Round(137*ScaleX) " yp w" Round(119*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" PremiumBtnBG " c" p["text"], "🜲   PREMIUM")
    StandardBtn.OnEvent("Click", (*) => ToggleUserTier("STANDARD", &UserTier, StandardBtn, PremiumBtn, p))
    PremiumBtn.OnEvent("Click",  (*) => ToggleUserTier("PREMIUM",  &UserTier, PremiumBtn, StandardBtn, p))

    ; ── Custom Slider Matrix ──
    SliderCfg := {
        TrackX: Round(45 * ScaleX),
        TrackY: Round(380 * ScaleY),
        TrackW: Round(180 * ScaleX),
        TrackH: Round(4 * ScaleY),
        KnobW:  Round(10 * ScaleX),
        KnobH:  Round(16 * ScaleY),
        MinVal: 1,
        MaxVal: Multipliers.Length
    }

    SetFixedFont(MainGUI, 9, "norm")
    SpeedLabel_UI := MainGUI.Add("Text", "x0 y" Round(355*ScaleY) " w" Round(270*ScaleX) " Center c" p["text"], "Key Delay Multiplier: " KeyMultiplier "x")
    
    DelaySliderIndex := 4
    for index, name in Multipliers {
        if (name == KeyMultiplier) {
            DelaySliderIndex := index
            break
        }
    }
    DelaySlider_UI := {Value: DelaySliderIndex}
    knobY := SliderCfg.TrackY - (SliderCfg.KnobH // 2) + (SliderCfg.TrackH // 2)
    minX  := SliderCfg.TrackX - (SliderCfg.KnobW // 2)
    maxX  := SliderCfg.TrackX + SliderCfg.TrackW - (SliderCfg.KnobW // 2)
    startProgress := (DelaySlider_UI.Value - SliderCfg.MinVal) / (SliderCfg.MaxVal - SliderCfg.MinVal)
    startKnobX     := minX + (startProgress * (maxX - minX))

    SetFixedFont(MainGUI, 7, "norm") 
    MainGUI.Add("Text", "x" Round(22*ScaleX) " y" (SliderCfg.TrackY - Round(12*ScaleY)) " w" Round(12*ScaleX) " Center BackgroundTrans c" p["textDim"], "1")
    MainGUI.Add("Text", "x" Round(22*ScaleX) " y" (SliderCfg.TrackY - Round(6*ScaleY))  " w" Round(12*ScaleX) " Center BackgroundTrans c" p["textDim"], "─")
    MainGUI.Add("Text", "x" Round(22*ScaleX) " y" SliderCfg.TrackY " w" Round(12*ScaleX) " Center BackgroundTrans c" p["textDim"], "4")
    
    SetFixedFont(MainGUI, 8, "norm") 
    MainGUI.Add("Text", "x" Round(35*ScaleX) " y" (SliderCfg.TrackY - Round(6*ScaleY))  " w" Round(10*ScaleX) " Left BackgroundTrans c" p["textDim"], "x")
    
    SliderTrack := MainGUI.Add("Text", "x" SliderCfg.TrackX " y" SliderCfg.TrackY " w" SliderCfg.TrackW " h" SliderCfg.TrackH " +0x100 Background" p["divider"])
    SliderKnob  := MainGUI.Add("Text", "x" startKnobX " y" knobY " w" SliderCfg.KnobW " h" SliderCfg.KnobH " +0x100 Background" p["accent"])
    MainGUI.Add("Text", "x" Round(230*ScaleX) " y" (SliderCfg.TrackY - Round(6*ScaleY)) " w" Round(25*ScaleX) " Left c" p["textDim"], "4x")
    
    ; ── Action Buttons ──
    SetFixedFont(MainGUI, 9, "bold", "Semibold")
    AllBtn    := MainGUI.Add("Text", "x" Round(14*ScaleX) " y" Round(410*ScaleY) " w" Round(242*ScaleX) " h" Round(32*ScaleY) " Center 0x200 Background" p["btnMainBg"] " c" p["btnMainText"], "⟲   FULL LOOP     /")
    RaceBtn   := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+" Round(6*ScaleY) " w" Round(242*ScaleX) " h" Round(32*ScaleY) " Center 0x200 Background" p["btnBg"] " c" p["btnText"], "🏁   RACE      \")
    BuyBtn    := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+" Round(6*ScaleY) " w" Round(119*ScaleX) " h" Round(32*ScaleY) " Center 0x200 Background" p["btnBg"] " c" p["btnText"], "🚗   BUY     [")
    UnlockBtn := MainGUI.Add("Text", "x" Round(137*ScaleX) " yp w" Round(119*ScaleX) " h" Round(32*ScaleY) " Center 0x200 Background" p["btnBg"] " c" p["btnText"], "🛞   UNLOCK     ]")
    OpenSpinWindowBtn := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+" Round(6*ScaleY) " w" Round(242*ScaleX) " h" Round(32*ScaleY) " Center 0x200 Background" p["btnBg3"] " c" p["btnText3"], "🎰   OPEN SPIN INTERFACE")

    RaceBtn.OnEvent("Click",    (*) => StartRace())
    BuyBtn.OnEvent("Click",     (*) => StartBuy())
    UnlockBtn.OnEvent("Click",  (*) => StartUnlock())
    AllBtn.OnEvent("Click",     (*) => ToggleAll())
    OpenSpinWindowBtn.OnEvent("Click", (*) => OpenSpinPanel())

    ; ══════════════════════════════════════════
    ;  TAB 2 — STATS
    ; ══════════════════════════════════════════
    TabControl.UseTab(2)

    SetFixedFont(MainGUI, 9, "bold")
    MainGUI.Add("Text", "x" Round(14*ScaleX) " y" Round(180*ScaleY) " w" Round(242*ScaleX) " Center BackgroundTrans c" p["header"],  "TARGETS")
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

    MainGUI.Add("Text", "x" Round(14*ScaleX) " y" Round(560*ScaleY) " w" Round(242*ScaleX) " Center BackgroundTrans c" p["divider"], "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

    ; ── Persistent Dashboard Session Info ──
    SetFixedFont(MainGUI, 9, "norm", "Light")
    Key_UI          := MainGUI.Add("Text", "x0 y" Round(580*ScaleY) " w" Round(270*ScaleX) " Center BackgroundTrans c" p["cIdle"], "⌨   [   ]")
    Process_UI      := MainGUI.Add("Text", "x0 y+" Round(4*ScaleY) " w" Round(270*ScaleX) " Center BackgroundTrans c" p["cIdle"], "⚙️   Waiting...")
    TotalRunTime_UI := MainGUI.Add("Text", "x0 y+" Round(4*ScaleY) " w" Round(270*ScaleX) " Center BackgroundTrans c" p["cIdle"], "🕓   00:00")

    ; ── Cyber Dropdown: Event Lab Selector ─────────
    SetFixedFont(MainGUI, 8, "bold")
    EventLabSelect_UI := MainGUI.Add("Text", "x" Round(85*ScaleX) " y+" Round(14*ScaleY) " w" Round(100*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["editBg"] " c" p["text"])
    EventLabSelect_UI.DefineProp("Value", {
        get: (this) => this.HasOwnProp("ctrlIndex") ? this.ctrlIndex : 1,
        set: (this, val) => (this.ctrlIndex := val, ControlSetText(EventLabList[val] "   ▼", this.Hwnd, this.Gui.Hwnd))
    })
    EventLabSelect_UI.DefineProp("Text", {
        get: (this) => EventLabList[this.Value],
        set: (this, val) => ControlSetText(val, this.Hwnd, this.Gui.Hwnd)
    })
    startupIndex := 1
    for index, name in EventLabList {
        if (name == EventLab) {
            startupIndex := index
            break
        }
    }
    EventLabSelect_UI.Value := startupIndex
    EventLabSelect_UI.OnEvent("Click", ShowEventLabMenu)

    ; ── Clickable Code Labels ─────────────────
    SetFixedFont(MainGUI, 9, "norm", "Emoji")
    CodeTune_UI     := MainGUI.Add("Text", "x" Round(60*ScaleX) " y+" Round(5*ScaleY) " w" Round(150*ScaleX) " Center BackgroundTrans c" p["cIdle"], "Subaru 22B Tune Code")
    CodeEventLab_UI := MainGUI.Add("Text", "x" Round(60*ScaleX) " y+0 w" Round(150*ScaleX) " Center BackgroundTrans c" p["cIdle"], "EventLab Race Code")

    CodeTune_UI.OnEvent("Click", (*) => _CopyToClip(CodeTune, "Subaru 22B Tune Code"))
    CodeEventLab_UI.OnEvent("Click", (*) => _CopyToClip(CodeEventLab, "EventLab Race Code"))

    ; ── Cyber-Noir Styled Toggle Trigger ────────────────
    SetFixedFont(MainGUI, 8, "bold", "Semibold")
    ToggleBtn := MainGUI.Add("Text", "x" Round(65*ScaleX) " y+" Round(15*ScaleY) " w" Round(140*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" p["btnText"], "⚙️   OPTIONS   ⏷")

    ; ── Collapsible Options Section ─────
    
    OptionsControls := []

    ; ── Cyber Dropdown: Resolution Selector ─────────
    SetFixedFont(MainGUI, 9, "bold")
    OptionsControls.Push(ResoSelect_UI := MainGUI.Add("Text", "x" Round(75*ScaleX) " y+" Round(12*ScaleY) " w" Round(120*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["editBg"] " c" p["text"]))
    ResoSelect_UI.DefineProp("Value", {
        get: (this) => this.HasOwnProp("ctrlIndex") ? this.ctrlIndex : 1,
        set: (this, val) => (this.ctrlIndex := val, ControlSetText("     " ResoList[val] "   ▼", this.Hwnd, this.Gui.Hwnd))
    })
    ResoSelect_UI.DefineProp("Text", {
        get: (this) => ResoList[this.Value],
        set: (this, val) => ControlSetText(val, this.Hwnd, this.Gui.Hwnd)
    })
    startupIndex := 1
    for index, name in ResoList {
        if (name == SelectedReso) {
            startupIndex := index
            break
        }
    }
    ResoSelect_UI.Value := startupIndex
    ResoSelect_UI.OnEvent("Click", ShowResoMenu)
    
    SetFixedFont(MainGUI, 8, "bold", "Semibold")
    OptionsControls.Push(BrowseBtn := MainGUI.Add("Text", "x" Round(70*ScaleX) " y+" Round(8*ScaleY) " w" Round(130*ScaleX) " h" Round(26*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" p["btnText"], "📂   SET GAME PATH"))
    BrowseBtn.OnEvent("Click", (*) => LocateGameDir(true))

    OptionsControls.Push(LaunchBtn := MainGUI.Add("Text", "x" Round(70*ScaleX) " y+" Round(8*ScaleY) " w" Round(130*ScaleX) " h" Round(26*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" p["btnText"], "🚀   LAUNCH GAME"))
    LaunchBtn.OnEvent("Click", LaunchGame)

    ; ── Special K Checkbox ─────────
    ; Read current status to set the correct initialization style
    isKEnabled := SpecialKCheck() 
    isGameRunning := ProcessExist(GameExe)
    initColor := isGameRunning ? p["textDim"] : (isKEnabled ? p["text"] : p["textDim"])
    initText  := isGameRunning ? "🔒 SPECIAL K (GAME RUNNING)" : (isKEnabled ? "▰  SPECIAL K: ACTIVE" : "▱  SPECIAL K: INACTIVE")

    SetFixedFont(MainGUI, 9, "norm", "Light")
    SpecialKCheck_UI := MainGUI.Add("Text", "x" Round(20*ScaleX) " y+" Round(8*ScaleY) " w" Round(230*ScaleX) " h" Round(20*ScaleY) " Center 0x200 c" initColor, initText)
    SpecialKCheck_UI.State := isKEnabled 
    OptionsControls.Push(SpecialKCheck_UI)
    SpecialKCheck_UI.OnEvent("Click", SpecialKToggle)

    ; ── Clean Center-Aligned Footer ─────────
    FooterControls := []
    
    ; Row 1: Divider line
    FooterControls.Push(F_Divider := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+" Round(6*ScaleY) " w" Round(242*ScaleX) " h" Round(1*ScaleY) " BackgroundTrans", ""))

    ; Row 2: Centered Ko-fi button
    FooterControls.Push(Kofi_UI := MainGUI.Add("Picture", "x" Round(72*ScaleX) " yp+" Round(0*ScaleY) " w" Round(125*ScaleX) " h" Round(25*ScaleY), A_ScriptDir "\assets\kofi.png"))
    Kofi_UI.OnEvent("Click", (*) => Run("https://ko-fi.com/mhaziqiqbal"))
    
    ; Row 3: Natively Centered Application Status Bar (Full Width)
    SetFixedFont(MainGUI, 8, "norm")
    FooterControls.Push(UpdateLink := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+" Round(6*ScaleY) " w" Round(242*ScaleX) " Center c" p["btnText2"], "Checking status..."))
    
    ; Custom property-based click router (No more parameter index crashes!)
    UpdateLink.OnEvent("Click", (ctrlObj, *) => (ctrlObj.HasProp("DownloadUrl") && ctrlObj.DownloadUrl != "") ? ProcessUpdate(ctrlObj.DownloadUrl, ctrlObj.AssetType) : Run(ctrlObj.HtmlUrl))
    
    ; Launch update check
    CheckForUpdates(UpdateLink)
    
    ; Row 4: Bottom boundary spacer
    FooterControls.Push(BottomSpacer := MainGUI.Add("Text", "x0 yp+" Round(25*ScaleY) " w" Round(270*ScaleX) " h" Round(1*ScaleY) " BackgroundTrans c" p["footer"], ""))

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
        
        for ctrl in OptionsControls
            ctrl.Visible := isOpen
             
        for i, ctrl in FooterControls {
            ctrl.Move(, isOpen ? footerOrigY[i] : (footerOrigY[i] - shiftY))
        }
        
        MainGUI.Move(,,, isOpen ? expandedH : compactH)
        btnObj.Opt("Background" (isOpen ? p["activeBg"] : p["btnBg2"]))
        btnObj.Text := isOpen ? "⚙️   OPTIONS   ⏶"  : "⚙️   OPTIONS   ⏷"
        btnObj.Redraw()
    }
    ToggleBtn.OnEvent("Click", _OnOptionsToggle)

    for ctrl in OptionsControls
        ctrl.Visible := false
    for i, ctrl in FooterControls
        ctrl.Move(, footerOrigY[i] - shiftY)

    MainGUI.OnEvent("Close", (*) => ExitApp())
    MainGUI.OnEvent("Size",  MainGUI_SizeChange)
    
    MainGUI.Move(MonLeft + MonWidth - w - Round(35*ScaleX), MonTop + Round(35*ScaleX), w, compactH)
    MainGUI.Show()
}

; ══════════════════════════════════════════════
;  POPOUT INTERFACE: SPIN MANAGEMENT PANEL
; ══════════════════════════════════════════════
OpenSpinPanel(*) {
    global SpinGUI, SpinRunTime_UI, SpinOpenCount_UI, SpinLeftCount_UI, SpinLoop_In, SpinWants_In, MainGUI, ActiveMode, SpinMode
    global ScaleX, ScaleY
    
    try {
        if IsSet(SpinGUI) && SpinGUI && WinExist("ahk_id " SpinGUI.Hwnd) {
            WinActivate("ahk_id " SpinGUI.Hwnd)
            return
        }
    } catch {
        ; Handle edge-case windowless errors
    }

    p := GetPalette()
    SpinGUI := Gui("+AlwaysOnTop -MaximizeBox -DPIScale -Caption +Border", "MHI | SPIN MODULE")
    SpinGUI.BackColor := p["bg"]

    SetFixedFont(SpinGUI, 10, "bold")
    SpinMin := SpinGUI.Add("Text", "x" Round(205*ScaleX) " y" Round(12*ScaleY) " w" Round(16*ScaleX) " h" Round(16*ScaleY) " Center BackgroundTrans c" p["textDim"], "─")
    ; FIXED: Replaced non-existent internal method with safe native call
    SpinMin.OnEvent("Click", (*) => WinMinimize(SpinGUI.Hwnd))

    SpinX := SpinGUI.Add("Text", "x" Round(225*ScaleX) " y" Round(12*ScaleY) " w" Round(16*ScaleX) " h" Round(16*ScaleY) " Center BackgroundTrans c" p["textDim"], "✕")

    OnSpinClose(*) {
        global SpinGUI, ActiveMode
        if (ActiveMode == "Spin") {
            StartSpin()
        }
        SpinGUI.Destroy()
        SpinGUI := 0
    }
    SpinX.OnEvent("Click", OnSpinClose)

    ; ── Interface Content ──
    SetFixedFont(SpinGUI, 12, "bold", "Light")
    SpinGUI.Add("Text", "x0 y" Round(30*ScaleY) " w" Round(250*ScaleX) " Center c" p["accent"], "SPIN CONTROLLER")

    SetFixedFont(SpinGUI, 9, "norm", "Light")
    SpinLoop_In := SpinGUI.Add("Edit", "x" Round(170*ScaleX) " y+" Round(15*ScaleY) " w" Round(63*ScaleX) " h" Round(20*ScaleY) " -E0x200 Center Number Background" p["editBg"] " c" p["text"], 99)
    SpinGUI.Add("Text", "x" Round(20*ScaleX) " yp+" Round(3*ScaleY) " w" Round(155*ScaleX) " BackgroundTrans c" p["text"], "⟡   Spin Loop")
        
    SpinWants_In := SpinGUI.Add("Edit", "x" Round(170*ScaleX) " y+" Round(6*ScaleY) " w" Round(63*ScaleX) " h" Round(20*ScaleY) " -E0x200 Center Number Background" p["editBg"] " c" p["text"], 99)
    SpinGUI.Add("Text", "x" Round(20*ScaleX) " yp+" Round(3*ScaleY) " w" Round(155*ScaleX) " BackgroundTrans c" p["text"], "⟡   Desired Spins")

    SpinGUI.Add("Text", "x" Round(5*ScaleX) " y+5 w" Round(240*ScaleX) " Center BackgroundTrans c" p["divider"], "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    SetFixedFont(SpinGUI, 9, "norm", "Light")
    SpinGUI.Add("Text", "x" Round(20*ScaleX) " y+" Round(5*ScaleY) " w" Round(130*ScaleX) " c" p["textDim"], "🕓   Spin Runtime")
    SpinRunTime_UI := SpinGUI.Add("Text", "x" Round(150*ScaleX) " yp w" Round(80*ScaleX) " Right c" p["text"], "00:00")

    SpinGUI.Add("Text", "x" Round(20*ScaleX) " y+6 w" Round(130*ScaleX) " c" p["textDim"], "🎊   Spins Opened")
    SpinOpenCount_UI := SpinGUI.Add("Text", "x" Round(150*ScaleX) " yp w" Round(80*ScaleX) " Right c" p["text"], "0")

    SpinGUI.Add("Text", "x" Round(20*ScaleX) " y+6 w" Round(130*ScaleX) " c" p["textDim"], "🎁   Spins Remaining")
    SpinLeftCount_UI := SpinGUI.Add("Text", "x" Round(150*ScaleX) " yp w" Round(80*ScaleX) " Right c" p["text"], "0")

    SetFixedFont(SpinGUI, 9, "bold", "Semibold")
    KeepBtnBG := SpinMode = "KEEP" ? p["activeBg"] : p["inactiveBg"]
    SellBtnBG := SpinMode = "SELL" ? p["activeBg"] : p["inactiveBg"]
    KeepBtn := SpinGUI.Add("Text", "x" Round(15*ScaleX) " y+16 w" Round(105*ScaleX) " h" Round(26*ScaleY) " Center 0x200 Background" KeepBtnBG " c" p["text"], "💾   KEEP")
    SellBtn := SpinGUI.Add("Text", "x" Round(130*ScaleX) " yp w" Round(105*ScaleX) " h" Round(26*ScaleY) " Center 0x200 Background" SellBtnBG " c" p["text"], "🏷️   SELL")

    KeepBtn.OnEvent("Click", (*) => ToggleSpinMode("KEEP", &SpinMode, KeepBtn, SellBtn, p))
    SellBtn.OnEvent("Click", (*) => ToggleSpinMode("SELL", &SpinMode, SellBtn, KeepBtn, p))

    SetFixedFont(SpinGUI, 10, "bold", "Semibold")
    SpinBtn := SpinGUI.Add("Text", "x" Round(15*ScaleX) " y+10 w" Round(220*ScaleX) " h" Round(35*ScaleY) " Center 0x200 Background" p["btnBg"] " c" p["btnText"], "🎲   RUN WHEELSPIN   =")
    SpinBtn.OnEvent("Click", (*) => StartSpin())

    sW := Round(250 * ScaleX)
    sH := Round(290 * ScaleY)
    
    MainGUI.GetPos(&mX, &mY, &mW, &mH)
    sX := mX + (mW // 2) - (sW // 2)
    sY := mY + (mH // 2) - (sH // 2)
    
    SpinGUI.Show("x" sX " y" sY " w" sW " h" sH)
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
    
    ; FIXED: Target the text property for reliability on Text layout objects
    if IsSet(SpeedLabel_UI)
        SpeedLabel_UI.Text := "Key Delay Multiplier: " currentValue "x"
    
    try UpdateSpeed(DelaySlider_UI, "")
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

ShowEventLabMenu(ctrl, *) {
    global EventLabList
    EventLabMenu := Menu()
    for index, EventLabName in EventLabList {
        EventLabMenu.Add(EventLabName, MenuSelectEventLab.Bind(index))
    }
    EventLabMenu.Show()
}

MenuSelectEventLab(index, *) {
    global EventLabSelect_UI
    EventLabSelect_UI.Value := index 
    try UpdateEventLab(EventLabSelect_UI, "")
}

ShowResoMenu(ctrl, *) {
    global ResoList
    resoMenu := Menu()
    for index, resoNum in ResoList {
        resoMenu.Add(resoNum, MenuSelectReso.Bind(index))
    }
    resoMenu.Show()
}

MenuSelectReso(index, *) {
    global ResoSelect_UI
    ResoSelect_UI.Value := index 
    try UpdateReso(ResoSelect_UI, "")
}

; ==========================================
; UPDATE FUNCTIONS
; ==========================================

CheckForUpdates(linkCtrl) {
    try {
        whr := ComObject("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", "https://api.github.com/repos/" RepoOwner "/" RepoName "/releases/latest", true)
        whr.SetRequestHeader("User-Agent", "AHK-v2-Updater")
        whr.Send()
        whr.WaitForResponse()
        
        if (whr.Status != 200)
            throw Error()
            
        jsonText := whr.ResponseText
        
        if !RegExMatch(jsonText, '"tag_name":\s*"([^"]+)"', &matchTag)
            throw Error()
        latestVersion := matchTag[1]
        
        downloadUrl := ""
        assetType := ""
        currentArch := (A_PtrSize == 8) ? "x64" : "x32"
        
        if (!A_IsCompiled) {
            assetType := "ZIP archive"
            if RegExMatch(jsonText, '"browser_download_url":\s*"([^"]+\.zip)"', &matchUrl)
                downloadUrl := matchUrl[1]
        } else {
            assetType := currentArch " Executable"
            archPattern := (currentArch == "x64") ? "x64" : "(x32|x86)"
            if RegExMatch(jsonText, '"browser_download_url":\s*"([^"]+' archPattern '[^"]*\.exe)"', &matchUrl)
                downloadUrl := matchUrl[1]
        }
        
        RegExMatch(jsonText, '"html_url":\s*"([^"]+)"', &matchHtml)
        htmlUrl := matchHtml ? matchHtml[1] : "https://github.com/" RepoOwner "/" RepoName "/releases"

        ; Run our smart comparison math
        compResult := CompareVersions(CurrentVersion, latestVersion)

        if (compResult == 1) {
            ; 🧪 LOCAL VERSION IS GREATER THAN GITHUB RELEASE
            linkCtrl.DownloadUrl := ""  ; Empty url forces click to open the github changelog instead
            linkCtrl.AssetType := ""
            linkCtrl.HtmlUrl := htmlUrl
            linkCtrl.Text := CurrentVersion " | Beta Build 🧪"
        } 
        else if (compResult == -1) {
            ; ⚠ LOCAL VERSION IS OLDER (UPDATE AVAILABLE)
            linkCtrl.DownloadUrl := downloadUrl
            linkCtrl.AssetType := assetType
            linkCtrl.HtmlUrl := htmlUrl
            linkCtrl.Text := CurrentVersion " | Update Available ⚠"
        } 
        else {
            ; ✓ PERFECT MATCH
            linkCtrl.DownloadUrl := ""
            linkCtrl.AssetType := ""
            linkCtrl.HtmlUrl := htmlUrl
            linkCtrl.Text := CurrentVersion " | Up to Date ✓"
        }
        
    } catch {
        linkCtrl.DownloadUrl := ""
        linkCtrl.HtmlUrl := "https://github.com/" RepoOwner "/" RepoName "/releases"
        linkCtrl.Text := "Check Failed"
    }
}

; ── Smart Semantic Version Comparator Helper ──
CompareVersions(vLocal, vRemote) {
    ; Strip out letters/prefixes (e.g., "v1.0.1-beta" -> "1.0.1")
    cleanL := RegExReplace(vLocal, "[^\d.]")
    cleanR := RegExReplace(vRemote, "[^\d.]")
    
    aLocal  := StrSplit(cleanL, ".")
    aRemote := StrSplit(cleanR, ".")
    
    ; Loop through the longest section array length
    Loop Max(aLocal.Length, aRemote.Length) {
        nLocal  := (A_Index <= aLocal.Length  && aLocal[A_Index]  != "") ? Integer(aLocal[A_Index])  : 0
        nRemote := (A_Index <= aRemote.Length && aRemote[A_Index] != "") ? Integer(aRemote[A_Index]) : 0
        
        if (nLocal > nRemote)  
            return 1  ; Local is newer (Beta / Prerelease)
        if (nLocal < nRemote)  
            return -1 ; Local is older (Update available)
    }
    return 0 ; Versions match exactly
}

ProcessUpdate(url, assetType) {
    if (url == "") {
        MsgBox("Could not find the appropriate " assetType " asset in the latest GitHub release.", "Asset Missing", "Iconx")
        return
    }
    
    MsgBox("Downloading " assetType "... The application will restart automatically.", "Updating", "Iconi")
    
    try {
        scriptPath := A_ScriptFullPath
        workingDir := A_ScriptDir
        
        if (!A_IsCompiled) {
            ; --- ZIP UPDATE ROUTINE (.ahk script users) ---
            zipFile := workingDir "\update.tmp.zip"
            Download(url, zipFile)
            
            psCommand := 'Start-Sleep -s 2; '
                      . 'Expand-Archive -Path "' zipFile '" -DestinationPath "' workingDir '" -Force; '
                      . 'Remove-Item -Path "' zipFile '" -Force; '
                      . 'Start-Process "' workingDir '\' A_ScriptName '"'
            
            Run('powershell -NoProfile -WindowStyle Hidden -Command ' . psCommand, , "Hide")
        } 
        else {
            ; --- EXE UPDATE ROUTINE (.exe users) ---
            tempFile := scriptPath ".tmp"
            Download(url, tempFile)
            
            cmdCommand := A_ComSpec ' /c timeout /t 1 > nul & del "' scriptPath '" & move "' tempFile '" "' scriptPath '" & start "" "' scriptPath '"'
            
            Run(cmdCommand, , "Hide")
        }
        
        ExitApp()
        
    } catch Error as err {
        MsgBox("Update failed:`n" err.Message, "Update Error", "Iconx")
    }
}
