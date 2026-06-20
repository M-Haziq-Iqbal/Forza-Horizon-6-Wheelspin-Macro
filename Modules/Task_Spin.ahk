; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║        Cyber Noir Edition v1.7.0        ║
; ╚═════════════════════════════════════════╝

#Requires AutoHotkey v2.0

global SpinCount    := 0

StartSpin() {
    
    global ActiveMode, StatusText, cActive, SpinCount, SpinOpenCount_UI, SpinLeftCount_UI, SpinRunTime_Ui, SpinRunSeconds
    
    if !ToggleMode("Spin") {
        StatusText.Value := "⬤  Stopping..."
        StatusText.SetFont("cFFB347")
    }

    StartIndicators()
    if (ActiveMode = "Spin") {
        SpinCount             := 0
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

    global SpinMode, LoopCount_In

    SpinToOpen      := LoopCount_In.Value
    SpinLeftCount   := 0
    SpinOpenCount   := 0
    RewardCount     := 0
    SpinType        := ""

    CheckAbort() => (ActiveMode != "Spin")

    if WaitForPixel("Checking Wheelspin type...", 0.121, 0.312, "0xC7FD05", , 1000, 50, true, 5, "Super Wheelspinning...")
        SpinType := "Super Wheelspin"
    else if WaitForPixel("Checking Wheelspin type...", 0.879, 0.462, "0xC9FE03", , 1000, 50, true, 5, "Wheelspinning...")
        SpinType := "Wheelspin"
    else
        return

    Process("Spinning...")
    PressKey("Enter") ; Enter Wheelspin

    if SpinType = "Super Wheelspin"
        SpinLeftCount   := ScanOCR(0.107, 0.622, 0.071, 0.052, 5000, , true)
    else if SpinType = "Wheelspin"
        SpinLeftCount   := ScanOCR(0.148, 0.624, 0.075, 0.054, 5000, , true)

    SpinLeftCount := SpinLeftCount = -1 ? SpinToOpen : SpinLeftCount

    While (ActiveMode = "Spin" && SpinLeftCount > 0)  {
        loop Min(SpinToOpen, SpinLeftCount) {
            Process("Skipping...")

            if ScanOCR(0.072, 0.916, 0.027, 0.034, 2000, "Skip")
                PressKey("Enter", 50) ; Skip`

            ; Rescan Wheelspin amount to avoid desync
            SpinOpenCount++
            if Mod(SpinOpenCount, 5) = 0 && SpinOpenCount > 0 {
                if SpinType = "Super Wheelspin"
                    SpinLeftCount   := ScanOCR(0.107, 0.622, 0.071, 0.052, 5000, , true)
                else if SpinType = "Wheelspin"
                    SpinLeftCount   := ScanOCR(0.148, 0.624, 0.075, 0.054, 5000, , true)
            }

            SpinOpenCount_UI.Value    := SpinOpenCount
            SpinLeftCount_UI.Value    := SpinLeftCount
            if (WaitForPixel("Collecting...", 0.058, 0.926, "0xFFFFFF", , 4000, 50, true, , "Collecting...")) {

                if Mod(SpinOpenCount, SpinToOpen) = 0 && SpinOpenCount > 0 {
                    PressKey("Esc", 50) ; Collect Prize
                } else {
                    PressKey("Enter", 50) ; Collect Prize and Spin Again
                }
            }
            
            while (RewardCount < 3) {
                if (WaitForPixel("Selling...", 0.450, 0.695, "0x000000", , 1000, 50, true, , "Info: No duplicate car found!")) {
                    if SpinMode = "SELL" {
                        PressKey("Down", 50)
                        PressKey("Down", 50)
                        PressKey("Enter", 50)
                    } else if SpinMode = "KEEP"{
                        PressKey("Enter", 50)
                    }
                } else {
                    break
                }
                RewardCount++
            }
            RewardCount := 0
            SpinLeftCount--

            if Mod(SpinOpenCount, SpinToOpen) = 0 && SpinOpenCount > 0 {
                break
            }

            if CheckAbort()
                break
        }
        PressKey("Esc", 1000) ; Return to Free Roam to avoid Inactivity Status
        
        WaitForPixel("Returning to Free Roam...", 0.137, 0.950, "0xFFFFFF", , 10000)

        Process("Navigating Menu...")
        PressKey("Esc", 1000) ; Open Menu
        PressKey("PgDn", 50) ; Navigate to Cars Menu
        PressKey("PgDn", 50) ; Navigate to My Horizon Menu
        
        if SpinType = "Super Wheelspin"
            PressKey("Left", 500) ; Navigate to Super Wheelspin
        else
            PressKey("Right", 500) ; Navigate to Wheelspin

        PressKey("Enter", 50)
    }
}