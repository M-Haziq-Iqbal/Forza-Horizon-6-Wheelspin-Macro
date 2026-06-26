; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║        Cyber Noir Edition v1.8.0        ║
; ╚═════════════════════════════════════════╝

; ══════════════════════════════════════════════
;  LOOP COORDINATION MECHANICS
; ══════════════════════════════════════════════

TogglePause() {
    global ActiveMode, PauseMode, StatusText, cIdle, cPaused, cStat, MasterMode
    Pause(-1)
    ;PauseMode := ActiveMode ? !PauseMode : PauseMode

    if !PauseMode && ActiveMode {
        StatusText.Value := "⬤  Paused..."
        StatusText.SetFont("c" cPaused)
        PauseMode := true
        ShowNotif("info", "Macro Paused", "Execution has been temporarily suspended.")
    } else if PauseMode && ActiveMode {
        StatusText.Value := "⬤  Running..."
        StatusText.SetFont("c" cStat)
        PauseMode := false
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
    global MaxPoints, PointsGain, SelectedCarPoint, cHighlight, cIdle, InitStartBtn

    if FindGame() = 0
        return

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
    EventLabSelect_UI.Enabled := false

    SetTimer(TotalTimerTick, 1000)
}

ResetIndicators() {
    global Key_UI, Process_UI, StatusText, cIdle, cTextDim
    global TotalRunTime_UI, RaceRunTime_UI, BuyRunTime_UI, UnlockRunTime_UI, SectorCount_UI, ActiveMode, MasterMode
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
    
    StatusText.Value := "⬤  Stopped"
    StatusText.SetFont("c" cTextDim)
    
    SkillPtsCount_In.Enabled := true
    SkillPtsWant_In.Enabled  := true
    CarCount_In.Enabled      := true
    CarSelect_UI.Enabled     := true
    DelaySlider_UI.Enabled   := true
    EventLabSelect_UI.Enabled    := true
    LoopCount_In.Enabled     := true

    PressKey("W up")
}

; ══════════════════════════════════════════════
;  UPDATE VALUE INPUT
; ══════════════════════════════════════════════

UpdateEventLab(ctrl, *) {
    global EventLab, EventLabData, MaxPoints, MaxSections, AveragePoints, SkillPtsWant_In, CarCount_In, PointsTotal, CodeTune, CodeEventLab, SelectedCarPoint

    EventLab        := ctrl.Text

    data := EventLabData[EventLab]
    MaxSections     := data.MaxSections
    MaxPoints       := data.MaxPoints
    AveragePoints   := data.AveragePoints
    CodeTune        := data.CodeTune
    CodeEventLab    := data.CodeEvent
    
    SkillPtsWant_In.Value := UpdateSkillPtsWant({Value: MaxPoints})
    CarCount_In.Value     := Floor(PointsTotal / SelectedCarPoint)

    WriteMacroIni("Settings", "EventLab", EventLab)
}

UpdateCar(ctrl, *) {
    global SelectedCar, SelectedCarPoint, PointsTotal, CarSelect_UI, CarsLabel_UI, CarCount_In, CarData
    
    SelectedCar      := ctrl.Text
    
    SelectedCarPoint := CarData[SelectedCar].SkillPtsCost
    CarPurchaseCount := Floor(PointsTotal / SelectedCarPoint)
        
    CarCount_In.Value  := CarPurchaseCount
    CarsLabel_UI.Value := CarPurchaseCount

    WriteMacroIni("Settings", "Car", SelectedCar)
}

UpdateReso(ctrl, *) {
    global SelectedReso

    SelectedReso := ctrl.Text

    WriteMacroIni("Settings", "Resolution", SelectedReso)
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
    global EventLab, MaxPoints, MaxSections

    pointsPerSection := MaxPoints / MaxSections
    sections         := Ceil(score / pointsPerSection)
    return Floor(sections * pointsPerSection)
}

CalcTimeRace(score) {
    global MaxSections, EventLab, EventLabData

    StartLoadingTime := 52
    MidLoadingTime   := 20
    FinLoadingTime   := 40

    pointsPerSection := MaxPoints / MaxSections

    data := EventLabData[EventLab]
    secPerSection       := data.SecPerSection
    secPerRow           := data.SecPerRow
    sectionsPerRow      := data.SectionsPerRow

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
        centerX := mLeft + Integer(ratioX * mWidth)
        centerY := mTop  + Integer(ratioY * mHeight)
            
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
            if isFatal {
                failMsg := note!="" ? note : "Menu interaction timed out!"
                Process("Sync Error: " failMsg)
                if note!=0
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

GetPixelColorAfterDelay(ratioX, ratioY, delayMs := 2000) {
    global ActiveMode, MasterMode, MasterStart, CurrentMultiplier, GameTitle
    CoordMode("Pixel", "Screen")
    
    ; Apply your macro speed multiplier to the wait time
    delayMs *= CurrentMultiplier
    StartTime := A_TickCount

    ; 1. Responsive delay loop (allows emergency abort while waiting)
    Loop {
        if ((ActiveMode != "Race" && ActiveMode != "Buy" && ActiveMode != "Unlock" && ActiveMode != "Spin") || (!MasterMode && MasterStart))
            return "" ; Aborted
            
        if !WinExist(GameTitle)
            return ""

        ; Check if the required time has passed
        if (A_TickCount - StartTime >= delayMs)
            break
            
        Sleep(50) 
    }

    ; 2. Calculate the exact target coordinates right at the moment of capture
    WinGetClientPos(&mLeft, &mTop, &mWidth, &mHeight, GameTitle)
    centerX := Integer(mLeft + (ratioX * mWidth))
    centerY := Integer(mTop  + (ratioY * mHeight))

    ; 3. Grab and return the Hex color code (e.g., "0xFFFFFF")
    try {
        detectedColor := PixelGetColor(centerX, centerY)
        return detectedColor
    } catch {
        return "" ; Game window closed or minimized during grab
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

; --- Put this at the very top of your main script file ---
global GameHwnd := 0  ; Initializes the permanent window pointer handle

; --- Your Updated PressKey Function ---
PressKey(key, delay := 500) {
    ; OPTIMIZATION: Added GameHwnd and MiniKey_UI to your global list
    global Key_UI, MiniKey_UI, cHighlight, cIdle, CurrentMultiplier, GameTitle, GameHwnd

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

    ; SMART HWND CACHING:
    ; If we don't have the handle yet, or the old handle died (game restarted), find it once.
    if (!GameHwnd || !WinExist(GameHwnd)) {
        GameHwnd := WinExist(GameTitle)
    }

    ; If the game isn't running at all, throw the warning safely
    if (!GameHwnd) {
        ShowNotif("error", "Target Error", "Keystroke missed because game window was not found.")
        return
    }

    try {
        ; CRUCIAL CHANGE: We target GameHwnd directly instead of the GameTitle string text.
        ; This makes background input delivery 100% immune to focus changes.
        ControlSend("{" sendKey "}", , GameHwnd)
    } catch {
        ShowNotif("error", "Target Error", "Keystroke missed because game canvas was lost.")
    }
    
    delay := Random(delay, delay + 50)
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

    WriteMacroIni("Settings", "CurrentMultiplier", CurrentMultiplier)
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

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    global MainGUI, MiniGui, SpinGUI, RestoreBtn, PauseBtn, StopBtn, DragOffsetX, DragOffsetY
    global SliderCfg, SliderKnob, SliderTrack, MainDragOffsetX, MainDragOffsetY
    global SpinDragOffsetX, SpinDragOffsetY ; Scoped asynchronous position matrix

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

    ; ── 2. SPIN GUI ROUTING (Asynchronous Hand-off) ──
    try {
        if (IsSet(SpinGUI) && SpinGUI && hwnd == SpinGUI.Hwnd) {
            CoordMode("Mouse", "Screen")
            MouseGetPos(&mouseX, &mouseY)
            WinGetPos(&guiX, &guiY, , , SpinGUI.Hwnd)
            SpinDragOffsetX := mouseX - guiX
            SpinDragOffsetY := mouseY - guiY
            SetTimer(DragSpinGUI, 10)
            return
        }
    } catch {
        ; Quietly catch and discard "Windowless GUI" exceptions if the panel was destroyed
    }

    ; ── 3. MAIN GUI ROUTING ──
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

; ══════════════════════════════════════════════
;  GAME WINDOW MANIPULATION
; ══════════════════════════════════════════════

SetGameResolution(ctrl) {
    global WindowedMode, GameTitle, SelectedReso
    global IsGameAlwaysOnTop, AlwaysOnTopBtn

    if !WinExist(GameTitle) {
        ShowNotif("error", "Resolution Resizing Error", "Game window could not be found.")
        return
    }

    ; if SpecialKCheck() = false {
    ;     ShowNotif("error", "Resolution Resizing Error", "Special K is not enabled.")
    ;     return
    ; }

    resParts := StrSplit(SelectedReso, "x", " ")

    TargetWidth := Integer(resParts[1])
    TargetHeight := Integer(resParts[2])

    if !WindowedMode {

        WindowedMode := !WindowedMode ; Toggle the true/false state
        
        ; Calculate coordinates to center the window on the primary monitor
        ; TargetX := (A_ScreenWidth - TargetWidth) // 2
        TargetX := (A_ScreenWidth) - (TargetWidth // 3)
        ;TargetY := (A_ScreenHeight - TargetHeight) // 2
        TargetY := (A_ScreenHeight - TargetHeight)
        
        ; Reposition and apply resolution boundaries
        WinMove(TargetX, TargetY, TargetWidth, TargetHeight, GameTitle)

        ctrl.Opt("c3B82F6")
        ShowNotif("info", "Windowed Mode", "Press Alt + Left Click to hold and drag the game window.")
    }
    else {
        WindowedMode := !WindowedMode ; Toggle the true/false state

        ; --- STEP 3: Stretch the window to fill your entire monitor space ---
        WinMove(0, 0, A_ScreenWidth, A_ScreenHeight, GameTitle)

        ctrl.Opt("c94A3B8")
        ShowNotif("info", "Fullscreen Mode", "Press 🗗 button to enable windowed mode.")

        WinSetAlwaysOnTop(0, GameTitle)
        IsGameAlwaysOnTop := false
        AlwaysOnTopBtn.Opt("c94A3B8")
    }
}

; ToggleBackgroundLock() {
;     global ForceBackgroundMode
;     ForceBackgroundMode := !ForceBackgroundMode
    
;     if (ForceBackgroundMode) {
;         TrayTip("Background Lock ON", "The game is now locked out of focus.")
;         SetTimer(AnchorFocusToDesktop, 50) ; Check focus every 50 milliseconds
;     } else {
;         TrayTip("Background Lock OFF", "Game focus behavior returned to normal.")
;         SetTimer(AnchorFocusToDesktop, 0) ; Turn off the loop
;     }
; }

; AnchorFocusToDesktop() {
;     global GameTitle
    
;     ; If Windows tries to force the game to become active...
;     if WinActive(GameTitle) {
;         ; Immediately pass focus to the Windows Desktop shell layers instead!
;         ; This satisfies Windows' focus rule without activating the game.
;         if WinExist("ahk_class WorkerW")
;             WinActivate("ahk_class WorkerW")
;         else if WinExist("ahk_class Progman")
;             WinActivate("ahk_class Progman")
;     }
; }

ToggleWindowLock(ctrl) {
    global IsGameLocked, GameTitle
    
    if !WinExist(GameTitle) {
        ShowNotif("error","Lock Error", "Game window could not be found.")
        return
    }
    
    IsGameLocked := !IsGameLocked
    
    if (IsGameLocked) {
        ; 1. Tell Windows to disable the window. 
        ; It remains completely visible, but becomes completely immune to focus vacuuming and clicks.
        WinSetEnabled(false, GameTitle)
        
        ; 2. Instantly pass focus to the desktop wallpaper layer to clear the screen
        if WinExist("ahk_class WorkerW")
            WinActivate("ahk_class WorkerW")
        else if WinExist("ahk_class Progman")
            WinActivate("ahk_class Progman")
        
        ctrl.Opt("cF59E0B")
        ShowNotif("info", "Background Lock ON", "Game is locked open but completely inactive.")
    } else {
        ; 3. Re-enable the window so it can accept normal clicks and focus again
        WinSetEnabled(true, GameTitle)
        
        ; Bring it back to the front
        WinActivate(GameTitle) 
        
        ctrl.Opt("c94A3B8")
        ShowNotif("info", "Background Lock OFF", "Game control restored to normal.")
    }
}

AlwaysOnTopEnable(ctrl) {
    global IsGameAlwaysOnTop, GameTitle, WindowedMode
    
    if !WinExist(GameTitle) {
        ShowNotif("error","Always On Top", "Game window could not be found.")
        return
    }
    
    if !WindowedMode {
        ShowNotif("error","Always On Top", "Always On Top mode is disabled on Fullscreen mode.")
        return
    }
    
    IsGameAlwaysOnTop := !IsGameAlwaysOnTop
    
    if (IsGameAlwaysOnTop) {
        WinSetAlwaysOnTop(1, GameTitle)
        ctrl.Opt("cF7507F")
        ShowNotif("info", "Always On Top ON", "Game is set to be Always On Top other windows.")
    } else {
        WinSetAlwaysOnTop(0, GameTitle)
        ctrl.Opt("c94A3B8")
        ShowNotif("info", "Always On Top OFF", "Game is set to be normal.")
    }
}

MoveWindow() {
    CoordMode "Mouse", "Screen"
    MouseGetPos &startX, &startY, &targetWin
    WinGetPos &winX, &winY, , , targetWin
    
    while GetKeyState("LButton", "P") {
        MouseGetPos &currentX, &currentY
        WinMove winX + (currentX - startX), winY + (currentY - startY), , , targetWin
        Sleep 10 ; Smooth tracking without eating CPU
    }
}


; ══════════════════════════════════════════════
;  MISC SETTINGS
; ══════════════════════════════════════════════

; Calculates the similarity percentage between two strings (0 to 100)
GetTextSimilarity(str1, str2) {
    s := Format("{:L}", str1) ; Convert to lowercase for case-insensitivity
    t := Format("{:L}", str2)
    
    lenS := StrLen(s)
    lenT := StrLen(t)
    
    if (s == t) 
        return 100.0
    if (lenS == 0 || lenT == 0) 
        return 0.0
    
    v0 := []
    v1 := []
    loop lenT + 1 {
        v0.Push(A_Index - 1)
        v1.Push(0)
    }
    
    loop lenS {
        i := A_Index
        v1[1] := i
        chS := SubStr(s, i, 1)
        
        loop lenT {
            j := A_Index
            chT := SubStr(t, j, 1)
            cost := (chS == chT) ? 0 : 1
            v1[j + 1] := Min(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost)
        }
        loop lenT + 1 {
            v0[A_Index] := v1[A_Index]
        }
    }
    
    maxLen := Max(lenS, lenT)
    return (1 - (v0[lenT + 1] / maxLen)) * 100
}

_LinkNoirTelemetry(ctrl, initialValue) {
    ctrl.DefineProp("Text", {
        get: (this) => ControlGetText(this.Hwnd, this.Gui.Hwnd),
        set: (this, val) => (
            RegExMatch(val, "[—–-]\s*(.*)$", &match) 
            ? ControlSetText(match[1], this.Hwnd, this.Gui.Hwnd) 
            : ControlSetText(val, this.Hwnd, this.Gui.Hwnd)
        )
    })
    ctrl.Text := initialValue
    return ctrl
}

_CopyToClip(text, label) {
    A_Clipboard := text
    ToolTip(label " Copied!`n" text)
    SetTimer(() => ToolTip(), -2000)
}

LaunchGame(ctrl, *) {
    global GameDir, GameExe
    
    ; Ensure we have a working directory before trying to launch
    if (GameDir == "" || !DirExist(GameDir)) {
        if (!LocateGameDir(false)) {
            return ; Abort launch if directory wasn't found/selected
        }
    }
    
    try {
        Run(GameDir "\" GameExe)
        ShowNotif("success", "Launcher", "Launching Forza Horizon 6...")
    } catch Error as err {
        MsgBox("Failed to execute game binary:`n" err.Message, "Launcher Error", 16)
    }
}

FindGame() {
    global GameTitle

    if !WinExist(GameTitle) {
        ShowNotif("error", "Error", "Game process could not be found.")
        return 0
    }
}

LocateGameDir(forceManual := false) {
    global GameDir, GameExe
    targetFolder := ""

    if (!forceManual) {
        targetFolder := AutoLocateGameDir()
    }

    if (targetFolder == "") {
        if (!forceManual) {
            MsgBox("Forza Horizon 6 directory could not be auto-detected.`nPlease select your installation folder manually.", "MHI Auto-Setup", "Icon!")
        }
        chosenFolder := DirSelect(, 3, "Select your Forza Horizon 6 Installation Folder")
        if (!chosenFolder) {
            return false
        }
        targetFolder := chosenFolder
    }

    foundExe := false
    cleanPath := RTrim(targetFolder, "\")
    baseSlashes := StrLen(cleanPath) - StrLen(StrReplace(cleanPath, "\"))
    
    Loop Files, cleanPath "\" GameExe, "R" {
        currentSlashes := StrLen(A_LoopFileFullPath) - StrLen(StrReplace(A_LoopFileFullPath, "\"))
        if (currentSlashes - baseSlashes <= 3) {
            foundExe := true
            GameDir := RTrim(A_LoopFileDir, "\")
            break
        }
    }

    if (foundExe) {
        WriteMacroIni("Settings", "GameDir", GameDir)
        return true
    } else {
        MsgBox("Error: '" GameExe "' could not be found within 3 directory levels of the selected folder.", "MHI Verification Failed", "Iconx")
        return false
    }
}

AutoLocateGameDir() {
    global GameExe
    
    ; ── 1. REAL-TIME RUNNING HOOK (100% Reliable for both Steam & Xbox App) ──
    if WinExist("ahk_exe " GameExe) {
        try {
            fullPath := WinGetProcessPath("ahk_exe " GameExe)
            SplitPath(fullPath, , &dirPath)
            if DirExist(dirPath)
                return RTrim(dirPath, "\")
        }
    }

    ; ── 2. WINDOWS REGISTRY CHECK (Standard Steam/Retail App Paths) ──
    regLocations := [
        "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" GameExe,
        "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" GameExe
    ]
    for regPath in regLocations {
        try {
            fullPath := RegRead(regPath)
            SplitPath(fullPath, , &dirPath)
            if DirExist(dirPath)
                return RTrim(dirPath, "\")
        }
    }

    ; ── 3. STEAM SYSTEM DIRECTORY REGISTRY LOOKUP ──
    try {
        steamPath := RegRead("HKCU\SOFTWARE\Valve\Steam", "SteamPath")
        if steamPath {
            steamTarget := steamPath "\steamapps\common\ForzaHorizon6"
            if DirExist(steamTarget)
                return steamTarget
        }
    }

    ; ── 4. MULTI-DRIVE SCAN MATRIX (Fallback for Custom Libraries) ──
    drives := ["C", "D", "E", "F", "G", "H", "X"]
    for drive in drives {
        commonSteamPath := drive ":\SteamLibrary\steamapps\common\ForzaHorizon6"
        if DirExist(commonSteamPath)
            return commonSteamPath
            
        commonXboxPath := drive ":\XboxGames\Forza Horizon 6\Content"
        if DirExist(commonXboxPath)
            return commonXboxPath
            
        commonXboxRoot := drive ":\XboxGames\Forza Horizon 6"
        if DirExist(commonXboxRoot)
            return commonXboxRoot
    }

    return "" 
}

SpoofWindowFocus() {
    if WinExist(GameTitle) {
        ; Only spoof if the game is currently running in the background
        if !WinActive(GameTitle) {
            gameHwnd := WinExist(GameTitle)
            
            ; 0x0006 = WM_ACTIVATE | wParam = 1 (WA_ACTIVE)
            PostMessage(0x0006, 1, 0, , "ahk_id " gameHwnd)
            
            ; 0x001C = WM_ACTIVATEAPP | wParam = 1 (True)
            PostMessage(0x001C, 1, 0, , "ahk_id " gameHwnd)
        }
    }
}

WriteMacroIni(Section, Key, Value) {
    global GameExe, MacroIni

    Base := EnvGet("USERPROFILE") "\Documents\My Mods\SpecialK\Profiles\"
    
    targetDir := Base GameExe
    try {
        if (!DirExist(targetDir))
            DirCreate(targetDir)
        IniWrite(Value, targetDir "\" MacroIni, Section, Key)
    }
}

ReadMacroIni(Section, Key, DefaultValue := "") {
    global GameExe, MacroIni
    
    Base := EnvGet("USERPROFILE") "\Documents\My Mods\SpecialK\Profiles\"
        
    targetFile := Base GameExe "\" MacroIni
    if FileExist(targetFile) {
        try {
            return IniRead(targetFile, Section, Key)
        }
    }
    
    return DefaultValue ; Returns this if no file or key was found
}

VerifyAuction(timeoutMs := 5000) {
    global ActiveMode, MasterMode, MasterStart, CurrentMultiplier, GameTitle
    
    timeoutMs *= CurrentMultiplier
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