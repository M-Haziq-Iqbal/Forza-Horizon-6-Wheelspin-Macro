; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║        Cyber Noir Edition v1.7.0        ║
; ╚═════════════════════════════════════════╝

; ══════════════════════════════════════════════
;  RESOLUTION-RELATIVE MATRIX CONFIGURATION
; ══════════════════════════════════════════════
Global MiniGui             := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale")
Global p                   := GetPalette()
Global RestoreBtn, PauseBtn, StopBtn
Global RaceControls := [], BuyControls := [], UnlockControls := []

; 1. Fetch target game monitor dimensions in raw physical pixels
gameMonitorIndex := GetGameMonitor()
MonitorGet(gameMonitorIndex, &mLeft, &mTop, &mRight, &mBottom)
Global MonWidth            := mRight - mLeft
Global MonHeight           := mBottom - mTop

; 2. Define Ratios relative to your 1440p baseline workspace (2560x1440)
Global ScaleX              := MonWidth / 2560
Global ScaleY              := MonHeight / 1440

; 3. Calculate Font Matrix (Neutralizes Windows OS DPI, scales via Display Area)
DpiScale                   := A_ScreenDPI / 96
Global FontScale           := ScaleX / DpiScale

; 4. Resolution-Relative UI Bounding Boxes
Global TargetWidgetWidth   := Round(230 * ScaleX)
Global CurrentWidgetHeight := Round(225 * ScaleY) 
WidgetPadding              := Round(15 * ScaleX)
StartY                     := Round(115 * ScaleY)

; Deep obsidian canvas background
MiniGui.BackColor          := "111216"

; Left accent status bar (Electric Neon Cyan)
Global LeftAccentBar       := MiniGui.Add("Progress", "x0 y0 w" Round(4 * ScaleX) " h" CurrentWidgetHeight " Background00D2FF")

; --- HEADER SECTION ---
MiniGui.SetFont("s" (8 * FontScale) " bold c00D2FF", "Segoe UI")
MiniGui.Add("Text", "x" Round(15*ScaleX) " y" Round(12*ScaleY) " w" Round(110*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "⚙️ FH6 MACRO ")

; Flat Premium Action Buttons (Header Control Bar)
PauseBtn := MiniGui.Add("Text", "x" Round(145*ScaleX) " y" Round(10*ScaleY) " w" Round(20*ScaleX) " h" Round(20*ScaleY) " Center Background22252E cFFD166", "⏸")
PauseBtn.SetFont("s" (9 * FontScale) " bold")
PauseBtn.OnEvent("Click", MiniTogglePause)

StopBtn := MiniGui.Add("Text", "x" Round(170*ScaleX) " y" Round(10*ScaleY) " w" Round(20*ScaleX) " h" Round(20*ScaleY) " Center Background22252E cFF5A5A", "⏹")
StopBtn.SetFont("s" (9 * FontScale) " bold")
StopBtn.OnEvent("Click", MiniStopMacro)

RestoreBtn := MiniGui.Add("Text", "x" Round(195*ScaleX) " y" Round(10*ScaleY) " w" Round(20*ScaleX) " h" Round(20*ScaleY) " Center Background22252E c00D2FF", "⤢")
RestoreBtn.SetFont("s" (10 * FontScale) " bold")
RestoreBtn.OnEvent("Click", RestoreMainWindow)

; --- SYSTEM STATUS SECTION (Always Visible) ---
MiniGui.SetFont("s" (9 * FontScale) " norm c8A99AD", "Segoe UI")
Global MiniTotalRunTime_UI := MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(6*ScaleY) " w" Round(200*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "🕓  00:00")
Global MiniKey_UI          := MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(2*ScaleY) " w" Round(200*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "⌨  [   ]")
Global MiniProcess_UI      := MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(2*ScaleY) " w" Round(200*ScaleX) " h" Round(30*ScaleY) " BackgroundTrans", "⚙️  Waiting...")

; Premium subtle dark divider line
MiniGui.Add("Progress", "x" Round(15*ScaleX) " y+" Round(6*ScaleY) " w" Round(190*ScaleX) " h" Round(1*ScaleY) " Background22252E")

; --- ADAPTIVE SECTION 1: RACE TELEMETRY ---
MiniGui.SetFont("s" (7 * FontScale) " bold c566273", "Segoe UI")
RaceControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y" StartY " w" Round(190*ScaleX) " h" Round(12*ScaleY) " BackgroundTrans c00D2FF", "◼ RACE PROGRESS"))

MiniGui.SetFont("s" (9 * FontScale) " norm c8A99AD", "Segoe UI")
RaceControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(6*ScaleY) " w" Round(140*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "🕓  Race Runtime"))
RaceControls.Push(MiniRaceRunTime_UI := _LinkNoirTelemetry(MiniGui.Add("Text", "x" Round(155*ScaleX) " yp w" Round(60*ScaleX) " h" Round(16*ScaleY) " Right BackgroundTrans cF3F4F6"), "00:00"))

RaceControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "💡  Points Gained"))
RaceControls.Push(MiniPointsCount_UI := _LinkNoirTelemetry(MiniGui.Add("Text", "x" Round(155*ScaleX) " yp w" Round(60*ScaleX) " h" Round(16*ScaleY) " Right BackgroundTrans cF3F4F6"), "0"))

RaceControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "🏁  Sectors Cleared"))
RaceControls.Push(MiniSectorCount_UI := _LinkNoirTelemetry(MiniGui.Add("Text", "x" Round(155*ScaleX) " yp w" Round(60*ScaleX) " h" Round(16*ScaleY) " Right BackgroundTrans cF3F4F6"), "0"))


; --- ADAPTIVE SECTION 2: CAR PURCHASE ---
MiniGui.SetFont("s" (7 * FontScale) " bold c566273", "Segoe UI")
BuyControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y" StartY " w" Round(190*ScaleX) " h" Round(12*ScaleY) " BackgroundTrans c00D2FF", "◼ CAR PURCHASE"))

MiniGui.SetFont("s" (9 * FontScale) " norm c8A99AD", "Segoe UI")
BuyControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(6*ScaleY) " w" Round(140*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "🕓  Buy Runtime"))
BuyControls.Push(MiniBuyRunTime_UI := _LinkNoirTelemetry(MiniGui.Add("Text", "x" Round(155*ScaleX) " yp w" Round(60*ScaleX) " h" Round(16*ScaleY) " Right BackgroundTrans cF3F4F6"), "00:00"))

BuyControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "📦  Cars Purchased"))
BuyControls.Push(MiniCarCount_UI := _LinkNoirTelemetry(MiniGui.Add("Text", "x" Round(155*ScaleX) " yp w" Round(60*ScaleX) " h" Round(16*ScaleY) " Right BackgroundTrans cF3F4F6"), "0"))


; --- ADAPTIVE SECTION 3: REWARDS UNLOCK ---
MiniGui.SetFont("s" (7 * FontScale) " bold c566273", "Segoe UI")
UnlockControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y" StartY " w" Round(190*ScaleX) " h" Round(12*ScaleY) " BackgroundTrans c00D2FF", "◼ REWARDS UNLOCK"))

MiniGui.SetFont("s" (9 * FontScale) " norm c8A99AD", "Segoe UI")
UnlockControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(6*ScaleY) " w" Round(140*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "🕓  Unlock Runtime"))
UnlockControls.Push(MiniUnlockRunTime_UI := _LinkNoirTelemetry(MiniGui.Add("Text", "x" Round(155*ScaleX) " yp w" Round(60*ScaleX) " h" Round(16*ScaleY) " Right BackgroundTrans cF3F4F6"), "00:00"))

UnlockControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "🌟  Super Wheelspins"))
UnlockControls.Push(MiniSWheelCount_UI := _LinkNoirTelemetry(MiniGui.Add("Text", "x" Round(155*ScaleX) " yp w" Round(60*ScaleX) " h" Round(16*ScaleY) " Right BackgroundTrans cF3F4F6"), "0"))

UnlockControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "🛞  Regular Wheelspins"))
UnlockControls.Push(MiniWheelCount_UI := _LinkNoirTelemetry(MiniGui.Add("Text", "x" Round(155*ScaleX) " yp w" Round(60*ScaleX) " h" Round(16*ScaleY) " Right BackgroundTrans cF3F4F6"), "0"))

UnlockControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "💲  Credits Earned"))
UnlockControls.Push(MiniCreditCount_UI := _LinkNoirTelemetry(MiniGui.Add("Text", "x" Round(145*ScaleX) " yp w" Round(70*ScaleX) " h" Round(16*ScaleY) " Right BackgroundTrans cF3F4F6"), "0 CR"))

;SetInitial UI state safely
UpdateMiniWidgetMode("")

; ══════════════════════════════════════════════
;  ADAPTIVE VISIBILITY & FRAME RESIZE ENGINE
; ══════════════════════════════════════════════
UpdateMiniWidgetMode(activeMode) {
    global CurrentWidgetHeight, LeftAccentBar, MiniGui, ScaleY
    global RaceControls, BuyControls, UnlockControls
    
    for ctrl in RaceControls
        ctrl.Visible := false
    for ctrl in BuyControls
        ctrl.Visible := false
    for ctrl in UnlockControls
        ctrl.Visible := false

    switch StrLower(activeMode) {
        case "race":
            for ctrl in RaceControls
                ctrl.Visible := true
            targetHeight := Round(195 * ScaleY)
            
        case "buy":
            for ctrl in BuyControls
                ctrl.Visible := true
            targetHeight := Round(175 * ScaleY)
            
        case "unlock":
            for ctrl in UnlockControls
                ctrl.Visible := true
            targetHeight := Round(215 * ScaleY)
            
        default:
            targetHeight := Round(100 * ScaleY)
    }

    CurrentWidgetHeight := targetHeight
    LeftAccentBar.Move(,,, targetHeight)
    MiniGui.Move(,,, targetHeight)
    WinRedraw(MiniGui.Hwnd)
}

; ══════════════════════════════════════════════
;  BUTTON ACTION INTERFACES
; ══════════════════════════════════════════════
MiniTogglePause(ctrlObj, info) {
    TogglePause()
}

MiniStopMacro(ctrlObj, info) {
    global ActiveMode

    if MasterMode
        ToggleAll()
    else
        switch ActiveMode {
            case "Race": StartRace()
            case "Buy": StartBuy()
            case "Unlock": StartUnlock()
            default: 
        } 
}

; ══════════════════════════════════════════════
;  SIZE CHANGE TRIGGER (Dynamic Top-Right Screen Snap)
; ══════════════════════════════════════════════
MainGUI_SizeChange(thisGui, minMax, *) {
    global TargetWidgetWidth, CurrentWidgetHeight, WidgetPadding
    
    if (minMax == -1) {
        thisGui.Hide()
        
        gameMonitorIndex := GetGameMonitor()
        MonitorGet(gameMonitorIndex, &mLeft, &mTop, &mRight, &mBottom)
        
        miniX := mRight - TargetWidgetWidth - WidgetPadding
        miniY := mTop + WidgetPadding
        
        MiniGui.Show("x" miniX " y" miniY " w" TargetWidgetWidth " h" CurrentWidgetHeight " NoActivate")
        WinSetTransparent(180, MiniGui.Hwnd)
    }
}

DragMiniGui() {
    global MiniGui, DragOffsetX, DragOffsetY
    
    if !GetKeyState("LButton", "P") {
        SetTimer(, 0)
        return
    }
    
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)
    
    MiniGui.Move(mouseX - DragOffsetX, mouseY - DragOffsetY)
}

RestoreMainWindow(*) {
    MiniGui.Hide()
    MainGUI.Show()
}

; ══════════════════════════════════════════════
;  NOTIFICATION TOAST (Relative Resolution Scale Engine)
; ══════════════════════════════════════════════
ShowNotif(type, title, message := "") {
    switch StrLower(type) {
        case "success":
            accentColor := "33FF66"
            icon        := "✅ "
            duration    := -5000
        case "error", "fail", "failure":
            accentColor := "FF3333"
            icon        := "❌ "
            duration    := -5000
        default:
            accentColor := "00D2FF"
            icon        := "ℹ️ "
            duration    := -5000
    }

    ; ── INTERSECT DETECTION ROUTING ──
    ; Calls formula to pull the best monitor index
    targetMon := GetGameMonitor()

    ; Fetch bounding limits for the specific display containing the game
    MonitorGet(targetMon, &mLeft, &mTop, &mRight, &mBottom)
    mWidth  := mRight - mLeft
    mHeight := mBottom - mTop
    
    ; Local scaling factors calculated against the game screen's real footprint
    sX     := mWidth / 2560
    sY     := mHeight / 1440
    fScale := sX / (A_ScreenDPI / 96)

    Notif := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 -DPIScale")
    Notif.BackColor := "181A1F"
    Notif.Add("Progress", "x0 y0 w" Round(6*sX) " h" Round(70*sY) " Background" accentColor)
    
    Notif.SetFont("s" (10 * fScale) " bold c" accentColor, "Segoe UI")
    Notif.Add("Text", "x" Round(15*sX) " y" Round(10*sY) " w" Round(250*sX) " BackgroundTrans", icon title)
    
    Notif.SetFont("s" (9 * fScale) " norm cEEEEEE", "Segoe UI")
    Notif.Add("Text", "x" Round(15*sX) " y+" Round(5*sY) " w" Round(250*sX) " h" Round(35*sY) " BackgroundTrans", message)

    tWidth  := Round(280 * sX)
    tHeight := Round(70 * sY)
    Notif.Show("w" tWidth " h" tHeight " Hide")
    
    ; Pins the notification precisely inside the workspace boundaries of that display
    notifX := mRight - tWidth - Round(15 * sX)
    notifY := mBottom - tHeight - Round(45 * sY)

    WinMove(notifX, notifY,,, Notif.Hwnd)
    Notif.Show("NoActivate")
    SetTimer(() => Notif.Destroy(), duration)
}