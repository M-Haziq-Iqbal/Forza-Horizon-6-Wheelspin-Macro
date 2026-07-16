; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

StartBuy() {
    global ActiveMode, StatusText, BuyRunSeconds
    global SpinOpenCount_UI, SpinLeftCount_UI, SpinRunTime_UI
    global CarCount_UI, BuyRunTime_UI
    global MiniCarCount_UI, MiniBuyRunTime_UI
    global SuperBtn, RegularBtn
    global CarData, SelectedCar
    global CustomCarCount, CarsToBuy

    if (FindGame() = 0)
        return

    if !ToggleMode("Buy") {
        StatusText.Value := "⬤  Stopping..."
        StatusText.SetFont("cFFB347")
    }

    if (ActiveMode != "Buy")
        return

    if !CarData.Has(SelectedCar) {
        MsgBox("Error: Selected car '" SelectedCar "' not found in database.", "Error", 16)
        return
    }
    
    StartIndicators()
    UpdateMiniWidgetMode(ActiveMode)

    car := CarData[SelectedCar]

    if CustomCarCount
        CarsToBuy := CarCount_In.Value
    else {
        CarsToBuy := Floor(SkillPtsCount / car.SkillPtsCost)
        CarCount_In.Value := CarsToBuy
    }

    CarsLabel_UI.Value := CarsToBuy

    if (CarsToBuy <= 0) {
        if (CustomCarCount && !MasterMode) {
            ShowNotif("warning", "Buy Mode", "Skipping Buy Segment: No cars purchased.", true)
            ResetIndicators()
            return
        }
    }

    BuyRunSeconds := 0
    
    CarCount_UI.Value       := "0"
    BuyRunTime_UI.Value     := "00:00"
    MiniCarCount_UI.Value   := "0"
    MiniBuyRunTime_UI.Value := "00:00"

    CarCount_UI.SetFont("c" cHighlight)
    BuyRunTime_UI.SetFont("c" cHighlight)
    
    SetTimer(BuyTimerTick, 1000)
    DiscordStatusUpdate("info", "Buy Mode Started", "Acquiring: " SelectedCar)
    BuyLoop()
    DiscordStatusUpdate("success", "Buy Mode Ended", "Acquired: " SelectedCar)

    ResetIndicators()
}

BuyLoop() {
    global SkillPtsCount, SkillPtsCount_In
    global CarsToBuy, CustomCarCount
    global CarData, SelectedCar
    
    global BuyCount := 0

    car := CarData[SelectedCar]

    CheckAbort() {
        return ActiveMode != "Buy" && !MasterMode
    }

    Process("Scanning Menu...")
    BuyNav()

    SkillPtsCount := SkillPtsCount_In.Value

    ; ── SCAN SKILL POINTS IF NEEDED ───────────────────────────────────────
    if (!SkillPtsScanSuccess && !SkillPtsCount && !CustomCarCount) {
        Process("Checking Available Skill Points..")
        PressKey("PgDn")       ; Navigate to Buy & Sell Menu
        PressKey("PgDn")       ; Navigate to Cars Menu
        PressKey("Down", 50)   ; Navigate to Upgrades & Tuning
        PressKey("Enter", 800) ; Select Upgrades & Tuning
        
        Loop 7 
            PressKey("Down", 50) ; Navigate to Car Mastery
        PressKey("Enter")      ; Select Car Mastery

        if CheckAbort()
            return

        Process("Scanning Skill Points...")
        BuySkillPtsScan(0.331, 0.851, 0.054, 0.033, "Home")
            
        Process("Returning to Campaign Menu...")
        PressKey("Esc", 1500)  ; Navigate to Upgrades Menu
        PressKey("Esc", 1500)  ; Navigate to Cars Menu
        PressKey("PgUp", 50)   ; Navigate to Buy & Sell Menu
        PressKey("PgUp")       ; Navigate to Campaign Menu
    }

    if (CarsToBuy > 0) {
        ShowNotif("info", "Buy Mode", "Purchasing " CarCount_In.Value " " SelectedCar "`nIncludes one extra car as a safeguard.")
    } else {
        ShowNotif("error", "Buy Mode", "Purchasing 0 " SelectedCar "`nAborting Buy Mode.", true)
        return
    }

    ; ── NAVIGATE JOURNAL ──────────────────────────────────────────────────
    Process("Navigating Journal...")
    Loop 3
        PressKey("Up", 50)     ; Navigate to Drive
    PressKey("Down", 50)       ; Navigate to Collection Journal
    PressKey("Enter", 650)     ; Select Collection Journal
    PressKey("Right")          ; Navigate to Master Explorer
    PressKey("Enter", 650)     ; Select Master Explorer
    PressKey("Down")           ; Navigate to Car Collection
    PressKey("Enter", 650)     ; Select Car Collection
    PressKey("Backspace")      ; Select Manufacturers
    
    if CheckAbort()
        return

    NavigateToCar(SelectedCar)

    if CheckAbort()
        return

    ; ── BUYING CAR ────────────────────────────────────────────────────────
    Process("Buying " SelectedCar "...")
    PressKey("Enter")          ; Select Car

    EmergencyBuyCheck()

    targetCount := CarCount_In.Value + 1

    DiscordStatusUpdate("info", "Acquiring Cars", targetCount " " SelectedCar " targeted")
    Loop {
        PressKey("Space")      ; Purchase Car
        PressKey("Down")       ; Navigate to Yes
        PressKey("Enter")      ; Select Yes (Car Collection)
        PressKey("Enter")      ; Select Yes (Buy Car)
        PressKey("Enter")      ; Select Yes (Ok)
        
        ; Live Operation Runtime Telemetry Updates
        BuyCount++
        CarCount_UI.Value := BuyCount
        MiniCarCount_UI.Value := BuyCount

        if BuyCount >= targetCount
            break

        if CheckAbort()
            break
    }
    
    ShowNotif("success", "Buy Mode", BuyCount " " SelectedCar " purchased.", true)

    if CheckAbort()
        return

    ; ── RETURN TO HOME ────────────────────────────────────────────────────
    Process("Returning to Home...")
    Loop 4
        PressKey("Esc")        ; Navigate to Home Menu
    Sleep(500)
    PressKey("Up")             ; Navigate to Drive
    return
}

NavigateToCar(SelectedCar) {
    if !CarData.Has(SelectedCar) {
        MsgBox("Error: Selected car '" SelectedCar "' not found in database.", "Error", 16)
        return
    }
    
    car := CarData[SelectedCar]
    ExecutePath(car.BuyMfrPath) ; 1. Navigate to the Manufacturer
    PressKey("Enter")           ; 2. Enter the Manufacturer's menu
    ExecutePath(car.BuyCarPath) ; 3. Navigate to the specific car
}

ExecutePath(pathArray) {
    if (!IsObject(pathArray) || pathArray == "")
        return

    for , step in pathArray {
        keyName    := step[1]  
        pressCount := step[2]  
        Loop pressCount {
            PressKey(keyName, 50)
        }
    }
}

EmergencyBuyCheck() {
    ScannedCar := ScanOCR(0.254, 0.607, 0.446 - 0.254, 0.672 - 0.607) 

    if (!InStr(ScannedCar, CarData[SelectedCar].AltName) && !InStr(ScannedCar, SelectedCar)) {
        EmergencyExit("Selected Car does not match scanned car name.")
    }
}

BuyNav() {
    global CarData, SelectedCar

    Scanned := ScanMenu()

    if (Scanned.menu == "") {
        Process("Navigation aborted: Menu could not be identified.")
        return 
    }

    FreeRoamNav := Map(
        "Free Roam Menu - Campaign",     { key: "PgDn", count: 1 },
        "Free Roam Menu - Cars",         { key: "",     count: 0 },
        "Free Roam Menu - My Horizon",   { key: "PgUp", count: 1 },
        "Free Roam Menu - Online",       { key: "PgUp", count: 2 },
        "Free Roam Menu - Creative Hub", { key: "PgUp", count: 3 },
        "Free Roam Menu - Store",        { key: "PgUp", count: 4 }
    )

    HomeNav := Map(
        "Home Menu - Campaign",             { key: "",     count: 0 },
        "Home Menu - Buy & Sell",           { key: "PgUp", count: 1 },
        "Home Menu - Cars",                 { key: "PgUp", count: 2 },
        "Home Menu - Customizable Garage",  { key: "PgUp", count: 3 },
        "Home Menu - Character",            { key: "PgUp", count: 4 }
    )

    switch Scanned.menu {
        case "Home Menu":
            ShowNotif("info", "Buy Mode", "Home Menu detected.")

        case "Free Roam":
            Process("Navigating to Free Roam Menu...")
            ShowNotif("info", "Buy Mode", "Free Roam detected!")
            PressKey("Esc", 1000) 
            Scanned.submenu := "Free Roam Menu - Campaign"
            
        case "Free Roam Menu":
            ShowNotif("info", "Buy Mode", "Free Roam Menu detected!")
    }

    Process("Navigating to Free Roam Menu - Cars...")
    if FreeRoamNav.Has(Scanned.submenu) {
        nav := FreeRoamNav[Scanned.submenu]
        Loop nav.count {
            PressKey(nav.key, 100)
        }

        Process("Scanning Skill Points...")
        points := BuySkillPtsScan(0.280, 0.698, 0.157, 0.058, "Free Roam")
        if points < CarData[SelectedCar].SkillPtsCost
            return

        Process("Navigating to My Horizon Menu...")
        PressKey("PgDn")    ; Navigate to My Horizon Menu
        PressKey("Enter")   ; Select Return Home
        PressKey("Enter")   ; Confirm Travel to Home
        WaitForPixel("Returning to Home...", 0.168, 0.722, "0xFFFFFF", , 20000)
    }
    
    Process("Navigating to Home Menu - Campaign...")
    if HomeNav.Has(Scanned.submenu) {
        nav := HomeNav[Scanned.submenu]
        Loop nav.count {
            PressKey(nav.key, 100)
        }
        Sleep(500)
        if (nav.count == 0) {
            Process("Resetting the menu position...")
            Loop 4
                PressKey("Up", 50)
        }
    }
}

; ══════════════════════════════════════════════
;  OCR TELEMETRY ENGINE WITH SYSTEM STATE HOOK
; ══════════════════════════════════════════════

BuySkillPtsScan(ratioX, ratioY, ratioW, ratioH, menu := "", waitTime := 3000) {
    global SkillPtsCount_In, SkillPtsWant_In, ActiveMode, MaxPoints
    global SkillPtsCount, SkillPtsWant, SkillPtsScanSuccess

    ; Run OCR Scan
    points := ScanOCR(ratioX, ratioY, ratioW, ratioH, waitTime, , true)
    
    ; Clean up data (Extracts first 3 digits if string, otherwise handles -1)
    if points != -1
        points := Integer(SubStr(String(points), 1, 3))

    global SkillPtsScanSuccess := (points != -1)

    ; Handle Notifications & Base Count Assignment
    if SkillPtsScanSuccess {
        SkillPtsCount := points
        ShowNotif("info", ActiveMode " Mode", SkillPtsCount " Skill Points detected.", true)
    } else {
        EmergencyExit("Skill Points not detected: `nManual input required.")
    }

    SkillPtsWant := Min(999 - SkillPtsCount, MaxPoints)
    SkillPtsWant_In.Value := SkillPtsWant

    UpdateSystemState(SkillPtsCount, SkillPtsWant)

    SkillPtsCount_In.Value := SkillPtsCount

    TimeTotal    := CalcTimeBuy(CarsToBuy) + CalcTimeUnlock(CarsToUnlock) + (SpinInFullLoop ? CalcTimeSpin(CarsToUnlock) : 0)
    TimeLabel_UI.Value     := Format("{:02}:{:02}", Floor(TimeTotal), Floor((TimeTotal - Floor(TimeTotal)) * 60))

    return points
}