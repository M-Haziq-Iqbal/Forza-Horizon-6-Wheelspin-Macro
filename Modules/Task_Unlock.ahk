; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

StartUnlock() {
    global ActiveMode, StatusText, UnlockRunSeconds, SelectedCarPoint
    global SWheelCount_UI, WheelCount_UI, CreditCount_UI, UnlockRunTime_UI, CarsLabel_UI, CarCount_In, SkillPtsCount_In

    if FindGame() = 0
        return

    if !ToggleMode("Unlock") {
        StatusText.Value := "⬤  Stopping..."
        StatusText.SetFont("cFFB347")
    }
    
    StartIndicators()
    UpdateMiniWidgetMode(activeMode)
    if (ActiveMode = "Unlock") {
        UnlockRunSeconds       := 0
        SkillPtsScanSuccess := false
        CarCount_In.Value      := Floor(SkillPtsCount_In.Value / SelectedCarPoint)
        CarsLabel_UI.Value     := CarCount_In.Value

        SWheelCount_UI.Value   := "0"
        WheelCount_UI.Value    := "0"
        CreditCount_UI.Value   := "0 CR"
        UnlockRunTime_UI.Value := "00:00"

        MiniSWheelCount_UI.Value   := "0"
        MiniWheelCount_UI.Value    := "0"
        MiniCreditCount_UI.Value   := "0 CR"
        MiniUnlockRunTime_UI.Value := "00:00"

        UnlockRunTime_UI.SetFont("c" cHighlight)
        SetTimer(UnlockTimerTick, 1000)

        UnlockLoop()
    }

    ResetIndicators()
}

UnlockLoop() {
    global ActiveMode, MasterMode, SkillPtsScanSuccess
    global cActive, cHighlight, cIdle
    global SWheelCount_UI, WheelCount_UI, CreditCount_UI, UnlockRunTime_UI
    global SelectedCar, SelectedCarPoint, SkillPtsCount_In, CarCount_In

    global CarSorted := false

    UnlockCount    := 0
    SWheelCount    := 0
    WheelCount     := 0
    CreditCount    := 0
    NotiFreqInterv := 5
    CarMismatch    := false

    CheckAbort() => (ActiveMode != "Unlock" || (!MasterMode && MasterStart))

    While (ActiveMode = "Unlock") {

        Switch SelectedCar {
            Case "Subaru Impreza 22B-STi":
                SWheelCount_UI.SetFont("c" cHighlight)
            Case "Lamborghini Revuelto":
                SWheelCount_UI.SetFont("c" cHighlight)
                WheelCount_UI.SetFont("c" cHighlight)
            Case "Dodge Viper GTS ACR":
                CreditCount_UI.SetFont("c" cHighlight)
        }

        SetTimer(EmergencyUnlockCheck, 400)
        
        CarMenu := ScanOCR(0.060, 0.090, 0.156-0.060, 0.135-0.090)

        ; Check if currently in My Cars menu for custom starting point
        if !InStr(CarMenu, "My Cars", 0) {

            ; Initial Navigation
            Process("Navigating Home...")
            Loop 4
                PressKey("Up", 50) ; Navigate to Drive selection

            if CheckAbort()
                break

            if(!MasterMode && !SkillPtsScanSuccess && SkillPtsCount_In.Value = 0) {
                Process("Checking Available Skill Points..")
                PressKey("PgDn") ; Navigate to Buy & Sell Menu
                PressKey("PgDn") ; Navigate to Cars Menu
                PressKey("Down", 50) ; Navigate to Upgrades & Tuning
                PressKey("Enter", 800) ; Select Upgrades & Tuning
                Loop 7 
                    PressKey("Down", 50) ; Navigate to Car Mastery
                PressKey("Enter") ; Select Car Mastery

                if CheckAbort()
                    break
                
                Process("Scanning Skill Points...")
                points := SkillPtsScan(0.331, 0.851, 0.054, 0.033, 1500, 1500)

                if points != -1 {
                    SkillPtsScanSuccess := true
                }
                else {
                    SkillPtsScanSuccess := false
                    ShowNotif("fail", "Reward Unlock", "Unable to scan Current Skill Points amount. `nManual input required.")
                }

                if CheckAbort()
                    break            

                Process("Returning to Campaign Menu...")
                PressKey("Esc", 1500) ; Navigate to Upgrades Menu
                PressKey("Esc", 1500) ; Navigate to Cars Menu
                PressKey("PgUp", 50) ; Navigate to Buy & Sell Menu
                PressKey("PgUp") ; Navigate to Campaign Menu
            }
            
            CarCount_In.Value := Floor(SkillPtsCount_In.Value / SelectedCarPoint)
            if CarCount_In.Value > 0
                Switch SelectedCar {
                    Case "Subaru Impreza 22B-STi":
                        ShowNotif("info", "Reward Unlock", CarCount_In.Value " Super Wheelspins will be obtained." )
                        
                    Case "Lamborghini Revuelto":
                        ShowNotif("info", "Reward Unlock", CarCount_In.Value " Super Wheelspins and`n" CarCount_In.Value*3 " Wheelspins will be obtained." )
                        
                    Case "Dodge Viper GTS ACR":
                        ShowNotif("info", "Reward Unlock", FormatCommas(CarCount_In.Value*85400) " CR will be obtained.")
                }
            else {
                ShowNotif("error", "Reward Unlock", "Insufficient Skill Points")
                break
            }

            if CheckAbort()
                break
            
            PressKey("PgDn") ; Navigate to Buy & Sell Menu
            PressKey("Down", 50) ; Navigate to Auction House

            if CheckAbort()
                break
        
            Process("Navigating Auction House...")
            PressKey("Enter", 800) ; Select Auction House
            PressKey("Down", 50) ; Navigate to Start Auction
            PressKey("Enter", 800) ; Select Start Auction

            if CheckAbort()
                break
        
            Process("Sort by Recently Added...")
            PressKey("X") ; Sort
            Loop 6 
                PressKey("Down", 50) ; Navigate to Recently Added
            PressKey("Enter") ; Select Recently Added
            PressKey("Backspace") ; Jump to Recently Added
            PressKey("Enter") ; Select All Cars

            if CheckAbort()
                break
        }

        CarSorted := true

        Process("Choosing First Car...")
        PressKey("Enter", 800) ; Select First Car
        PressKey("Down") ; Navigate to Get in Car
        PressKey("Enter", 800) ; Select Get in Car

        if !WaitForPixel("Getting in Car...", 0.067, 0.169, "0xFFFFFF", "", 10000, 500) {
            Process("Sync Error: Unable to get in car!")
            break
        }

        if CheckAbort()
            break

        PressKey("Esc", 1500) ; Navigate to Auction House Menu
        PressKey("Esc", 1500) ; Navigate to Buy & Sell Menu

        if CheckAbort()
            break
    
        ; 4. Main Unlocking Loop
        Loop CarCount_In.Value {

            if CheckAbort()
                break
            
            Process("Navigating Upgrade...")
            PressKey("PgDn") ; Navigate to Cars Menu
            PressKey("Down", 50) ; Navigate to Upgrades & Tuning
            PressKey("Enter", 800) ; Select Upgrades & Tuning
            Loop 7 
                PressKey("Down", 50) ; Navigate to Car Mastery
            PressKey("Enter") ; Select Car Mastery

            if !WaitForPixel("Opening Car Mastery...", 0.176, 0.545, "0xFFFFFF", "", 3000, 100) {
                Process("Sync Error: Car Mastery menu failed to load!")
                break
            }
    
            if CheckAbort()
                break
    
            Process("Unlocking Car Mastery...")
            Switch SelectedCar {
                Case "Subaru Impreza 22B-STi":
                    PressKey("Enter", 1100)
                    PressKey("Right", 300)
                    Loop 3 {
                        PressKey("Enter", 1100)
                        PressKey("Up", 300)
                    }
                    PressKey("Enter", 1100)
                    PressKey("Left", 300)
                    PressKey("Enter", 1100)
    
                    UnlockCount++

                    SWheelCount := UnlockCount

                    SWheelCount_UI.Value := SWheelCount
                    MiniSWheelCount_UI.Value := SWheelCount

                    if Mod(UnlockCount, NotiFreqInterv) = 0
                        ShowNotif("info", "Reward Unlock", SWheelCount " Super Wheelspins have been obtained." )

                Case "Lamborghini Revuelto":
                    PressKey("Enter", 1100)
                    Loop 3 {
                        PressKey("Up", 300)
                        PressKey("Enter", 1100)
                    }
                    Loop 2 {
                        PressKey("Right", 300)
                        PressKey("Enter", 1100)
                    }
    
                    UnlockCount++
                    SWheelCount := UnlockCount
                    WheelCount := UnlockCount*3

                    SWheelCount_UI.Value := SWheelCount
                    WheelCount_UI.Value  := WheelCount
                    MiniSWheelCount_UI.Value := SWheelCount
                    MiniWheelCount_UI.Value  := WheelCount

                    if Mod(UnlockCount, NotiFreqInterv) = 0
                        ShowNotif("info", "Reward Unlock", SWheelCount " Super Wheelspins and`n" WheelCount " Wheelspins have been obtained." )
                    
                Case "Dodge Viper GTS ACR":
                    PressKey("Enter", 1100)
                    PressKey("Right", 300)
                    Loop 3 {   
                        PressKey("Enter", 1100)
                        PressKey("Up", 300)
                    }
                    PressKey("Enter", 1100)
                    PressKey("Right", 300)
                    PressKey("Enter", 1100)
    
                    UnlockCount++

                    CreditCount := UnlockCount*85400

                    CreditCount_UI.Value := FormatCommas(CreditCount) " CR"
                    MiniCreditCount_UI.Value := FormatCommas(CreditCount) " CR"

                    if Mod(UnlockCount, NotiFreqInterv) = 0
                        ShowNotif("info", "Reward Unlock", FormatCommas(CreditCount) " CR have been obtained.")
                
                Case "Mazda #123 Mad Mike 808":
                    Loop 2 {
                        PressKey("Enter", 1100)
                        PressKey("Right", 300)
                    }
                    Loop 3 {
                        PressKey("Enter", 1100)
                        PressKey("Up", 300)
                    }
                    PressKey("Enter", 1100)
    
                    UnlockCount++

                    SWheelCount := UnlockCount

                    SWheelCount_UI.Value := SWheelCount
                    MiniSWheelCount_UI.Value := SWheelCount

                    if Mod(UnlockCount, NotiFreqInterv) = 0
                        ShowNotif("info", "Reward Unlock", SWheelCount " Super Wheelspins have been obtained." )            
            }

            SkillPtsCount_In.Value -=  SelectedCarPoint
            SkillPtsWant_In.Value := Min(999 - SkillPtsCount_In.Value, MaxPoints)
    
            if CheckAbort()
                break
    
            Process("Navigating Home...")
            PressKey("Esc", 1500) ; Navigate to Upgrades Menu
            PressKey("Esc", 1500) ; Navigate to Cars Menu
            PressKey("PgUp") ; Navigate to Buy & Sell Menu
            PressKey("Down", 1000) ; Navigate to Auction House

            if CheckAbort()
                break
    
            Process("Navigating Auction House...")
            PressKey("Enter", 800) ; Select Auction House
            PressKey("Down") ; Navigate to Start Auction
            PressKey("Enter", 800) ; Select Start Auction
            
            if CheckAbort()
                break
    
            Process("Sort by Recently Added...")
            PressKey("X") ; Sort
            Loop 6 
                PressKey("Down", 50) ; Navigate to Recently Added
            PressKey("Enter") ; Select Recently Added

            if CheckAbort()
                break
    
            Process("Choosing Next Car...")
            PressKey("Down") ; Navigate to Next Car
            PressKey("Enter", 800) ; Select Next Car
            PressKey("Down") ; Navigate to Get in Car 
            PressKey("Enter", 800) ; Select Get in Car

            if !WaitForPixel("Getting in Car...", 0.067, 0.169, "0xFFFFFF", "", 10000, 500) {
                Process("Sync Error: Unable to get in car!")
                break
            }

            if CheckAbort()
                break
    
            Process("Removing Car From Garage...")
            PressKey("Up") ; Navigate to First Car
            PressKey("Enter") ; Select First Car
            Loop 5 
                PressKey("Down", 50) ; Navigate to Remove from Garage
            PressKey("Enter") ; Select Remove from Garage
            PressKey("Down") ; Navigate to Confirm
            PressKey("Enter", 1000) ; Confirm Remove from Garage

            if CheckAbort()
                break
    
            Process("Returning to Home...")
            PressKey("Esc", 1600) ; Navigate to Auction House Menu
            PressKey("Esc", 1600) ; Navigate to Buy & Sell Menu
            
            if CheckAbort()
                break
        }

        if CheckAbort()
            break

        Switch SelectedCar {
            Case "Subaru Impreza 22B-STi":
                ShowNotif("success", "Reward Unlock", SWheelCount " Super Wheelspins have been obtained." )
                
            Case "Lamborghini Revuelto":
                ShowNotif("success", "Reward Unlock", SWheelCount " Super Wheelspins and`n" WheelCount " Wheelspins have been obtained." )
                
            Case "Dodge Viper GTS ACR":
                ShowNotif("success", "Reward Unlock", FormatCommas(CreditCount) " CR have been obtained.")
        }

        ; if CarMismatch {
        ;     Process("Returning to Home...")
        ;     PressKey("Esc", 1600) ; Navigate to Auction House Menu
        ;     PressKey("Esc", 1600) ; Navigate to Buy & Sell Menu
        ; }
        
        PressKey("PgUp") ; Navigate to Campaign Menu
        SetTimer(EmergencyUnlockCheck, 0)
        break ;
    }
}

VerifyAuction(timeoutMs := 5000) {
    global ActiveMode, MasterMode, MasterStart, PixelMultiplier, GameTitle
    
    timeoutMs *= PixelMultiplier
    StartTime := A_TickCount
    
    Process("Safety Scan: 'Create Auction' menu...")

    Loop {
        ; 1. Standard emergency stops
        if ((ActiveMode != "Race" && ActiveMode != "Buy" && ActiveMode != "Unlock" && ActiveMode != "Spin") || (!MasterMode && MasterStart))
            return false
            
        if !WinExist(GameTitle)
            return false

        ; 2. Scan the dangerous UI area
        ocrText := ScanOCR(0.403, 0.373, 0.598 - 0.403, 0.425 - 0.373)

        ; 3. TRIPWIRE: If the phrase appears, IMMEDIATELY abort the macro
        if InStr(ocrText, "Create Auction") {
            Process("CRITICAL: 'Create Auction' detected! Aborting loop.")
            ShowNotif("error", "Accidental Sell Blocked", "Macro intercepted on a selling screen. Stopped safely.")
            return false ; Tell the main script to STOP
        }

        ; 4. SAFE ZONE: If 5 seconds pass and the tripwire was never hit, we are safe
        if (A_TickCount - StartTime > timeoutMs) {
            Process("Safety Check Passed: No forbidden text found.")
            return true ; Tell the main script it's safe to keep going
        }

        Sleep(400) ; Low CPU overhead throttle
    }
}

VerifyCar() {
    global SelectedCar, CarData, CarMismatch

    Process("Scanning the right car...")
    scannedCar := ScanOCR(0.080, 0.040, (0.290-0.080), (0.070-0.040), 1000)

    if CarData.Has(SelectedCar) {
        AltName := CarData[SelectedCar].AltName

        if !InStr(scannedCar, AltName, 0) {
            ShowNotif("error", "Reward Unlock", "The current car is not " AltName "!`nEmergency break!")
            CarMismatch := true
            return false
        }
    }
}

EmergencyUnlockCheck() {
    global GameTitle, ActiveMode, CarData, SelectedCar, CarSorted

    static StatsNum := 0
    
    ; Only scan if the macro is actively running and the game is open
    if (ActiveMode != "Unlock" || !WinExist(GameTitle))
        return

    MenuText := ScanOCR(0.362, 0.357,0.652-0.362, 0.449-0.357)
    if InStr(MenuText, "Create Auction") {
        ; 1. Kill the timer thread immediately
        SetTimer(, 0)
        
        ; 2. Sound the alarm
        SoundBeep(400, 500)
        
        ; 3. Flash a hard modal box to freeze all AHK execution paths
        MsgBox("CRITICAL SAFETY INTERCEPT!`n`nCreate Auction menu detected. Script has been reset to IDLE state to protect your account.", "MHI Emergency System", "IconX")
        
        ; 4. Vaporize the current thread and reset the macro back to its pristine default state
        Reload()
    }

    if !CarSorted {
        if InStr(MenuText, "Remove Car") {
            ; 1. Kill the timer thread immediately
            SetTimer(, 0)
            
            ; 2. Sound the alarm
            SoundBeep(400, 500)
            
            ; 3. Flash a hard modal box to freeze all AHK execution paths
            MsgBox("CRITICAL SAFETY INTERCEPT!`n`nRemove Car menu detected. Script has been reset to IDLE state to protect your account.", "MHI Emergency System", "IconX")
            
            ; 4. Vaporize the current thread and reset the macro back to its pristine default state
            Reload()
        }
    }

    if CarSorted {
        MenuText := ScanOCR(0.062, 0.092, 0.148-0.062, 0.132-0.092)
        if InStr(MenuText, "My Cars") {
            Loop {
                if SelectedCar = "Mazda #123 Mad Mike 808" {
                    StatsNumNew := ScanOCR(0.170, 0.455, 0.205-0.170, 0.700-0.455, , , true)
                } else {
                    StatsNumNew := ScanOCR(0.177, 0.457, 0.205-0.177, 0.707-0.457, , , true)
                }
                if StrLen(StatsNumNew) >= 10
                    StatsNum := StatsNumNew
                    break
            }

            if GetTextSimilarity(CarData[SelectedCar].StatsNum, StatsNum) <= 80 {
                ; 1. Kill the timer thread immediately
                SetTimer(, 0)
                
                ; 2. Sound the alarm
                SoundBeep(400, 500)
                
                ; 3. Flash a hard modal box to freeze all AHK execution paths
                MsgBox("CRITICAL SAFETY INTERCEPT!`n`nWrong car detected. Script has been reset to IDLE state to protect your account.", "MHI Emergency System", "IconX")
                
                ; 4. Vaporize the current thread and reset the macro back to its pristine default state
                Reload()
            }
        }
    }
}