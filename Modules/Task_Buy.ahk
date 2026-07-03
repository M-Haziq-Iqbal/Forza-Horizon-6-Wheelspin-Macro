; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

StartBuy() {
    global ActiveMode, MasterMode, StatusText, cActive, BuyRunSeconds
    global BuyRunTime_UI, CarCount_UI, CarsLabel_UI, SkillPtsWant_In, CarCount_In, SkillPtsCount_In, SelectedCarPoint

    if FindGame() = 0
        return

    if !ToggleMode("Buy") {
        StatusText.Value := "⬤  Stopping..."
        StatusText.SetFont("cFFB347")
    }
    
    StartIndicators()
    UpdateMiniWidgetMode(activeMode)
    if (ActiveMode = "Buy") {
        
        BuyCount            := 0
        SkillPtsScanSuccess := false
        CarCount_In.Value   := Floor(SkillPtsCount_In.Value / SelectedCarPoint)
        CarsLabel_UI.Value  := CarCount_In.Value

        CarCount_UI.Value   := "0"
        BuyRunTime_UI.Value := "00:00"
        MiniCarCount_UI.Value   := "0"
        MiniBuyRunTime_UI.Value := "00:00"

        CarCount_UI.SetFont("c" cHighlight)
        BuyRunTime_UI.SetFont("c" cHighlight)
        
        SetTimer(BuyTimerTick, 1000)
        BuyLoop()
    }
    ResetIndicators()
}

BuyLoop() {
    global ActiveMode, MasterMode, MasterStart, UserTier, SkillPtsScanSuccess
    global cActive, cHighlight, cIdle
    global CarCount_In, SelectedCar, CarCount_UI, BuyRunTime_UI, SkillPtsCount_In

    BuyCount := 0

    ; Local helper to cleanly check if the macro should stop
    CheckAbort() => (ActiveMode != "Buy" || (!MasterMode && MasterStart))

    While (ActiveMode = "Buy") {

        Loop 4
            PressKey("Up", 50) ; Navigate to Drive selection
        
        if(!MasterMode && !SkillPtsScanSuccess && SkillPtsCount_In.Value = 0) {
            Process("Checking Available Skill Points..")
            PressKey("PgDn") ; Navigate to Buy & Sell Menu
            PressKey("PgDn") ; Navigate to Cars Menu
            PressKey("Down", 50) ; Navigate to Upgrades & Tuning
            PressKey("Enter", 800) ; Select Upgrades & Tuning
            Loop 7 
                PressKey("Down", 50) ; Navigate to Car Mastery
            PressKey("Enter") ; Select Car Mastery
            
            Process("Scanning Skill Points...")
            points := SkillPtsScan(0.331, 0.851, 0.054, 0.033) 

            if points != -1 {
                SkillPtsScanSuccess := true
            }
            else {
                SkillPtsScanSuccess := false
                ShowNotif("fail","Car Purchase", "Unable to scan Current Skill Points amount. `nManual input required.")
            }
            
            Process("Returning to Campaign Menu...")
            PressKey("Esc", 1500) ; Navigate to Upgrades Menu
            PressKey("Esc", 1500) ; Navigate to Cars Menu
            PressKey("PgUp", 50) ; Navigate to Buy & Sell Menu
            PressKey("PgUp") ; Navigate to Campaign Menu
        }

        CarCount_In.Value := Floor(SkillPtsCount_In.Value / SelectedCarPoint)
        if CarCount_In.Value > 0
            ShowNotif("info", "Car Purchase", CarCount_In.Value " " SelectedCar " will be purchased.`nAn extra car will be purchased for safety measure.")
        else {
            ShowNotif("error", "Car Purchase", "Insufficient Skill Points.")
            break
        }

        Process("Navigating Journal...")
        Loop 3
            PressKey("Up", 50) ; Navigate to Drive
        PressKey("Down", 50) ; Navigate to Collection Journal
        PressKey("Enter", 650) ; Select Collection Journal
        PressKey("Right") ; Navigate to Master Explorer
        PressKey("Enter", 650) ; Select Master Explorer
        PressKey("Down") ; Navigate to Car Collection
        PressKey("Enter", 650) ; Select Car Collection
        PressKey("Backspace") ; Select Manufacturers
        if CheckAbort()
            break

        ; Upgraded to a clean Switch block for car selection menu logic
        Switch SelectedCar {
            Case "Subaru Impreza 22B-STi":
                Loop 3
                    PressKey("Up", 50)
                Loop 3
                    PressKey("Right", 50)
                PressKey("Enter") ; Select Subaru
                PressKey("Down")

            Case "Lamborghini Revuelto":
                Loop 10
                    PressKey("Down", 50)
                PressKey("Right") ; Navigate to Lancia
                PressKey("Enter") ; Select Lancia
                PressKey("Left") ; Navigate to Revuelto

            Case "Dodge Viper GTS ACR":
                Loop 5
                    PressKey("Down", 50)
                Loop 2
                    PressKey("Right", 50) ; Navigate to Dodge
                PressKey("Enter") ;Select Dodge
                if UserTier = "STANDARD"
                    PressKey("Down")
                else if UserTier = "PREMIUM" {
                    PressKey("Down")
                    PressKey("Right")
                }
                
            Case "Mazda #123 Mad Mike 808":
                Loop 10
                    PressKey("Up", 50) ; Navigate to Mazda
                PressKey("Enter") ;Select Mazda
                if UserTier = "STANDARD" {
                    PressKey("Down")
                    PressKey("Left")
                    PressKey("Left")
                } else if UserTier = "PREMIUM" {
                    PressKey("Down")
                    PressKey("Left")
                    PressKey("Left")
                }
        }

        if CheckAbort()
            break

        ; ── Buying Car ───────────────
        Process("Buying " SelectedCar "...")
        PressKey("Enter") ; Select Car
        ScannedCar := ScanOCR(0.254, 0.607, 0.446-0.254, 0.672-0.607) ; Verify car name is correct

        if !InStr(ScannedCar, CarData[SelectedCar].AltName) {
            ShowNotif("error", "Car Purchase", "Selected Car does not match scanned car name.`nPlease check the selected car and try again.")
            break
        } else {
            ShowNotif("info", "Car Purchase", "Purchasing " CarCount_In.Value+1 " " SelectedCar ".")
        }

        While (BuyCount < CarCount_In.Value+1) {
            PressKey("Space") ; Purchase Car
            PressKey("Down") ; Navigate to Yes
            PressKey("Enter") ; Select Yes (Car Collection)
            PressKey("Enter") ; Select Yes (Buy Car)
            PressKey("Enter") ; Select Yes (Ok)
            
            BuyCount++
            CarCount_UI.Value := BuyCount
            MiniCarCount_UI.Value := BuyCount
        }

        ShowNotif("success", "Car Purchase", BuyCount " " SelectedCar " have been purchased.")

        if CheckAbort()
            break

        ; ── Return to Home ───────────────
        Process("Returning to Home...")
        Loop 4
            PressKey("Esc") ; Navigate to Home Menu
        Sleep(500)
        PressKey("Up") ; Navigate to Drive
        
        break
    }
}

SkillPtsScan(ratioX, ratioY, ratioW, ratioH, waitTime:= 1000, delay:=1000) {
    global SkillPtsCount_In, SkillPtsWant_In, CarCount_In
    global PointsLabel_UI, SectorLabel_UI, TimeLabel_UI, CarsLabel_UI
    global ActiveMode, MaxPoints, PointsGain, PointsTotal, TimeTotal, SelectedCarPoint

    points := ScanOCR(ratioX, ratioY, ratioW, ratioH, waitTime, , true)

    if (points = -1) {
        SkillPtsCount_In.Value := 0
    } else {
        SkillPtsCount_In.Value := points
    }

    SkillPtsWant_In.Value := Min(999 - points, MaxPoints)

    PointsGain := GetMinScore(SkillPtsWant_In.Value)
    PointsTotal := Min(PointsGain + SkillPtsCount_In.Value, 999)

    CarCount_In.Value := Floor(PointsTotal / SelectedCarPoint)

    TimeTotal := CalcTimeRace(SkillPtsWant_In.Value)  + CalcTimeBuy(CarCount_In.Value) + CalcTimeUnlock(CarCount_In.Value)

    PointsLabel_UI.Value := PointsGain
    SectorLabel_UI.Value := Ceil(PointsGain/AveragePoints)
    TimeLabel_UI.Value :=  Format("{:02}:{:02}", Floor(TimeTotal) , Round((TimeTotal - Floor(TimeTotal)) * 60))
    CarsLabel_UI.Value := Floor(PointsTotal / SelectedCarPoint)

    Sleep(delay)

    return points
}