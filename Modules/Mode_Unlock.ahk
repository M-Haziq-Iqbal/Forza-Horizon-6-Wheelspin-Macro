; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

StartUnlock() {
    global ActiveMode, StatusText, UnlockRunSeconds, cHighlight
    global SWheelCount_UI, WheelCount_UI, CreditCount_UI, UnlockRunTime_UI
    global MiniSWheelCount_UI, MiniWheelCount_UI, MiniCreditCount_UI, MiniUnlockRunTime_UI
    global SuperBtn, RegularBtn
    global CarData, SelectedCar 
    global CustomCarCount, CarsToUnlock

    if FindGame() == 0
        return

    if !ToggleMode("Unlock") {
        StatusText.Value := "⬤  Stopping..."
        StatusText.SetFont("cFFB347")
    }

    if (ActiveMode != "Unlock")
        return

    if !CarData.Has(SelectedCar) {
        MsgBox("Error: Selected car '" SelectedCar "' not found in database.", "Error", 16)
        return
    }
    
    StartIndicators()
    UpdateMiniWidgetMode(ActiveMode)

    car := CarData[SelectedCar]

    if CustomCarCount
        CarsToUnlock := CarCount_In.Value
    else {
        CarsToUnlock := CarsToTarget
    }

    CarsLabel_UI.Value := CarsToUnlock

    if (CarsToUnlock <= 0) {
        if (CustomCarCount && !MasterMode) {
            ShowNotif("warning", "Unlock Mode", "Skipping Unlock Segment: No cars to unlock.", true)
            ResetIndicators()
            return
        }
    }

    UnlockRunSeconds := 0

    SWheelCount_UI.Value   := "0"
    WheelCount_UI.Value    := "0"
    CreditCount_UI.Value   := "0 CR"
    UnlockRunTime_UI.Value := "00:00"

    MiniSWheelCount_UI.Value   := "0"
    MiniWheelCount_UI.Value    := "0"
    MiniCreditCount_UI.Value   := "0 CR"
    MiniUnlockRunTime_UI.Value := "00:00"
    
    UnlockRunTime_UI.SetFont("c" cHighlight)
    if (car.UnlockSWheel > 0)
        SWheelCount_UI.SetFont("c" cHighlight)
    if (car.UnlockWheel > 0) 
        WheelCount_UI.SetFont("c" cHighlight)
    if (car.UnlockCredit > 0)
        CreditCount_UI.SetFont("c" cHighlight)

    SetTimer(UnlockTimerTick, 1000)

    DiscordStatusUpdate("info", "Unlock Mode Started", "Preparing Car Mastery...")
    UnlockLoop()
    DiscordStatusUpdate("success", "Unlock Mode Ended", "Preparing Car Mastery...")

    ResetIndicators()
}

UnlockLoop() {
    global TotalSWheel := 0
    global TotalWheel := 0
    global TotalCredit := 0
    global CarSorted := false
    global CarData, SelectedCar
    global CarsToUnlock, CustomCarCount
    global UnlockCount := 0

    car := CarData[SelectedCar]
    CheckAbort() {
        return ActiveMode != "Unlock" && !MasterMode
    }

    NotiFreqInterv  := 10
    UnlockStarted   := false
    
    Process("Starting Emergency Unlock Check", 500)
    SetTimer(EmergencyUnlockCheck, 400)

    CarMenu := ScanOCR(0.060, 0.090, 0.096, 0.045)

    if !InStr(CarMenu, "My Cars") {
        Process("Scanning Menu...")
        UnlockNav()
        
        StartRewardsText := BuildRewardString(
            CarsToUnlock * car.UnlockSWheel, 
            CarsToUnlock * car.UnlockWheel, 
            CarsToUnlock * car.UnlockCredit, 
            ""
        )

        if (CarsToUnlock > 0) {
            ShowNotif("info", "Unlock Mode", "Obtaining " StartRewardsText)
        } else {
            ShowNotif("error", "Unlock Mode", "Obtaining no reward. `nAborting UInlock Mode.", true)
            return
        }

        if CheckAbort()
            return

        Process("Navigating Auction House...", 500)
        PressKey("Down", 50)   ; Navigate to Auction House
        PressKey("Enter", 800) ; Select Auction House
        PressKey("Down", 50)   ; Navigate to Start Auction
        PressKey("Enter", 800) ; Select Start Auction

        if CheckAbort()
            return

        Process("Sort by Recently Added...")
        PressKey("X")
        Loop 6 
            PressKey("Down", 50) ; Navigate to Recently Added
        PressKey("Enter")         ; Select Recently Added
        PressKey("Backspace")     ; Jump to Recently Added
        PressKey("Enter")         ; Select All Cars

        if CheckAbort()
            return

        FilterByDuplicates()
    } 

    CarSorted := true
    CarVerifyCheck("Unlock Mode")

    Process("Choosing First Car...")
    PressKey("Enter", 800) ; Select First Car
    PressKey("Down", 50)   ; Navigate to Get in Car
    PressKey("Enter", 800) ; Select Get in Car

    WaitForPixel("Getting in Car...", 0.067, 0.169, "0xFFFFFF", "", 10000, 500)

    Process("Returning to Cars Menu...")
    PressKey("Esc", 1500) ; Navigate to Upgrades Menu
    PressKey("Esc", 1500) ; Navigate to Cars Menu

    if CheckAbort()
        return

    DiscordStatusUpdate("info", "Redeeming Car Mastery", "Consuming " SelectedCar)

    ; ── MAIN UNLOCKING LOOP ───────────────────────────────────────────────────
    Loop {
        if CheckAbort()
            break
        
        Process("Navigating to Cars...")
        PressKey("PgDn", 50) ; Navigate to Cars Menu

        Process("Navigating to Upgrades & Tuning...", 500)
        PressKey("Down", 50)   ; Navigate to Upgrades & Tuning
        PressKey("Enter", 800) ; Select Upgrades & Tuning
        Loop 8 ; Extra Down for safety
            PressKey("Down", 50) ; Navigate to Car Mastery
        PressKey("Enter", 800) ; Select Car Mastery

        if CheckAbort()
            return

        SkillPtsCount := SkillPtsCount_In.Value

        if !UnlockStarted {
            if (!SkillPtsScanSuccess && !SkillPtsCount && !CustomCarCount) {        
                Process("Scanning Skill Points...")
                UnlockSkillPtsScan(0.331, 0.851, 0.054, 0.033, "Home")
            }
            
            if (CarsToUnlock > 0) {
                StartRewardsText := BuildRewardString(
                    CarsToUnlock * car.UnlockSWheel, 
                    CarsToUnlock * car.UnlockWheel, 
                    CarsToUnlock * car.UnlockCredit, 
                    ""
                )
                ShowNotif("info", "Unlock Mode", "Obtaining " StartRewardsText)
            } else {
                ShowNotif("error", "Unlock Mode", "Obtaining 0 rewards. `nAborting Unlock Mode.", true)
                Process("Returning to Campaign Menu...")
                PressKey("Esc", 1500) ; Navigate to Upgrades Menu
                PressKey("Esc", 1500) ; Navigate to Cars Menu
                PressKey("PgUp", 50)  ; Navigate to Buy & Sell Menu
                PressKey("PgUp", 50)  ; Navigate to Campaign
                return
            }

            if CheckAbort()
                return

            UnlockStarted := true
        }

        WaitForPixel("Opening Car Mastery...", 0.176, 0.545, "0xFFFFFF", "0xFF0088", 5000, 100)

        UnlockedCar := false
        EndGrid := ""

        if (CarData[SelectedCar].AltName = "1974 Mazda")
            EndGrid := GetPixelColor(0.298, 0.222)

        if (EndGrid = "0xFF0088") {
            ShowNotif("warning", "Unlock Mode", "Mastery perk has been fully unlocked. `nChoosing the next car.")
            UnlockedCar := true
        } else if (EndGrid = "0xFFFFFF") {
            ShowNotif("warning", "Unlock Mode", "Mastery perk has been partially unlocked. `nResetting the grid starting position.")
            Process("Resetting the Car Mastery position")
            Loop 4 
                PressKey("Down", 10)
            Loop 4 
                PressKey("Left", 10)
        }

        if !UnlockedCar {
            Process("Unlocking Car Mastery...")
            if (UnlockCar() = false) {
                PressKey("Enter")      ; Select Ok (Cannot Afford Perk)
                PressKey("Esc", 1500)  ; Navigate to Upgrades
                PressKey("Esc", 1500)  ; Navigate to Home - Cars
                PressKey("PgUp")       ; Navigate to Home - Buy & Sell
                break
            }

            UnlockCount++

            TotalSWheel += car.UnlockSWheel
            TotalWheel  += car.UnlockWheel
            TotalCredit += car.UnlockCredit

            if (car.UnlockSWheel > 0) {
                SWheelCount_UI.Value := TotalSWheel
                MiniSWheelCount_UI.Value := TotalSWheel
            }
            if (car.UnlockWheel > 0) {
                WheelCount_UI.Value := TotalWheel
                MiniWheelCount_UI.Value := TotalWheel
            }
            if (car.UnlockCredit > 0) {
                CreditCount_UI.Value := FormatCommas(TotalCredit) " CR"
                MiniCreditCount_UI.Value := FormatCommas(TotalCredit) " CR"
            }

            if (Mod(UnlockCount, NotiFreqInterv) == 0) {
                PeriodicRewardsText := BuildRewardString(TotalSWheel, TotalWheel, TotalCredit, " obtained.")
                ShowNotif("info", "Unlock Mode", PeriodicRewardsText)
            }
            
            CarsToUnlock -= 1
            SkillPtsCount -= CarData[SelectedCar].SkillPtsCost
            SkillPtsWant := Min(999 - SkillPtsCount_In.Value, MaxPoints)
            
            SkillPtsCount_In.Value := SkillPtsCount
            SkillPtsWant_In.Value := SkillPtsWant
            CarCount_In.Value := CarsToUnlock

            if CheckAbort()
                break            
        }

        Process("Navigating Home...")
        PressKey("Esc", 1500) ; Navigate to Upgrades
        PressKey("Esc", 1500) ; Navigate to Home - Cars
        PressKey("PgUp")      ; Navigate to Home - Buy & Sell
        PressKey("Down", 1000) ; Navigate to Auction House

        if CheckAbort()
            break

        Process("Navigating Auction House...")
        PressKey("Enter", 800) ; Select Auction House
        PressKey("Down")       ; Navigate to Start Auction
        PressKey("Enter", 800) ; Select Start Auction
            
        if CheckAbort()
            break

        Process("Sort by Recently Added...")
        PressKey("X") ; Sort
        Loop 6 
            PressKey("Down", 50) ; Navigate to Recently Added
        PressKey("Enter")         ; Select Recently Added

        FilterByDuplicates()

        if CheckAbort()
            break

        Process("Choosing Next Car...")
        PressKey("Down") ; Navigate to Next Car

        CarVerifyCheck("Unlock Mode")

        PressKey("Enter", 800) ; Select Next Car
        PressKey("Down", 50)   ; Navigate to Get in Car 
        PressKey("Enter", 800) ; Select Get in Car

        WaitForPixel("Getting in Car...", 0.067, 0.169, "0xFFFFFF", "", 10000, 500)

        if CheckAbort()
            break

        Process("Removing Car From Garage...")
        PressKey("Up") ; Navigate to First Car

        CarVerifyCheck("Unlock Mode")

        PressKey("Enter") ; Select First Car
        Loop 5 
            PressKey("Down", 50) ; Navigate to Remove from Garage
        PressKey("Enter")         ; Select Remove from Garage
        PressKey("Down")          ; Navigate to Confirm
        PressKey("Enter", 1000)   ; Confirm Remove from Garage

        if CheckAbort()
            break

        Process("Returning to Home...")
        PressKey("Esc", 1600) ; Navigate to Auction House Menu
        PressKey("Esc", 1600) ; Navigate to Home - Buy & Sell

        if (CarsToUnlock = 0)
            break
    }

    FinalRewardsText := BuildRewardString(TotalSWheel, TotalWheel, TotalCredit, " obtained.")
    ShowNotif("success", "Unlock Mode", FinalRewardsText, true)

    PressKey("PgUp") ; Navigate to Home - Campaign
    SetTimer(EmergencyUnlockCheck, 0)
}

BuildRewardString(sWheel, wheel, credit, executionSuffix) {
    car := CarData[SelectedCar]
    msgParts := []
    
    if (car.UnlockSWheel > 0)
        msgParts.Push(sWheel " Super Wheelspins")
    if (car.UnlockWheel > 0)
        msgParts.Push(wheel " Wheelspins")
    if (car.UnlockCredit > 0)
        msgParts.Push(FormatCommas(credit) " CR")
        
    compiledMessage := ""
    for idx, text in msgParts
        compiledMessage .= (idx == 1 ? "" : " and`n") . text
        
    return compiledMessage . executionSuffix
}

UnlockCar() {
    PressKey("Enter", 1100)
    for , step in CarData[SelectedCar].UnlockPath {
        keyName    := step[1]
        pressCount := step[2]
        
        Loop pressCount {
            PressKey(keyName, 300)
            PressKey("Enter", 0)

            if ScanOCR(0.388, 0.424, 0.625-0.388, 0.476-0.424, 1000, "Cannot Afford Perk", , false)
                return false
        }
    }
}

EmergencyUnlockCheck() {
    if (ActiveMode != "Unlock" || !WinExist(GameTitle))
        return

    MenuText := ScanOCR(0.362, 0.357, 0.290, 0.092)
    
    if InStr(MenuText, "Create Auction")
        EmergencyExit("Create Auction Menu detected.")

    if (!CarSorted && InStr(MenuText, "Remove Car"))
        EmergencyExit("Remove Car Menu detected.")

    SubMenuText := ScanOCR(0.062, 0.092, 0.086, 0.040)
    
    if InStr(SubMenuText, "Car Pass")
        EmergencyExit("Car Pass Menu detected.")
}

UnlockNav() {
    global CarData, SelectedCar

    FreeRoamNav := Map(
        "Free Roam Menu - Campaign",     { key: "PgDn", count: 1 },
        "Free Roam Menu - Cars",         { key: "",     count: 0 },
        "Free Roam Menu - My Horizon",   { key: "PgUp", count: 1 },
        "Free Roam Menu - Online",       { key: "PgUp", count: 2 },
        "Free Roam Menu - Creative Hub", { key: "PgUp", count: 3 },
        "Free Roam Menu - Store",        { key: "PgUp", count: 4 }
    )

    HomeNav := Map(
        "Home Menu - Campaign",             { key: "PgDn", count: 1 },
        "Home Menu - Buy & Sell",           { key: "",     count: 0 },
        "Home Menu - Cars",                 { key: "PgUp", count: 1 },
        "Home Menu - Customizable Garage",  { key: "PgUp", count: 2 },
        "Home Menu - Character",            { key: "PgUp", count: 3 }
    )

    Scanned := ScanMenu()

    if (Scanned.menu == "") {
        Process("Navigation aborted: Menu could not be identified.")
        return 
    }

    switch Scanned.menu {
        case "Home Menu":
            ShowNotif("info", "Unlock Mode", "Home Menu detected!")

        case "Free Roam":
            Process("Navigating to Free Roam Menu...")
            ShowNotif("info", "Unlock Mode", "Free Roam detected!")
            PressKey("Esc", 1000) 
            Scanned.submenu := "Free Roam Menu - Campaign"
            
        case "Free Roam Menu":
            ShowNotif("info", "Unlock Mode", "Free Roam Menu detected!")
    }

    Process("Navigating to Cars Menu...")
    if FreeRoamNav.Has(Scanned.submenu) {
        nav := FreeRoamNav[Scanned.submenu]
        Loop nav.count {
            PressKey(nav.key, 100)
        }
        
        Process("Scanning Skill Points")
        points := UnlockSkillPtsScan(0.280, 0.698, (0.437-0.280), (0.756-0.698), "Free Roam")
        if points < CarData[SelectedCar].SkillPtsCost
            return
        
        Process("Navigating to My Horizon Menu...")
        PressKey("PgDn")  ; Navigate to My Horizon Menu
        PressKey("Enter") ; Select Return Home
        PressKey("Enter") ; Confirm Travel to Home
        WaitForPixel("Returning to Home...", 0.168, 0.722, "0xFFFFFF", "", 20000)

        Process("Navigating to Home Menu - Buy & Sell...")
        PressKey("PgDn") ; Navigate to Buy & Sell
    }
    
    Process("Navigating to Home Menu - Buy & Sell...")
    if HomeNav.Has(Scanned.submenu) {
        nav := HomeNav[Scanned.submenu]
        Loop nav.count {
            PressKey(nav.key, 100)
        }
        Sleep(500)
        if (nav.count = 0) {
            Process("Resetting the menu position...")
            Loop 4
                PressKey("Up", 50)
        }
    }
}

FilterByDuplicates() {
    Process("Filter Cars by Duplicates...")
    PressKey("y") ; Filter
    Loop 2
        PressKey("Down", 50) ; Navigate to Duplicates
    PressKey("Enter", 50)   ; Check Duplicates
    PressKey("Esc")         ; Return to All Cars
}

; ══════════════════════════════════════════════
;  OCR TELEMETRY ENGINE WITH SYSTEM STATE HOOK
; ══════════════════════════════════════════════

UnlockSkillPtsScan(ratioX, ratioY, ratioW, ratioH, menu := "", waitTime := 3000) {
    global SkillPtsCount_In, SkillPtsWant_In, ActiveMode, MaxPoints
    global SkillPtsCount, SkillPtsWant, SkillPtsScanSuccess

    ; Run OCR Scan
    points := ScanOCR(ratioX, ratioY, ratioW, ratioH, waitTime, , true)
    
    ; Clean up data (Extracts first 3 digits if string, otherwise handles -1)
    if points != -1
        points := Integer(SubStr(String(points), 1, 3))

    SkillPtsScanSuccess := (points != -1)

    ; 3. Handle Notifications & Base Count Assignment
    if (SkillPtsScanSuccess) {
        SkillPtsCount := points
        ShowNotif("info", ActiveMode " Mode", SkillPtsCount " Skill Points detected.", true)
    } else {
        EmergencyExit("Skill Points not detected: `nManual input required.")
    }

    SkillPtsWant := Min(999 - SkillPtsCount, MaxPoints)
    SkillPtsWant_In.Value  := SkillPtsWant

    UpdateSystemState(SkillPtsCount, SkillPtsWant)

    SkillPtsCount_In.Value := SkillPtsCount

    TimeTotal    := CalcTimeUnlock(CarsToUnlock) + (SpinInFullLoop ? CalcTimeSpin(CarsToUnlock) : 0)
    TimeLabel_UI.Value     := Format("{:02}:{:02}", Floor(TimeTotal), Floor((TimeTotal - Floor(TimeTotal)) * 60))

    return points
}