; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

StartSpin() {
    global ActiveMode, StatusText, SpinRunSeconds
    global SpinOpenCount_UI, SpinLeftCount_UI, SpinRunTime_UI
    global MiniSpinOpenCount_UI, MiniSpinLeftCount_UI, MiniSpinRunTime_UI
    global MainSpinOpenCount_UI, MainSpinLeftCount_UI, MainSpinRunTime_UI
    global SuperBtn, RegularBtn
    global CarData, SelectedCar
    global UnlockCount

    car := CarData[SelectedCar]

    if FindGame() = 0
        return

    if MasterMode && UnlockCount = 0 {
        ShowNotif("error", "Spin Mode", "Opening 0 Wheelspin. `nAborting Spin Mode.", true)
        return
    }
    
    if !ToggleMode("Spin") {
        StatusText.Value := "⬤  Stopping..."
        StatusText.SetFont("cFFB347")
    }

    if (ActiveMode != "Spin")
        return
    
    if !CarData.Has(SelectedCar) {
        MsgBox("Error: Selected car '" SelectedCar "' not found in database.", "Error", 16)
        return
    }

    StartIndicators()
    UpdateMiniWidgetMode(ActiveMode)

    SuperBtn.Opt("+Disabled")
    RegularBtn.Opt("+Disabled")

    if (ActiveMode = "Spin") {
        SpinRunSeconds        := 0

        SpinOpenCount_UI.Value    := "0" 
        SpinLeftCount_UI.Value    := "0"  
        SpinRunTime_UI.Value  := "00:00"

        MiniSpinOpenCount_UI.Value    := "0" 
        MiniSpinLeftCount_UI.Value    := "0"  
        MiniSpinRunTime_UI.Value  := "00:00"

        MainSpinOpenCount_UI.Value    := "0" 
        MainSpinLeftCount_UI.Value    := "0"  
        MainSpinRunTime_UI.Value  := "00:00"
        
        SpinRunTime_UI.SetFont("c" cHighlight)
        SpinLeftCount_UI.SetFont("c" cHighlight)
        SpinOpenCount_UI.SetFont("c" cHighlight)
        SetTimer(SpinTimerTick, 1000)
        SpinLoop()
    }
    try {
        SuperBtn.Opt("-Disabled")
        RegularBtn.Opt("-Disabled")
    }

    ResetIndicators()
}

SpinLoop() {
    DiscordStatusUpdate("info", "Spin Mode Started", "Opening My Horizon wheelspin menu...")

    global ActiveMode, MasterMode
    global SpinInFullLoop, SpinType, SpinMode, SpinCount_In
    global TotalSWheel, TotalWheel

    global SpinCount       := SpinCount_In.Value
    global SpinLeftCount   := SpinCount
    global SpinOpenCount   := 0
    
    SpinLoopCount   := 100
    
    SpinName        := SpinType = "SUPER" ? "Super Wheelspin" : "Regular Wheelspin"

    if MasterMode {
        SpinCount_In.Value := SpinType = "SUPER" ?  TotalSWheel : TotalWheel
        SpinCount := SpinCount_In.Value
    }

    if SpinCount = 0 {
        ShowNotif("warning", "Spin Mode", "0 " SpinName " detected. `nAborting Spin Mode.")
        return
    }

    CheckAbort() {
        return ActiveMode != "Spin" && !MasterMode
    }

    ShowNotif("info", "Spin Mode", "Opening " SpinName)

    SpinNav()

    Process("Opening " SpinName " menu...")
    SpinType = "SUPER" ? PressKey("left", 100) : PressKey("right", 100)
        
    Process("Spinning...")
    PressKey("Enter") ; Enter Wheelspin

    if SpinType = "SUPER"
        SpinLeftCount   := ScanOCR(0.107, 0.622, 0.071, 0.052, 3000, , true)
    else if SpinType = "REGULAR"
        SpinLeftCount   := ScanOCR(0.148, 0.624, 0.075, 0.054, 3000, , true)

    SpinLeftCount := SpinLeftCount = -1 ? SpinCount : SpinLeftCount
    SpinLeftCount++

    SpinOpenCount_UI.Value    := SpinOpenCount
    SpinLeftCount_UI.Value    := SpinLeftCount

    MiniSpinOpenCount_UI.Value    := SpinOpenCount
    MiniSpinLeftCount_UI.Value    := SpinLeftCount

    MainSpinOpenCount_UI.Value    := SpinOpenCount
    MainSpinLeftCount_UI.Value    := SpinLeftCount

    DiscordStatusUpdate("info", "Opening Wheelspins", "Rolling car gacha...")
    Loop {
        loop Min(SpinCount, SpinLeftCount) {            
            Process("Skipping...")

            if InStr(ScanOCR(0.071, 0.915, 0.110-0.070, 0.945-0.915, 2000), "S", 0)
                PressKey("Enter", 50) ; Skip`

            if CheckAbort()
                break
            
            ; Rescan Wheelspin amount to avoid desync
            if Mod(SpinOpenCount, 5) = 0 {
                if SpinType = "SUPER"
                    spin := ScanOCR(0.107, 0.622, 0.071, 0.052, 2000, , true)
                else if SpinType = "REGULAR"
                    spin := ScanOCR(0.148, 0.624, 0.075, 0.054, 2000, , true)
                SpinLeftCount := spin = -1 ? SpinLeftCount : spin
                SpinLeftCount++
            }

            SpinOpenCount++
            SpinOpenCount_UI.Value          := SpinOpenCount
            MiniSpinOpenCount_UI.Value      := SpinOpenCount
            MainSpinOpenCount_UI.Value      := SpinOpenCount

            SpinLeftCount--
            SpinLeftCount_UI.Value          := SpinLeftCount
            MiniSpinLeftCount_UI.Value      := SpinLeftCount
            MainSpinLeftCount_UI.Value      := SpinLeftCount
            
            if CheckAbort()
                break
            
            Process("Collecting...")
            if InStr(ScanOCR(0.071, 0.915, 0.110-0.070, 0.945-0.915, 4000), "C") {
                if SpinOpenCount >= SpinCount || SpinOpenCount >= SpinLoopCount {
                    PressKey("Esc", 50) ; Collect Prize
                } else {
                    PressKey("Enter", 50) ; Collect Prize and Spin Again
                }
            }

            if CheckAbort()
                break

            Loop 3 {
                if GetPixelColor(0.352, 0.696, 500) = "0x000000" {
                    if SpinMode = "SELL" {
                        Process("Selling...")
                        PressKey("Down", 50)
                        PressKey("Down", 50)
                        PressKey("Enter", 50)
                    } 
                    else if SpinMode = "GIFT" {
                        Process("Gifting...")
                        PressKey("Down", 50) ; Navigate to Send as a Gift
                        PressKey("Enter") ; Select Send as a Gift
                        PressKey("Enter") ; Select Gift to
                        PressKey("Enter") ; Select Gift Message
                        PressKey("Enter") ; Select Gift From
                        PressKey("Enter") ; Select Send Gift
                        
                        ScanOCR(0.448, 0.422, 0.553-0.448, 0.474-0.422, 5000, "Gift Sent")
                        PressKey("Enter", 100) ; Select OK after Gift Sent
                    }
                    else if SpinMode = "KEEP"
                        Process("Keeping...")
                        PressKey("Enter", 50)
                } 
                else
                    break
            }
            
            if Mod(SpinOpenCount, 10) = 0
                ShowNotif("info", "Spin Mode", SpinOpenCount " " SpinName " opened.")

            DiscordStatusUpdate("info", "Opening Wheelspins", "Rolling car gacha...")

            if SpinOpenCount >= SpinCount || SpinOpenCount >= SpinLoopCount
                break

            if CheckAbort()
                break
        }
        Process("Returning to Free Roam...", 1000)
        PressKey("Esc", 1000) ; Return to Free Roam to avoid Inactivity Status

        WaitForPixel("Returning to Free Roam...", 0.137, 0.950, "0xFFFFFF", , 20000, 1000)
        
        if SpinOpenCount >= SpinCount {
            ShowNotif("success", "Spin Mode", SpinOpenCount " " SpinName " opened.", true)
            break
        }

        if CheckAbort()
            break

        Process("Navigating Menu...")
        PressKey("Esc", 1000) ; Open Menu
        PressKey("PgDn", 50) ; Navigate to Cars Menu
        PressKey("PgDn", 50) ; Navigate to My Horizon Menu

        if CheckAbort()
            break
        
        SpinType = "SUPER" ? PressKey("Left", 100) : PressKey("Right", 100)

        PressKey("Enter", 50)
    }
}

IsSpinGuiOpen() {
    global SpinGUI
    try {
        ; Check if variable is initialized, not null, and has an active OS window handle
        return IsSet(SpinGUI) && SpinGUI && WinExist("ahk_id " SpinGUI.Hwnd)
    } catch {
        return false
    }
}

OnSpinClose(*) {
    global SpinGUI, ActiveMode
    if (ActiveMode == "Spin") {
        StartSpin()
    }
    SpinGUI.Destroy()
    SpinGUI := 0
}

OpenSpinPanel(*) {
    global SpinGUI, SpinRunTime_UI, SpinOpenCount_UI, SpinLeftCount_UI, SpinCount_In, MainGUI, ActiveMode, SpinInFullLoop, SpinType, SpinMode, SuperBtn, RegularBtn
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
    SpinMin.OnEvent("Click", (*) => WinMinimize(SpinGUI.Hwnd))

    SpinX := SpinGUI.Add("Text", "x" Round(225*ScaleX) " y" Round(12*ScaleY) " w" Round(16*ScaleX) " h" Round(16*ScaleY) " Center BackgroundTrans c" p["textDim"], "✕")

    SpinX.OnEvent("Click", OnSpinClose)

    ; ── Interface Content ──
    SetFixedFont(SpinGUI, 12, "bold", "Light")
    SpinGUI.Add("Text", "x0 y" Round(30*ScaleY) " w" Round(250*ScaleX) " Center c" p["accent"], "SPIN CONTROLLER")

    SetFixedFont(SpinGUI, 9, "norm", "Light")
    SpinCount_In := SpinGUI.Add("Edit", "x" Round(170*ScaleX) " y+" Round(15*ScaleY) " w" Round(63*ScaleX) " h" Round(20*ScaleY) " -E0x200 Center Number Background" p["editBg"] " c" p["text"], 100)
    SpinGUI.Add("Text", "x" Round(20*ScaleX) " yp+" Round(3*ScaleY) " w" Round(155*ScaleX) " BackgroundTrans c" p["text"], "⟡   Spins Count")

    SpinCount_In.OnEvent("Change",  (ctrl, *) => UpdateSpinCount(ctrl))

    UpdateSpinCount(ctrl, *) {
        global SpinCount        := 0
        global SpinOpenCount    := 0

        value := ctrl.Value

        ; 🔹 instant normalize (UI)
        value := (value = "") ? 0 : Integer(value)
        value := Min(999, value)
        value := Max(SpinOpenCount+1, value)

        ; FIX: Strict string check detects leading zeros ("02" != "2")
        if !(ctrl.Value == String(value)) {
            ctrl.Value := value
            
            ; Only force caret to the end if the text was actually modified/cleaned up
            len := StrLen(String(value))
            SendMessage(0xB1, len, len, ctrl.Hwnd)  ; EM_SETSEL
        }

        ; 🔹 debounce global update
        if !HasProp(ctrl, "SpinTimer")
            ctrl.SpinTimer := (*) => (SpinCount := ctrl.Value)

        SetTimer(ctrl.SpinTimer, 0)
        SetTimer(ctrl.SpinTimer, -1000)
    }

    SpinGUI.Add("Text", "x" Round(5*ScaleX) " y+" Round(5*ScaleY) " w" Round(240*ScaleX) " Center BackgroundTrans c" p["divider"], "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    SetFixedFont(SpinGUI, 9, "norm", "Light")
    SpinGUI.Add("Text", "x" Round(20*ScaleX) " y+" Round(5*ScaleY) " w" Round(130*ScaleX) " c" p["textDim"], "🕓   Spin Runtime")
    SpinRunTime_UI := SpinGUI.Add("Text", "x" Round(150*ScaleX) " yp w" Round(80*ScaleX) " Right c" p["text"], "00:00")

    SpinGUI.Add("Text", "x" Round(20*ScaleX) " y+6 w" Round(130*ScaleX) " c" p["textDim"], "🎊   Spins Opened")
    SpinOpenCount_UI := SpinGUI.Add("Text", "x" Round(150*ScaleX) " yp w" Round(80*ScaleX) " Right c" p["text"], "0")

    SpinGUI.Add("Text", "x" Round(20*ScaleX) " y+6 w" Round(130*ScaleX) " c" p["textDim"], "🎁   Spins Remaining")
    SpinLeftCount_UI := SpinGUI.Add("Text", "x" Round(150*ScaleX) " yp w" Round(80*ScaleX) " Right c" p["text"], "0")

    ; ── Spin Mode Full Loop Checkbox ─────────
    isFullLoopEnabled := IsSet(SpinInFullLoop) ? SpinInFullLoop : false
    initColor := isFullLoopEnabled ? p["text"] : p["textDim"]
    initText  := isFullLoopEnabled ? "▰  FULL LOOP: INCLUDE" : "▱  FULL LOOP: EXCLUDE"

    SetFixedFont(SpinGUI, 9, "norm", "Light")
    SpinFullLoop_UI := SpinGUI.Add("Text", "x" Round(50*ScaleX) " y+12 w" Round(150*ScaleX) " h" Round(20*ScaleY) " Center 0x200 c" initColor, initText)
    SpinFullLoop_UI.State := isFullLoopEnabled
    
    ToggleSpinFullLoop(*) {
        global SpinInFullLoop
        SpinFullLoop_UI.State := !SpinFullLoop_UI.State
        SpinInFullLoop := SpinFullLoop_UI.State
        if (SpinInFullLoop) {
            SpinFullLoop_UI.Opt("c" p["text"])
            SpinFullLoop_UI.Text := "▰  FULL LOOP: INCLUDE"
        } else {
            SpinFullLoop_UI.Opt("c" p["textDim"])
            SpinFullLoop_UI.Text := "▱  FULL LOOP: EXCLUDE"
        }
        SpinFullLoop_UI.Redraw()

        WriteMacroIni("Settings", "SpinInFullLoop", SpinInFullLoop)
    }
    SpinFullLoop_UI.OnEvent("Click", ToggleSpinFullLoop)

    ; ── Spin Type Toggle (SUPER / REGULAR) ─────────
    if !IsSet(SpinType) || (SpinType != "SUPER" && SpinType != "REGULAR")
        SpinType := "SUPER" ; Default initialization fallback

    SetFixedFont(SpinGUI, 9, "bold", "Semibold")
    isSpinActive := (ActiveMode == "Spin")
    
    ; Determine background based on selection status OR whether macro is currently running
    SuperBtnBG   := isSpinActive ? p["inactiveBg"] : (SpinType = "SUPER" ? p["activeBg"] : p["inactiveBg"])
    RegularBtnBG := isSpinActive ? p["inactiveBg"] : (SpinType = "REGULAR" ? p["activeBg"] : p["inactiveBg"])
    TypeTextColor := isSpinActive ? p["textDim"] : p["text"]

    SuperBtn := SpinGUI.Add("Text", "x" Round(15*ScaleX) " y+12 w" Round(105*ScaleX) " h" Round(26*ScaleY) " Center 0x200 Background" SuperBtnBG " c" TypeTextColor, "✨  SUPER")
    RegularBtn := SpinGUI.Add("Text", "x" Round(130*ScaleX) " yp w" Round(105*ScaleX) " h" Round(26*ScaleY) " Center 0x200 Background" RegularBtnBG " c" TypeTextColor, "🎫  REGULAR")

    ChangeSpinType(Type, ActBtn, InactBtn) {
        global SpinType

        SpinType := Type
        ActBtn.Opt("Background" p["activeBg"]), ActBtn.Redraw()
        InactBtn.Opt("Background" p["inactiveBg"]), InactBtn.Redraw()
        WriteMacroIni("Settings", "SpinType", SpinType)
    }

    SuperBtn.OnEvent("Click", (*) => ChangeSpinType("SUPER", SuperBtn, RegularBtn))
    RegularBtn.OnEvent("Click", (*) => ChangeSpinType("REGULAR", RegularBtn, SuperBtn))

    ; ── Mode Selection Buttons (KEEP / SELL / GIFT) ─────────
    SetFixedFont(SpinGUI, 9, "bold", "Semibold")
    KeepBtnBG := SpinMode = "KEEP" ? p["activeBg"] : p["inactiveBg"]
    GiftBtnBG := SpinMode = "GIFT" ? p["activeBg"] : p["inactiveBg"]
    SellBtnBG := SpinMode = "SELL" ? p["activeBg"] : p["inactiveBg"]
    
    KeepBtn := SpinGUI.Add("Text", "x" Round(15*ScaleX) " y+12 w" Round(70*ScaleX) " h" Round(26*ScaleY) " Center 0x200 Background" KeepBtnBG " c" p["text"], "💾  KEEP")
    GiftBtn := SpinGUI.Add("Text", "x" Round(90*ScaleX) " yp w" Round(70*ScaleX) " h" Round(26*ScaleY) " Center 0x200 Background" GiftBtnBG " c" p["text"], "🎁  GIFT")
    SellBtn := SpinGUI.Add("Text", "x" Round(165*ScaleX) " yp w" Round(70*ScaleX) " h" Round(26*ScaleY) " Center 0x200 Background" SellBtnBG " c" p["text"], "🏷️  SELL")

    ChangeSpinMode(Mode, ActBtn, DM1, DM2) {
        global SpinMode
        SpinMode := Mode
        ActBtn.Opt("Background" p["activeBg"]), ActBtn.Redraw()
        DM1.Opt("Background" p["inactiveBg"]), DM1.Redraw()
        DM2.Opt("Background" p["inactiveBg"]), DM2.Redraw()
        
        WriteMacroIni("Settings", "SpinMode", SpinMode)
    }

    KeepBtn.OnEvent("Click", (*) => ChangeSpinMode("KEEP", KeepBtn, SellBtn, GiftBtn))
    GiftBtn.OnEvent("Click", (*) => ChangeSpinMode("GIFT", GiftBtn, KeepBtn, SellBtn))
    SellBtn.OnEvent("Click", (*) => ChangeSpinMode("SELL", SellBtn, KeepBtn, GiftBtn))

    ; ── Run Button ──
    SetFixedFont(SpinGUI, 10, "bold", "Semibold")
    SpinBtn := SpinGUI.Add("Text", "x" Round(15*ScaleX) " y+12 w" Round(220*ScaleX) " h" Round(35*ScaleY) " Center 0x200 Background" p["btnBg"] " c" p["btnText"], "🎲   RUN WHEELSPIN   =")
    SpinBtn.OnEvent("Click", (*) => StartSpin())

    sW := Round(250 * ScaleX)
    sH := Round(350 * ScaleY)
    
    MainGUI.GetPos(&mX, &mY, &mW, &mH)
    sX := mX + (mW // 2) - (sW // 2)
    sY := mY + (mH // 2) - (sH // 2)
    
    SpinGUI.Show("x" sX " y" sY " w" sW " h" sH)
}

SpinNav() {
    Scanned := ScanMenu()

    ; 1. Safety Check: Handle timeout immediately
    if (Scanned.menu == "") {
        Process("Navigation aborted: Menu could not be identified.")
        return 
    }

    ; 2. Define page movements needed to reach "My Horizon" from any tab
    FreeRoamNav := Map(
        "Free Roam Menu - Campaign",     { key: "PgDn", count: 2 },
        "Free Roam Menu - Cars",         { key: "PgDn", count: 1 },
        "Free Roam Menu - My Horizon",   { key: "",     count: 0 },
        "Free Roam Menu - Online",       { key: "PgUp", count: 1 },
        "Free Roam Menu - Creative Hub", { key: "PgUp", count: 2 },
        "Free Roam Menu - Store",        { key: "PgUp", count: 3 }
    )

    ; 3. State Normalization (Get everything into the Free Roam Menu state)
    switch Scanned.menu {
        case "Home Menu":
            Process("Navigating to Free Roam...")
            ShowNotif("info", "Spin Mode", "Home Menu detected!")
            PressKey("Esc") ; Return to Free Roam
            
            WaitForPixel("Returning to Free Roam...", 0.137, 0.950, "0xFFFFFF", , 20000, 1000)

            PressKey("Esc", 1000) ; Open Free Roam Menu (Lands on default Campaign tab)
            Scanned.submenu := "Free Roam Menu - Campaign"

        case "Free Roam":
            Process("Navigating to Free Roam Menu...")
            ShowNotif("info", "Spin Mode", "Free Roam detected!")
            PressKey("Esc", 1000) ; Open Free Roam Menu (Lands on default Campaign tab)
            Scanned.submenu := "Free Roam Menu - Campaign"
            
        case "Free Roam Menu":
            ; Already in the menu structure; Scanned.submenu is already accurately set by ScanMenu()
            ShowNotif("info", "Spin Mode", "Free Roam Menu detected!")
    }

    ; 4. Unified Tab Navigation Execution
    Process("Navigating to My Horizon Menu...")

    if FreeRoamNav.Has(Scanned.submenu) {
        nav := FreeRoamNav[Scanned.submenu]
        Loop nav.count {
            PressKey(nav.key, 100)
        }
        if nav.count = 0 {
            Process("Resetting the menu position...")
            PressKey("PgUp", 50)
            PressKey("PgDn", 50)
        }
    }
}