; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

StartRace() {
    global ActiveMode, StatusText, cActive, TotalRunSeconds, RaceRunSeconds, PointsGain
    global RaceRunTime_UI, PointsCount_UI, SectorCount_UI
    global SkillPtsCount_In, SkillPtsWant_In, CarCount_In
    global MiniSectorCount_UI, MiniPointsCount_UI, MiniRaceRunTime_UI, cHighlight

    if (FindGame() = 0)
        return

    if !ToggleMode("Race") {
        StatusText.Value := "⬤  Stopping..."
        StatusText.SetFont("cFFB347")
    }
    
    StartIndicators()
    UpdateMiniWidgetMode(ActiveMode)
    
    if (ActiveMode = "Race" && SkillPtsWant_In.Value > 0 && SkillPtsCount_In.Value < 999) {        

        TotalRunSeconds      := 0
        RaceRunSeconds       := 0

        SectorCount_UI.Value := 0
        PointsCount_UI.Value := 0
        RaceRunTime_UI.Value := "00:00"

        ; Update GUI
        MiniSectorCount_UI.Value := 0
        MiniPointsCount_UI.Value := 0
        MiniRaceRunTime_UI.Value := "00:00"

        PointsCount_UI.SetFont("c" cHighlight)
        SectorCount_UI.SetFont("c" cHighlight)
        RaceRunTime_UI.SetFont("c" cHighlight)
        
        SetTimer(RaceTimerTick, 1000)
        RaceLoop()
    }
    ResetIndicators()
}

RaceLoop() {
    global ActiveMode, MasterMode, EventLab
    global cActive, cHighlight, cIdle
    global SectorCount_UI, PointsCount_UI, CarCount_UI, RaceRunTime_UI
    global MiniSectorCount_UI, MiniPointsCount_UI
    global Maxpoints, PointsGain, RaceRunSeconds
    global CarData, SelectedCar, EventLabData, EventLab
    global PointsCount     := 0
    global SectorCount     := 0

    car := CarData[SelectedCar]
    event := EventLabData[EventLab]

    FailedTurn      := 0
    NotiFreqInterv  := 10

    CheckAbort() {
        return ActiveMode != "Race" && !MasterMode
    }

    While (ActiveMode = "Race") {
        DiscordStatusUpdate("info", "Race Mode Started", "Starting " EventLab " EventLab circuit...")

        Process("Scanning Menu...")
        RaceNav()

        if CheckAbort()
            break
        
        Process("Scanning Skill Points")
        RaceSkillPtsScan(0.280, 0.698, 0.157, 0.058, false)

        if (PointsGain <= 0)
            break 

        if CheckAbort()
            break

        Process("Navigating to Creative Hub Menu")
        Loop 3
            PressKey("PgDn", 100) 

        Process("Opening EventLab Menu...", 500)
        PressKey("Enter", 1000)     ; Select EventLab
        PressKey("Enter", 3000)     ; Select Play Event

        if CheckAbort()
            break

        Process("Navigating to Favourited Events...")
        Loop 7
            PressKey("PgDn", 100)

        WaitForPixel("Waiting for EventLab to load...", 0.283, 0.198, "0xFCC500", , 10000)

        PressKey("Enter")           ; Select Event

        if CheckAbort()
            break

        WaitForPixel("Choosing Race Type...", 0.331, 0.567, "0xFFFFFF", , 10000)

        PressKey("Enter", 3000) ; Select Race Type

        if CheckAbort()
            break

        Process("Select Favourited Car...")
        PressKey("Y")               ; Filter
        PressKey("Enter")           ; Toggle
        PressKey("Esc", 1000)       ; Back to My Cars

        if CheckAbort()
            break

        Loop {
            Process("Verifying 1998 Subaru with the correct tune.", 500)
            CarVerify := CarVerifyCheck("Race Mode", "1998 Subaru", 816997639471, false)
            if !CarVerify
                PressKey("Right", 50)
            else {
                PressKey("Enter", 50)
                break
            }

            if A_Index > 15
                EmergencyExit("No 1998 Subaru with the correct tune detected.")
        }
        
        Process("Loading EventLab...")
        WaitForPixel("Waiting for track to load...", 0.158, 0.678, "0xFFFFFF", , 30000)

        Process("Start Race Event...")
        PressKey("Enter", 2000) 
        
        if CheckAbort()
            break

        DiscordStatusUpdate("info", "Race Mode Active", "Driving " EventLab " EventLab circuit...")

        PressKey("W", 50) 
        Process("Countdown...", 3000)

        if (EventLab == "LIQUIDPOTATO") {
            While (PointsCount < PointsGain) {
                Process("Throttling...")
                PressKey("w down", 50) 
                Sleep(30000)
                PressKey("w up", 50) 

                if CheckAbort()
                    break
                
                SectorCount++
                PointsCount := Floor(SectorCount * event.AveragePoints) 

                ; Update GUI
                PointsCount_UI.Value     := PointsCount
                SectorCount_UI.Value     := SectorCount
                MiniPointsCount_UI.Value := PointsCount
                MiniSectorCount_UI.Value := SectorCount
                
                if (Mod(SectorCount, 4) == 0 && PointsCount < PointsGain) {
                    PressKey("w down", 50) 
                    Sleep(7700) 
                    PressKey("w up", 50) 
                }

                if (Mod(SectorCount, NotiFreqInterv) == 0)
                    ShowNotif("info", "Race Mode", SectorCount " sectors of EventLab Race completed.")

                DiscordStatusUpdate("info", "Race Mode Active", "Driving " EventLab " EventLab circuit...")
            }

            Process("Quitting the Event...", 2000)
            PressKey("Esc", 1000)       ; Pause Menu
            PressKey("Right")           ; Navigate to Quit
            PressKey("Enter")           ; Quit Event
            PressKey("Enter")           ; Confirm Quit
        }
        else if (EventLab == "AMMAGEDON") {
            AlreadyQuit := false

            While (PointsCount < PointsGain) {
                Process("Throttling...")
                Loop 18 {
                    PressKey("w down", 1000)
                    if CheckAbort()
                        break 2
                }

                if CheckAbort()
                    break

                if WaitForPixel("Turning...", 0.202, 0.843, "0x696562", , 6000, 500, 25, 5, true, "Failed braking on time.") {
                    Process("Braking...")
                    PressKey("w up")
                    PressKey("s down", 1500)
                    PressKey("s up", 1000)

                    if CheckAbort()
                        break

                    Process("Throttling...")
                    PressKey("w down", 2000)
                } else {
                    Process("Releasing throttle...")
                    PressKey("w up", 2000)

                    if CheckAbort()
                        break

                    Process("Throttling...")
                    PressKey("w down", 2000)
                }

                if CheckAbort()
                    break
                
                SectorCount++

                if (Mod(SectorCount, NotiFreqInterv) == 0)
                    ShowNotif("info", "Race Mode", SectorCount " sectors of EventLab Race completed.")

                PointsCount := Floor(SectorCount * event.AveragePoints) 

                ; Update GUI
                PointsCount_UI.Value     := PointsCount
                SectorCount_UI.Value     := SectorCount
                MiniPointsCount_UI.Value := PointsCount
                MiniSectorCount_UI.Value := SectorCount

                if (!(Mod(SectorCount, 50) == 0) && PointsCount >= PointsGain) {
                    Process("Quitting the Event...", 2000)
                    PressKey("Esc", 1000)   ; Pause Menu
                    PressKey("Right")       ; Navigate to Quit
                    PressKey("Enter")       ; Quit Event
                    PressKey("Enter")       ; Confirm Quit
                    AlreadyQuit := true
                    break
                }

                if (Mod(SectorCount, 50) == 0 && PointsCount >= PointsGain) {
                    if WaitForPixel("Waiting for leaderboard to load...", 0.166, 0.292, "0xFFFFFF", "", 20000, , , , true, "Leaderboard failed to load! `nRestarting event...") {
                        Process("Quitting the Event...")
                        PressKey("Enter")
                        AlreadyQuit := true
                        break
                    }
                }

                if (Mod(SectorCount, 50) == 0 && PointsCount < PointsGain) {
                    if !WaitForPixel("Waiting for leaderboard to load...", 0.166, 0.292, "0xFFFFFF", "", 30000, , , , true, "Leaderboard failed to load! `nRestarting event...") {
                        Process("Sync Error: EventLab leaderboard failed to load!")

                        Process("Restarting the Event...", 2000)
                        PressKey("Esc", 1000)   ; Pause Menu
                        PressKey("Left")        ; Navigate to Restart
                        PressKey("Enter")       ; Restart Event
                        PressKey("Enter")       ; Confirm Restart
                    
                    } else {
                        Process("Restarting the Event...")
                        PressKey("X") 
                        PressKey("Enter") 
                    }

                    WaitForPixel("Waiting for next round to load...", 0.174, 0.683, "0xFFFFFF", "", 20000)
                    
                    Process("Entering the Event")
                    PressKey("Enter", 2000) 
                    PressKey("W down", 50) 
                    Process("Countdown...", 3000)
                }

                DiscordStatusUpdate("info", "Race Mode Active", "Driving " EventLab " EventLab circuit...")
            }

            if (!AlreadyQuit) {
                Process("Quitting the Event...", 2000)
                PressKey("Esc", 1000)   ; Pause Menu
                PressKey("Right")       ; Navigate to Quit
                PressKey("Enter")       ; Quit Event
                PressKey("Enter")       ; Confirm Quit
            }
        }
        
        PressKey("w up")

        ShowNotif("success", "Race Mode", SectorCount " sectors EventLab Race completed.")

        WaitForPixel("Returning to Free Roam...", 0.061, 0.945, "0xFFFFFF", "", 30000)

        if CheckAbort()
            break

        Process("Navigating Menu...")
        PressKey("Esc", 1000)    ; Open Menu
        PressKey("PgDn")         ; Navigate to Cars Menu

        Process("Scanning Skill Points")
        RaceSkillPtsScan(0.280, 0.698, 0.157, 0.058, true)

        Process("Navigating Home...")
        PressKey("PgDn")        ; Navigate to My Horizon Menu
        PressKey("Enter")       ; Select Return Home
        PressKey("Enter")       ; Confirm Travel to Home

        WaitForPixel("Returning to Home...", 0.168, 0.722, "0xFFFFFF", "", 20000)

        RaceRunTime_UI.SetFont("c" cIdle)
        PointsCount_UI.SetFont("c" cIdle)
        SectorCount_UI.SetFont("c" cIdle)
        break
    }
}

RaceSkillPtsScan(ratioX, ratioY, ratioW, ratioH, finish:=false waitTime := 1000) {
    global SkillPtsCount_In, SkillPtsWant_In, CarCount_In
    global PointsLabel_UI, SectorLabel_UI, TimeLabel_UI, CarsLabel_UI
    global ActiveMode, MaxPoints, CustomSkillPts
    global SkillPtsCount, SkillPtsWant, PointsGain, PointsTotal, CarCount, TimeTotal
    global CarData, SelectedCar, EventLabData, EventLab

    car := CarData[SelectedCar]
    event := EventLabData[EventLab]

    SkillPtsCountOld := SkillPtsCount_In.Value
    
    Process("Scanning Skill Points", 1000)
    points := ScanOCR(ratioX, ratioY, ratioW, ratioH, 1000, , true)

    if !finish {
        if (points == -1) {
            SkillPtsCount := SkillPtsCountOld
            ShowNotif("warning", "Race Mode", "Skill Points not detected. `nEstimated value: " SkillPtsCount)
        } else {
            SkillPtsCount := points
            ShowNotif("info", "Race Mode", SkillPtsCount " Skill Points detected.", true)
        }

        SkillPtsWant := CustomSkillPts ? Min(CustomSkillPts, MaxPoints - SkillPtsCount) : Min(999 - SkillPtsCount, MaxPoints)
        SkillPtsWant_In.Value  := SkillPtsWant

        PointsGain  := GetMinScore(SkillPtsWant)
        PointsTotal := Min(PointsGain + SkillPtsCount, 999)
        CarCount    := Floor(PointsTotal / CarData[SelectedCar].SkillPtsCost)
        TimeTotal   := CalcTotalTime(SkillPtsWant, CarCount)

        CarCount_In.Value      := CarCount

        PointsLabel_UI.Value := PointsGain
        SectorLabel_UI.Value := Ceil(PointsGain / event.AveragePoints)
        TimeLabel_UI.Value   := Format("{:02}:{:02}", Floor(TimeTotal), Floor((TimeTotal - Floor(TimeTotal)) * 60))
        CarsLabel_UI.Value   := CarCount
    } else if finish {
        if (points == -1) {
            SkillPtsCount := PointsTotal - 10
            ShowNotif("warning", "Race Mode", "Skill Points not detected. `nEstimated value: " SkillPtsCount, true)
        } else {
            global SkillPtsScanSuccess := true
            SkillPtsCount       := points
            SkillPtsCountNew    := SkillPtsCount - SkillPtsCountOld
            ShowNotif("success", "Race Mode", SkillPtsCountNew " Skill Points earned.", true)
        }

        SkillPtsWant := Min(999 - SkillPtsCount, MaxPoints)
        SkillPtsWant_In.Value := SkillPtsWant
    }

    SkillPtsCount_In.Value := SkillPtsCount

    return points
}

RaceNav() {
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

    switch Scanned.menu {
        case "Home Menu":
            Process("Navigating to Free Roam...")
            ShowNotif("info", "Race Mode", "Home Menu detected!")
            PressKey("Esc")             ; Return to Free Roam
            WaitForPixel("Returning to Free Roam...", 0.137, 0.950, "0xFFFFFF", , 20000, 1000)
            PressKey("Esc", 1000)       ; Open Free Roam Menu (Lands on default Campaign tab)
            Scanned.submenu := "Free Roam Menu - Campaign"

        case "Free Roam":
            Process("Navigating to Free Roam Menu...")
            ShowNotif("info", "Race Mode", "Free Roam detected!")
            PressKey("Esc", 1000)       ; Open Free Roam Menu (Lands on default Campaign tab)
            Scanned.submenu := "Free Roam Menu - Campaign"
            
        case "Free Roam Menu":
            ShowNotif("info", "Race Mode", "Free Roam Menu detected!")
    }

    Process("Navigating to My Horizon Menu...")
    if FreeRoamNav.Has(Scanned.submenu) {
        nav := FreeRoamNav[Scanned.submenu]
        Loop nav.count {
            PressKey(nav.key, 100)
        }
    }
}