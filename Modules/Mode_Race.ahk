; ══════════════════════════════════════════════
;  AUTOMATION TRIGGER ENGINES
; ══════════════════════════════════════════════

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

        ; Update Mini Widget Canvas Panels
        MiniSectorCount_UI.Value := 0
        MiniPointsCount_UI.Value := 0
        MiniRaceRunTime_UI.Value := "00:00"

        PointsCount_UI.SetFont("c" cHighlight)
        SectorCount_UI.SetFont("c" cHighlight)
        RaceRunTime_UI.SetFont("c" cHighlight)
        
        SetTimer(RaceTimerTick, 1000)

        DiscordStatusUpdate("info", "Race Mode Started", "Starting " EventLab " EventLab circuit...")
        RaceLoop()
        DiscordStatusUpdate("success", "Race Mode Ended", "Completed " EventLab " EventLab circuit...")
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
    
    ; Setup localized loop registers cleanly for AHK v2 variable scopes
    global PointsCount, SectorCount
    PointsCount := 0
    SectorCount := 0

    car := CarData[SelectedCar]
    event := EventLabData[EventLab]

    FailedTurn      := 0
    NotiFreqInterv  := 10

    CheckAbort() {
        return ActiveMode != "Race" && !MasterMode
    }

    While (ActiveMode = "Race") {
        Process("Scanning Menu...")
        RaceNav()

        if CheckAbort()
            break
        
        Process("Scanning Skill Points")
        RaceSkillPtsScan(0.280, 0.698, 0.157, 0.058, false)

        if (PointsGain <= 0)
            break 

        PressKey("Enter") ; Select Change Car

        if CheckAbort()
            break

        if GetInSubaru() = true {
            WaitForText("ANNA", 0.052, 0.929, 0.099-0.052, 0.957-0.929, 10000)
            PressKey("Enter", 1000)
            PressKey("PgDn", 100) 
        }

        if CheckAbort()
            break

        Process("Navigating to Creative Hub Menu", 500)
        Loop 3
            PressKey("PgDn", 100) 

        Process("Opening EventLab Menu...", 500)
        PressKey("Enter", 1000)     ; Select EventLab

        if EventLab = "AAMIRUSMANDUS" {
            PressKey("Down", 1000) ; Navigate to Play Challenge
            PressKey("Enter", 3000) ; Select Play Challenge
            PressKey("Backspace") ; Search
            PressKey("Up")
            PressKey("Enter")
            PasteNumberToGamingUI("140849306")
            PressKey("Down")
            PressKey("Enter")
            WaitForPixel("Waiting for Challenge to load...", 0.269, 0.268, "0xF4BA04", , 10000, 200)
            PressKey("Enter")

            Loop {
                Process("Waiting for the challenge to start...")
                WaitForText("ANNA", 0.052, 0.929, 0.099-0.052, 0.957-0.929, 40000)

                if CheckAbort(){
                    Process("Quitting the Event...", 2000)
                    PressKey("Esc", 1000)   ; Pause Menu
                    PressKey("Right")       ; Navigate to Quit
                    PressKey("Enter")       ; Quit Event
                    PressKey("Enter")       ; Confirm Quit
                    break
                }

                Process("Throttling...")
                PressKey("w down", 15000)
                WaitForText("Enter", 0.039, 0.916, 0.104-0.039, 0.947-0.916, 10000)

                SectorCount++

                if (Mod(SectorCount, NotiFreqInterv) == 0)
                    ShowNotif("info", "Race Mode", SectorCount " sectors of EventLab Race completed.")

                PointsCount := Floor(SectorCount * event.AveragePoints) 

                ; Live Real-time UI Telemetry Updates
                PointsCount_UI.Value     := PointsCount
                SectorCount_UI.Value     := SectorCount
                MiniPointsCount_UI.Value := PointsCount
                MiniSectorCount_UI.Value := SectorCount

                if CheckAbort() || PointsCount >= PointsGain {
                    PressKey("Esc") ; Quit
                    break
                }

                PressKey("Enter") ; Retry
            }
            WaitForPixel("Liking the challenge...", 0.347, 0.532, "0x000000", , 10000, 3000)
            PressKey("Enter") ; Like

        }

        if EventLab != "AAMIRUSMANDUS" {
            PressKey("Enter", 3000)     ; Select Play Challenge
            if CheckAbort()
                break

            Process("Navigating to Favourited Events...")
            Loop 7
                PressKey("PgDn", 100)

            WaitForPixel("Waiting for EventLab to load...", 0.283, 0.198, "0xFCC500", , 10000)

            PressKey("Enter") ; Select Event

            if CheckAbort()
                break

            WaitForPixel("Choosing Race Type...", 0.331, 0.567, "0xFFFFFF", , 10000)

            PressKey("Enter")     ; Select Race Type

            if CheckAbort()
                break

            GetInSubaru()

            if CheckAbort()
                break

            Process("Loading EventLab...")
            WaitForPixel("Waiting for track to load...", 0.158, 0.678, "0xFFFFFF", , 30000)

            Process("Start Race Event...")
            PressKey("Enter", 2000) 
            
            if CheckAbort()
                break

            DiscordStatusUpdate("info", "Driving EventLab", "Wrecking " EventLab " circuit...")

            PressKey("W", 50) 
            Process("Countdown...", 3000)
        }

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

                ; Live Real-time UI Telemetry Updates
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

                ; Live Real-time UI Telemetry Updates
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

        Process("Returning to Free Roam...")
        WaitForText("ANNA", 0.052, 0.929, 0.099-0.052, 0.957-0.929, 40000)
        ; WaitForPixel("Returning to Free Roam...", 0.061, 0.945, "0xFFFFFF", "", 30000)

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

; ══════════════════════════════════════════════
;  OCR TELEMETRY ENGINE WITH SYSTEM STATE HOOK
; ══════════════════════════════════════════════

RaceSkillPtsScan(ratioX, ratioY, ratioW, ratioH, finish := false, waitTime := 1000) {
    global SkillPtsCount_In, SkillPtsWant_In, ActiveMode, MaxPoints, CustomSkillPts
    global SkillPtsCount, SkillPtsWant, PointsTotal, CarData, SelectedCar, EventLabData, EventLab

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
        SkillPtsWant_In.Value := SkillPtsWant

        ; Modernized Integration: Fire the master pipeline to cleanly update all layout timings and thresholds
        UpdateSystemState(SkillPtsCount, SkillPtsWant)

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

        ; Modernized Integration: Fire master pipeline post-race
        UpdateSystemState(SkillPtsCount, SkillPtsWant)
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

GetInSubaru() {
    WaitForText("My Cars", 0.060, 0.090, 0.096, 0.045, 5000)

    Process("Select Favourited Car...", 500)
    PressKey("Y")               ; Filter
    PressKey("Enter")           ; Toggle
    PressKey("Esc", 1000)       ; Back to My Cars

    Process("Verifying 1998 Subaru.", 500)
    Loop {
        CarVerify := CarVerifyCheck("Race Mode", "1998 Subaru", [816997639471, 594970474057], false)
        if !CarVerify 
            PressKey("Right", 50)
        else {
            PressKey("Enter")
            if WaitForText("Get In Car", 0.462, 0.415, 0.536-0.462, 0.453-0.415, 3000) {
                Process("Entering 1998 Subaru...")
                PressKey("Enter", 50)
                return true
            }
            else {
                PressKey("Esc")
                PressKey("Esc")
                return false
            }
        }

        if A_Index > 15
            EmergencyExit("No 1998 Subaru detected.")
    }
}