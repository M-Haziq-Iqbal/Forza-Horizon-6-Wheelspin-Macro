; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

; ══════════════════════════════════════════════
;  GUI CONSTRUCTION BLOCK
; ══════════════════════════════════════════════
BuildMiniGui() {

    Global
    Global RaceControls := [], BuyControls := [], UnlockControls := [], SpinControls := []
    global previewGui := ""

    MiniGui := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale")
    
    ; Resolution-Relative UI Bounding Boxes
    TargetWidgetWidth   := Round(230 * ScaleX)
    CurrentWidgetHeight := Round(225 * ScaleY) 
    WidgetPadding       := Round(35 * ScaleX)
    StartY              := Round(115 * ScaleY)

    ; Deep obsidian canvas background
    MiniGui.BackColor          := "111216"

    ; Left accent status bar (Electric Neon Cyan)
    LeftAccentBar := MiniGui.Add("Progress", "x0 y0 w" Round(4 * ScaleX) " h" CurrentWidgetHeight " Background00D2FF")

    ; --- HEADER SECTION ---
    MiniGui.SetFont("s" (8 * FontScale) " bold c00D2FF", "Segoe UI")
    MiniGui.Add("Text", "x" Round(15*ScaleX) " y" Round(12*ScaleY) " w" Round(110*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "⚙️ FH6 MACRO ")

    MiniGui.SetFont("s" (10 * FontScale) " bold")
    RestoreBtn := MiniGui.Add("Text", "x" Round(195*ScaleX) " y" Round(10*ScaleY) " w" Round(20*ScaleX) " h" Round(20*ScaleY) " Center Background22252E c64748B", "⛶")
    RestoreBtn.OnEvent("Click", RestoreMainWindow)

    ReloadBtn := MiniGui.Add("Text", "x" Round(173*ScaleX) " y" Round(10*ScaleY) " w" Round(20*ScaleX) " h" Round(20*ScaleY) " Center Background22252E c94A3B8", "⭮")
    ReloadBtn.OnEvent("Click", (*) => Reload())

    PreviewBtn := MiniGui.Add("Text", "x" Round(151*ScaleX) " y" Round(10*ScaleY) " w" Round(20*ScaleX) " h" Round(20*ScaleY) " Center Background22252E c94A3B8", "🎞️")
    PreviewBtn.OnEvent("Click", (ctrl, *) => TogglePreview(ctrl))

    AlwaysOnTopBtn := MiniGui.Add("Text", "x" Round(195*ScaleX) " y" Round(32*ScaleY) " w" Round(20*ScaleX) " h" Round(20*ScaleY) " Center Background22252E " (IsGameAlwaysOnTop ? "cF7507F" : "c94A3B8"), "📌")
    AlwaysOnTopBtn.OnEvent("Click", (ctrl, *) => AlwaysOnTopEnable(ctrl))

    LockBtn := MiniGui.Add("Text", "x" Round(173*ScaleX) " y" Round(32*ScaleY) " w" Round(20*ScaleX) " h" Round(20*ScaleY) " Center Background22252E " (IsGameLocked ? "cF59E0B" : "c94A3B8"), "🔒")
    LockBtn.OnEvent("Click", (ctrl, *) => ToggleWindowLock(ctrl))

    ResoSetBtn := MiniGui.Add("Text", "x" Round(151*ScaleX) " y" Round(32*ScaleY) " w" Round(20*ScaleX) " h" Round(20*ScaleY) " Center Background22252E " (IsGameWindowed ? "c3B82F6" : "c94A3B8"), "🗗")
    ResoSetBtn.OnEvent("Click", (ctrl, *) => ResizeGameClient(ctrl))

    InitStartBtn := MiniGui.Add("Text", "x" Round(195*ScaleX) " y" Round(70*ScaleY) " w" Round(18*ScaleX) " h" Round(18*ScaleY) " Center Background22252E c94A3B8", "⬤")
    InitStartBtn.OnEvent("Click", (ctrl, *) => MiniInitStartMacro(ctrl))

    ; Flat Premium Action Buttons (Header Control Bar)
    MiniGui.SetFont("s" (9 * FontScale) " bold")
    PauseBtn := MiniGui.Add("Text", "x" Round(173*ScaleX) " y" StartY " w" Round(18*ScaleX) " h" Round(18*ScaleY) " Center Background22252E cFFD166","❚❚")
    PauseBtn.OnEvent("Click", (ctrl, *) => MiniTogglePause(ctrl))

    StopBtn := MiniGui.Add("Text", "x" Round(195*ScaleX) " y" StartY " w" Round(18*ScaleX) " h" Round(18*ScaleY) " Center Background22252E cFF5A5A", "⏹")
    StopBtn.OnEvent("Click", (ctrl, *) => MiniStopMacro(ctrl))

    ; --- SYSTEM STATUS SECTION ---
    MiniGui.SetFont("s" (9 * FontScale) " norm c8A99AD", "Segoe UI")
    MiniTotalRunTime_UI := MiniGui.Add("Text", "x" Round(15*ScaleX) " y35" " w" Round(180*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "🕓  00:00")
    MiniKey_UI          := MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(2*ScaleY) " w" Round(180*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "⌨  [   ]")
    MiniProcess_UI      := MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(2*ScaleY) " w" Round(180*ScaleX) " h" Round(30*ScaleY) " BackgroundTrans", "⚙️  Waiting...")

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

    ; --- ADAPTIVE SECTION 4: WHEELSPINS ---
    MiniGui.SetFont("s" (7 * FontScale) " bold c566273", "Segoe UI")
    SpinControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y" StartY " w" Round(190*ScaleX) " h" Round(12*ScaleY) " BackgroundTrans c00D2FF", "◼ WHEELSPINS"))

    MiniGui.SetFont("s" (9 * FontScale) " norm c8A99AD", "Segoe UI")
    SpinControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(6*ScaleY) " w" Round(140*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "🕓  Spin Runtime"))
    SpinControls.Push(MiniSpinRunTime_UI := _LinkNoirTelemetry(MiniGui.Add("Text", "x" Round(155*ScaleX) " yp w" Round(60*ScaleX) " h" Round(16*ScaleY) " Right BackgroundTrans cF3F4F6"), "00:00"))

    SpinControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "🎊  Spins Opened"))
    SpinControls.Push(MiniSpinOpenCount_UI := _LinkNoirTelemetry(MiniGui.Add("Text", "x" Round(155*ScaleX) " yp w" Round(60*ScaleX) " h" Round(16*ScaleY) " Right BackgroundTrans cF3F4F6"), "0"))

    SpinControls.Push(MiniGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(4*ScaleY) " w" Round(140*ScaleX) " h" Round(16*ScaleY) " BackgroundTrans", "🎁  Spins Remaining"))
    SpinControls.Push(MiniSpinLeftCount_UI := _LinkNoirTelemetry(MiniGui.Add("Text", "x" Round(145*ScaleX) " yp w" Round(70*ScaleX) " h" Round(16*ScaleY) " Right BackgroundTrans cF3F4F6"), "0"))
}

; ══════════════════════════════════════════════
;  ADAPTIVE VISIBILITY & FRAME RESIZE ENGINE
; ══════════════════════════════════════════════
UpdateMiniWidgetMode(activeMode) {
    global CurrentWidgetHeight, LeftAccentBar, MiniGui, ScaleY
    global RaceControls, BuyControls, UnlockControls, SpinControls
    
    for ctrl in RaceControls
        ctrl.Visible := false
    for ctrl in BuyControls
        ctrl.Visible := false
    for ctrl in UnlockControls
        ctrl.Visible := false
    for ctrl in SpinControls
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

        case "spin":
            for ctrl in SpinControls
                ctrl.Visible := true
            targetHeight := Round(195 * ScaleY)
            
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
MiniTogglePause(ctrl) {
    global MasterMode, ActiveMode
    
    TogglePause()

    if !PauseMode && ActiveMode {
        ctrl.Opt("cFFD166")
        ctrl.Value := "❚❚"
    }
    else if PauseMode && ActiveMode {
        ctrl.Opt("cFFD166")
        ctrl.Value := "▶"
    }
}

MiniStopMacro(ctrl) {
    global MasterMode, ActiveMode, PauseBtn

    if MasterMode
        StartFullLoop()
    else
        switch ActiveMode {
            case "Race": StartRace()
            case "Buy": StartBuy()
            case "Unlock": StartUnlock()
            default: 
        }
    
    if !ActiveMode && !MasterMode {
        ctrl.Opt("c94A3B8")
    }
}

MiniInitStartMacro(ctrl) {

    ctrl.Opt("c22C55E")
    StartFullLoop()
    ctrl.Opt("c94A3B8")
}

; ══════════════════════════════════════════════
;  SIZE CHANGE TRIGGER (Dynamic Top-Right Screen Snap)
; ══════════════════════════════════════════════
MainGUI_SizeChange(thisGui, minMax, *) {
    global TargetWidgetWidth, CurrentWidgetHeight, WidgetPadding, MonRight, MonTop
    
    if (minMax == -1) {
        thisGui.Hide()
        
        ; Sync display bounds dynamically in case game shifted screens
        UpdateMonitorMetrics()
        
        ; Align using precise work area boundaries (MonRight & MonTop)
        miniX := MonRight - TargetWidgetWidth - WidgetPadding
        miniY := MonTop + WidgetPadding
        
        MiniGui.Show("x" miniX " y" miniY " w" TargetWidgetWidth " h" CurrentWidgetHeight " NoActivate")
        WinSetTransparent(180, MiniGui.Hwnd)
    }
}

RestoreMainWindow(*) {
    MiniGui.Hide()
    MainGUI.Show()
}

; ════════════════════
;  NOTIFICATION TOAST
; ════════════════════
ShowNotif(type, title, message := "", mirrorToDiscord := true) {
    global ScaleX, ScaleY, FontScale, MonRight, MonBottom

    ; Mirrors this toast to Discord if the webhook is configured and enabled.
    ; Covers every existing notification site in the codebase with no
    ; changes needed anywhere else. mirrorToDiscord=false is used by
    ; Discord.ahk's own error reporting, so a broken webhook can't try
    ; to recursively notify itself about being broken.
    if (mirrorToDiscord)
        DiscordNotify(type, title, message)

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
            duration    := -8000
    }

    UpdateMonitorMetrics()

    Notif := Gui("+AlwaysOnTop -Caption +ToolWindow -DPIScale")
    Notif.BackColor := "181A1F"
    Notif.Add("Progress", "x0 y0 w" Round(6*ScaleX) " h" Round(70*ScaleY) " Background" accentColor)
    
    Notif.SetFont("s" (10 * FontScale) " bold c" accentColor, "Segoe UI")
    Notif.Add("Text", "x" Round(15*ScaleX) " y" Round(10*ScaleY) " w" Round(235*ScaleX) " BackgroundTrans", icon title)
    
    Notif.SetFont("s" (9 * FontScale) " norm cEEEEEE", "Segoe UI")
    Notif.Add("Text", "x" Round(15*ScaleX) " y+" Round(5*ScaleY) " w" Round(235*ScaleX) " h" Round(35*ScaleY) " BackgroundTrans", message)

    Notif.SetFont("s" (11 * FontScale) " norm c888888", "Segoe UI")
    closeBtn := Notif.Add("Text", "x" Round(255*ScaleX) " y" Round(8*ScaleY) " w" Round(15*ScaleX) " h" Round(15*ScaleY) " Center BackgroundTrans", "×")
    closeBtn.OnEvent("Click", (*) => Notif.Destroy())

    tWidth  := Round(280 * ScaleX)
    tHeight := Round(70 * ScaleY)
    Notif.Show("w" tWidth " h" tHeight " Hide")
    
    ; Uses MonRight and MonBottom to avoid clipping behind the taskbar layout
    notifX := MonRight - tWidth - Round(15 * ScaleX)
    notifY := MonBottom - tHeight - Round(15 * ScaleY)

    WinMove(notifX, notifY,,, Notif.Hwnd)
    Notif.Show("NoActivate")
    SetTimer(() => Notif.Destroy(), duration)
}

; ══════════════════════════════════════════════
;  GAME WINDOW MANIPULATION
; ══════════════════════════════════════════════

ResizeGameClient(ctrl) {
    global IsGameWindowed, GameTitle, SelectedReso
    global IsGameAlwaysOnTop, AlwaysOnTopBtn
    global MonWidth, MonHeight, MonLeft, MonTop

    ; 1. Verify target window exists before executing sizing logic
    if !WinExist(GameTitle) {
        ShowNotif("error", "Resize Game Client", "Game window could not be found.")
        return
    }

    ; 2. Dynamically refresh layout dimensions for the designated target monitor
    UpdateMonitorMetrics()

    ; 3. Parse resolution string securely
    resParts := StrSplit(SelectedReso, "x", " ")

    TargetWidth  := Integer(resParts[1])
    TargetHeight := Integer(resParts[2])

    IsGameWindowed := !IsGameWindowed 

    if IsGameWindowed {
        ; ─── ENTER WINDOWED MODE ───

        ; Strip title bar and window borders so the game canvas aligns perfectly with monitor pixels
        WinSetStyle("-0x00C00000 -0x00040000", GameTitle) ; -WS_CAPTION -WS_THICKFRAME

        TargetX := (MonLeft + MonWidth) - TargetWidth
        TargetY := (MonTop + MonHeight) - TargetHeight
        
        ; Apply positioning metrics
        WinMove(TargetX, TargetY, TargetWidth, TargetHeight, GameTitle)

        ; Update control color scheme and force immediate UI redraw
        ctrl.Opt("c3B82F6")
        ctrl.Redraw()
        
        ShowNotif("info", "Windowed Mode", "Press Alt + Left Click to hold and drag the game window.")
    }
    else {
        ; ─── ENTER BORDERLESS FULLSCREEN MODE ───

        ; Strip title bar and window borders so the game canvas aligns perfectly with monitor pixels
        WinSetStyle("-0x00C00000 -0x00040000", GameTitle) ; -WS_CAPTION -WS_THICKFRAME

        ; Stretch the clean borderless canvas to fill the precise coordinates of your SELECTED monitor
        WinMove(MonLeft, MonTop, MonWidth, MonHeight, GameTitle)

        ; Reset AlwaysOnTop flags to prevent rendering conflicts over the macro overlay
        WinSetAlwaysOnTop(0, GameTitle)
        IsGameAlwaysOnTop := false
        
        ; Update UI controls and redraw layout elements
        ctrl.Opt("c94A3B8")
        ctrl.Redraw()
        if IsSet(AlwaysOnTopBtn) && AlwaysOnTopBtn {
            AlwaysOnTopBtn.Opt("c94A3B8")
            AlwaysOnTopBtn.Redraw()
        }

        ShowNotif("info", "Fullscreen Mode", "Press 🗗 button to enable windowed mode.")
    }
}

ToggleWindowLock(ctrl) {
    global IsGameLocked, GameTitle
    
    if !WinExist(GameTitle) {
        ShowNotif("error","Lock Game Client", "Game window could not be found.")
        return
    }
    
    IsGameLocked := !IsGameLocked
    
    if (IsGameLocked) {
        ; 1. Tell Windows to disable the window. 
        ; It remains completely visible, but becomes completely immune to focus vacuuming and clicks.
        WinSetEnabled(false, GameTitle)
        
        ; 2. Instantly pass focus to the desktop wallpaper layer to clear the screen
        if WinExist("ahk_class WorkerW")
            WinActivate("ahk_class WorkerW")
        else if WinExist("ahk_class Progman")
            WinActivate("ahk_class Progman")
        
        ctrl.Opt("cF59E0B")
        ShowNotif("info", "Background Lock ON", "Game is locked open but completely inactive.")
    } else {
        ; 3. Re-enable the window so it can accept normal clicks and focus again
        WinSetEnabled(true, GameTitle)
        
        ; Bring it back to the front
        WinActivate(GameTitle) 
        
        ctrl.Opt("c94A3B8")
        ShowNotif("info", "Background Lock OFF", "Game control restored to normal.")
    }
}

AlwaysOnTopEnable(ctrl) {
    global IsGameAlwaysOnTop, GameTitle, IsGameWindowed
    
    if !WinExist(GameTitle) {
        ShowNotif("error","Always On Top", "Game window could not be found.")
        return
    }
    
    if !IsGameWindowed {
        ShowNotif("error","Always On Top", "Always On Top mode is disabled on Fullscreen mode.")
        return
    }
    
    IsGameAlwaysOnTop := !IsGameAlwaysOnTop
    
    if (IsGameAlwaysOnTop) {
        WinSetAlwaysOnTop(1, GameTitle)
        ctrl.Opt("cF7507F")
        ShowNotif("info", "Always On Top ON", "Game is set to be Always On Top other windows.")
    } else {
        WinSetAlwaysOnTop(0, GameTitle)
        ctrl.Opt("c94A3B8")
        ShowNotif("info", "Always On Top OFF", "Game is set to be normal.")
    }
}

TogglePreview(ctrl) {
    global GameTitle, ScaleX, ScaleY, MonRight, MonLeft, MonTop, MonBottom
    global previewGui, MiniGui
    static hThumbnail := 0

    if !WinExist(GameTitle) {
        ShowNotif("error","Mini Preview", "Game window could not be found.")
        return
    }

    UpdateMonitorMetrics()

    PreviewWidth := Round(230 * ScaleX)
    PreviewHeight := Round(130 * ScaleY)
    PreviewX := MonRight - PreviewWidth - Round(35 * ScaleX)
    PreviewY := MonTop + Round(35 * ScaleY)
    
    ; If preview is already active, close and unregister it
    if previewGui {
        if hThumbnail {
            DllCall("dwmapi\DwmUnregisterThumbnail", "Ptr", hThumbnail)
            hThumbnail := 0
        }
        previewGui.Destroy()
        previewGui := ""
        ctrl.Opt("c94A3B8")
        ctrl.Redraw()
        return
    }
    ctrl.Opt("c64d0ea")
    ctrl.Redraw()

    ; Check if target game/window is running
    targetHwnd := WinExist(GameTitle)
    if !targetHwnd {
        ToolTip("Target window not found!")
        SetTimer(() => ToolTip(), -2000)
        return
    }
    
    ; 1. Create the Host GUI Window
    previewGui := Gui("+AlwaysOnTop +ToolWindow -Caption -DPIScale", "Live Game Preview")
    previewGui.BackColor := "Black"
    
    ; Setup a clean exit if the user manually closes the GUI window
    previewGui.OnEvent("Close", (ctrl, *) => TogglePreview(ctrl))
    
    ; Show the GUI box without stealing focus from your current active window
    previewGui.Show(Format("w{} h{} x{} y{} NoActivate", PreviewWidth, PreviewHeight, PreviewX, PreviewY))
    MiniGui.Hide() ; Hide the MiniGUI to prevent it from overlapping the preview window
    MiniGui.Show("NoActivate") ; Ensure the MiniGUI stays on top of the preview window  
    
    ; 2. Register the DWM Thumbnail link between the GUI and the Game
    if DllCall("dwmapi\DwmRegisterThumbnail", "Ptr", previewGui.Hwnd, "Ptr", targetHwnd, "Ptr*", &hThumbnail := 0) != 0 {
        MsgBox("Failed to register DWM Thumbnail API relationship.")
        previewGui.Destroy()
        previewGui := ""
        return
    }
    
    ; 3. Build the DWM_THUMBNAIL_PROPERTIES struct (48-byte buffer)
    ; Layout: dwFlags(0), rcDestination(4), rcSource(20), opacity(36), fVisible(40), fSourceClientAreaOnly(44)
    structProps := Buffer(48, 0)
    
    ; dwFlags: Set flags to update Destination Rect (0x1), Visibility (0x8), and ClientArea Only (0x10)
    NumPut("UInt", 0x1 | 0x8 | 0x10, structProps, 0) 
    
    ; rcDestination: Maps the inside region of your AHK GUI where the game stream draws
    NumPut("Int", 0,              structProps, 4)   ; Left
    NumPut("Int", 0,              structProps, 8)   ; Top
    NumPut("Int", PreviewWidth,   structProps, 12)  ; Right
    NumPut("Int", PreviewHeight,  structProps, 16)  ; Bottom
    
    ; fVisible: Set to True (1)
    NumPut("Int", 1, structProps, 40)
    
    ; fSourceClientAreaOnly: Set to True (1) to crop out the game's titlebar and borders
    NumPut("Int", 1, structProps, 44)
    
    ; 4. Update and display the live stream
    DllCall("dwmapi\DwmUpdateThumbnailProperties", "Ptr", hThumbnail, "Ptr", structProps)
}

; ══════════════════════════════════════════════
;  VARIABLE INIT FUNCTIONS
; ══════════════════════════════════════════════

CheckWindowed() {
    global GameTitle, MonWidth, MonHeight
    
    if !WinExist(GameTitle)
        return false

    ; 1. Refresh your monitor metrics to get the target screen's width/height
    UpdateMonitorMetrics() 
    
    ; 2. Fetch the actual current width and height of the game window
    WinGetClientPos(, , &gameWidth, &gameHeight, GameTitle)
    
    ; 3. If it's smaller than the monitor's full canvas, it is in Windowed Mode
    if (gameWidth < MonWidth || gameHeight < MonHeight) {
        return true  ; Yes, it is Windowed
    }
    
    return false ; No, it matches screen size (Borderless Fullscreen)
}

CheckLocked() {
    global GameTitle

    if !WinExist(GameTitle)
        return false

    if WinGetStyle(GameTitle) & 0x08000000
        return true
    else
        return false
}

CheckAlwaysOnTop() {
    global GameTitle
    
    if !WinExist(GameTitle)
        return false

    if WinGetExStyle(GameTitle) & 0x8
        return true
    else
        return false
}