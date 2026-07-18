; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

; ══════════════════════════════════════════════
;  LOOP COORDINATION MECHANICS
; ══════════════════════════════════════════════

TogglePause() {
    global ActiveMode, PauseMode, StatusText, cStat, MasterMode
    p := GetPalette()

    Pause(-1)
    ;PauseMode := ActiveMode ? !PauseMode : PauseMode

    if !PauseMode && ActiveMode {
        StatusText.Value := "⬤  Paused..."
        StatusText.SetFont("c" p["cPaused"])
        PauseMode := true
        ShowNotif("info", "Macro Paused", "Execution has been temporarily suspended.")
    } else if PauseMode && ActiveMode {
        StatusText.Value := "⬤  Running..."
        StatusText.SetFont("c" cStat)
        PauseMode := false
        ShowNotif("info", "Macro Resumed", "Resuming automated sequence.")
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
    ShowNotif("info", "Mode Activated", "Routine locked into: " mode)
    return true
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
    global ActiveMode
    global StatusText, Process_UI, Key_UI, TotalRunTime_UI, CarSelect_UI
    global RadioRace, RadioBuy, RadioUnlock

    p := GetPalette()
    cActive := p["cActive"]
    cHighlight := P["cHighlight"]

    StatusText.Value := "⬤  Running..."
    StatusText.SetFont("c" cActive)

    Process_UI.SetFont("c" cHighlight)
    Key_UI.SetFont("c" cHighlight)
    TotalRunTime_UI.SetFont("c" cHighlight)

    if ActiveMode = "Buy" || ActiveMode = "Unlock"
        CarSelect_UI.Enabled := false

    EventLabSelect_UI.Enabled := false
    RadioRace.Enabled := false
    RadioBuy.Enabled := false
    RadioUnlock.Enabled := false

    StopBtn.Opt("cFF5A5A")
    PauseBtn.Opt("cFFD166")
    PauseBtn.Value := "❚❚"
}

ResetIndicators() {
    global Key_UI, Process_UI, StatusText
    global TotalRunTime_UI, RaceRunTime_UI, BuyRunTime_UI, UnlockRunTime_UI, SectorCount_UI, ActiveMode, MasterMode
    global SkillPtsCount_In, SkillPtsWant_In, CarCount_In, CarSelect_UI

    p := GetPalette()
    cIdle := p["cIdle"]
    cTextDim := p["cTextDim"]

    SetTimer(RaceTimerTick, 0)
    SetTimer(BuyTimerTick, 0)
    SetTimer(UnlockTimerTick, 0)
    SetTimer(SpinTimerTick, 0)
    
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
    MainSpinOpenCount_UI.SetFont("c" cIdle)
    MainSpinLeftCount_UI.SetFont("c" cIdle)
    MainSpinRunTime_UI.SetFont("c" cIdle)
    
    StatusText.Value := "⬤  Stopped"
    StatusText.SetFont("c" cTextDim)

    CarSelect_UI.Enabled := true
    EventLabSelect_UI.Enabled := true
    RadioRace.Enabled := true
    RadioBuy.Enabled := true
    RadioUnlock.Enabled := true

    StopBtn.Opt("c94A3B8")
    PauseBtn.Opt("c94A3B8")
    PauseBtn.Value := "❚❚"

    PressKey("W up")
}

; ══════════════════════════════════════════════
;  SCORE AND TIME CALCULATION
; ══════════════════════════════════════════════

GetMinScore(score) {
    global EventLab, EventLabData
    
    step := EventLabData[EventLab].AveragePoints
    return Floor(Ceil(score / step) * step)
}

CalcTotalTime(PointsGain, CarsToTarget, CarsToBuy:=CarsToTarget, CarsToUnlock:=CarsToTarget) {
    return CalcTimeRace(PointsGain) + CalcTimeBuy(CarsToBuy) + CalcTimeUnlock(CarsToUnlock) + (SpinInFullLoop ? CalcTimeSpin(CarsToUnlock) : 0)
}

CalcTimeRace(score) {
    global EventLab, EventLabData

    event := EventLabData[EventLab]
    AveragePoints       := event.AveragePoints
    secPerSection       := event.SecPerSection
    secPerRow           := event.SecPerRow
    sectionsPerRow      := event.SectionsPerRow
    StartLoadingTime    := event.StartLoadingTime
    MidLoadingTime      := event.MidLoadingTime
    FinLoadingTime      := event.FinLoadingTime

    sections  := Ceil(score / AveragePoints)
    rows      := Ceil(sections / sectionsPerRow)
    totalTime := StartLoadingTime + (sections * secPerSection) + (rows * secPerRow) + MidLoadingTime + FinLoadingTime

    return totalTime / 60
}

CalcTimeBuy(car) {
    totalTime := car * 3.2
    return totalTime / 60
}

CalcTimeUnlock(car) {
    totalTime := car * 38.5
    return totalTime / 60
}

CalcTimeSpin(car) {
    totalTime := car * 5.8
    return totalTime / 60
}

; ══════════════════════════════════════════════
;  TIMER TICKS
; ══════════════════════════════════════════════

TotalTimerTick() {
    global TotalRunSeconds, TotalRunTime_UI, MiniTotalRunTime_UI
    static lastStr := ""
    TotalRunSeconds++
    
    mins := TotalRunSeconds // 60
    secs := Mod(TotalRunSeconds, 60)
    timeStr := "🕓  " Format("{:02d}:{:02d}", mins, secs)

    TotalRunTime_UI.Value     := timeStr
    MiniTotalRunTime_UI.Value := timeStr

    DiscordStatusUpdate()
}

RaceTimerTick() {
    global RaceRunSeconds, RaceRunTime_UI, MiniRaceRunTime_UI
    RaceRunSeconds++
    mins := RaceRunSeconds // 60
    secs := Mod(RaceRunSeconds, 60)

    RaceRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
    MiniRaceRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
}

BuyTimerTick() {
    global BuyRunSeconds, BuyRunTime_UI, MiniBuyRunTime_UI
    BuyRunSeconds++
    mins := BuyRunSeconds // 60
    secs := Mod(BuyRunSeconds, 60)

    BuyRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
    MiniBuyRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
}

UnlockTimerTick() {
    global UnlockRunSeconds, UnlockRunTime_UI, MiniUnlockRunTime_UI
    UnlockRunSeconds++
    mins := UnlockRunSeconds // 60
    secs := Mod(UnlockRunSeconds, 60)

    UnlockRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
    MiniUnlockRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
}

spinTimerTick() {
    global SpinRunSeconds, SpinRunTime_UI, MiniSpinRunTime_UI, MainSpinRunTime_UI
    SpinRunSeconds++
    mins := SpinRunSeconds // 60
    secs := Mod(SpinRunSeconds, 60)

    SpinRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
    MiniSpinRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
    MainSpinRunTime_UI.Value := Format("{:02d}:{:02d}", mins, secs)
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

ScanOCR(ratioX, ratioY, ratioW, ratioH, waitTime := 0, targetText := "", searchNumber := false, notif := true) {
    global GameTitle

    ; Failsafe: Exit early if the game isn't running
    if !WinExist(GameTitle) {
        ShowNotif("error", "OCR Error", "Game window '" GameTitle "' is not running.")
        return -1
    }

    deadline := A_TickCount + waitTime

    Loop {
        try {
            ; 👉 CALL THE NEW BACKGROUND ENGINE HERE
            result := GetBackgroundOCR(ratioX, ratioY, ratioW, ratioH)
            scannedText := Trim(result)

            if (scannedText != "") {

                ; Condition A: Looking for one or more specific phrases
                if (targetText != "") {
                    ; Multiple target texts
                    if IsObject(targetText) {
                        for text in targetText {
                            if InStr(scannedText, text)
                                return scannedText
                        }
                    }
                    ; Single target text
                    else if InStr(scannedText, targetText) {
                        return scannedText
                    }
                }

                ; Condition B: Looking for a number/digit data type
                if (searchNumber) {
                    if InStr(scannedText, "No")
                        return 0 ; Custom "No available skills" fallback

                    cleanNumber := RegExReplace(scannedText, "\D")
                    if (cleanNumber != "")
                        return Number(cleanNumber)
                }

                ; Condition C: If user passed no targets or flags, just return raw string instantly
                if (targetText == "" && !searchNumber)
                    return scannedText
            }
        } catch {
            ; Suppressed background window state capture exception
        }

        if (A_TickCount >= deadline)
            break

        Sleep(50) ; Brief rest to keep CPU usage low
    }

    ; Trigger notifications on timeout
    if (waitTime > 0 && notif) {
        if (targetText != "") {

            if IsObject(targetText)
                target := '"' StrJoin(targetText, '", "') '"'
            else
                target := "'" targetText "'"

            ShowNotif(
                "warning",
                "OCR Timeout",
                "Failed to find text: " target " within " Round(waitTime / 1000, 1) "s"
            )

        } else if (searchNumber) {

            ShowNotif(
                "warning",
                "OCR Timeout",
                "Failed to find a valid number within " Round(waitTime / 1000, 1) "s"
            )

        }
    }

    return searchNumber ? -1 : false
}

StrJoin(arr, separator := ", ") {
    result := ""
    for i, value in arr
        result .= (i > 1 ? separator : "") value
    return result
}

; Load the wheelspin-exclusive car list from assets\exclusive_cars.csv into ExclusiveCars.
; CSV columns: "Long Car Name", "Short Car Name", "Valuable", "Value Seen In Auction House".
;   - Short Car Name : the string matched against OCR -> becomes the Map key. It MUST equal the
;                      name the game shows on the wheelspin duplicate prompt (see ShouldKeepExclusive).
;   - Valuable       : "true"/"false" -> the Map value. Selects which cars the VALUABLE mode keeps.
;   - Long / Value   : human-readable reference only; not read by the code.
; To maintain the list, add/edit rows in the CSV; no code change is needed.
; Missing/empty file leaves the map empty -> the Keep-Exclusives feature stays inert.
LoadExclusiveCars() {
    global ExclusiveCars
    ExclusiveCars := Map()

    csvPath := A_ScriptDir "\assets\exclusive_cars.csv"
    if !FileExist(csvPath) {
        ShowNotif("warning", "Keep Exclusives", "exclusive_cars.csv not found. `nExclusive cars will be sold/gifted as normal.")
        return
    }

    csv := FileRead(csvPath, "UTF-8")
    isHeader := true
    for line in StrSplit(csv, "`n", "`r") {
        if (Trim(line) == "")
            continue
        if isHeader {
            isHeader := false ; Skip the column header row
            continue
        }
        cols := StrSplit(line, ",")
        if (cols.Length < 3)
            continue
        shortName := Trim(cols[2])
        if (shortName == "")
            continue
        ExclusiveCars[shortName] := (StrLower(Trim(cols[3])) == "true")
    }
}

; Escape a literal string for safe use inside a RegEx pattern.
RegexEscape(str) {
    return RegExReplace(str, "([\\.\*\?\+\[\]\{\}\(\)\^\$\|\-#])", "\$1")
}

; Build a case-insensitive RegEx from a car name: the apostrophe (which OCR routinely garbles
; into a stray character, e.g. '19 -> 119) becomes a single-char wildcard, while the surrounding
; text (including the year digits) stays literal. So "Corvette '19" -> "Corvette .19" still
; matches "Corvette 119" but not "Corvette '09".
CarNamePattern(name) {
    parts := StrSplit(name, "'")
    pattern := ""
    for i, part in parts
        pattern .= (i > 1 ? "." : "") RegexEscape(part)
    return "i)" pattern
}

; Decide whether an OCR-read car name should be kept as a wheelspin-exclusive.
; mode: "ALL" keeps every listed exclusive; "VALUABLE" keeps only the valuable subset.
; Matches the short name with an apostrophe-wildcard (see CarNamePattern) to tolerate OCR noise
; in the year. Returns true only on a positive match (blank/garbled/unlisted -> false).
ShouldKeepExclusive(carText, mode) {
    global ExclusiveCars
    if (!carText || Trim(carText) == "")
        return false

    for shortName, valuable in ExclusiveCars {
        if RegExMatch(carText, CarNamePattern(shortName)) {
            if (mode == "ALL" || valuable)
                return true
        }
    }
    return false
}

GetBackgroundOCR(ratioX, ratioY, ratioW, ratioH) {
    global GameTitle
    hWnd := WinExist(GameTitle)
    if !hWnd
        return ""

    ; Calculate background frame geometry dimensions
    rectW := Buffer(16), rectC := Buffer(16), pt := Buffer(8)
    DllCall("GetWindowRect", "Ptr", hWnd, "Ptr", rectW)
    DllCall("GetClientRect", "Ptr", hWnd, "Ptr", rectC)
    
    wW := NumGet(rectW, 8, "Int") - NumGet(rectW, 0, "Int")
    hW := NumGet(rectW, 12, "Int") - NumGet(rectW, 4, "Int")
    wC := NumGet(rectC, 8, "Int")
    hC := NumGet(rectC, 12, "Int")

    NumPut("Int", 0, pt, 0), NumPut("Int", 0, pt, 4)
    DllCall("ClientToScreen", "Ptr", hWnd, "Ptr", pt)
    offsetX := NumGet(pt, 0, "Int") - NumGet(rectW, 0, "Int")
    offsetY := NumGet(pt, 4, "Int") - NumGet(rectW, 4, "Int")

    startX := offsetX + Integer(ratioX * wC)
    startY := offsetY + Integer(ratioY * hC)
    width  := Integer(ratioW * wC)
    height := Integer(ratioH * hC)

    ; Initialize low-level GDI Canvas structures
    hdcScreen := DllCall("GetDC", "Ptr", 0, "Ptr")
    hdcMemSrc  := DllCall("gdi32\CreateCompatibleDC", "Ptr", hdcScreen, "Ptr")
    hFullBmp   := DllCall("gdi32\CreateCompatibleBitmap", "Ptr", hdcScreen, "Int", wW, "Int", hW, "Ptr")
    hOldSrc    := DllCall("gdi32\SelectObject", "Ptr", hdcMemSrc, "Ptr", hFullBmp, "Ptr")

    ; Direct composition grab pulls data even if window is covered
    DllCall("PrintWindow", "Ptr", hWnd, "Ptr", hdcMemSrc, "UInt", 2)

    ; Setup the crop destination slice canvas
    hdcMemDst  := DllCall("gdi32\CreateCompatibleDC", "Ptr", hdcScreen, "Ptr")
    hCropBmp   := DllCall("gdi32\CreateCompatibleBitmap", "Ptr", hdcScreen, "Int", width, "Int", height, "Ptr")
    hOldDst    := DllCall("gdi32\SelectObject", "Ptr", hdcMemDst, "Ptr", hCropBmp, "Ptr")

    ; Execute the fast hardware crop transfer
    DllCall("gdi32\BitBlt", "Ptr", hdcMemDst, "Int", 0, "Int", 0, "Int", width, "Int", height, "Ptr", hdcMemSrc, "Int", startX, "Int", startY, "UInt", 0x00CC0020)

    ; 🌟 UNLOCK THE BITMAP: Restore original states so Windows UWP OCR can read it
    DllCall("gdi32\SelectObject", "Ptr", hdcMemDst, "Ptr", hOldDst)
    DllCall("gdi32\SelectObject", "Ptr", hdcMemSrc, "Ptr", hOldSrc)

    ; Perform the OCR pass over the unlocked memory block
    textResult := ""
    try {
        ocrObj := OCR.FromBitmap(hCropBmp, { scale: 3, invertcolors: 1 })
        textResult := Trim(ocrObj.Text)
    }

    ; Dispose of raw memory handlers safely to completely avoid memory leaks
    DllCall("gdi32\DeleteObject", "Ptr", hCropBmp)
    DllCall("gdi32\DeleteDC", "Ptr", hdcMemDst)
    DllCall("gdi32\DeleteObject", "Ptr", hFullBmp)
    DllCall("gdi32\DeleteDC", "Ptr", hdcMemSrc)
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hdcScreen)

    return textResult
}

WaitForPixel(text, ratioX, ratioY, targetColor, targetColorHDR := "", timeoutMs := 8000, postDelayMs := 1000, variation := 0, radius := 0, isFatal := false, note := "") {
    global ActiveMode, MasterMode, PixelMultiplier, GameTitle
    
    StartTime := A_TickCount
    LastSec   := -1
    
    timeoutMs   *= PixelMultiplier
    postDelayMs *= PixelMultiplier

    ; Parse colors safely to numeric values for bit-shifting operations
    nTarget := Integer(targetColor)
    nTargetHDR := targetColorHDR != "" ? Integer(targetColorHDR) : ""

    Loop {  
        hWnd := WinExist(GameTitle)
        if !hWnd
            return false

        ; Fetch structural dimensions of the target window
        rectW := Buffer(16)
        DllCall("GetWindowRect", "Ptr", hWnd, "Ptr", rectW)
        wW := NumGet(rectW, 8, "Int") - NumGet(rectW, 0, "Int")
        hW := NumGet(rectW, 12, "Int") - NumGet(rectW, 4, "Int")

        rectC := Buffer(16)
        DllCall("GetClientRect", "Ptr", hWnd, "Ptr", rectC)
        wC := NumGet(rectC, 8, "Int")
        hC := NumGet(rectC, 12, "Int")

        ; Calculate the exact structural offset of the client canvas relative to the window frame
        pt := Buffer(8)
        NumPut("Int", 0, pt, 0), NumPut("Int", 0, pt, 4)
        DllCall("ClientToScreen", "Ptr", hWnd, "Ptr", pt)
        offsetX := NumGet(pt, 0, "Int") - NumGet(rectW, 0, "Int")
        offsetY := NumGet(pt, 4, "Int") - NumGet(rectW, 4, "Int")

        ; Map scaling ratios directly to the background client zone coordinates
        centerX := offsetX + Integer(ratioX * wC)
        centerY := offsetY + Integer(ratioY * hC)
            
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

        ; BACKGROUND DEVICE CONTEXT RENDERING ENGINE
        hdcScreen := DllCall("GetDC", "Ptr", 0, "Ptr")
        hdcMem := DllCall("gdi32\CreateCompatibleDC", "Ptr", hdcScreen, "Ptr")
        hBitmap := DllCall("gdi32\CreateCompatibleBitmap", "Ptr", hdcScreen, "Int", wW, "Int", hW, "Ptr")
        hOld := DllCall("gdi32\SelectObject", "Ptr", hdcMem, "Ptr", hBitmap, "Ptr")
        
        ; Flag 2 (PW_RENDERFULLCONTENT) forces direct hardware composition capture 
        DllCall("PrintWindow", "Ptr", hWnd, "Ptr", hdcMem, "UInt", 2)

        pixelMatchFound := false
        
        ; Scan the internal graphic buffer within the designated radius
        loopY := y1
        while (loopY <= y2 && !pixelMatchFound) {
            loopX := x1
            while (loopX <= x2 && !pixelMatchFound) {
                bgrColor := DllCall("gdi32\GetPixel", "Ptr", hdcMem, "Int", loopX, "Int", loopY, "UInt")
                
                if (bgrColor != 0xFFFFFFFF) { ; Ensure valid data window reads
                    ; Convert background GDI Windows structure (BGR) back to standard AHK color formatting (RGB)
                    rgbColor := ((bgrColor & 0xFF) << 16) | (bgrColor & 0xFF00) | ((bgrColor >> 16) & 0xFF)
                    
                    if BGColorCompare(rgbColor, nTarget, variation) || (nTargetHDR !== "" && BGColorCompare(rgbColor, nTargetHDR, variation)) {
                        pixelMatchFound := true
                    }
                }
                loopX++
            }
            loopY++
        }

        ; Explicitly clean up all tracking handles to eliminate memory leaks
        DllCall("gdi32\SelectObject", "Ptr", hdcMem, "Ptr", hOld)
        DllCall("gdi32\DeleteObject", "Ptr", hBitmap)
        DllCall("gdi32\DeleteDC", "Ptr", hdcMem)
        DllCall("ReleaseDC", "Ptr", 0, "Ptr", hdcScreen)

        if (pixelMatchFound) {
            if (postDelayMs > 0)
                Sleep(postDelayMs)
            return true
        }

        if (A_TickCount - StartTime > timeoutMs) {
            if isFatal {
                failMsg := note != "" ? note : "Menu interaction timed out!"
                Process("Sync Error: " failMsg)
                if note != "0"
                    ShowNotif("error", "Sync Failure", failMsg)
                return false
            } else {
                Process("Sync Warning: Pixel missed. Proceeding...", 2000)
                ShowNotif("warning", "Sync Warning", "A tracking pixel was missed. `nContinuing routine safely...")
                return true 
            }
        }
        Sleep(50) 
    }
}

GetPixelColor(ratioX, ratioY, delayMs := 0) {
    global ActiveMode, MasterMode, PixelMultiplier, GameTitle
    
    ; Apply multiplier and execute delay ONLY if delayMs is greater than 0
    if (delayMs > 0) {
        delayMs *= PixelMultiplier
        StartTime := A_TickCount
        Loop {
            if !WinExist(GameTitle)
                return ""
            if (A_TickCount - StartTime >= delayMs)
                break
            Sleep(50) 
        }
    }

    hWnd := WinExist(GameTitle)
    if !hWnd
        return ""

    ; Calculate background frame metrics
    rectW := Buffer(16), rectC := Buffer(16), pt := Buffer(8)
    DllCall("GetWindowRect", "Ptr", hWnd, "Ptr", rectW)
    DllCall("GetClientRect", "Ptr", hWnd, "Ptr", rectC)
    
    wW := NumGet(rectW, 8, "Int") - NumGet(rectW, 0, "Int")
    hW := NumGet(rectW, 12, "Int") - NumGet(rectW, 4, "Int")
    wC := NumGet(rectC, 8, "Int")
    hC := NumGet(rectC, 12, "Int")

    NumPut("Int", 0, pt, 0), NumPut("Int", 0, pt, 4)
    DllCall("ClientToScreen", "Ptr", hWnd, "Ptr", pt)
    offsetX := NumGet(pt, 0, "Int") - NumGet(rectW, 0, "Int")
    offsetY := NumGet(pt, 4, "Int") - NumGet(rectW, 4, "Int")

    centerX := offsetX + Integer(ratioX * wC)
    centerY := offsetY + Integer(ratioY * hC)

    ; Initialize memory graphics handles
    hdcScreen := DllCall("GetDC", "Ptr", 0, "Ptr")
    hdcMem    := DllCall("gdi32\CreateCompatibleDC", "Ptr", hdcScreen, "Ptr")
    hBitmap   := DllCall("gdi32\CreateCompatibleBitmap", "Ptr", hdcScreen, "Int", wW, "Int", hW, "Ptr")
    hOld      := DllCall("gdi32\SelectObject", "Ptr", hdcMem, "Ptr", hBitmap, "Ptr")
    
    bgrColor := 0xFFFFFFFF ; Default to invalid flag
    
    try {
        ; Capture background window state layer
        DllCall("PrintWindow", "Ptr", hWnd, "Ptr", hdcMem, "UInt", 2)
        bgrColor := DllCall("gdi32\GetPixel", "Ptr", hdcMem, "Int", centerX, "Int", centerY, "UInt")
    } finally {
        ; 🌟 GUARANTEED CLEANUP: This block executes no matter what happens above
        DllCall("gdi32\SelectObject", "Ptr", hdcMem, "Ptr", hOld)
        DllCall("gdi32\DeleteObject", "Ptr", hBitmap)
        DllCall("gdi32\DeleteDC", "Ptr", hdcMem)
        DllCall("ReleaseDC", "Ptr", 0, "Ptr", hdcScreen)
    }

    ; CLR_INVALID or window acquisition failure fallback
    if (bgrColor = 0xFFFFFFFF)
        return ""

    ; Convert GDI's native 0xBBGGRR format cleanly into standard 0xRRGGBB
    rgbColor := ((bgrColor & 0xFF) << 16) | (bgrColor & 0xFF00) | ((bgrColor >> 16) & 0xFF)
    return Format("0x{:06X}", rgbColor)
}

; Internal processing math module to match variations across shading maps
BGColorCompare(color1, color2, variation) {
    if (variation == 0)
        return color1 == color2
        
    r1 := (color1 >> 16) & 0xFF, g1 := (color1 >> 8) & 0xFF, b1 := color1 & 0xFF
    r2 := (color2 >> 16) & 0xFF, g2 := (color2 >> 8) & 0xFF, b2 := color2 & 0xFF
    
    return (Abs(r1 - r2) <= variation) && (Abs(g1 - g2) <= variation) && (Abs(b1 - b2) <= variation)
}

; ══════════════════════════════════════════════
;  CONTROL OUTPUTS & HARDWARE ACTIONS
; ══════════════════════════════════════════════

PressKey(key, delay := 500, delayEnable:= true) {
    global Key_UI, MiniKey_UI, cHighlight, cIdle, KeyMultiplier, GameTitle, GameHwnd, GameExe

    switch StrLower(key) {
        case "down":            displayname := "↓"
        case "up":              displayname := "↑"
        case "left":            displayname := "←"
        case "right":           displayname := "→"
        case "enter":           displayname := "Enter ↵" 
        case "backspace":       displayname := "⬅ Backspace"
        case "w down", "w up":  displayname := "W"
        case "s down", "s up":  displayname := "S"
        default:                displayname := key
    }

    if IsSet(Key_UI) && Key_UI
        Key_UI.Value     := "⌨  [ " displayname " ]"
    if IsSet(MiniKey_UI) && MiniKey_UI
        MiniKey_UI.Value := "⌨  [ " displayname " ]"

    cleanKey := key
    suffix   := ""
    if InStr(key, " ") {
        parts    := StrSplit(key, " ")
        cleanKey := parts[1]   
        suffix   := parts[2] 
    }

    try {
        vkCode := GetKeyVK(cleanKey)
        scCode := GetKeySC(cleanKey)
        
        isExtended := (cleanKey = "Up" || cleanKey = "Down" || cleanKey = "Left" || cleanKey = "Right" || cleanKey = "Enter")
        extBit     := isExtended ? 0x01000000 : 0
        
        lParamDown := 0x00000001 | (scCode << 16) | extBit
        lParamUp   := 0xC0000001 | (scCode << 16) | extBit
    } catch {
        return 
    }

    if (!GameHwnd || !WinExist(GameHwnd)) {
        GameHwnd := WinExist("ahk_exe " GameExe)
    }

    if (!GameHwnd) {
        ShowNotif("error", "Target Error", "Native game window (" GameExe ") was not found.")
        return
    }

    try {
        if (suffix = "down") {
            PostMessage(0x0100, vkCode, lParamDown, , "ahk_id " GameHwnd)
        }
        else if (suffix = "up") {
            PostMessage(0x0101, vkCode, lParamUp, , "ahk_id " GameHwnd)
        } 
        else {
            PostMessage(0x0100, vkCode, lParamDown, , "ahk_id " GameHwnd)
            Sleep(45) 
            PostMessage(0x0101, vkCode, lParamUp, , "ahk_id " GameHwnd)
        }
    } catch {
        ShowNotif("error", "Target Error", "Keystroke failed to post to native local game.")
    }
    
    currentMultiplier := IsSet(KeyMultiplier) ? KeyMultiplier : 1

    if delayEnable
        actualDelay := Random(delay, delay + 50)
    else
        actualDelay := delay
    
    Sleep(currentMultiplier * actualDelay)
}

SendToGamingUI(numberString) {
    ; Target the window by class so we don't accidentally send to explorer.exe
    target := "ahk_class ApplicationFrameWindow"
    
    ; 1. Check if the window exists
    if (!WinExist(target)) {
        ShowNotif("error", "Target Error", "Gaming UI window not found.")
        return
    }

    ; 2. SetKeyDelay is CRITICAL for UWP/Gaming UI
    ; Gaming UI apps are slow to process input. 
    ; 50ms press duration, 50ms between keys prevents dropped characters.
    SetKeyDelay(50, 50)

    try {
        ; Send the number string followed by Enter
        ; The empty parameter for Control causes it to send to the window's main input area
        ControlSend(numberString "{Enter}", , target)
    } catch as e {
        ShowNotif("error", "ControlSend Error", "Failed to send to Gaming UI: " e.Message)
    }
}

TypeStringViaPressKey(str) {
    global GameHwnd, GameExe
    
    ; 1. Find the Gaming UI window specifically
    ; targetHwnd := WinExist("Gaming UI ahk_class ApplicationFrameWindow")
    
    ; if (!targetHwnd) {
    ;     ShowNotif("error", "Target Error", "Gaming UI window not found.")
    ;     return
    ; }

    ; 2. Temporarily swap the GameHwnd to the Gaming UI
    ; originalHwnd := GameHwnd
    ; GameHwnd := targetHwnd

    ; 3. Loop through each character in the string
    Loop Parse, str {
        PressKey(A_LoopField)
        Sleep(50) ; Small delay between keystrokes to ensure the UI catches them
    }

    ; 4. Press Enter
    PressKey("Enter")

    ; 5. Restore the original GameHwnd so your main game keeps working
    ; GameHwnd := originalHwnd
}

PasteNumberToGamingUI(numberToPaste) {
    ; Access the game's executable name defined globally in your script[cite: 1]
    global GameExe 

    ; 1. Bookmark whatever the user is looking at RIGHT NOW
    originalActiveWin := WinExist("A")
    
    ; 2. Dynamically locate the actual game window using its process name[cite: 1]
    gameWin := 0
    if (IsSet(GameExe) && GameExe && WinExist("ahk_exe " GameExe)) {
        gameWin := WinExist("ahk_exe " GameExe)
    }
    
    ; If the game is hiding in the background, bring it forward first
    if (gameWin && originalActiveWin != gameWin) {
        WinActivate(gameWin)
        WinWaitActive(gameWin, , 1.0)
    }

    ; Define the target overlay window
    targetWin := "Gaming UI ahk_class ApplicationFrameWindow"
    
    ; Check if the overlay window exists
    if !WinExist(targetWin) {
        ShowNotif("warning", "Target Error", "Gaming UI window not found.")
        TypeStringViaPressKey(numberToPaste)
        return
    }

    ; --- CRITICAL FIX: Snatch the unique Process ID (PID) of the Gaming UI ---
    targetPID := WinGetPID(targetWin)

    ; Focus the overlay
    WinActivate(targetWin)
    if !WinWaitActive(targetWin, , 0.5) {
        ShowNotif("error", "Focus Error", "Could not bring Gaming UI to foreground.")
        return
    }

    ; Perform the paste sequence
    oldClip := ClipboardAll()
    A_Clipboard := numberToPaste
    
    Sleep(100) 
    Send("^v")
    Sleep(100)
    Send("{Enter}")
    A_Clipboard := oldClip

    Sleep(500) 

    ; 4. VERIFY AND CLOSE THE WINDOWS
    ; First, close the primary Gaming UI window
    if WinExist(targetWin) {
        WinClose(targetWin)
        if !WinWaitClose(targetWin, , 1.0) {
            WinActivate(targetWin)
            Send("{Esc}")
        }
    }

    ; SECONDARY SWEEP: Hunt down any lingering blank windows from the same process
    if (targetPID) {
        Loop 3 { ; Attempt up to 3 times so the script never gets stuck in an infinite loop
            blankWin := WinExist("ahk_class ApplicationFrameWindow ahk_pid " targetPID)
            if !blankWin
                break ; No more windows from this process found, we are clear!
                
            ; If it exists and the title is completely empty, it's the stuck input box
            if (WinGetTitle(blankWin) == "") {
                WinClose(blankWin)
                if !WinWaitClose(blankWin, , 0.5) {
                    WinActivate(blankWin)
                    Send("{Esc}")
                    Sleep(100)
                }
            } else {
                break ; If it has an actual title, leave it alone to be safe
            }
        }
    }

    ; 5. KILL THE GLOW: Force-focus the game so Windows clears the taskbar alarm
    if (gameWin && WinExist(gameWin)) {
        Sleep(200)
        WinActivate(gameWin)
        WinWaitActive(gameWin, , 0.5)
    }

    ; 6. BE A GOOD NEIGHBOR: If you were tabbed out, put you right back where you were
    if (originalActiveWin && originalActiveWin != gameWin && WinExist(originalActiveWin)) {
        Sleep(100)
        WinActivate(originalActiveWin)
    }
}

Process(text, delay := 0) {
    global Process_UI

    Process_UI.Value     := "⚙️  " text
    MiniProcess_UI.Value := "⚙️  " text
    Sleep(delay)
}

UpdateSpeed(*) {
    global SpeedLabel_UI, DelaySlider_UI

    sliderPosition := DelaySlider_UI.Value
    
    Global KeyMultiplier := Multipliers[sliderPosition]
    SpeedLabel_UI.Text   := "Key Delay Multiplier: " KeyMultiplier "x"

    WriteMacroIni("Settings", "KeyMultiplier", KeyMultiplier)
}

; ══════════════════════════════════════════════
;  RESOLUTION-RELATIVE MATRIX INITIALIZATION
; ══════════════════════════════════════════════

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

UpdateMonitorMetrics() {
    global MonLeft, MonTop, MonRight, MonBottom, MonWidth, MonHeight, ScaleX, ScaleY, FontScale
    global GameHwnd, GameTitle

    ; Smart Handle Syncing
    if (!GameHwnd || !WinExist(GameHwnd)) {
        if IsSet(GameTitle)
            GameHwnd := WinExist(GameTitle)
    }

    gameMonitor := GetGameMonitor()
    
    ; 1. POSITIONING BOUNDS: Read usable Desktop workspace context (Excludes taskbars)
    MonitorGetWorkArea(gameMonitor, &wLeft, &wTop, &wRight, &wBottom)
    MonLeft    := wLeft
    MonTop     := wTop
    MonRight   := wRight
    MonBottom  := wBottom
    MonWidth   := wRight - wLeft
    MonHeight  := wBottom - wTop

    ; 2. DISPLAY SCALING PROPORTIONS: Read true raw hardware panel parameters
    MonitorGet(gameMonitor, &mLeft, &mTop, &mRight, &mBottom)
    fullWidth  := mRight - mLeft
    fullHeight := mBottom - mTop
    
    ScaleX     := fullWidth / 2560
    ScaleY     := fullHeight / 1440

    ; 3. PER-WINDOW CONTEXTUAL DPI TRANSFORMATION
    targetDpi := (GameHwnd && WinExist(GameHwnd)) 
                 ? DllCall("User32\GetDpiForWindow", "Ptr", GameHwnd, "UInt") 
                 : DllCall("User32\GetDpiForSystem", "UInt")

    FontScale  := ScaleX / (targetDpi / 96)
}

FormatCommas(val) {
    return RegExReplace(val, "\G\d+?(?=(\d{3})+(?:\D|$))", "$0,")
}

; ══════════════════════════════════════════════
;  MASTER MOUSE ROUTING CONTROLLER
; ══════════════════════════════════════════════

OnMessage(0x0201, WM_LBUTTONDOWN)

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    global SliderKnob, SliderTrack
    global ActiveDragGui, DragOffsetX, DragOffsetY

    ; 1. CUSTOM SLIDER ENGINE ROUTING
    if (IsSet(SliderKnob) && IsSet(SliderTrack) && (hwnd == SliderKnob.Hwnd || hwnd == SliderTrack.Hwnd)) {
        DragSliderTimer()
        SetTimer(DragSliderTimer, 10)
        return
    }

    ; 2. NATIVE WORKSPACE IDENTIFICATION
    rootHwnd := DllCall("User32\GetAncestor", "Ptr", hwnd, "UInt", 2, "Ptr")
    if !(guiObj := GuiFromHwnd(rootHwnd))
        return

    ctrlClass := WinGetClass(hwnd)
    if (ctrlClass != "AutoHotkeyGUI" && ctrlClass != "Static")
        return
        
    if (ctrlClass == "Static" && (WinGetStyle(hwnd) & 0x100))
        return 

    ; 4. INITIALIZE UNIFIED INTERFACE DRAG STATE
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)
    WinGetPos(&guiX, &guiY, , , rootHwnd)
    
    ActiveDragGui := guiObj  ; <-- Store the complete GUI instance reference rather than the HWND
    DragOffsetX   := mouseX - guiX
    DragOffsetY   := mouseY - guiY
    
    SetTimer(DragActiveGui, 10)
}

; ══════════════════════════════════════════════
;  BACKGROUND ASYNC WORKER LOOPS (NON-BLOCKING)
; ══════════════════════════════════════════════

DragActiveGui() {
    global ActiveDragGui, DragOffsetX, DragOffsetY
    
    if !IsSet(ActiveDragGui) || !ActiveDragGui || !GetKeyState("LButton", "P") {
        SetTimer(, 0)
        ActiveDragGui := 0
        return
    }
    
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)
    
    ; Bypasses global window lookup engines for instantaneous updates
    try ActiveDragGui.Move(mouseX - DragOffsetX, mouseY - DragOffsetY)
}

; ══════════════════════════════════════════════
;  REPOSITION GAME CLIENT WINDOW
; ══════════════════════════════════════════════

MoveWindow() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&startX, &startY, &targetWin)
    
    ; Cache the window's width and height once so we don't query it inside the loop
    try WinGetPos(, , &winW, &winH, targetWin)
    catch
        return ; Exit if the window handle vanishes
        
    WinGetPos(&winX, &winY, , , targetWin)
    
    while GetKeyState("LButton", "P") {
        MouseGetPos(&currentX, &currentY)
        
        newX := winX + (currentX - startX)
        newY := winY + (currentY - startY)
        
        ; DIRECT WIN32 API CALL: Bypasses AHK window validation entirely.
        ; Moves the external game client/window smoothly at the driver level.
        DllCall("User32\MoveWindow", "Ptr", targetWin, "Int", newX, "Int", newY, "Int", winW, "Int", winH, "Int", 1)
        
        Sleep(10)
    }
}

; ══════════════════════════════════════════════
;  GAME LAUNCH AND DIRECTORY FUNCTIONS
; ══════════════════════════════════════════════

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
        ShowNotif("info", "Launcher", "Launching Forza Horizon 6...")
    } catch Error as err {
        MsgBox("Failed to execute game binary:`n" err.Message, "Launcher Error", 16)
    }
}

FindGame() {
    global GameTitle

    if !WinExist(GameTitle) {
        ShowNotif("error", "Game Detection", "Game process could not be found.")
        return false
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

; ══════════════════════════════════════════════
;  INI I/O FUNCTIONS
; ══════════════════════════════════════════════

WriteMacroIni(Section, Key, Value) {
    global MacroIni, RepoName

    Base := EnvGet("USERPROFILE") "\Documents\"
    
    targetDir := Base RepoName
    try {
        if (!DirExist(targetDir))
            DirCreate(targetDir)
        IniWrite(Value, targetDir "\" MacroIni, Section, Key)
    }
}

ReadMacroIni(Section, Key, DefaultValue := "") {
    global MacroIni, RepoName
    
    Base := EnvGet("USERPROFILE") "\Documents\"
        
    targetFile := Base RepoName "\" MacroIni
    if FileExist(targetFile) {
        try {
            return IniRead(targetFile, Section, Key)
        }
    }
    
    return DefaultValue ; Returns this if no file or key was found
}

; ══════════════════════════════════════════════
;  MISC FUNCTIONS
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

; Register a Shell Hook to monitor window changes instantly
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
MsgNum := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
OnMessage(MsgNum, WindowChangedEvent)

WindowChangedEvent(wParam, lParam, *) {
    ; 4 = HSHELL_WINDOWACTIVATED | 32772 = HSHELL_RUDEGRIDACTIVATED
    ; These fire the exact millisecond any window gains focus
    if (wParam == 4 || wParam == 32772) {
        if WinExist(GameTitle) && !WinActive(GameTitle) {
            gameHwnd := WinExist(GameTitle)
            
            ; Spam all focus messages instantly before the game can process the pause
            PostMessage(0x0006, 1, 0, , "ahk_id " gameHwnd)      ; WM_ACTIVATE
            PostMessage(0x001C, 1, 0, , "ahk_id " gameHwnd)      ; WM_ACTIVATEAPP
            PostMessage(0x0086, 1, 0, , "ahk_id " gameHwnd)      ; WM_NCACTIVATE
        }
    }
}

ScanMenu(timeoutDuration := 5000) {
    global ActiveMode, MasterMode
    PressKey("up", 1000) ; Stop idling

    StartTime := A_TickCount
    
    while (A_TickCount - StartTime <= timeoutDuration) {
        for profile in MenuProfiles {
            ; Fetch coordinates instantly using the profile's coordinate key
            el := OCRCoords[profile.coordKey]
            
            ocrText := ScanOCR(el.x, el.y, el.w, el.h, 200)
            
            for keyword, subMenuValue in profile.keywords {
                if InStr(ocrText, keyword) {
                    return { menu: profile.menu, submenu: subMenuValue }
                }
            }
        }
        Sleep(50)
    }

    Process("Timeout Error...")
    ShowNotif("error", "Menu Detection", "Scanning timed out!")
    ActiveMode := "", MasterMode := false
    return { menu: "", submenu: "" } 
}

WaitForText(elementKey, timeoutDuration := 5000, customSearchText := "") {
    ; Safety check: Make sure the element exists in your map
    if !OCRCoords.Has(elementKey) {
        MsgBox("Error: '" elementKey "' is missing from the OCRCoords map.")
        return false
    }
    
    ; Fetch coordinates cleanly using dot notation
    el := OCRCoords[elementKey]
    startTime := A_TickCount
    
    ; Determine the text to look for: 
    ; Use customSearchText if provided, otherwise default to the elementKey string
    searchText := (customSearchText != "") ? customSearchText : elementKey
    
    ; Your original uniform processing logic for single strings vs arrays
    targets := IsObject(searchText) ? searchText : [searchText]
    isMultiple := IsObject(searchText)

    while (A_TickCount - startTime <= timeoutDuration) {
        ocrText := ScanOCR(el.x, el.y, el.w, el.h, 200)
        
        ; Check each target text against the scanned OCR result
        for textItem in targets {
            if (InStr(ocrText, textItem)) {
                return isMultiple ? textItem : true 
            }
        }
        
        Sleep(50) 
    }
    
    return false 
}

CarVerifyCheck(title:="", car:="", stats:="", exit:=true) {
    global GameTitle, ActiveMode, CarData, SelectedCar
    static StatsNum := 0
    
    ; Early exit guard clause
    if !WinExist(GameTitle) {
        return
    }

    expectedList := []
    
    ; 1. Process the stats parameter (handles both single values and arrays)
    if (stats != 0 && stats != "") {
        if IsObject(stats) { ; If you passed an array like ["num1", "num2"]
            for item in stats
                expectedList.Push(item)
        } else { ; If you passed a single number/string
            expectedList.Push(stats)
        }
    }
    
    ; 2. Fallback to global CarData if the parameter was omitted
    if (expectedList.Length == 0) {
        cData := CarData[SelectedCar]
        if IsObject(cData.StatsNum) {
            for item in cData.StatsNum
                expectedList.Push(item)
        } else if (cData.StatsNum != 0 && cData.StatsNum != "") {
            expectedList.Push(cData.StatsNum)
        }
    }
    
    ; Define both coordinate presets
    mazdaCoords    := {x: 0.170, y: 0.455, w: 0.035, h: 0.245}
    standardCoords := {x: 0.177, y: 0.457, w: 0.028, h: 0.250}

    ; Determine primary and secondary based on selection
    isMadMike := car ? car == "1974 Mazda" : (CarData[SelectedCar].AltName == "1974 Mazda")
    primary   := isMadMike ? mazdaCoords : standardCoords
    secondary := isMadMike ? standardCoords : mazdaCoords

    ; Primary Scan Attempt
    StatsNumNew := ScanOCR(primary.x, primary.y, primary.w, primary.h, 100, , true, false)

    ; Cross-Scan Fallback
    if (StrLen(StatsNumNew) < 10 || StatsNumNew = -1) {
        StatsNumNew := ScanOCR(secondary.x, secondary.y, secondary.w, secondary.h, 100, , true, false)
    }
    
    ; Validation Checks
    if (StrLen(StatsNumNew) >= 10 && StatsNumNew != -1) {
        StatsNum := StatsNumNew
        
        BestScore := 0
        BestExpected := ""
        
        ; Find the closest match out of all expected numbers
        for expNum in expectedList {
            currentScore := Round(GetTextSimilarity(expNum, StatsNum))
            if (currentScore > BestScore) {
                BestScore := currentScore
                BestExpected := expNum
            }
        }
        
        ; Match fails threshold -> Emergency Exit
        if (BestScore <= 80) {
            Details := "Wrong Car Detected!`n`n"
                     . "Scanning " SelectedCar " Stats Number...`n"
                     . "Scanned: " StatsNum "`n"
                     . "Closest Expected Match: " BestExpected "`n"
                     . "Similarity: " BestScore "%"
            if exit
                EmergencyExit(Details)
            else 
                return false
        }
        
        ; Match passes threshold -> Success Notification
        ShowNotif("info", title, "Car Stats detected: `n" StatsNum " (" BestScore "% match)")
        return true
    }

    ; Total Failure Notification
    ShowNotif("warning", title, "Car Stats not detected: `nEnsure it is fully visible on screen.")
    return false
}

EmergencyExit(LogDetails := "Unknown safety violation.") {
    global ActiveMode

    ShowNotif("critical", ActiveMode "Mode", LogDetails, true)
    SoundBeep(400, 500)
    MsgBox(
        "CRITICAL SAFETY INTERCEPT!`n`n" 
        LogDetails "`n`n"
        "Script has been reset to IDLE state to protect your account.", 
        "MHI Emergency System",
        "IconX"
    )
    Reload()
}