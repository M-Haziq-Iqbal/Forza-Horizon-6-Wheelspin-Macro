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

global p := GetPalette()

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
    global DarkMode, SpinGUI, MainGUI, p
    global ActiveMode, SkillPtsCount_In, SkillPtsWant_In, CarCount_In, LoopCount_In
    
    saved := [SkillPtsCount_In.Value, SkillPtsWant_In.Value, CarCount_In.Value, LoopCount_In.Value]

    if ActiveMode {
        ActiveMode  := ""
        MasterMode  := false
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
    p := GetPalette()
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
    ; Explicitly scoped globals for structural integrity and layout scaling
    Global MainGUI, TabControl, ThemeBtn, CustomMin, CustomX, StatusText, CustomCarToggle_UI
    Global SkillPtsCount_In, SkillPtsWant_In, LoopCount_In, CarCount_In
    Global CarSelect_UI, AddCarBtn, EditCarBtn, RadioRace, RadioBuy, RadioUnlock
    Global AllBtn, RaceBtn, BuyBtn, UnlockBtn, OpenSpinWindowBtn
    Global PointsLabel_UI, SectorLabel_UI, TimeLabel_UI, CarsLabel_UI
    Global RaceRunTime_UI, PointsCount_UI, SectorCount_UI, BuyRunTime_UI
    Global CarCount_UI, UnlockRunTime_UI, SWheelCount_UI, WheelCount_UI, CreditCount_UI
    Global Key_UI, Process_UI, TotalRunTime_UI, EventLabSelect_UI
    Global CodeTune_UI, CodeEventLab_UI, ToggleBtn, ResoSelect_UI
    Global BrowseBtn, LaunchBtn, SpecialKCheck_UI, UpdateLink
    Global ScaleX, ScaleY, DarkMode, ActiveMode, StartLoopMode
    Global CarList, SelectedCar, EventLabList, EventLab
    Global PointsGain, PointsTotal, TimeTotal, ResoList, SelectedReso
    Global GameExe

    ; 1. Environment & Theme Matrix Resolution
    global cStat      := ActiveMode ? p["accent"] : p["textDim"]
    global sLabel     := ActiveMode ? "⬤   Running..." : "⬤   Stopped"
    tabW       := Round(260 * ScaleX)

    ; 2. Frame Container Instantiation
    MainGUI := Gui("+AlwaysOnTop -MaximizeBox -DPIScale -Caption +Border", "MHI | FH6 MACRO")
    MainGUI.BackColor := p["bg"]

    ; 3. Structural Segment Compositions
    _AddHeader()
    
    ; Establish Tab Framework Control Engine
    TabControl := MainGUI.Add("Tab2", "x" Round(5*ScaleX) " y+15 w" tabW " +Buttons +0x400 c" p["accent"], ["📥 Inputs", "📊 Stats"])
    SendMessage(0x1329, 0, Floor((tabW - 12) / 2) | (Round(26 * ScaleY) << 16), TabControl)

    ; 1. RENDER TAB CONTENTS
    _AddInputTab(savedVals)
    _AddStatsTab()
    
    ; 2. DYNAMIC HEIGHT RESOLUTION ENGINE
    TabControl.UseTab(1)
    SpeedLabel_UI.GetPos(&InpX, &InpY, &InpW, &InpH)
    Tab1Bottom := InpY + InpH + Round(16 * ScaleY)

    TabControl.UseTab(2)
    CreditCount_UI.GetPos(&StX, &StY, &StW, &StH)
    Tab2Bottom := StY + StH + Round(16 * ScaleY)

    ; Compute the absolute maximum boundary point
    MaxTabHeight := Max(Tab1Bottom, Tab2Bottom)
    
    ; 3. COMPENSATE & VERTICALLY CENTER CONTENT IN TAB 2
    if (Tab1Bottom > Tab2Bottom) {
        VerticalOffset := (Tab1Bottom - Tab2Bottom) // 2
        StatsHeader_UI.Move(, StatsHeaderOrigY + VerticalOffset)
        _RepositionStatsControls(VerticalOffset)
    }

    TabControl.UseTab()

    ; 4. RENDER CONTEXTUAL FRAME DIVIDER ACCORDING TO MAX HEIGHT
    SetFixedFont(MainGUI, 9, "bold", "Semibold")
    MainGUI.Add("Text", "x" Round(14*ScaleX) " y" MaxTabHeight + Round(10*ScaleX) " w" Round(242*ScaleX) " h0 Center BackgroundTrans c" p["divider"], "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

    ; Build Shared Controls and Dashboard Panels
    _AddSharedDashboard(MaxTabHeight + 20)
    OptionsControls := _AddCollapsibleOptions()
    FooterControls  := _AddFooterLayout()

    ; 4. Native Layout Compilation & Collapsible Animation Offsets
    MainGUI.Show("w" Round(270*ScaleX) " Hide")
    ToggleBtn.GetPos(, &tY, , &tH)
    FooterControls[1].GetPos(, &fY)
    shiftY := fY - (tY + tH + Round(15*ScaleY))
    
    footerOrigY := []
    for ctrl in FooterControls {
        ctrl.GetPos(, &cY)
        footerOrigY.Push(cY)
    }

    MainGUI.GetPos(,, &w, &expandedH)
    compactH := expandedH - shiftY

    ; 5. Define Contextual Local Toggling Function
    _OnOptionsToggle(btnObj, *) {
        static isOpen := false
        isOpen := !isOpen
        for ctrl in OptionsControls
            ctrl.Visible := isOpen
        for i, ctrl in FooterControls
            ctrl.Move(, isOpen ? footerOrigY[i] : (footerOrigY[i] - shiftY))
        
        ; Adjust window bounds
        MainGUI.Move(,,, isOpen ? expandedH : compactH)
        
        ; Visual polish adjustments
        btnObj.Opt("Background" (isOpen ? p["activeBg"] : p["btnBg2"]))
        btnObj.Text := isOpen ? "⚙️   OPTIONS   ⏶" : "⚙️   OPTIONS   ⏷"
        
        btnObj.Redraw()
        MainGUI.Show()
    }
    
    ToggleBtn.OnEvent("Click", _OnOptionsToggle)
    for ctrl in OptionsControls
        ctrl.Visible := false
    for i, ctrl in FooterControls
        ctrl.Move(, footerOrigY[i] - shiftY)

    ; Window Runtime Assignments
    MainGUI.OnEvent("Close", (*) => ExitApp())
    MainGUI.OnEvent("Size", MainGUI_SizeChange)
    MainGUI.Move(MonLeft + MonWidth - w - Round(35*ScaleX), MonTop + Round(55*ScaleX), w, compactH)
    MainGUI.Show()
}

; ══════════════════════════════════════════════
;  UI STRUCTURAL SUB-COMPONENTS
; ══════════════════════════════════════════════

_AddHeader() {
    Global MainGUI, ThemeBtn, CustomMin, CustomX, StatusText, ScaleX, ScaleY, DarkMode
    Global Key_UI, Process_UI, TotalRunTime_UI
    
    SetFixedFont(MainGUI, 10, "norm")
    ThemeBtn := MainGUI.Add("Text", "x" Round(12*ScaleX) " y" Round(12*ScaleY) " w" Round(20*ScaleX) " h" Round(20*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" p["btnText2"], DarkMode ? "☀" : "🌙")
    ThemeBtn.OnEvent("Click", (*) => ToggleTheme())
    ThemeBtn.ToolTipText := "Toggle Dark/Light Mode"

    SetFixedFont(MainGUI, 10, "bold")
    CustomMin := MainGUI.Add("Text", "x" Round(225*ScaleX) " y" Round(12*ScaleY) " w" Round(16*ScaleX) " h" Round(16*ScaleY) " Center BackgroundTrans c" p["textDim"], "─")
    CustomMin.OnEvent("Click", (*) => WinMinimize(MainGUI.Hwnd))

    CustomX := MainGUI.Add("Text", "x" Round(245*ScaleX) " y" Round(12*ScaleY) " w" Round(16*ScaleX) " h" Round(16*ScaleY) " Center BackgroundTrans c" p["textDim"], "✕")
    CustomX.OnEvent("Click", (*) => ExitApp())

    SetFixedFont(MainGUI, 14, "bold", "Light")
    MainGUI.Add("Text", "x0 y" Round(30*ScaleY) " w" Round(270*ScaleX) " Center BackgroundTrans c" p["accent"], "WHEELSPIN MACRO")
    SetFixedFont(MainGUI, 7, "norm")
    MainGUI.Add("Text", "x0 y+" Round(1*ScaleY) " w" Round(270*ScaleX) " Center BackgroundTrans c" p["textDim"], "FORZA HORIZON 6   ✦   AFK FARM")

    SetFixedFont(MainGUI, 10, "bold", "Semibold")
    StatusText := MainGUI.Add("Text", "x0 y+" Round(10*ScaleY) " w" Round(270*ScaleX) " Center BackgroundTrans c" cStat, sLabel)

    ; Live Dashboard Info
    SetFixedFont(MainGUI, 9, "norm", "Light")
    TotalRunTime_UI := MainGUI.Add("Text", "x0 y+8 w" Round(270*ScaleX) " Center BackgroundTrans c" p["cIdle"], "⏱   00:00")
    Key_UI          := MainGUI.Add("Text", "x0 y+4 w" Round(270*ScaleX) " Center BackgroundTrans c" p["cIdle"], "⌨   [   ]")
    Process_UI      := MainGUI.Add("Text", "x0 y+4 w" Round(270*ScaleX) " Center BackgroundTrans c" p["cIdle"], "⚙️   Waiting...")
}

_AddInputTab(savedVals) {
    ; Explicitly scoped globals for structural integrity and layout scaling
    Global MainGUI, TabControl, SkillPtsCount_In, SkillPtsWant_In, LoopCount_In, CarCount_In, CustomCarToggle_UI
    Global SkillPtsCountText, SkillPtsWantText, LoopCountText, CarCountText
    Global CarSelect_UI, AddCarBtn, EditCarBtn, RadioRace, RadioBuy, RadioUnlock
    Global AllBtn, OpenSpinWindowBtn
    Global ScaleX, ScaleY, SkillPtsCount, SkillPtsWant, LoopCount, CarList, SelectedCar, StartLoopMode, UseCustomCarCount

    TabControl.UseTab(1)
    MainGUI.Add("Text", "x0 y+5 w" Round(270*ScaleX) " h5 BackgroundTrans c" p["footer"], "")

    SetFixedFont(MainGUI, 9, "norm", "Light")
    SkillPtsCount_In := MainGUI.Add("Edit", "x" Round(179*ScaleX) " y+5 w" Round(63*ScaleX) " h" Round(20*ScaleY) " -E0x200 Center Number Background" p["editBg"] " c" p["text"], savedVals ? savedVals[1] : SkillPtsCount)
    SkillPtsCountText := MainGUI.Add("Text", "x" Round(30*ScaleX) " yp+3 w" Round(155*ScaleX) " BackgroundTrans c" p["text"], "✦   Current Skill Points")

    SkillPtsWant_In := MainGUI.Add("Edit", "x" Round(179*ScaleX) " yp+26 w" Round(63*ScaleX) " h" Round(20*ScaleY) " -E0x200 Center Number Background" p["editBg"] " c" p["text"], savedVals ? savedVals[2] : SkillPtsWant)
    SkillPtsWantText := MainGUI.Add("Text", "x" Round(30*ScaleX) " yp+3 w" Round(155*ScaleX) " BackgroundTrans c" p["text"], "⟡   Desired Skill Points")

    LoopCount_In := MainGUI.Add("Edit", "x" Round(179*ScaleX) " yp+26 w" Round(63*ScaleX) " h" Round(20*ScaleY) " -E0x200 Center Number Background" p["editBg"] " c" p["text"], savedVals ? savedVals[4] : LoopCount)
    LoopCountText := MainGUI.Add("Text", "x" Round(30*ScaleX) " yp+3 w" Round(155*ScaleX) " BackgroundTrans c" p["text"], "⟡   Sequence Loop")

    CarCount_In := MainGUI.Add("Edit", "x" Round(179*ScaleX) " yp+26 w" Round(63*ScaleX) " h" Round(20*ScaleY) " -E0x200 Center Number Background" p["editBg"] " c" p["text"], savedVals ? savedVals[3] : CarsToTarget)
    CarCountText := MainGUI.Add("Text", "x" Round(30*ScaleX) " yp+3 w" Round(155*ScaleX) " BackgroundTrans c" p["text"], "⟡   Car Amount")

    SkillPtsCount_In.OnEvent("Change", (ctrl, *) => UpdateSkillPtsCountIn(ctrl))
    SkillPtsWant_In.OnEvent("Change", (ctrl, *) => UpdateSkillPtsWantIn(ctrl))
    LoopCount_In.OnEvent("Change", (ctrl, *) => UpdateLoopCount(ctrl))
    CarCount_In.OnEvent("Change", (ctrl, *) => UpdateCarCountIn(ctrl))

    ; --- Use Custom Car Values Toggle ---
    isCustomEnabled := CustomCarCount
    customColor := isCustomEnabled ? p["accent"] : p["textDim"]
    customText  := isCustomEnabled ? "▰  CUSTOM CAR VALUES: ON" : "▱  CUSTOM CAR VALUES: OFF"

    SetFixedFont(MainGUI, 8, "bold", "Semibold")
    CustomCarToggle_UI := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+12 w" Round(242*ScaleX) " h" Round(22*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" customColor, customText)
    CustomCarToggle_UI.ToolTipText := "Toggle between automatic calculation based on Skill Points or custom manual car counts."
    CustomCarToggle_UI.OnEvent("Click", CustomCarToggle_Click)

    ; Profile Database Dropdown
    SetFixedFont(MainGUI, 9, "bold")
    AddCarBtn := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+12 w" Round(25*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" p["btnText2"], "＋")
    AddCarBtn.OnEvent("Click", (*) => ShowCarEditorGUI("New"))
    AddCarBtn.ToolTipText := "Add Car Profile"

    CarSelect_UI := MainGUI.Add("Text", "x" Round(45*ScaleX) " yp w" Round(180*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["editBg"] " c" p["text"])
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

    EditCarBtn := MainGUI.Add("Text", "x" Round(231*ScaleX) " yp w" Round(25*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" p["btnText2"], "✎")
    EditCarBtn.OnEvent("Click", (*) => ShowCarEditorGUI("Edit"))
    EditCarBtn.ToolTipText := "Edit Car Profile"

    ; ══════════════════════════════════════════════
    ;  LOOP ENTRY POINT SELECTOR
    ; ══════════════════════════════════════════════
    SetFixedFont(MainGUI, 9, "bold", "Semibold")
    MainGUI.Add("Text", "x" Round(14*ScaleX) " y+5 w" Round(242*ScaleX) " Center BackgroundTrans c" p["divider"], "___________:━━━━━━━━━━━━━━━━:___________")

    SetFixedFont(MainGUI, 8, "bold", "Semibold")
    MainGUI.Add("Text", "x" Round(14*ScaleX) " y+5 w" Round(242*ScaleX) " c" p["textDim"] " Center", "LOOP ENTRY POINT")
    
    segW := Round(78 * ScaleX)
    segH := Round(24 * ScaleY)
    
    RadioRace   := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+6 w" segW " h" segH " Center 0x200 Background" p["btnBg2"] " c" p["text"], "🏁 RACE")
    RadioBuy    := MainGUI.Add("Text", "x+4 yp w" segW " h" segH " Center 0x200 Background" p["btnBg2"] " c" p["textDim"], "🚗 BUY")
    RadioUnlock := MainGUI.Add("Text", "x+4 yp w" segW " h" segH " Center 0x200 Background" p["btnBg2"] " c" p["textDim"], "🛞 UNLOCK")
    
    ; Power-user tooltips indicating the dual interaction options
    RadioRace.ToolTipText   := "Click to set sequence start point.`nCtrl + Click to execute Isolated RACE Mode."
    RadioBuy.ToolTipText    := "Click to set sequence start point.`nCtrl + Click to execute Isolated BUY Mode."
    RadioUnlock.ToolTipText := "Click to set sequence start point.`nCtrl + Click to execute Isolated UNLOCK Mode."

    RadioRace.OnEvent("Click",   (obj, *) => _HandleSegmentClick(obj, "Race"))
    RadioBuy.OnEvent("Click",    (obj, *) => _HandleSegmentClick(obj, "Buy"))
    RadioUnlock.OnEvent("Click", (obj, *) => _HandleSegmentClick(obj, "Unlock"))
    
    if (StartLoopMode == "Buy")
        _UpdateStartLoop(RadioBuy, "Buy")
    else if (StartLoopMode == "Unlock")
        _UpdateStartLoop(RadioUnlock, "Unlock")
    else
        _UpdateStartLoop(RadioRace, "Race")
    
    ; ══════════════════════════════════════════════
    ;  DYNAMIC MASTER TRIGGER ACTIONS
    ; ══════════════════════════════════════════════
    SetFixedFont(MainGUI, 9, "bold", "Semibold")
    AllBtn := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+12 w" Round(242*ScaleX) " h" Round(36*ScaleY) " Center 0x200 Background" p["btnMainBg"] " c" p["btnMainText"], "⟲     START FULL LOOP     /")

    MainGUI.Add("Text", "x" Round(14*ScaleX) " y+4 w" Round(242*ScaleX) " Center BackgroundTrans c" p["divider"], "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    OpenSpinWindowBtn := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+4 w" Round(242*ScaleX) " h" Round(32*ScaleY) " Center 0x200 Background" p["btnBg3"] " c" p["btnText3"], "🎰   OPEN SPIN INTERFACE")

    AddCustomSpeedSlider(MainGUI)

    AllBtn.OnEvent("Click", (*) => StartFullLoop())
    OpenSpinWindowBtn.OnEvent("Click", (*) => OpenSpinPanel())
}

; ══════════════════════════════════════════════
;  UNIFIED INTERCEPT ROUTER & STATE PIPELINE
; ══════════════════════════════════════════════
_HandleSegmentClick(clickedObj, modeName) {
    ; Check for alternative user execution logic via Ctrl Key tracking
    if GetKeyState("Ctrl", "P") {
        ; 1. Dynamically select/highlight the mode button and update the main button text first
        _UpdateStartLoop(clickedObj, modeName)
        
        ; 2. Fire the isolated notification and execute the script block
        ShowNotif("warning", "Isolated Task Triggered", "Running independent process: " StrUpper(modeName))
        
        switch modeName {
            case "Race":   StartRace()
            case "Buy":    StartBuy()
            case "Unlock": StartUnlock()
        }
        return
    }

    ; If standard click pattern verified, alter the loop tracking pipeline target context normally
    _UpdateStartLoop(clickedObj, modeName)
}

_AddStatsTab() {
    Global MainGUI, TabControl, PointsLabel_UI, SectorLabel_UI, TimeLabel_UI, CarsLabel_UI
    Global RaceRunTime_UI, PointsCount_UI, SectorCount_UI, BuyRunTime_UI, CarCount_UI
    Global UnlockRunTime_UI, SWheelCount_UI, WheelCount_UI, CreditCount_UI
    Global MainSpinRunTime_UI, MainSpinOpenCount_UI, MainSpinLeftCount_UI
    Global ScaleX, ScaleY, PointsGain, TimeTotal, CarsToTarget
    Global StatsHeader_UI, StatsHeaderOrigY, StatsControlsList := []

    TabControl.UseTab(2)
    SetFixedFont(MainGUI, 9, "bold")
    
    StatsHeaderOrigY := Round(175 * ScaleY)
    StatsHeader_UI   := MainGUI.Add("Text", "x" Round(14*ScaleX) " y" StatsHeaderOrigY " w" Round(242*ScaleX) " Center BackgroundTrans c" p["header"],  "TARGETS")
    
    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(14*ScaleX) " y+0 w" Round(242*ScaleX) " Center BackgroundTrans c" p["divider"], "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))

    SectorCountEst := Ceil(PointsGain / EventLabData[EventLab].AveragePoints)
    TimeTotalText  := Format("{:02}:{:02}", Floor(TimeTotal), Round((TimeTotal - Floor(TimeTotal)) * 60))

    SetFixedFont(MainGUI, 9, "norm", "Light")
    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+6 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "⟡   Est. Points Gain"))
    StatsControlsList.Push(PointsLabel_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), PointsGain))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+4 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "⟡   Est. Sectors"))
    StatsControlsList.Push(SectorLabel_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), SectorCountEst))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+4 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "⟡   Est. Total Time"))
    StatsControlsList.Push(TimeLabel_UI   := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), TimeTotalText))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+4 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "⟡   Recommended Car"))
    StatsControlsList.Push(CarsLabel_UI   := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), CarsToTarget))

    ; Live Engine Metrics Panel
    SetFixedFont(MainGUI, 9, "bold")
    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(14*ScaleX) " y+18 w" Round(242*ScaleX) " Center BackgroundTrans c" p["header"],  "LIVE TELEMETRY"))
    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(14*ScaleX) " y+0 w" Round(242*ScaleX) " Center BackgroundTrans c" p["divider"], "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))

    SetFixedFont(MainGUI, 9, "norm", "Light")
    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+6 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🕓   Race Runtime"))
    StatsControlsList.Push(RaceRunTime_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "00:00"))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+4 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "💎   Points Gained"))
    StatsControlsList.Push(PointsCount_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["accent"]), "0"))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+4 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🏁   Sectors Cleared"))
    StatsControlsList.Push(SectorCount_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "0"))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+12 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🕓   Buy Runtime"))
    StatsControlsList.Push(BuyRunTime_UI  := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "00:00"))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+4 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "📦   Cars Purchased"))
    StatsControlsList.Push(CarCount_UI    := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "0"))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+12 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🕓   Unlock Runtime"))
    StatsControlsList.Push(UnlockRunTime_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "00:00"))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+4 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🌟   Super Wheelspins"))
    StatsControlsList.Push(SWheelCount_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["accent"]), "0"))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+4 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🛞   Regular Wheelspins"))
    StatsControlsList.Push(WheelCount_UI  := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["accent"]), "0"))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+4 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "💲   Credits Earned"))
    StatsControlsList.Push(CreditCount_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["accent"]), "0 CR"))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+12 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🕓   Spin Runtime"))
    StatsControlsList.Push(MainSpinRunTime_UI   := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "00:00"))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+4 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🎊   Spins Opened"))
    StatsControlsList.Push(MainSpinOpenCount_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "0"))

    StatsControlsList.Push(MainGUI.Add("Text", "x" Round(22*ScaleX) " y+4 w" Round(140*ScaleX) " Left BackgroundTrans c" p["textDim"], "🎁   Spins Remaining"))
    StatsControlsList.Push(MainSpinLeftCount_UI := _LinkNoirTelemetry(MainGUI.Add("Text", "x" Round(162*ScaleX) " yp w" Round(86*ScaleX) " Right BackgroundTrans c" p["text"]), "0"))
}

_AddSharedDashboard(DividerYPosition) {
    Global MainGUI, ToggleBtn, ScaleX, ScaleY

    SetFixedFont(MainGUI, 8, "bold", "Semibold")
    ToggleBtn := MainGUI.Add("Text", "x" Round(65*ScaleX) " y+16 w" Round(140*ScaleX) " h" Round(24*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" p["btnText"], "⚙️   OPTIONS   ⏷")
}

_RepositionStatsControls(yOffset) {
    global StatsControlsList
    for ctrl in StatsControlsList {
        ctrl.GetPos(&cX, &cY)
        ctrl.Move(, cY + yOffset)
    }
}

_AddCollapsibleOptions() {
    Global MainGUI, ResoSelect_UI, BrowseBtn, LaunchBtn, SpecialKCheck_UI, ScaleX, ScaleY, ResoList, SelectedReso, GameExe
    Global EventLabSelect_UI, CodeTune_UI, CodeEventLab_UI, EventLabList, EventLab, SearchByCode
    
    ControlsArray := []
    margin       := Round(14 * ScaleX)
    fullWidth    := Round(242 * ScaleX)
    halfWidth    := Round(119 * ScaleX)
    btnHeight    := Round(26 * ScaleY)

    ; ── PROFILE ──────────────────────────────────────────
    SetFixedFont(MainGUI, 8, "bold", "Semibold")
    ControlsArray.Push(MainGUI.Add("Text", "x" margin " y+14 w" fullWidth " Center BackgroundTrans c" p["textDim"], "FARM PROFILE"))
    
    SetFixedFont(MainGUI, 9, "bold")
    ControlsArray.Push(EventLabSelect_UI := MainGUI.Add("Text", "x" margin " y+6 w" fullWidth " h" Round(24*ScaleY) " Center 0x200 Background" p["editBg"] " c" p["text"]))

    ; Define properties for the moved control
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

    SetFixedFont(MainGUI, 8, "bold")
    ControlsArray.Push(CodeTune_UI     := MainGUI.Add("Text", "x" margin " y+4 w" halfWidth " h" Round(24*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" p["btnText2"], "📋 TUNE CODE"))
    ControlsArray.Push(CodeEventLab_UI := MainGUI.Add("Text", "x+4 yp w" halfWidth " h" Round(24*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" p["btnText2"], "📋 RACE CODE"))
    
    CodeTune_UI.OnEvent("Click", (*) => _CopyToClip(EventLabData[EventLab].CodeTune, "Subaru 22B Tune Code"))
    CodeEventLab_UI.OnEvent("Click", (*) => _CopyToClip(EventLabData[EventLab].CodeEvent, "EventLab Race Code"))

    ; ── SEARCH/SELECT CHALLENGE ─────────────────────────────────────────────
    SetFixedFont(MainGUI, 8, "norm")
    isSearchByCode := (SearchByCode = "1")
    SearchColor := SearchByCode ? p["accent"] : p["textDim"]
    SearchText  := SearchByCode ? "▰  SEARCH BY CODE" : "▱  SELECT BY CREATOR"

    SetFixedFont(MainGUI, 9, "bold", "Semibold")
    SearchByCode_UI := MainGUI.Add("Text", "x" margin " y+6 w" fullWidth " h" Round(22*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" SearchColor, SearchText)
    SearchByCode_UI.State := isSearchByCode
    ControlsArray.Push(SearchByCode_UI)
    
    SearchByCode_UI.OnEvent("Click", SearchToggle)

    SearchToggle(ctrl, *) {
        global NotifEnabled, p, SearchByCode

        ctrl.State := !ctrl.State
        SearchByCode := ctrl.State
        WriteMacroIni("Settings", "SearchByCode", SearchByCode)

        if (ctrl.State) {
            ctrl.Opt("c" p["accent"])
            ctrl.Text := "▰  SEARCH BY CODE"
            ctrl.Redraw()
        } else {
            ctrl.Opt("c" p["textDim"])
            ctrl.Text := "▱  SELECT BY CREATOR"
            ctrl.Redraw()
        }
    }

    ; ── RESOLUTION SELECTOR ───────────────────────────────────────────────────
    SetFixedFont(MainGUI, 8, "bold", "Semibold")
    ControlsArray.Push(MainGUI.Add("Text", "x" margin " y+14 w" fullWidth " Center BackgroundTrans c" p["textDim"], "GAME CLIENT RESOLUTION"))

    SetFixedFont(MainGUI, 9, "bold")
    ControlsArray.Push(ResoSelect_UI := MainGUI.Add("Text", "x" margin " y+6 w" fullWidth " h" Round(24*ScaleY) " Center 0x200 Background" p["editBg"] " c" p["text"]))
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
    ResoSelect_UI.ToolTipText := "Game Client Resolution"

    ; ──  NOTIFICATION PANEL ─────────────────────────────────────────────   
    SetFixedFont(MainGUI, 8, "bold", "Semibold")
    ControlsArray.Push(MainGUI.Add("Text", "x" margin " y+12 w" fullWidth " Center BackgroundTrans c" p["textDim"], "NOTIFICATION"))

    ; ── DESKTOP NOTIFICATION PANEL ─────────────────────────────────────────────
    SetFixedFont(MainGUI, 8, "norm")
    isNotifEnabled := (NotifEnabled = "1")
    notifColor := NotifEnabled ? p["accent"] : p["textDim"]
    notifText  := NotifEnabled ? "▰  DESKTOP" : "▱  DESKTOP"

    SetFixedFont(MainGUI, 9, "bold", "Semibold")
    NotifCheck_UI := MainGUI.Add("Text", "x" margin " y+6 w" halfWidth " h" Round(22*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" notifColor, notifText)
    NotifCheck_UI.State := isNotifEnabled
    ControlsArray.Push(NotifCheck_UI)
    
    NotifCheck_UI.OnEvent("Click", NotifToggle)

    NotifToggle(ctrl, *) {
        global NotifEnabled, p

        ctrl.State := !ctrl.State
        NotifEnabled := ctrl.State
        WriteMacroIni("Settings", "NotifEnabled", NotifEnabled)

        if (ctrl.State) {
            ctrl.Opt("c" p["accent"])
            ctrl.Text := "▰  DESKTOP"
            ctrl.Redraw()
        } else {
            ctrl.Opt("c" p["textDim"])
            ctrl.Text := "▱  DESKTOP"
            ctrl.Redraw()
        }
    }

    ; ── DISCORD NOTIFICATION PANEL ─────────────────────────────────────────────
    SetFixedFont(MainGUI, 8, "norm")
    isDiscordEnabled := (DiscordEnabled = "1")
    discordColor := isDiscordEnabled ? p["accent"] : p["textDim"]
    discordText  := isDiscordEnabled ? "▰  DISCORD" : "▱  DISCORD"

    SetFixedFont(MainGUI, 9, "bold", "Semibold")
    DiscordCheck_UI := MainGUI.Add("Text", "x+4 yp w" halfWidth " h" Round(22*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" discordColor, discordText)
    DiscordCheck_UI.State := isDiscordEnabled
    DiscordCheck_UI.ToolTipText := "Ctrl + Click to configure Webhook URL"
    ControlsArray.Push(DiscordCheck_UI)
    
    DiscordCheck_UI.OnEvent("Click", DiscordToggle)

    ; ── OTHERS PANEL ─────────────────────────────────────────────   
    SetFixedFont(MainGUI, 8, "bold", "Semibold")
    ControlsArray.Push(MainGUI.Add("Text", "x" margin " y+12 w" fullWidth " Center BackgroundTrans c" p["textDim"], "OTHERS"))

    ; ── GAME DIRECTORY UTILITIES ─────────────────────────
    SetFixedFont(MainGUI, 8, "bold", "Semibold")
    ControlsArray.Push(BrowseBtn := MainGUI.Add("Text", "x" margin " y+10 w" halfWidth " h" btnHeight " Center 0x200 Background" p["btnBg2"] " c" p["btnText"], "📂  SET PATH"))
    BrowseBtn.OnEvent("Click", (*) => LocateGameDir(true))

    ControlsArray.Push(LaunchBtn := MainGUI.Add("Text", "x+4 yp w" halfWidth " h" btnHeight " Center 0x200 Background" p["btnBg2"] " c" p["btnText"], "🚀  LAUNCH"))
    LaunchBtn.OnEvent("Click", LaunchGame)

    ; ── SPECIAL K ENGINE INTEGRATION ──────────────────────────────────────────
    isKEnabled := SpecialKCheck()
    isGameRunning := ProcessExist(GameExe)
    initColor := isGameRunning ? p["textDim"] : (isKEnabled ? p["accent"] : p["textDim"])
    initText  := isGameRunning ? "🔒  SPECIAL K (GAME RUNNING)" : (isKEnabled ? "▰  SPECIAL K: ACTIVE" : "▱  SPECIAL K: INACTIVE")

    SetFixedFont(MainGUI, 9, "bold", "Semibold")
    SpecialKCheck_UI := MainGUI.Add("Text", "x" margin " y+10 w" fullWidth " h" Round(22*ScaleY) " Center 0x200 Background" p["btnBg2"] " c" initColor, initText)
    SpecialKCheck_UI.State := isKEnabled
    ControlsArray.Push(SpecialKCheck_UI)
    SpecialKCheck_UI.OnEvent("Click", SpecialKToggle)

    return ControlsArray
}

_AddFooterLayout() {
    Global MainGUI, UpdateLink, ScaleX, ScaleY
    
    ControlsArray := []
    ControlsArray.Push(F_Divider := MainGUI.Add("Text", "x" Round(14*ScaleX) " y+6 w" Round(242*ScaleX) " h" Round(1*ScaleY) " BackgroundTrans", ""))

    tempImagePath := A_Temp "\fh6_kofi_fallback.png"
    try {
        FileInstall("assets\kofi.png", tempImagePath, 1)
        Kofi_UI := MainGUI.Add("Picture", "x" Round(72*ScaleX) " yp+0 w" Round(125*ScaleX) " h" Round(25*ScaleY), tempImagePath)
    } catch {
        Kofi_UI := MainGUI.Add("Text", "x" Round(72*ScaleX) " yp+0 w" Round(125*ScaleX) " h" Round(25*ScaleY) " cBlue", "[ Support on Ko-fi ]")
    }
    ControlsArray.Push(Kofi_UI)
    Kofi_UI.OnEvent("Click", (*) => Run("https://ko-fi.com/mhaziqiqbal"))

    SetFixedFont(MainGUI, 8, "norm")
    UpdateLink := MainGUI.Add("Text", "x" Round(60*ScaleX) " y+6 w" Round(150*ScaleX) " Center c" p["btnText2"], "Checking status...")
    ControlsArray.Push(UpdateLink)
    UpdateLink.OnEvent("Click", (ctrlObj, *) => (ctrlObj.HasProp("DownloadUrl") && ctrlObj.DownloadUrl != "") ? ProcessUpdate(ctrlObj.DownloadUrl, ctrlObj.AssetType) : Run(ctrlObj.HtmlUrl))
    CheckForUpdates(UpdateLink)

    BottomSpacer := MainGUI.Add("Text", "x0 yp+25 w" Round(270*ScaleX) " h" Round(1*ScaleY) " BackgroundTrans c" p["footer"], "")
    ControlsArray.Push(BottomSpacer)

    return ControlsArray
}

AddCustomSpeedSlider(parentGui) {
    global SliderCfg, SliderKnob, SliderTrack, SpeedLabel_UI, DelaySlider_UI
    global ScaleX, ScaleY, KeyMultiplier, Multipliers

    SliderCfg := {
        TrackX: Round(45 * ScaleX),
        TrackW: Round(180 * ScaleX),
        TrackH: Round(4 * ScaleY),
        KnobW:  Round(10 * ScaleX),
        KnobH:  Round(16 * ScaleY),
        MinVal: 1,
        MaxVal: Multipliers.Length
    }

    SetFixedFont(parentGui, 9, "norm")
    SpeedLabel_UI := parentGui.Add("Text", "x0 y+20 w" Round(270*ScaleX) " Center c" p["text"], "Key Delay Multiplier: " KeyMultiplier "x")
    
    DelaySliderIndex := 4
    for index, name in Multipliers {
        if (name == KeyMultiplier) {
            DelaySliderIndex := index
            break
        }
    }
    DelaySlider_UI := {Value: DelaySliderIndex}
    
    SpeedLabel_UI.GetPos(, &labelY, , &labelH)
    SliderCfg.TrackY := labelY + labelH + Round(12*ScaleY)

    knobY := SliderCfg.TrackY - (SliderCfg.KnobH // 2) + (SliderCfg.TrackH // 2)
    minX  := SliderCfg.TrackX - (SliderCfg.KnobW // 2)
    maxX  := SliderCfg.TrackX + SliderCfg.TrackW - (SliderCfg.KnobW // 2)
    startProgress := (DelaySlider_UI.Value - SliderCfg.MinVal) / (SliderCfg.MaxVal - SliderCfg.MinVal)
    startKnobX     := minX + (startProgress * (maxX - minX))

    SetFixedFont(parentGui, 7, "norm") 
    parentGui.Add("Text", "x" Round(22*ScaleX) " y" (SliderCfg.TrackY - Round(12*ScaleY)) " w" Round(12*ScaleX) " Center BackgroundTrans c" p["textDim"], "1")
    parentGui.Add("Text", "x" Round(22*ScaleX) " y" (SliderCfg.TrackY - Round(6*ScaleY))  " w" Round(12*ScaleX) " Center BackgroundTrans c" p["textDim"], "─")
    parentGui.Add("Text", "x" Round(22*ScaleX) " y" SliderCfg.TrackY " w" Round(12*ScaleX) " Center BackgroundTrans c" p["textDim"], "4")
    
    SetFixedFont(parentGui, 8, "norm") 
    parentGui.Add("Text", "x" Round(35*ScaleX) " y" (SliderCfg.TrackY - Round(6*ScaleY))  " w" Round(10*ScaleX) " Left BackgroundTrans c" p["textDim"], "x")
    
    SliderTrack := parentGui.Add("Text", "x" SliderCfg.TrackX " y" SliderCfg.TrackY " w" SliderCfg.TrackW " h" SliderCfg.TrackH " +0x100 Background" p["divider"])
    SliderKnob  := parentGui.Add("Text", "x" startKnobX " y" knobY " w" SliderCfg.KnobW " h" SliderCfg.KnobH " +0x100 Background" p["accent"])
    parentGui.Add("Text", "x" Round(230*ScaleX) " y" (SliderCfg.TrackY - Round(6*ScaleY)) " w" Round(25*ScaleX) " Left c" p["textDim"], "4x")
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

ShowEventLabMenu(ctrl, *) {
    global EventLabList
    EventLabMenu := Menu()
    for index, EventLabName in EventLabList {
        EventLabMenu.Add(EventLabName, MenuSelectEventLab.Bind(index))
    }
    EventLabMenu.Show()
}

ShowResoMenu(ctrl, *) {
    global ResoList
    resoMenu := Menu()
    for index, resoNum in ResoList {
        resoMenu.Add(resoNum, MenuSelectReso.Bind(index))
    }
    resoMenu.Show()
}

MenuSelectCar(index, *) {
    global CarSelect_UI
    CarSelect_UI.Value := index 
    try UpdateCar(CarSelect_UI, "")
}

MenuSelectEventLab(index, *) {
    global EventLabSelect_UI
    EventLabSelect_UI.Value := index 
    try UpdateEventLab(EventLabSelect_UI, "")
}

MenuSelectReso(index, *) {
    global ResoSelect_UI
    ResoSelect_UI.Value := index 
    try UpdateReso(ResoSelect_UI, "")
}

; ══════════════════════════════════════════════
;  UPDATE SYSTEM VALUE
; ══════════════════════════════════════════════
UpdateSystemState(countInput := "", wantInput := "") {
    ; --- Writeable Globals ---
    global SkillPtsCount := (countInput !== "") ? countInput : SkillPtsCount
    global SkillPtsWant  := (wantInput !== "")  ? wantInput  : SkillPtsWant
    global PointsGain, PointsTotal, CarsToTarget, CarsToBuy, CarsToUnlock, TimeTotal
    
    ; --- Readable Globals ---
    global CustomCarCount
    global CarData, SelectedCar, EventLabData, EventLab, StartLoopMode
    global PointsLabel_UI, SectorLabel_UI, CarCount_In, CarsLabel_UI, TimeLabel_UI
    global SkillPtsCount_In, SkillPtsWant_In
    
    car := CarData[SelectedCar]
    event := EventLabData[EventLab]

    ; 1. Calculate Skill Point variables
    PointsGain  := GetMinScore(SkillPtsWant)
    PointsTotal := Min(PointsGain + SkillPtsCount, 999)

    ; 2. Calculate Car Target quantities
    CarsToTarget := Floor(PointsTotal / car.SkillPtsCost)
    CarsActual   := Floor(SkillPtsCount / car.SkillPtsCost)

    if (!CustomCarCount) {
        CarsToBuy    := CarsActual
        CarsToUnlock := CarsActual
    } else {
        ; Use custom value if > 0, otherwise fallback to what the user can currently afford
        CarsToBuy    := (CarsToBuy > 0) ? CarsToBuy : CarsActual
        CarsToUnlock := (CarsToUnlock > 0) ? CarsToUnlock : CarsActual
    }

    ; 3. Calculate Time Requirements
    TimeTotal := CalcTotalTime(PointsGain, CarsToTarget)
    
    TotalSubUnits := Round(TimeTotal * 60)
    MainUnit      := Floor(TotalSubUnits / 60)
    SubUnit       := Mod(TotalSubUnits, 60)

    ; 4. Push updates to the UI
    PointsLabel_UI.Value := PointsGain
    SectorLabel_UI.Value := Ceil(PointsGain / event.AveragePoints)
    CarsLabel_UI.Value   := CarsToTarget
    TimeLabel_UI.Value   := Format("{:02}:{:02}", MainUnit, SubUnit)

    ; 5. Apply target values or active custom profiles to the UI edit box
    UpdateCarInputState()
}

UpdateCarInputState() {
    global CustomCarCount, StartLoopMode, CarCount_In, CarsToTarget, CarsToBuy, CarsToUnlock

    if (!CustomCarCount) {
        if (StartLoopMode == "Buy") {
            CarCount_In.Value := CarsToBuy
        } else if (StartLoopMode == "Unlock") {
            CarCount_In.Value := CarsToUnlock
        } else {
            ; Fallback for Race/Full modes
            CarCount_In.Value := CarsToTarget 
        }
    } else {
        ; Mode ON: Display the specific target based on the selected loop entry
        if (StartLoopMode == "Buy") {
            CarCount_In.Value := CarsToBuy
        } else if (StartLoopMode == "Unlock") {
            CarCount_In.Value := CarsToUnlock
        } else {
            ; Fallback for Race/Full modes
            CarCount_In.Value := CarsToTarget 
        }
    }
}

; ══════════════════════════════════════════════
;  UPDATE INPUT VALUE
; ══════════════════════════════════════════════
UpdateSkillPtsCountIn(ctrl) {
    global SkillPtsWant_In, MaxPoints, CustomSkillPts
    global SkillPtsCountText, SkillPtsWantText

    ShowNotif(
        "info", "Current Skill Points Input", 
        "Mode: Automatic Desired Skill Points." 
        "`nPlease edit Desired Skill Points to revert."
    )
    SkillPtsCountText.Value := "✦   Current Skill Points"
    SkillPtsWantText.Value := "⟡   Desired Skill Points"

    value := ctrl.Value
    value := (value = "") ? 0 : Min(999, value)

    if !(ctrl.Value == String(value)) {
        ctrl.Value := value
        len := StrLen(String(value))
        SendMessage(0xB1, len, len, ctrl.Hwnd)
    }

    newWant := (999 - value > MaxPoints) ? MaxPoints : 999 - value
    SkillPtsWant_In.Value := newWant
    
    CustomSkillPts := 0 
    UpdateSystemState(value, newWant)

    return value
}

UpdateSkillPtsWantIn(ctrl) {
    global SkillPtsCount_In, MaxPoints, CustomSkillPts

    ShowNotif(
        "info", "Desired Skill Points Input", 
        "Mode: Custom Desired Skill Points." 
        "`nPlease edit Current Skill Points to revert."
    )
    SkillPtsCountText.Value := "⟡   Current Skill Points"
    SkillPtsWantText.Value := "✦   Desired Skill Points"

    currentCount := (SkillPtsCount_In.Value = "") ? 0 : SkillPtsCount_In.Value

    value := ctrl.Value
    value := (value = "") ? 0 : value
    value := Min(value, 999 - currentCount)
    value := Min(value, MaxPoints)

    if !(ctrl.Value == String(value)) {
        ctrl.Value := value
        len := StrLen(String(value))
        SendMessage(0xB1, len, len, ctrl.Hwnd)
    }

    CustomSkillPts := value
    UpdateSystemState(currentCount, value)

    return value
}

UpdateCarCountIn(ctrl, *) {
    global CustomCarCount, StartLoopMode, CarsToBuy, CarsToUnlock, CarsToTarget

    ; If custom mode is off, forcefully snap the value back to target if the user tries to type
    if (!CustomCarCount) {
        if (ctrl.Value != String(CarsToTarget))
            ctrl.Value := CarsToTarget
        return
    }

    ; Sanitize and parse the input
    value := (ctrl.Value = "" || ctrl.Value < 0) ? 0 : Integer(ctrl.Value)
    
    ; [IMPROVED] Safely assign values to their respective variables without cross-contamination
    if (StartLoopMode == "Buy") {
        value := Min(value, 999) ; Hard cap for buying
        CarsToBuy := value
        CarsToUnlock := Min(value, CarsToTarget)
    } else if (StartLoopMode == "Unlock") {
        value := Min(value, CarsToTarget) ; Cannot unlock more cars than targeted/owned
        CarsToUnlock := value
    }

    ; Update UI and handle caret positioning cleanly
    if (ctrl.Value != String(value)) {
        ctrl.Value := value
        len := StrLen(String(value))
        SendMessage(0xB1, len, len, ctrl.Hwnd)
    }
}

UpdateLoopCount(ctrl, *) {
    value := ctrl.Value
    value := (value = "") ? 0 : Min(value, 999)

    if !(ctrl.Value == String(value)) {
        ctrl.Value := value
        len := StrLen(String(value))
        SendMessage(0xB1, len, len, ctrl.Hwnd)
    }
}

_UpdateStartLoop(clickedObj, modeName) {
    Global StartLoopMode := modeName
    global CustomCarCount, SkillPtsCount_In, SkillPtsWant_In, CarCount_In, CarCountText, AllBtn
    
    RadioRace.Opt("Background" p["btnBg2"] " c" p["textDim"])
    RadioBuy.Opt("Background" p["btnBg2"] " c" p["textDim"])
    RadioUnlock.Opt("Background" p["btnBg2"] " c" p["textDim"])
    
    clickedObj.Opt("Background" p["btnMainBg"] " c" p["btnMainText"])
    RadioRace.Redraw(), RadioBuy.Redraw(), RadioUnlock.Redraw()

    ; Dynamically adapt the Primary Master Button action text string (Slashes Removed)
    if IsSet(AllBtn) && AllBtn {
        switch modeName {
            case "Race":   AllBtn.Text := "⟲     START FULL LOOP"
            case "Buy":    AllBtn.Text := "▶     START FROM BUY"
            case "Unlock": AllBtn.Text := "▶     START FROM UNLOCK"
        }
        AllBtn.Redraw()
    }

    ; --- Dynamic Input Toggling based on Custom Toggle State ---
    if (modeName == "Race" || modeName == "Full" || !CustomCarCount) {
        CarCount_In.Enabled := false
        CarCountText.Value := "⟡   Targeted Cars" 
    } 
    else if ((modeName == "Buy" || modeName == "Unlock") && CustomCarCount) {
        CarCount_In.Enabled := true
        CarCountText.Value := (modeName == "Buy") ? "▰   Cars to Buy" : "▰   Cars to Unlock"
    }

    WriteMacroIni("Settings", "StartLoopMode", StartLoopMode)
    UpdateCarInputState()
}

CustomCarToggle_Click(ctrl, *) {
    global CustomCarCount, p, StartLoopMode, RadioRace, RadioBuy, RadioUnlock
    
    CustomCarCount := !CustomCarCount
    WriteMacroIni("Settings", "CustomCarCount", CustomCarCount)
    
    ; FIXED: Check the actual boolean toggle variable instead of the numeric count
    if (CustomCarCount) {
        ctrl.Opt("c" p["accent"])
        ctrl.Text := "▰  CUSTOM CAR VALUES: ON"
        ShowNotif("info", "Custom Car Mode", "You can now manually set the car targets.")
    } else {
        ctrl.Opt("c" p["textDim"])
        ctrl.Text := "▱  CUSTOM CAR VALUES: OFF"
        ShowNotif("info", "Auto Car Mode", "Car targets will be auto-calculated from Skill Points.")
    }
    ctrl.Redraw()
    
    activeRadio := (StartLoopMode == "Buy") ? RadioBuy : (StartLoopMode == "Unlock" ? RadioUnlock : RadioRace)
    _UpdateStartLoop(activeRadio, StartLoopMode)
}

; ══════════════════════════════════════════════
;  UPDATE DROPDOWN VALUE
; ══════════════════════════════════════════════
UpdateCar(ctrl, *) {
    global SelectedCar

    SelectedCar := ctrl.Text
    WriteMacroIni("Settings", "Car", SelectedCar)

    UpdateSystemState()
}

UpdateEventLab(ctrl, *) {
    global EventLab

    EventLab := ctrl.Text
    WriteMacroIni("Settings", "EventLab", EventLab)

    UpdateSystemState()
}

UpdateReso(ctrl, *) {
    global SelectedReso

    SelectedReso := ctrl.Text
    WriteMacroIni("Settings", "Resolution", SelectedReso)
}

; ==========================================
; VERSION UPDATE
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

        compResult := CompareVersions(CurrentVersion, latestVersion)

        if (compResult == 1) {
            linkCtrl.DownloadUrl := ""
            linkCtrl.AssetType := ""
            linkCtrl.HtmlUrl := htmlUrl
            linkCtrl.Text := CurrentVersion " | Beta Build 🧪"
            linkCtrl.ToolTipText := "Click to open Github Release"
        } 
        else if (compResult == -1) {
            linkCtrl.DownloadUrl := downloadUrl
            linkCtrl.AssetType := assetType
            linkCtrl.HtmlUrl := htmlUrl
            linkCtrl.Text := CurrentVersion " | Update Available ⚠"
            linkCtrl.ToolTipText := "Click to Update"
        } 
        else {
            linkCtrl.DownloadUrl := ""
            linkCtrl.AssetType := ""
            linkCtrl.HtmlUrl := htmlUrl
            linkCtrl.Text := CurrentVersion " | Up to Date ✓"
            linkCtrl.ToolTipText := "Click to open Github Release"
        }
        
    } catch {
        linkCtrl.DownloadUrl := ""
        linkCtrl.HtmlUrl := "https://github.com/" RepoOwner "/" RepoName "/releases"
        linkCtrl.Text := CurrentVersion " | Check Failed"
    }
}

CompareVersions(vLocal, vRemote) {
    cleanL := RegExReplace(vLocal, "[^\d.]")
    cleanR := RegExReplace(vRemote, "[^\d.]")
    
    aLocal  := StrSplit(cleanL, ".")
    aRemote := StrSplit(cleanR, ".")
    
    Loop Max(aLocal.Length, aRemote.Length) {
        nLocal  := (A_Index <= aLocal.Length  && aLocal[A_Index]  != "") ? Integer(aLocal[A_Index])  : 0
        nRemote := (A_Index <= aRemote.Length && aRemote[A_Index] != "") ? Integer(aRemote[A_Index]) : 0
        
        if (nLocal > nRemote)  
            return 1
        if (nLocal < nRemote)  
            return -1
    }
    return 0
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
            zipFile := workingDir "\update.tmp.zip"
            Download(url, zipFile)
            
            psCommand := 'Start-Sleep -s 2; '
                      . 'Expand-Archive -Path "' zipFile '" -DestinationPath "' workingDir '" -Force; '
                      . 'Remove-Item -Path "' zipFile '" -Force; '
                      . 'Start-Process "' workingDir '\' A_ScriptName '"'
            
            Run('powershell -NoProfile -WindowStyle Hidden -Command ' . psCommand, , "Hide")
        } 
        else {
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

; ══════════════════════════════════════════════
;  MOUSE HOVER CURSOR CONTROLLER
; ══════════════════════════════════════════════
OnMessage(0x0020, WM_SETCURSOR)

WM_SETCURSOR(wParam, lParam, msg, hwnd) {
    if ((lParam & 0xFFFF) == 1) { 
        try {
            ctrlClass := ControlGetClassNN(wParam)
            
            if InStr(ctrlClass, "SysTabControl32") {
                charHand := DllCall("LoadCursor", "Ptr", 0, "Ptr", 32649, "Ptr")
                DllCall("SetCursor", "Ptr", charHand)
                return true
            }
            else if InStr(ctrlClass, "Static") {
                ctrlText := ControlGetText(wParam)
                
                if (InStr(ctrlText, "━━━━") || InStr(ctrlText, "Forza Horizon"))
                    return
                    
                if (ctrlText == "") {
                    try {
                        if (wParam != SliderTrack.Hwnd && wParam != SliderKnob.Hwnd)
                            return 
                    } catch {
                        return
                    }
                }

                charHand := DllCall("LoadCursor", "Ptr", 0, "Ptr", 32649, "Ptr")
                DllCall("SetCursor", "Ptr", charHand)
                return true 
            }
        }
    }
}

OnMessage(0x0200, WM_MOUSEMOVE)

WM_MOUSEMOVE(wParam, lParam, msg, hwnd) {
    static lastHwnd := 0
    
    MouseGetPos , , , &ctrlHwnd, 2
    
    if (ctrlHwnd == lastHwnd)
        return
        
    lastHwnd := ctrlHwnd
    ToolTip()
    
    if (ctrlHwnd) {
        try {
            ctrlObj := GuiCtrlFromHwnd(ctrlHwnd)
            if (ctrlObj && ctrlObj.HasOwnProp("ToolTipText")) {
                ToolTip(ctrlObj.ToolTipText)
                SetTimer(() => ToolTip(), -3000)
            }
        }
    }
}