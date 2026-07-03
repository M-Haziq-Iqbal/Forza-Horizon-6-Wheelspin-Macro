; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

; ══════════════════════════════════════════════
;  SPECIAL K SIDE-LOAD CONFIGURATION CONTROLLER
; ══════════════════════════════════════════════

SpecialKCheck() {
    global GameDir, GameExe, TargetDLL, MacroIni

    isKEnabled := 0
    
    ; 1. Recover the game directory by scanning Special K's profile directory paths
    GameDir := FindGameDirFromProfiles()
    
    if (GameDir != "") {
        GameDir := RTrim(GameDir, "\")
        TargetDLL := GameDir "\dxgi.dll" 
        
        ; 2. Verify the game executable still exists at that path
        try {
            if !FileExist(GameDir "\" GameExe) {
                GameDir := ""
                TargetDLL := ""
                return 0
            }
        } catch {
            GameDir := ""
            TargetDLL := ""
            return 0
        }

        ; 3. Check if Special K is currently active (wrapper dll is deployed)
        try {
            isKEnabled := FileExist(TargetDLL) ? 1 : 0
        } catch {
            isKEnabled := 0
        }

        ; 4. Sync the active states across all Central Profile folder variations
        WriteMacroIni("Settings", "GameDir", GameDir)
        WriteMacroIni("Settings", "SpecialKEnabled", isKEnabled ? "1" : "0")
    }
    
    return isKEnabled
}

SpecialKToggle(ctrl, *) {
    global GameDir, GameExe, p

    ; ── 1. LIVE GAME-RUNNING GUARD GATE ──
    if ProcessExist(GameExe) {
        ctrl.Opt("c" p["textDim"])
        ctrl.Text := "🔒 SPECIAL K (GAME RUNNING)"
        ctrl.Redraw()
        ShowNotif("warning", "System Locked", "Please close Forza Horizon 6 entirely before editing side-load options.")
        return 
    }

    ; ── 2. FLIP INTERNAL TOGGLE STATE ──
    ctrl.State := !ctrl.State

    ; ── 3. EXECUTE RE-STYLING AND FILE DEPLOYMENT MATRIX ──
    if (ctrl.State == 0) {
        ctrl.Opt("c" p["textDim"])
        ctrl.Text := "▱  SPECIAL K: INACTIVE"
        ctrl.Redraw()
        SpecialKDisable(ctrl)
    } else {
        ctrl.Opt("c" p["text"])
        ctrl.Text := "▰  SPECIAL K: ACTIVE"
        ctrl.Redraw()
        
        if (GameDir == "" || !DirExist(GameDir)) {
            if (!LocateGameDir(false)) {
                ctrl.State := 0
                ctrl.Opt("c" p["textDim"])
                ctrl.Text := "▱  SPECIAL K: INACTIVE"
                ctrl.Redraw()
                return
            }
        }
        SpecialKEnable(ctrl)
    }
}

SpecialKEnable(ctrl) {
    global GameDir, TargetDLL, MacroIni, SK_ConfigMap, SK_GlobalOSDMap, GameExe, p
    operationSuccess := false
    
    GameDir := RTrim(GameDir, "\")
    TargetDLL := GameDir "\dxgi.dll"
    
    ; Clear old files from game directory to block local fallback mode
    try {
        if FileExist(GameDir "\dxgi.ini")
            FileDelete(GameDir "\dxgi.ini")
        if FileExist(GameDir "\SpecialK.ini")
            FileDelete(GameDir "\SpecialK.ini")
        if FileExist(GameDir "\SpecialK.central")
            FileDelete(GameDir "\SpecialK.central")
    }

    if FileExist(TargetDLL) {
        operationSuccess := true
    } else {
        SourceDLL := FindExistingSpecialK()
        
        if (SourceDLL == "") {
            ctrl.Text := "⚡ CONNECTING TO ASSETS..."
            ctrl.Redraw()
            
            userChoice := MsgBox("Special K was not detected.`n`nDownload core components directly to your game folder?", "MHI Asset Manager", 4)
            if (userChoice == "No") {
                ctrl.State := 0
                ctrl.Opt("c" p["textDim"])
                ctrl.Text := "▱  SPECIAL K: INACTIVE"
                ctrl.Redraw()
                return
            }
            
            ctrl.Text := "📥 DOWNLOADING..."
            ctrl.Redraw()
            
            if (!DownloadAndExtractSpecialK(GameDir)) {
                ShowNotif("danger", "Network Error", "Failed to retrieve or unpack official repository files.")
                ctrl.State := 0
                ctrl.Opt("c" p["textDim"])
                ctrl.Text := "▱  SPECIAL K: INACTIVE"
                ctrl.Redraw()
                return
            }
            SourceDLL := GameDir "\SpecialK64.dll"
        }
        
        ctrl.Text := "⚡ DEPLOYING MOD WRAPPER..."
        ctrl.Redraw()

        try {
            if (SourceDLL == GameDir "\SpecialK64.dll")
                FileMove(SourceDLL, TargetDLL, 1)
            else
                FileCopy(SourceDLL, TargetDLL, 1)
            
            Loop 10 {
                if FileExist(TargetDLL) {
                    operationSuccess := true
                    break
                }
                Sleep(50)
            }
        } catch {
            operationSuccess := false
        }
    }
    
    if (operationSuccess) {
        ctrl.State := 1
        ctrl.Opt("c" p["text"])
        ctrl.Text := "▰  SPECIAL K: ACTIVE"
        ctrl.Redraw()
        
        WriteMacroIni("Settings", "SpecialKEnabled", "1")
        ApplySKSettingsToProfiles(SK_ConfigMap)
        ApplySKGlobalOSDSettings(SK_GlobalOSDMap)
    } else {
        ctrl.State := 0 
        ctrl.Opt("c" p["textDim"])
        ctrl.Text := "▱  SPECIAL K: INACTIVE"
        ctrl.Redraw()
        WriteMacroIni("Settings", "SpecialKEnabled", "0")
        MsgBox("Verification Failure: 'dxgi.dll' could not be confirmed on disk.", "MHI Verification Error", 16)
    }
}

SpecialKDisable(ctrl) {
    global TargetDLL, GameDir, MacroIni, p

    GameDir := RTrim(GameDir, "\")
    TargetDLL := GameDir "\dxgi.dll"
    operationSuccess := false

    if FileExist(TargetDLL) {
        try {
            FileMove(TargetDLL, GameDir "\SpecialK64.dll", 1)
            
            Loop 10 {
                if (!FileExist(TargetDLL) && FileExist(GameDir "\SpecialK64.dll")) {
                    operationSuccess := true
                    break
                }
                Sleep(50)
            }
        } catch Error as err {
            MsgBox("Failed to disable Special K. The file may be locked by a running game process.`n`nDetails: " err.Message, "MHI File Lock Error", 16)
        }
    } else {
        operationSuccess := true
    }

    if (operationSuccess) {
        ctrl.State := 0 
        ctrl.Opt("c" p["textDim"])
        ctrl.Text := "▱  SPECIAL K: INACTIVE"
        ctrl.Redraw()
        ; FIXED: Swapped local path IniWrite for zero-footprint Profile router
        WriteMacroIni("Settings", "SpecialKEnabled", "0")
    } else {
        ctrl.State := 1
        ctrl.Opt("c" p["text"])
        ctrl.Text := "▰  SPECIAL K: ACTIVE"
        ctrl.Redraw()
        WriteMacroIni("Settings", "SpecialKEnabled", "1")
    }
}

; ════════════════════════════════
;   CENTRAL DATA ROUTING UTILITIES
; ════════════════════════════════

; Helper: Generates a clean array of existing Special K profile folder destinations
GetSKProfilePaths() {
    global GameExe
    localAppData := EnvGet("LOCALAPPDATA")
    userProfile  := EnvGet("USERPROFILE")
    
    bases := []
    if localAppData
        bases.Push(localAppData "\Programs\Special K\Profiles")
    if userProfile
        bases.Push(userProfile "\Documents\My Mods\SpecialK\Profiles")
        
    ExeNameNoExt := SubStr(GameExe, 1, InStr(GameExe, ".", , -1) - 1)
    variants     := [GameExe, ExeNameNoExt]
    
    paths := []
    for baseDir in bases {
        if !DirExist(baseDir)
            continue
        for folderName in variants {
            if (folderName != "")
                paths.Push(baseDir "\" folderName)
        }
    }
    return paths
}

FindGameDirFromProfiles() {
    global MacroIni, GameExe, SpecialKEnabled
    
    for targetDir in GetSKProfilePaths() {
        testIni := targetDir "\" MacroIni
        if FileExist(testIni) {
            try {
                chkDir := IniRead(testIni, "Settings", "GameDir", "")
                if (chkDir != "" && DirExist(chkDir) && FileExist(chkDir "\" GameExe)) {
                    SpecialKEnabled := IniRead(testIni, "Settings", "SpecialKEnabled", "0")
                    return chkDir
                }
            }
        }
    }
    
    SpecialKEnabled := "0"
    return ""
}

ApplySKSettingsToProfiles(ConfigMap) {
    for targetDir in GetSKProfilePaths() {
        try {
            if (!DirExist(targetDir))
                DirCreate(targetDir)
            
            for iniName in ["SpecialK.ini", "dxgi.ini"] {
                targetIni := targetDir "\" iniName
                for section, keys in ConfigMap {
                    for key, value in keys {
                        IniWrite(value, targetIni, section, key)
                    }
                }
            }
        }
    }
}

ApplySKGlobalOSDSettings(OSDConfigMap) {
    localAppData    := EnvGet("LOCALAPPDATA")
    userProfile     := EnvGet("USERPROFILE")
    modernGlobalIni := localAppData ? localAppData "\Programs\Special K\Global\osd.ini" : ""
    legacyGlobalIni := userProfile ? userProfile "\Documents\My Mods\SpecialK\Global\osd.ini" : ""
    
    for targetIni in [modernGlobalIni, legacyGlobalIni] {
        if (targetIni == "")
            continue
            
        splitPos  := InStr(targetIni, "\", , -1)
        parentDir := SubStr(targetIni, 1, splitPos - 1)
        
        try {
            if (!DirExist(parentDir))
                DirCreate(parentDir)
                
            for section, keys in OSDConfigMap {
                for key, value in keys {
                    IniWrite(value, targetIni, section, key)
                }
            }
        }
    }
}

; ══════════════════════════════════════════════
;  ASSET MANAGEMENT & ARTIFACT EXTRACTION
; ══════════════════════════════════════════════

FindExistingSpecialK() {
    global GameDir

    if (GameDir != "" && DirExist(GameDir) && FileExist(GameDir "\SpecialK64.dll")) {
        return GameDir "\SpecialK64.dll"
    }

    try {
        skRegistryPath := RegRead("HKEY_CURRENT_USER\Software\Kaldaien\Special K", "Path")
        if (skRegistryPath && FileExist(skRegistryPath "\SpecialK64.dll")) {
            return skRegistryPath "\SpecialK64.dll"
        }
    }

    localAppData := EnvGet("LOCALAPPDATA")
    if (localAppData && FileExist(localAppData "\Programs\Special K\SpecialK64.dll")) {
        return localAppData "\Programs\Special K\SpecialK64.dll"
    }

    userProfile := EnvGet("USERPROFILE")
    if (userProfile && FileExist(userProfile "\Documents\My Mods\SpecialK\SpecialK64.dll")) {
        return userProfile "\Documents\My Mods\SpecialK\SpecialK64.dll"
    }

    return "" 
}

DownloadAndExtractSpecialK(TargetDir) {
    DownloadUrl := "https://github.com/SpecialKO/SpecialK/releases/latest/download/SpecialK.7z"
    TempArchive := A_Temp "\SpecialK.7z"
    ExtractedDir := A_Temp "\SK_TempExtract"
    Success := false
    
    if (TargetDir == "" || !DirExist(TargetDir))
        return false
        
    if !DirExist(ExtractedDir)
        DirCreate(ExtractedDir)
        
    try {
        Download(DownloadUrl, TempArchive)
        RunWait('tar -xf "' TempArchive '" -C "' ExtractedDir '"', , "Hide")
        
        if FileExist(ExtractedDir "\SpecialK64.dll") {
            FileCopy(ExtractedDir "\SpecialK64.dll", TargetDir "\SpecialK64.dll", 1)
            ShowNotif("info", "Special K", "Special K downloaded successfully...")
            Success := true
        } else
            ShowNotif("error", "Special K", "Extraction failed: SpecialK64.dll not found in archive.")
    } catch {
        ShowNotif("error", "Special K", "Special K download failed...")
        Success := false
    }
    
    try {
        if FileExist(TempArchive)
            FileDelete(TempArchive)
        if DirExist(ExtractedDir)
            DirDelete(ExtractedDir, 1)
    }
    
    return Success
}

ApplySKSettings(IniPath, ConfigMap) {
    for section, keys in ConfigMap {
        for key, value in keys {
            IniWrite(value, IniPath, section, key)
        }
    }
}