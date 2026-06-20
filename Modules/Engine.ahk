; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║        Cyber Noir Edition v1.7.0        ║
; ╚═════════════════════════════════════════╝

; ══════════════════════════════════════════════
;  LOOP COORDINATION MECHANICS
; ══════════════════════════════════════════════

TogglePause() {
    global ActiveMode, PauseMode, StatusText, cIdle, cPaused, cStat, MasterMode
    Pause(-1)
    ;PauseMode := ActiveMode ? !PauseMode : PauseMode

    if (PauseMode && ActiveMode) {
        StatusText.Value := "⬤  Paused..."
        StatusText.SetFont("c" cPaused)
        ShowNotif("info", "Macro Paused", "Execution has been temporarily suspended.")
    } else if ActiveMode {
        StatusText.Value := "⬤  Running..."
        StatusText.SetFont("c" cStat)
        ShowNotif("success", "Macro Resumed", "Resuming automated sequence.")
    }
}

ToggleMode(mode) {
    global ActiveMode
    if (ActiveMode = mode) {
        ActiveMode := ""
        ShowNotif("info", "Mode Deactivated", "Cleared active routine state.")
        return false
    }
    if ActiveMode {
        return false
    }
    ActiveMode := mode
    ShowNotif("success", "Mode Activated", "Routine locked into: " mode)
    return true
}

ToggleAll() {
    global ActiveMode, MasterMode, MasterStart
    global SkillPtsCount_In, SkillPtsWant_In, CarCount_In, LoopCount_In
    global MaxPoints, PointsGain, SelectedCarPoint, cHighlight, cIdle

    StartIndicators()
    MasterMode := !MasterMode

    if (MasterMode) {
        ShowNotif("success", "Master Loop Initiated", "Beginning automated event cycles.")
    }

    while (MasterMode && LoopCount_In.Value > 0) {
        MasterStart := true

        StartRace()
        ActiveMode := ""
        if !MasterMode
            break

        StartBuy()
        ActiveMode := ""
        if !MasterMode
            break

        StartUnlock()
        ActiveMode := ""
        if !MasterMode
            break

        Process("Restarting Race...")
        LoopCount_In.Value -= 1
    }
    
    if (MasterMode == "") {
        ShowNotif("info", "Sequence Complete", "Master loop runs finished or stopped.")
    }
    
    MasterMode := ""
    MasterStart := false
    ResetIndicators()
}

; ══════════════════════════════════════════════
;  COUNTDOWN ENGINE
; ══════════════════════════════════════════════

SmartCountdown(TotalSec, UIEl, ActiveText) {
    global ActiveMode
    Loop TotalSec {
        if (ActiveMode != "Race")
            return false
        UIEl.Value := ActiveText " (" (TotalSec - A_Index + 1) "s)"
        Sleep(1000)
    }
    return true
}

; ══════════════════════════════════════════════
;  RESET & INDICATORS
; ══════════════════════════════════════════════

StartIndicators() {
    global StatusText, Process_UI, Key_UI, TotalRunTime_UI, ActiveMode
    global SkillPtsCount_In, SkillPtsWant_In, CarCount_In, CarSelect_UI

    StatusText.Value := "⬤  Running..."
    StatusText.SetFont("c" cActive)

    Process_UI.SetFont("c" cHighlight)
    Key_UI.SetFont("c" cHighlight)
    TotalRunTime_UI.SetFont("c" cHighlight)

    if (ActiveMode = "Spin") {
        SkillPtsCount_In.Enabled := false
        SkillPtsWant_In.Enabled  := false
        CarCount_In.Enabled      := false
        CarSelect_UI.Enabled     := false
        DelaySlider_UI.Enabled   := false
        LoopCount_In.Enabled     := false
    }
    CodeSelect_UI.Enabled := false

    SetTimer(TotalTimerTick, 1000)
}

ResetIndicators() {
    global Key_UI, Process_UI, StatusText, cIdle, cTextDim
    global TotalRunTime_UI, RaceRunTime_UI, BuyRunTime_UI, UnlockRunTime_UI, SectorCount, ActiveMode, MasterMode
    global SkillPtsCount_In, SkillPtsWant_In, CarCount_In, CarSelect_UI

    SetTimer(RaceTimerTick, 0)
    SetTimer(BuyTimerTick, 0)
    SetTimer(UnlockTimerTick, 0)
    SetTimer(SpinTimerTick, 0)
    
    if (!MasterMode) {
        SetTimer(TotalTimerTick, 0)
    }
    
    ActiveMode           := ""
    Key_UI.Value         := "⌨  [   ]"
    Process_UI.Value     := "⚙️  Waiting..."

    MiniKey_UI.Value     := "⌨  [   ]"
    MiniProcess_UI.Value := "⚙️  Waiting..."
    
    Key_UI.SetFont("c" cIdle)
    Process_UI.SetFont("c" cIdle)
    TotalRunTime_UI.SetFont("c" cIdle)
    RaceRunTime_UI.SetFont("c" cIdle)
    BuyRunTime_UI.SetFont("c" cIdle)
    UnlockRunTime_UI.SetFont("c" cIdle)
    PointsCount_UI.SetFont("c" cIdle)
    SectorCount_UI.SetFont("c" cIdle)
    CarCount_UI.SetFont("c" cIdle)
    SWheelCount_UI.SetFont("c" cIdle)
    WheelCount_UI.SetFont("c" cIdle)
    CreditCount_UI.SetFont("c" cIdle)
    SpinRunTime_UI.SetFont("c" cIdle)
    SpinOpenCount_UI.SetFont("c" cIdle)
    SpinLeftCount_UI.SetFont("c" cIdle)
    
    StatusText.Value := "⬤  Stopped"
    StatusText.SetFont("c" cTextDim)
    
    SkillPtsCount_In.Enabled := true
    SkillPtsWant_In.Enabled  := true
    CarCount_In.Enabled      := true
    CarSelect_UI.Enabled     := true
    DelaySlider_UI.Enabled   := true
    CodeSelect_UI.Enabled    := true
    LoopCount_In.Enabled     := true

    PressKey("W up")
}

; ══════════════════════════════════════════════
;  UPDATE VALUE INPUT
; ══════════════════════════════════════════════

UpdateCode(ctrl, *) {
    global SelectedCode, MaxPoints, MaxSections, AveragePoints, SkillPtsCount_In, SkillPtsWant_In, CarCount_In, PointsTotal, CodeTune, CodeEventLab

    SelectedCode  := ctrl.Text
    MaxSections   := (SelectedCode = "AMMAGEDON") ? 100 : 96
    MaxPoints     := (SelectedCode = "AMMAGEDON") ? 990 : 940
    AveragePoints := (SelectedCode = "AMMAGEDON") ? 9.9 : 9.8
    
    CodeTune      := (CodeSelect_UI.Text = "AMMAGEDON") ? "206657706" : "293391902"
    CodeEventLab  := (CodeSelect_UI.Text = "AMMAGEDON") ? "102089819" : "124198343"
    
    SkillPtsWant_In.Value := UpdateSkillPtsWant({Value: MaxPoints})
    CarCount_In.Value     := Floor(PointsTotal / SelectedCarPoint)
}

UpdateCar(ctrl, *) {
    global SelectedCar, SelectedCarPoint, PointsTotal, CarSelect_UI, CarsLabel_UI, CarCount_In
    
    SelectedCar      := ctrl.Text
    SelectedCarPoint := (CarSelect_UI.Text = "Lamborghini Revuelto") ? 39 : 30
    CarPurchaseCount := Floor(PointsTotal / SelectedCarPoint)
        
    CarCount_In.Value  := CarPurchaseCount
    CarsLabel_UI.Value := CarPurchaseCount
}

UpdateSkillPts(ctrl, *) {
    global SelectedCarPoint, TimeTotal, PointsTotal, CarCount_In, SkillPtsWant_In, AveragePoints, PointsGain, MaxPoints
    global PointsLabel_UI, TimeLabel_UI, CarsLabel_UI, SectorLabel_UI, ActiveMode, CustomSkillPts

    if CustomSkillPts = true
        ShowNotif("info", "EventLab Race", "Mode: Automatic Desired Skill Point.")

    CustomSkillPts := false
    value          := ctrl.value
    value          := (value = "") ? 0 : Min(999, value)
    
    SkillPtsWant_In.Value := (999 - value > MaxPoints) ? MaxPoints : 999 - value

    PointsGain  := GetMinScore(SkillPtsWant_In.Value)    
    PointsTotal := Min(PointsGain + value, 999)
        
    CarCount_In.Value  := Floor(PointsTotal / SelectedCarPoint)
    TimeTotal          := CalcTimeRace(SkillPtsWant_In.Value) + CalcTimeBuy(CarCount_In.Value) + CalcTimeUnlock(CarCount_In.Value)

    PointsLabel_UI.Value := PointsGain
    SectorLabel_UI.Value := Ceil(PointsGain / AveragePoints)
    TimeLabel_UI.Value   := Format("{:02}:{:02}", Floor(TimeTotal), Round((TimeTotal - Floor(TimeTotal)) * 60))
    CarsLabel_UI.Value   := Floor(PointsTotal / SelectedCarPoint)
}
    
UpdateSkillPtsWant(ctrl, *) {
    global SelectedCarPoint, TimeTotal, PointsTotal, CarCount_In, SkillPtsCount_In, AveragePoints, PointsGain, MaxPoints
    global PointsLabel_UI, TimeLabel_UI, CarsLabel_UI, PointsCount_UI, SectorLabel_UI, CustomSkillPts

    if CustomSkillPts = false
        ShowNotif("info", "EventLab Race", "Mode: Custom Desired Skill Point.")

    CustomSkillPts := true
    value          := ctrl.value
    
    if (value = "") 
        value := 0
    else if (value + SkillPtsCount_In.Value > 999)
        value := 999 - SkillPtsCount_In.Value
    else if (value > MaxPoints)
        value := MaxPoints

    PointsGain  := GetMinScore(value)
    PointsTotal := Min(PointsGain + SkillPtsCount_In.Value, 999)
    
    CarCount_In.Value := Floor(PointsTotal / SelectedCarPoint)
    TimeTotal         := CalcTimeRace(value) + CalcTimeBuy(CarCount_In.Value) + CalcTimeUnlock(CarCount_In.Value)
    
    PointsLabel_UI.Value := PointsGain
    SectorLabel_UI.Value := Ceil(PointsGain / AveragePoints)
    TimeLabel_UI.Value   := Format("{:02}:{:02}", Floor(TimeTotal), Round((TimeTotal - Floor(TimeTotal)) * 60))
    CarsLabel_UI.Value   := Floor(PointsTotal / SelectedCarPoint)

    return value
}

ValidateSkillPts(ctrl, *) {
    global SkillPtsCount_In
    value := ctrl.value
    
    if (value = "") 
        value := 0
    else if (value > 999)
        value := 999
    
    ctrl.value := value
}

ValidateSkillPtsWant(ctrl, *) {
    global SkillPtsCount_In, MaxPoints
    value := ctrl.value
    
    if (value = "") 
        value := 0
    else if (value + SkillPtsCount_In.Value > 999)
        value := 999 - SkillPtsCount_In.Value
    else if (value > MaxPoints)
        value := MaxPoints
    
    ctrl.value := value
}

; ══════════════════════════════════════════════
;  SCORE AND TIME CALCULATION
; ══════════════════════════════════════════════

GetMinScore(score) {
    global SelectedCode, MaxPoints, MaxSections

    pointsPerSection := MaxPoints / MaxSections
    sections         := Ceil(score / pointsPerSection)
    return Floor(sections * pointsPerSection)
}

CalcTimeRace(score) {
    global MaxSections, SelectedCode

    StartLoadingTime := 52
    MidLoadingTime   := 20
    FinLoadingTime   := 40

    pointsPerSection := MaxPoints / MaxSections
    secPerSection    := (SelectedCode = "AMMAGEDON") ? 20 : 30
    secPerRow        := (SelectedCode = "AMMAGEDON") ? 4 : 7
    sectionsPerRow   := (SelectedCode = "AMMAGEDON") ? 1 : 4

    sections  := Ceil(score / pointsPerSection)
    rows      := Ceil(sections / sectionsPerRow)
    totalTime := StartLoadingTime + (sections * secPerSection) + (rows * secPerRow) + MidLoadingTime + FinLoadingTime

    return totalTime / 60
}

CalcTimeBuy(car) {
    totalTime := car * 2.7
    return totalTime / 60
}

CalcTimeUnlock(car) {
    totalTime := car * 31
    return totalTime / 60
}

; ══════════════════════════════════════════════
;  TIMER TICKS
; ══════════════════════════════════════════════

TotalTimerTick() {
    global TotalRunSeconds, TotalRunTime_UI, cHighlight
    TotalRunSeconds++
    mins := TotalRunSeconds // 60
    secs := Mod(TotalRunSeconds, 60)

    TotalRunTime_UI.Value     := "🕓  " Format("{:02d}:{:02d}", mins, secs)
    MiniTotalRunTime_UI.Value := "🕓  " Format("{:02d}:{:02d}", mins, secs)
}

RaceTimerTick() {
    global RaceRunSeconds, RaceRunTime_UI, cHighlight
    RaceRunSeconds++
    mins := RaceRunSeconds // 60
    secs := Mod(RaceRunSeconds, 60)

    RaceRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
    MiniRaceRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
}

BuyTimerTick() {
    global BuyRunSeconds, BuyRunTime_UI, cHighlight
    BuyRunSeconds++
    mins := BuyRunSeconds // 60
    secs := Mod(BuyRunSeconds, 60)

    BuyRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
    MiniBuyRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
}

UnlockTimerTick() {
    global UnlockRunSeconds, UnlockRunTime_UI, cHighlight
    UnlockRunSeconds++
    mins := UnlockRunSeconds // 60
    secs := Mod(UnlockRunSeconds, 60)

    UnlockRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
    MiniUnlockRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
}

spinTimerTick() {
    global SpinRunSeconds, SpinRunTime_UI, cHighlight
    SpinRunSeconds++
    mins := SpinRunSeconds // 60
    secs := Mod(SpinRunSeconds, 60)

    SpinRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
}

; ══════════════════════════════════════════════
;  PIXEL & OCR DETECTION ENGINE
; ══════════════════════════════════════════════

GetCoordsColor() {
    CoordMode("Mouse", "Screen")
    CoordMode("Pixel", "Screen")
    MouseGetPos(&x, &y)
    color := PixelGetColor(x, y)
    WinGetClientPos(&mLeft, &mTop, &mWidth, &mHeight, GameTitle)
    ratioX := (x - mLeft) / mWidth
    ratioY := (y - mTop)  / mHeight
    A_Clipboard := Format("{:.3f}, {:.3f}, `"{}`"", ratioX, ratioY, color)
    
    ToolTip("Copied Relative Coords!`nRatio X: " ratioX "`nRatio Y: " ratioY "`nColor: " color)
    SetTimer(() => ToolTip(), -3000)
}

ScanOCR(ratioX, ratioY, ratioW, ratioH, waitTime := 0, targetText := "", searchNumber := false) {
    CoordMode "Pixel", "Client"
    global GameTitle
    gameTarget := GameTitle
    
    ; 1. Failsafe: Exit early if the game isn't running
    if !WinExist(gameTarget) {
        ShowNotif("error", "OCR Error", "Game window '" gameTarget "' is not running.")
        return -1
    }
    
    ; 2. Get the canvas size to calculate percentage scaling
    WinGetClientPos(, , &gameWidth, &gameHeight, gameTarget)
    
    startX := Round(ratioX * gameWidth)
    startY := Round(ratioY * gameHeight)
    width  := Round(ratioW * gameWidth)
    height := Round(ratioH * gameHeight)
    
    deadline := A_TickCount + waitTime

    ; 3. Use a loop that always runs at least once, even if waitTime is 0
    Loop {
        try {
            ; Grab the text straight from the background window canvas memory
            result := OCR.FromWindow(gameTarget, {
                x: startX, 
                y: startY, 
                w: width, 
                h: height, 
                scale: 3, 
                invertcolors: 1
            })
            
            scannedText := Trim(result.Text)
            
            if (scannedText != "") {
                ; Condition A: Looking for a specific phrase/word
                if (targetText != "" && InStr(scannedText, targetText)) {
                    return scannedText
                }
                
                ; Condition B: Looking for a number/digit data type
                if (searchNumber) {
                    if InStr(scannedText, "No") {
                        return 0 ; Your custom "No available skills" fallback
                    }
                    
                    cleanNumber := RegExReplace(scannedText, "\D") 
                    if (cleanNumber != "") {
                        return Number(cleanNumber)
                    }
                }
                
                ; Condition C: If user passed no targets or flags, just return raw string instantly
                if (targetText == "" && !searchNumber) {
                    return scannedText
                }
            }
        } catch {
            ; Suppressed background window state capture exception (e.g. temporary lag)
        }
        
        ; Break the loop if we've exceeded the deadline
        if (A_TickCount >= deadline) {
            break
        }
        
        Sleep(50) ; Brief rest before looping to keep CPU usage low
    }
    
    ; Trigger notifications on timeout (Only if waitTime > 0 to prevent one-shot check spam)
    if (waitTime > 0) {
        if (targetText != "") {
            ShowNotif("warning", "OCR Timeout", "Failed to find text: '" targetText "' within " Round(waitTime/1000, 1) "s")
        } else if (searchNumber) {
            ShowNotif("warning", "OCR Timeout", "Failed to find a valid number within " Round(waitTime/1000, 1) "s")
        }
    }
    
    return (searchNumber) ? -1 : false ; Return appropriate fail state depending on type
}

WaitForPixel(text, ratioX, ratioY, targetColor, targetColorHDR := "", timeoutMs := 8000, postDelayMs := 1000, isFatal := false, variation := 0, note := "", radius := 0) {
    global ActiveMode, MasterMode, MasterStart, CurrentMultiplier, GameTitle
    CoordMode("Pixel", "Screen") 
    
    StartTime := A_TickCount
    LastSec   := -1
    
    timeoutMs   *= CurrentMultiplier
    postDelayMs *= CurrentMultiplier

    Loop {
        if ((ActiveMode != "Race" && ActiveMode != "Buy" && ActiveMode != "Unlock" && ActiveMode != "Spin") || (!MasterMode && MasterStart))
            return false
            
        if !WinExist(GameTitle)
            return false

        WinGetClientPos(&mLeft, &mTop, &mWidth, &mHeight, GameTitle)
        centerX := mLeft + Round(ratioX * mWidth)
        centerY := mTop  + Round(ratioY * mHeight)
            
        ; Define a tiny bounding box based on your radius
        x1 := centerX - radius
        y1 := centerY - radius
        x2 := centerX + radius
        y2 := centerY + radius

        RemainingSec := Ceil((timeoutMs - (A_TickCount - StartTime)) / 1000)
        if (RemainingSec < 0) 
            RemainingSec := 0
            
        if (RemainingSec != LastSec) {
            Process(text " (" RemainingSec "s)")
            LastSec := RemainingSec
        }

        ; 1. Check Standard Color inside the small radius box
        if PixelSearch(&foundX, &foundY, x1, y1, x2, y2, targetColor, variation) {
            if (postDelayMs > 0)
                Sleep(postDelayMs)
            return true 
        }

        ; 2. Check HDR Color Alternative inside the small radius box
        if (targetColorHDR != "" && PixelSearch(&foundX, &foundY, x1, y1, x2, y2, targetColorHDR, variation)) {
            if (postDelayMs > 0)
                Sleep(postDelayMs)
            return true 
        }

        if (A_TickCount - StartTime > timeoutMs) {
            if (isFatal) {
                failMsg := note ? note : "Menu interaction timed out!"
                Process("Sync Error: " failMsg)
                ShowNotif("error", "Sync Failure", failMsg)
                return false
            } else {
                Process("Sync Warning: Pixel missed. Proceeding...", 2000)
                ShowNotif("info", "Sync Warning", "A tracking pixel was missed. Continuing routine safely.")
                return true 
            }
        }
        Sleep(50) 
    }
}

LocatePixelInArea(ratioX, ratioY, ratioW, ratioH, targetColor, variation := 5) {
    CoordMode "Pixel", "Screen"
    global GameTitle
    
    if !WinExist(GameTitle)
        return false
        
    WinGetClientPos(&winX, &winY, &winW, &winH, GameTitle)
    
    ; Define scanning bounding boundaries using your relative percentages
    x1 := winX + Round(ratioX * winW)
    y1 := winY + Round(ratioY * winH)
    x2 := winX + Round(ratioW * winW) 
    y2 := winY + Round(ratioH * winH)
    
    ; Runs an immediate 1-shot search across the target zone
    if PixelSearch(&foundX, &foundY, x1, y1, x2, y2, targetColor, variation) {
        ; Returns the clean Y coordinate relative ONLY to the window's edge
        return foundY - winY 
    }
    
    return false ; Return clean false if color isn't anywhere in that box area
}

; ══════════════════════════════════════════════
;  CONTROL OUTPUTS & HARDWARE ACTIONS
; ══════════════════════════════════════════════

PressKey(key, delay := 500) {
    global Key_UI, cHighlight, cIdle, CurrentMultiplier, GameTitle

    switch key {
        case "Down":      displayname := "↓"
        case "Up":        displayname := "↑"
        case "Left":      displayname := "←"
        case "Right":     displayname := "→"
        case "Enter":     displayname := "Enter ↵" 
        case "Backspace": displayname := "⬅ Backspace"
        case "w down", "w up": displayname := "W"
        case "s down", "s up": displayname := "S"
        Default:          displayname := key
    }

    Key_UI.Value     := "⌨  [ " displayName " ]"
    MiniKey_UI.Value := "⌨  [ " displayName " ]"

    cleanKey := key
    suffix   := ""
    if InStr(key, " ") {
        parts    := StrSplit(key, " ")
        cleanKey := parts[1]   
        suffix   := " " parts[2] 
    }

    if (scCode := GetKeySC(cleanKey)) {
        hexSC   := Format("{:03X}", scCode)
        sendKey := "sc" hexSC suffix
    } else {
        sendKey := key
    }

    try {
        ControlSend("{" sendKey "}", , GameTitle)
    } catch {
        Process("Game Window Not Found!")
        ShowNotif("error", "Target Error", "Keystroke missed because game canvas was lost.")
    }

    Sleep(CurrentMultiplier * delay)
}

Process(text, delay := 0) {
    global Process_UI

    Process_UI.Value     := "⚙️  " text
    MiniProcess_UI.Value := "⚙️  " text
    Sleep(delay)
}

WriteNumber(num) {
    global GameTitle

    for digit in StrSplit(String(num)) {
        ControlSend("{" digit "}", , GameTitle)
        Sleep(50) 
    }
}

UpdateSpeed(*) {
    global SpeedLabel_UI, DelaySlider_UI

    sliderPosition := DelaySlider_UI.Value
    
    Global CurrentMultiplier := Multipliers[sliderPosition]
    SpeedLabel_UI.Text       := "Delay Multiplier: " CurrentMultiplier "x"
}

GetGameMonitor() {
    global GameTitle
    if !WinExist(GameTitle)
        return 1 ; Fallback if game isn't running
        
    ; Get game window dimensions
    WinGetPos(&gx, &gy, &gw, &gh, GameTitle)
    gRight  := gx + gw
    gBottom := gy + gh
    
    maxArea := 0
    bestMonitor := 1 ; Default fallback

    ; Loop through all monitors to find the biggest overlap
    loop MonitorGetCount() {
        MonitorGet(A_Index, &mLeft, &mTop, &mRight, &mBottom)
        
        ; Calculate the intersecting (overlapping) width and height
        overlapX := Max(0, Min(gRight, mRight) - Max(gx, mLeft))
        overlapY := Max(0, Min(gy + gh, mBottom) - Max(gy, mTop))
        overlapArea := overlapX * overlapY
        
        ; If this monitor holds more of the game than previous screens, track it!
        if (overlapArea > maxArea) {
            maxArea := overlapArea
            bestMonitor := A_Index
        }
    }
    
    return bestMonitor
}

FormatCommas(val) {
    return RegExReplace(val, "\G\d+?(?=(\d{3})+(?:\D|$))", "$0,")
}

; ══════════════════════════════════════════════
;  MASTER MOUSE ROUTING CONTROLLER
; ══════════════════════════════════════════════

OnMessage(0x0201, WM_LBUTTONDOWN)

; ══════════════════════════════════════════════
;  MASTER MOUSE ROUTING CONTROLLER (NON-BLOCKING)
; ══════════════════════════════════════════════
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    global MainGUI, MiniGui, RestoreBtn, PauseBtn, StopBtn, DragOffsetX, DragOffsetY
    global SliderCfg, SliderKnob, SliderTrack, MainDragOffsetX, MainDragOffsetY

    ; ── 1. MINI GUI ROUTING ──
    if (IsSet(MiniGui) && WinExist("ahk_id " MiniGui.Hwnd)) {
        if (hwnd == MiniGui.Hwnd || DllCall("GetParent", "Ptr", hwnd) == MiniGui.Hwnd) {
            if ((IsSet(RestoreBtn) && hwnd == RestoreBtn.Hwnd) || 
                (IsSet(PauseBtn)   && hwnd == PauseBtn.Hwnd)   || 
                (IsSet(StopBtn)    && hwnd == StopBtn.Hwnd)) {
                return
            }
            CoordMode("Mouse", "Screen")
            MouseGetPos(&mouseX, &mouseY)
            WinGetPos(&guiX, &guiY, , , MiniGui.Hwnd)
            DragOffsetX := mouseX - guiX
            DragOffsetY := mouseY - guiY
            SetTimer(DragMiniGui, 10)
            return
        }
    }

    ; ── 2. MAIN GUI ROUTING ──
    if (!IsSet(MainGUI) || !WinExist("ahk_id " MainGUI.Hwnd))
        return

    ; Check control identity relative to the layout window
    oldMouseMode := CoordMode("Mouse", "Window")
    MouseGetPos(,, &win, &ctrlHwnd, 2)
    CoordMode("Mouse", oldMouseMode)
    
    ; Custom Slider Engine Check -> Hands off to non-blocking background timer
    if (IsSet(SliderKnob) && IsSet(SliderTrack) && (ctrlHwnd == SliderKnob.Hwnd || ctrlHwnd == SliderTrack.Hwnd)) {
        DragSliderTimer() ; Fire once instantly to catch the initial click coordinate
        SetTimer(DragSliderTimer, 10)
        return
    }
    
    ; Main Background Dragging -> Replaced PostMessage with non-blocking screen mapping
    if (hwnd == MainGUI.Hwnd) {
        CoordMode("Mouse", "Screen")
        MouseGetPos(&mouseX, &mouseY)
        WinGetPos(&guiX, &guiY, , , MainGUI.Hwnd)
        MainDragOffsetX := mouseX - guiX
        MainDragOffsetY := mouseY - guiY
        SetTimer(DragMainGUI, 10)
        return
    }
}