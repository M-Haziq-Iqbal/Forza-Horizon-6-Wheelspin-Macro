; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

StartSpin() {
    global ActiveMode, StatusText, cActive, SpinRunSeconds
    global SpinOpenCount_UI, SpinLeftCount_UI, SpinRunTime_UI

    if FindGame() = 0
        return
    
    if !ToggleMode("Spin") {
        StatusText.Value := "⬤  Stopping..."
        StatusText.SetFont("cFFB347")
    }

    StartIndicators()
    if (ActiveMode = "Spin") {
        SpinRunSeconds        := 0
        SpinOpenCount_UI.Value    := "0" 
        SpinLeftCount_UI.Value    := "0"  
        SpinRunTime_UI.Value  := "00:00"
        
        SpinRunTime_UI.SetFont("c" cHighlight)
        SpinLeftCount_UI.SetFont("c" cHighlight)
        SpinOpenCount_UI.SetFont("c" cHighlight)
        SetTimer(SpinTimerTick, 1000)
        SpinLoop()
    }
    ResetIndicators()
}

SpinLoop() {

    global SpinMode, SpinLoop_In, SpinWants_In
    
    SpinToOpen      := SpinLoop_In.Value
    SpinLeftTotal   := SpinWants_In.Value
    SpinLeftCount   := 0
    SpinOpenCount   := 0
    SpinType        := ""

    CheckAbort() => (ActiveMode != "Spin")

    if WaitForPixel("Checking Wheelspin type...", 0.123, 0.479, "0x000000", , 1000, 50, true, , "0", 25)
        SpinType := "Super Wheelspin"
    else if WaitForPixel("Checking Wheelspin type...", 0.876, 0.483, "0x000000", , 1000, 50, true, , "0", 25)
        SpinType := "Wheelspin"

    If (SpinType = "") {
        MsgBox("No Wheelspin detected. Please ensure you have a Wheelspin or Super Wheelspin available.")
        ToggleMode("Spin")
        return
    }

    ShowNotif("info", SpinType = "Super Wheelspin" ? "Super Wheelspin" : "Wheelspin", "Starting Spin Macro...")

    Process("Spinning...")
    PressKey("Enter") ; Enter Wheelspin

    if SpinType = "Super Wheelspin"
        SpinLeftCount   := ScanOCR(0.107, 0.622, 0.071, 0.052, 3000, , true)
    else if SpinType = "Wheelspin"
        SpinLeftCount   := ScanOCR(0.148, 0.624, 0.075, 0.054, 3000, , true)

    SpinLeftCount := SpinLeftCount = -1 ? SpinToOpen : SpinLeftCount

    While (ActiveMode = "Spin" && SpinLeftCount > 0 && SpinLeftTotal > 0) {
        loop Min(SpinToOpen, SpinLeftCount) {            
            Process("Skipping...")

            if InStr(ScanOCR(0.071, 0.915, 0.110-0.070, 0.945-0.915, 2000), "S", 0)
                PressKey("Enter", 50) ; Skip`

            if CheckAbort()
                break

            SpinOpenCount++
            SpinLeftCount--
            SpinLeftTotal--
            
            ; Rescan Wheelspin amount to avoid desync
            if Mod(SpinOpenCount, 5) = 0 {
                if SpinType = "Super Wheelspin"
                    spin := ScanOCR(0.107, 0.622, 0.071, 0.052, 2000, , true)
                else if SpinType = "Wheelspin"
                    spin := ScanOCR(0.148, 0.624, 0.075, 0.054, 2000, , true)
                SpinLeftCount := spin = -1 ? SpinLeftCount : spin
            }

            if CheckAbort()
                break

            SpinOpenCount_UI.Value    := SpinOpenCount
            SpinLeftCount_UI.Value    := SpinLeftCount
            Process("Collecting...")
            if InStr(ScanOCR(0.071, 0.915, 0.110-0.070, 0.945-0.915, 4000), "C") {
            ; if (WaitForPixel("Collecting...", 0.058, 0.926, "0xFFFFFF", , 4000, 50, true, , 0)) {
                if Mod(SpinOpenCount, SpinToOpen) = 0 || SpinLeftTotal = 0{
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
                    else if SpinMode = "KEEP"
                        PressKey("Enter", 50)
                } 
                else
                    break
            }

            if SpinLeftTotal = 0
                break

            if CheckAbort()
                break
        }
        Process("Returning to Free Roam...", 1000)
        PressKey("Esc", 1000) ; Return to Free Roam to avoid Inactivity Status
        
        WaitForPixel("Returning to Free Roam...", 0.137, 0.950, "0xFFFFFF", , 10000)

        if SpinLeftTotal = 0
            break

        if CheckAbort()
            break

        Process("Navigating Menu...")
        PressKey("Esc", 1000) ; Open Menu
        PressKey("PgDn", 50) ; Navigate to Cars Menu
        PressKey("PgDn", 50) ; Navigate to My Horizon Menu

        if CheckAbort()
            break
        
        if SpinType = "Super Wheelspin"
            PressKey("Left", 500) ; Navigate to Super Wheelspin
        else
            PressKey("Right", 500) ; Navigate to Wheelspin

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