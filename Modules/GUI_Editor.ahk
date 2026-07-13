; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

; ══════════════════════════════════════════════
;   UNIFIED DATABASE EDITOR AND CREATOR ENGINE
; ══════════════════════════════════════════════

; ── Helper Function: Core Profile Protection Check ──
IsDefaultProfile(CarName) {
    global DefaultProfiles
    for defaultName in DefaultProfiles {
        if (CarName = defaultName) ; Case-insensitive match against the dynamic startup array
            return true
    }
    return false
}

ShowCarEditorGUI(Mode := "New") {
    global CarData, SelectedCar, CarList, RepoName, ScaleX, ScaleY, MainGUI, EditorGui, MacroCarIni
    
    try {
        if IsSet(EditorGui) && EditorGui && WinExist("ahk_id " EditorGui.Hwnd) {
            WinActivate("ahk_id " EditorGui.Hwnd)
            return
        }
    } catch {
        ; Trap micro-delay synchronization anomalies
    }

    p := GetPalette()
    MainGUI.Opt("+Disabled")
    EditorGui := Gui("+AlwaysOnTop -MaximizeBox -DPIScale -Caption +Border +Owner", Mode == "New" ? "MHI | ADD VEHICLE" : "MHI | EDIT PROFILE")
    EditorGui.BackColor := p["bg"]
    
    vName := "", vAltName := "", vStats := "", vMfrPath := "", vCarPath := "", vUnlockPath := "", vCost := "0", vSWheel := "0", vWheel := "0", vCredit := "0"
    
    if (Mode == "Edit") {
        if (!SelectedCar || !CarData.Has(SelectedCar)) {
            MsgBox("No vehicle profile is currently selected for modifications.", "Error", 48)
            return
        }
        vName    := SelectedCar
        cData    := CarData[SelectedCar]
        vAltName := cData.HasOwnProp("AltName") ? cData.AltName : ""
        vStats   := cData.HasOwnProp("StatsNum") ? cData.StatsNum : ""
        vCost    := cData.HasOwnProp("SkillPtsCost") ? cData.SkillPtsCost : "0"
        vSWheel  := cData.HasOwnProp("UnlockSWheel") ? cData.UnlockSWheel : "0"
        vWheel   := cData.HasOwnProp("UnlockWheel") ? cData.UnlockWheel : "0"
        vCredit  := cData.HasOwnProp("UnlockCredit") ? cData.UnlockCredit : "0"

        if cData.HasOwnProp("BuyMfrPath") && IsObject(cData.BuyMfrPath) {
            for item in cData.BuyMfrPath {
                vMfrPath .= (vMfrPath == "" ? "" : ", ") item[1] " " item[2]
            }
        }
        if cData.HasOwnProp("BuyCarPath") && IsObject(cData.BuyCarPath) {
            for item in cData.BuyCarPath {
                vCarPath .= (vCarPath == "" ? "" : ", ") item[1] " " item[2]
            }
        }
        if cData.HasOwnProp("UnlockPath") && IsObject(cData.UnlockPath) {
            for item in cData.UnlockPath {
                vUnlockPath .= (vUnlockPath == "" ? "" : ", ") item[1] " " item[2]
            }
        }
    }
    
    ; Caption Controls
    SetFixedFont(EditorGui, 10, "bold")
    ; EditorMin := EditorGui.Add("Text", "x" Round(265*ScaleX) " y" Round(12*ScaleY) " w" Round(16*ScaleX) " h" Round(16*ScaleY) " Center BackgroundTrans c" p["textDim"], "─")
    ; EditorMin.OnEvent("Click", (*) => WinMinimize(EditorGui.Hwnd))
    EditorX := EditorGui.Add("Text", "x" Round(285*ScaleX) " y" Round(12*ScaleY) " w" Round(16*ScaleX) " h" Round(16*ScaleY) " Center BackgroundTrans c" p["textDim"], "✕")
    EditorX.OnEvent("Click", (*) => ClosePopup())

    SetFixedFont(EditorGui, 12, "bold", "Light")
    EditorGui.Add("Text", "x0 y" Round(30*ScaleY) " w" Round(310*ScaleX) " Center c" p["accent"], Mode == "New" ? "ADD NEW VEHICLE" : "EDIT VEHICLE PROFILE")

    ; Shared Layout Geometry Tokens
    lblW  := Round(95 * ScaleX)
    editW := Round(170 * ScaleX)
    editX := Round(125 * ScaleX) 
    rowH  := Round(22 * ScaleY)
    gapY  := Round(6 * ScaleY)
    
    ; =========================================================================
    ; SECTION 1: PROFILE IDENTIFICATION INFO
    ; =========================================================================
    SetFixedFont(EditorGui, 8, "bold")
    EditorGui.Add("Text", "x" Round(15*ScaleX) " y" Round(66*ScaleY) " w" Round(280*ScaleX) " h" Round(14*ScaleY) " Center c" p["textDim"], "──  PROFILE IDENTITY  ──")
    
    SetFixedFont(EditorGui, 9, "norm", "Light")
    EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(8*ScaleY) " w" lblW " h" rowH " 0x200 c" p["textDim"], "Profile Name:")
    EditorGui.eName := EditorGui.Add("Edit", "x" editX " yp w" editW " h" rowH " -E0x200 Background" p["editBg"] " c" p["text"] (Mode == "Edit" ? " +ReadOnly" : ""), vName)
    if (Mode == "Edit")
        EditorGui.eName.Opt("+Disabled c" p["textDim"])
        
    EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" gapY " w" lblW " h" rowH " 0x200 c" p["textDim"], "Search Name:")
    EditorGui.eAlt := EditorGui.Add("Edit", "x" editX " yp w" editW " h" rowH " -E0x200 Background" p["editBg"] " c" p["text"], vAltName)
    
    EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" gapY " w" lblW " h" rowH " 0x200 c" p["textDim"], "Stats Number:")
    EditorGui.eStats := EditorGui.Add("Edit", "x" editX " yp w" editW " h" rowH " -E0x200 Background" p["editBg"] " c" p["text"] " Number", vStats)

    ; =========================================================================
    ; SECTION 2: REWARD BALANCES & VALUATION ECONOMY
    ; =========================================================================
    SetFixedFont(EditorGui, 8, "bold")
    EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(14*ScaleY) " w" Round(280*ScaleX) " h" Round(14*ScaleY) " Center c" p["textDim"], "──  REWARDS & ECONOMY  ──")
    
    SetFixedFont(EditorGui, 9, "norm", "Light")
    EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(8*ScaleY) " w" lblW " h" rowH " 0x200 c" p["textDim"], "Points Cost:")
    EditorGui.eCost := EditorGui.Add("Edit", "x" editX " yp w" editW " h" rowH " -E0x200 Background" p["editBg"] " c" p["text"] " Number", vCost)
    
    EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" gapY " w" lblW " h" rowH " 0x200 c" p["textDim"], "Super Spins:")
    EditorGui.eSWheel := EditorGui.Add("Edit", "x" editX " yp w" editW " h" rowH " -E0x200 Background" p["editBg"] " c" p["text"] " Number", vSWheel)
    
    EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" gapY " w" lblW " h" rowH " 0x200 c" p["textDim"], "Regular Spins:")
    EditorGui.eWheel := EditorGui.Add("Edit", "x" editX " yp w" editW " h" rowH " -E0x200 Background" p["editBg"] " c" p["text"] " Number", vWheel)
    
    EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" gapY " w" lblW " h" rowH " 0x200 c" p["textDim"], "Credits (CR):")
    EditorGui.eCredit := EditorGui.Add("Edit", "x" editX " yp w" editW " h" rowH " -E0x200 Background" p["editBg"] " c" p["text"] " Number", vCredit)

    ; =========================================================================
    ; SECTION 3: AUTOMATION ROUTE PATHS (Moved to the bottom)
    ; =========================================================================
    SetFixedFont(EditorGui, 8, "bold")
    EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(14*ScaleY) " w" Round(280*ScaleX) " h" Round(14*ScaleY) " Center c" p["textDim"], "──  AUTOMATION PATHS  ──")
    
    SetFixedFont(EditorGui, 9, "norm", "Light")
    EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(8*ScaleY) " w" lblW " h" rowH " 0x200 c" p["textDim"], "Manufacturer Path:")
    EditorGui.eMfrPath := EditorGui.Add("Edit", "x" editX " yp w" editW " h" rowH " -E0x200 Background" p["editBg"] " c" p["text"], vMfrPath)

    EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" gapY " w" lblW " h" rowH " 0x200 c" p["textDim"], "Car Path:")
    EditorGui.eCarPath := EditorGui.Add("Edit", "x" editX " yp w" editW " h" rowH " -E0x200 Background" p["editBg"] " c" p["text"], vCarPath)
    
    EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" gapY " w" lblW " h" rowH " 0x200 c" p["textDim"], "Unlock Path:")
    EditorGui.eUnlockPath := EditorGui.Add("Edit", "x" editX " yp w" editW " h" rowH " -E0x200 Background" p["editBg"] " c" p["text"], vUnlockPath)
    
    ; VALIDATION: Lock all profile configurations except paths if editing a default profile
    if (Mode == "Edit" && IsDefaultProfile(SelectedCar)) {
        EditorGui.eAlt.Opt("+Disabled c" p["textDim"])
        EditorGui.eStats.Opt("+Disabled c" p["textDim"])
        EditorGui.eCost.Opt("+Disabled c" p["textDim"])
        EditorGui.eSWheel.Opt("+Disabled c" p["textDim"])
        EditorGui.eWheel.Opt("+Disabled c" p["textDim"])
        EditorGui.eCredit.Opt("+Disabled c" p["textDim"])
    }

    ; Form Action Buttons Layout
    SetFixedFont(EditorGui, 10, "bold", "Semibold")
    btnW := Round(135 * ScaleX)
    btnH := Round(30 * ScaleY)
    
    if (Mode == "New") {
        BtnClear := EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(18*ScaleY) " w" btnW " h" btnH " Center 0x200 Background" p["btnBg2"] " c" p["btnText2"], "❌  CLEAR")
        BtnClear.OnEvent("Click", ClearEditorFields)
        
        BtnSubmit := EditorGui.Add("Text", "x" Round(160*ScaleX) " yp w" btnW " h" btnH " Center 0x200 Background" p["btnMainBg"] " c" p["btnMainText"], "✔  SUBMIT")
        BtnSubmit.OnEvent("Click", CommitChanges)
    } else {
        BtnDelete := EditorGui.Add("Text", "x" Round(15*ScaleX) " y+" Round(18*ScaleY) " w" btnW " h" btnH " Center 0x200 Background" p["inactiveBg"] " c" p["cIdle"], "🗑  DELETE")
        BtnDelete.OnEvent("Click", DeleteProfile)
        
        if IsDefaultProfile(SelectedCar) {
            BtnDelete.Opt("+Disabled c" p["textDim"] " Background" p["editBg"])
        }
        
        BtnSubmit := EditorGui.Add("Text", "x" Round(160*ScaleX) " yp w" btnW " h" btnH " Center 0x200 Background" p["btnMainBg"] " c" p["btnMainText"], "💾  SAVE")
        BtnSubmit.OnEvent("Click", CommitChanges)
    }
    
    sW := Round(310 * ScaleX)
    ; FIX: Resized from 415 to 465 to allow breathing room for headers and dividers
    sH := Round(490 * ScaleY)
    
    if IsSet(MainGUI) && MainGUI && WinExist("ahk_id " MainGUI.Hwnd) {
        MainGUI.GetPos(&mX, &mY, &mW, &mH)
        sX := mX + (mW // 2) - (sW // 2)
        sY := mY + (mH // 2) - (sH // 2)
        EditorGui.Show("x" sX " y" sY " w" sW " h" sH)
    } else {
        EditorGui.Show("w" sW " h" sH)
    }
}

RegisterCar(Name, ConfigObj) {
    global CarData, CarList, DefaultProfiles, IsScriptStarting
    if !CarData.Has(Name)
        CarList.Push(Name)
    CarData[Name] := ConfigObj
    
    ; Automatically log this vehicle as a protected default if registered at startup
    if (IsScriptStarting)
        DefaultProfiles.Push(Name)
}

DeleteProfile(CtrlObj, *) {
    global SelectedCar, RepoName, CarData, CarList, MacroCarIni
    EditorGui := CtrlObj.Gui
    
    Name := SelectedCar
    
    ; VALIDATION: Hard intercept block if user tries to invoke deletion on a default profile
    if IsDefaultProfile(Name) {
        MsgBox("The profile '" Name "' is a core default profile and cannot be deleted from the database.", "Protected Profile", 48)
        return
    }
    
    if (MsgBox("Are you sure you want to permanently delete the profile for '" Name "'?", "Confirm Deletion", 52) == "No")
        return
        
    Base := EnvGet("USERPROFILE") "\Documents\"
    fullIniPath := Base RepoName "\" MacroCarIni
    
    try IniDelete(fullIniPath, Name)
    
    if CarData.Has(Name)
        CarData.Delete(Name)
        
    for i, cName in CarList {
        if (cName == Name) {
            CarList.RemoveAt(i)
            break
        }
    }
    
    fallbackName := CarList.Length > 0 ? CarList[1] : ""
    RefreshCarSelectorTree(fallbackName)
    ClosePopup()
}

; Localized dynamic clearing subroutine
ClearEditorFields(CtrlObj, *) {
    guiObj := CtrlObj.Gui
    guiObj.eName.Value      := ""
    guiObj.eAlt.Value       := ""
    guiObj.eStats.Value     := ""
    guiObj.eMfrPath.Value   := ""
    guiObj.eCarPath.Value   := ""
    guiObj.eUnlockPath.Value := ""
    guiObj.eCost.Value      := "0"
    guiObj.eSWheel.Value    := "0"
    guiObj.eWheel.Value     := "0"
    guiObj.eCredit.Value    := "0"
}

InitializeDatabase() {
    global CarData, CarList, RepoName, MacroCarIni
    
    if !IsSet(CarData) || !CarData
        CarData := Map()
    if !IsSet(CarList) || !CarList
        CarList := []
        
    Base := EnvGet("USERPROFILE") "\Documents\"
    fullIniPath := Base RepoName "\" MacroCarIni
    
    if FileExist(fullIniPath) {
        try {
            Sections := IniRead(fullIniPath)
            for CarName in StrSplit(Sections, "`n") {
                if (CarName == "")
                    continue
                
                RegisterCar(CarName, {
                    SkillPtsCost:    Number(IniRead(fullIniPath, CarName, "SkillPtsCost", "0") == "" ? "0" : IniRead(fullIniPath, CarName, "SkillPtsCost", "0")),
                    AltName:         IniRead(fullIniPath, CarName, "AltName", ""),
                    StatsNum:        Number(IniRead(fullIniPath, CarName, "StatsNum", "0") == "" ? "0" : IniRead(fullIniPath, CarName, "StatsNum", "0")),
                    BuyMfrPath:      ParsePathString(IniRead(fullIniPath, CarName, "BuyMfrPath", "")),
                    BuyCarPath:      ParsePathString(IniRead(fullIniPath, CarName, "BuyCarPath", "")),
                    UnlockPath:      ParsePathString(IniRead(fullIniPath, CarName, "UnlockPath", "")),
                    UnlockSWheel:    Number(IniRead(fullIniPath, CarName, "UnlockSWheel", "0") == "" ? "0" : IniRead(fullIniPath, CarName, "UnlockSWheel", "0")),
                    UnlockWheel:     Number(IniRead(fullIniPath, CarName, "UnlockWheel", "0") == "" ? "0" : IniRead(fullIniPath, CarName, "UnlockWheel", "0")),
                    UnlockCredit:    Number(IniRead(fullIniPath, CarName, "UnlockCredit", "0") == "" ? "0" : IniRead(fullIniPath, CarName, "UnlockCredit", "0"))
                })
            }
        }
    }
}

ParsePathString(PathStr) {
    ActionArray := []
    if (PathStr == "")
        return ActionArray
        
    for Command in StrSplit(PathStr, ",") {
        CleanCommand := Trim(Command)
        if (CleanCommand == "")
            continue
        Parts := StrSplit(CleanCommand, " ")
        if (Parts.Length == 2)
            ActionArray.Push([Parts[1], Number(Parts[2])])
    }
    return ActionArray
}

CommitChanges(CtrlObj, *) {
    global RepoName, MacroCarIni
    EditorGui := CtrlObj.Gui
    
    ; 1. VALIDATION: Check if any fields are empty
    if (Trim(EditorGui.eName.Value) == "" 
     || Trim(EditorGui.eAlt.Value) == "" 
     || Trim(EditorGui.eStats.Value) == "" 
     || Trim(EditorGui.eMfrPath.Value) == "" 
     || Trim(EditorGui.eCarPath.Value) == "" 
     || Trim(EditorGui.eUnlockPath.Value) == "" 
     || Trim(EditorGui.eCost.Value) == "" 
     || Trim(EditorGui.eSWheel.Value) == "" 
     || Trim(EditorGui.eWheel.Value) == "" 
     || Trim(EditorGui.eCredit.Value) == "") {
        MsgBox("All input fields are mandatory and cannot be left blank.", "Input Error", 48)
        return
    }
    
    Name := Trim(EditorGui.eName.Value)
    
    ; 2. VALIDATION: Stats Number must be exactly 12 digits long
    StatsValue := Trim(EditorGui.eStats.Value)
    if (StrLen(StatsValue) != 12) {
        MsgBox("The Stats Number field must be exactly 12 digits long.`n`nCurrent length: " StrLen(StatsValue) " digits.", "Input Error", 48)
        return
    }
    
    ; 3. VALIDATION: Points cost must be greater than 0
    CostValue := Number(EditorGui.eCost.Value)
    if (CostValue <= 0) {
        MsgBox("Points Cost must be greater than 0.", "Input Error", 48)
        return
    }
    
    ; 4. VALIDATION: Unified Path Matrix Verification (Mfr, Car, and Unlock Paths)
    MfrPathVal    := Trim(EditorGui.eMfrPath.Value)
    CarPathVal    := Trim(EditorGui.eCarPath.Value)
    UnlockPathVal := Trim(EditorGui.eUnlockPath.Value)
    
    pathsToValidate := [
        { value: MfrPathVal,    label: "Manufacturer Path" },
        { value: CarPathVal,    label: "Car Path" },
        { value: UnlockPathVal, label: "Unlock Path" }
    ]
    
    for pathData in pathsToValidate {
        for Command in StrSplit(pathData.value, ",") {
            CleanCommand := Trim(Command)
            ; Enforces Direction followed by a single space and a number (e.g., Up 1)
            if !RegExMatch(CleanCommand, "i)^(Up|Down|Left|Right) \d+$") {
                MsgBox(pathData.label " syntax is incorrect!`n`nIt must consist only of a valid direction (Up, Down, Left, Right) followed by a single space and a number. Separate multiple items with commas.`n`nExample: Up 1, Down 2`n`nInvalid entry discovered: '" CleanCommand "'", "Input Error", 48)
                return
            }
        }
    }
    
    ; 5. VALIDATION: At least one payout value (Super Spins, Regular Spins, or Credits) must be > 0
    SWheelValue  := Number(EditorGui.eSWheel.Value)
    WheelValue   := Number(EditorGui.eWheel.Value)
    CreditValue  := Number(EditorGui.eCredit.Value)
    if (SWheelValue <= 0 && WheelValue <= 0 && CreditValue <= 0) {
        MsgBox("Reward payload is empty!`n`nYou must provide a value greater than 0 for at least one of the following fields:`n- Super Spins`n- Regular Spins`n- Credits (CR)", "Input Error", 48)
        return
    }
    
    ; ── All validations cleared successfully, proceeding to write changes ──
    Base := EnvGet("USERPROFILE") "\Documents\"
    targetDir := Base RepoName
    if !DirExist(targetDir)
        DirCreate(targetDir)
    fullIniPath := targetDir "\" MacroCarIni
    
    IniWrite(EditorGui.eCost.Value,       fullIniPath, Name, "SkillPtsCost")
    IniWrite(EditorGui.eAlt.Value,        fullIniPath, Name, "AltName")
    IniWrite(EditorGui.eStats.Value,      fullIniPath, Name, "StatsNum")
    IniWrite(EditorGui.eMfrPath.Value,    fullIniPath, Name, "BuyMfrPath")
    IniWrite(EditorGui.eCarPath.Value,    fullIniPath, Name, "BuyCarPath")
    IniWrite(EditorGui.eUnlockPath.Value, fullIniPath, Name, "UnlockPath")
    IniWrite(EditorGui.eSWheel.Value,     fullIniPath, Name, "UnlockSWheel")
    IniWrite(EditorGui.eWheel.Value,      fullIniPath, Name, "UnlockWheel")
    IniWrite(EditorGui.eCredit.Value,     fullIniPath, Name, "UnlockCredit")
    
    RegisterCar(Name, {
        SkillPtsCost:    CostValue,
        AltName:         EditorGui.eAlt.Value,
        StatsNum:        Number(StatsValue),
        BuyMfrPath:      ParsePathString(MfrPathVal),
        BuyCarPath:      ParsePathString(CarPathVal),
        UnlockPath:      ParsePathString(UnlockPathVal),
        UnlockSWheel:    SWheelValue,
        UnlockWheel:     WheelValue,
        UnlockCredit:    CreditValue
    })
    
    RefreshCarSelectorTree(Name)
    ClosePopup()
}

RefreshCarSelectorTree(TargetName) {
    global CarList, CarSelect_UI
    
    newIndex := 1
    for index, name in CarList {
        if (name == TargetName) {
            newIndex := index
            break
        }
    }
    
    if IsSet(CarSelect_UI) && CarSelect_UI {
        CarSelect_UI.Value := newIndex
        try UpdateCar(CarSelect_UI, "")
    }
}

ClosePopup() {
    MainGUI.Opt("-Disabled") ; Re-enable the main GUI window
    EditorGui.Destroy()
}