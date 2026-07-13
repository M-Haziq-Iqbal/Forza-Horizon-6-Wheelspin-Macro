; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║       Discord Webhook Notifications     ║
; ╚═════════════════════════════════════════╝

; Global queues tracking non-blocking background network threads
global PendingWebhooks := []
global ActiveDashboardRequests := 0 

; 🟢 FIX 1: Use a centralized state tracker with a generation counter to isolate distinct loops
global DashboardState := { msgId: "", generation: 0 }

; ══════════════════════════════════════════════
;  GLOBAL LIVE DASHBOARD ENGINE (All Stats, One Card)
; ══════════════════════════════════════════════
DiscordStatusUpdate(type := "", title := "", message := "") {
    global DiscordEnabled, DiscordWebhookUrl, ActiveDashboardRequests, DashboardState
    
    ; Import the GUI variable objects defined in BuildMiniGui
    global MiniRaceRunTime_UI, MiniPointsCount_UI, MiniSectorCount_UI
    global MiniBuyRunTime_UI, MiniCarCount_UI
    global MiniUnlockRunTime_UI, MiniSWheelCount_UI, MiniWheelCount_UI, MiniCreditCount_UI
    global MiniSpinRunTime_UI, MiniSpinOpenCount_UI, MiniSpinLeftCount_UI

    static lastType := "info"     
    static lastTitle := "Running"
    static lastMessage := ""

    if (DiscordEnabled != "1" || DiscordWebhookUrl = "")
        return

    isNewLoop     := InStr(title, "Full Loop Started")
    isFinalUpdate := (InStr(title, "Full Loop") && InStr(message, "Finalized"))

    if (isNewLoop) {
        DashboardState.msgId := ""
        DashboardState.generation++
    }

    if (ActiveDashboardRequests > 0 && !isNewLoop && !isFinalUpdate)
        return

    if (type != "")    lastType := type
    if (title != "")   lastTitle := title
    if (message != "") lastMessage := message

    emoji := "ℹ️", color := 6583496
    switch StrLower(lastType) {
        case "success":                  emoji := "✅", color := 53910  
        case "error", "fail", "failure": emoji := "❌", color := 16734810 
        case "warning", "warn":          emoji := "⚠️", color := 16765286 
        default:                         emoji := "ℹ️", color := 6583496  
    }

    ; Accessing values from GUI controls
    raceTimeStr   := MiniRaceRunTime_UI.Value
    buyTimeStr    := MiniBuyRunTime_UI.Value
    unlockTimeStr := MiniUnlockRunTime_UI.Value
    spinTimeStr   := MiniSpinRunTime_UI.Value

    payload := '{"username":"FH6 Global Monitor Bot","embeds":[{'
    payload .= '"title":"'       _DiscordEscape(emoji " Live Run Dashboard • " lastTitle) '",'
    payload .= '"color":'        color ','
    payload .= '"description":"' _DiscordEscape((lastMessage != "") ? "> " lastMessage : "") '",'
    payload .= '"fields":['

    payload .= '{"name":"🏎️  RACE","value":"'
    payload .= '• **Runtime:** ' _DiscordEscape(raceTimeStr) '\n'
    payload .= '• **Points Gained:** ' _DiscordEscape(MiniPointsCount_UI.Value) '\n'
    payload .= '• **Sectors Cleared:** ' _DiscordEscape(MiniSectorCount_UI.Value)
    payload .= '","inline":false},'

    payload .= '{"name":"📦  PURCHASE","value":"'
    payload .= '• **Runtime:** ' _DiscordEscape(buyTimeStr) '\n'
    payload .= '• **Purchased:** ' _DiscordEscape(MiniCarCount_UI.Value)
    payload .= '","inline":false},'

    payload .= '{"name":"🔓  UNLOCK","value":"'
    payload .= '• **Runtime:** ' _DiscordEscape(unlockTimeStr) '\n'
    payload .= '• **Super Spins:** ' _DiscordEscape(MiniSWheelCount_UI.Value) '\n'
    payload .= '• **Reg. Spins:** ' _DiscordEscape(MiniWheelCount_UI.Value) '\n'
    payload .= '• **Credits:** ' _DiscordEscape(MiniCreditCount_UI.Value)
    payload .= '","inline":false},'

    payload .= '{"name":"🛞  WHEELSPINS","value":"'
    payload .= '• **Runtime:** ' _DiscordEscape(spinTimeStr) '\n'
    payload .= '• **Spins Opened:** ' _DiscordEscape(MiniSpinOpenCount_UI.Value) '\n'
    payload .= '• **Remaining:** ' _DiscordEscape(MiniSpinLeftCount_UI.Value)
    payload .= '","inline":false}'

    payload .= '],'
    payload .= '"footer":{"text":"' _DiscordEscape("Global Metric Telemetry Sync • Updated: " . FormatTime(, "HH:mm:ss")) '"}'
    payload .= '}]}'

    _ExecuteWebhookRequest(payload, DashboardState.msgId, DashboardState.generation, true, isFinalUpdate)
}

; ══════════════════════════════════════════════
;  CORE ASYNCHRONOUS ENGINE (Non-Blocking Poller)
; ══════════════════════════════════════════════
_ExecuteWebhookRequest(payload, currentMsgId, generation, allowPatch := true, forceSync := false) {
    global ActiveDashboardRequests
    
    ; 🟢 FIX 3: Route final milestone updates to a dedicated synchronous blocking pipeline
    if (forceSync) {
        _SendWebhookSync(payload, currentMsgId, generation, allowPatch)
        return
    }
    
    if (allowPatch)
        ActiveDashboardRequests++
        
    SetTimer(() => _SendWebhookAsync(payload, currentMsgId, generation, allowPatch), -1)
}

_SendWebhookAsync(payload, currentMsgId, generation, allowPatch) {
    global DiscordWebhookUrl, PendingWebhooks, ActiveDashboardRequests
    try {
        utf8Body := _ToUtf8Bytes(payload)
        req := ComObject("WinHttp.WinHttpRequest.5.1")
        req.SetTimeouts(1000, 1000, 1000, 2000)

        method := "POST"
        url := DiscordWebhookUrl "?wait=true"

        if (currentMsgId != "" && allowPatch) {
            method := "PATCH"
            url := DiscordWebhookUrl "/messages/" currentMsgId
        }

        req.Open(method, url, true) 
        req.SetRequestHeader("Content-Type", "application/json; charset=utf-8")
        req.Send(utf8Body)

        PendingWebhooks.Push({
            req: req,
            generation: generation,
            allowPatch: allowPatch
        })

        SetTimer(PollPendingWebhooks, 100)
    } catch Error as err {
        if (allowPatch)
            ActiveDashboardRequests--
    }
}

; 🟢 FIX 4: Dedicated synchronous handler to guarantee loop closure
_SendWebhookSync(payload, currentMsgId, generation, allowPatch) {
    global DiscordWebhookUrl, DashboardState
    try {
        utf8Body := _ToUtf8Bytes(payload)
        req := ComObject("WinHttp.WinHttpRequest.5.1")
        req.SetTimeouts(1000, 1000, 1000, 4000) ; Generous timeout ceiling for tracking milestones

        method := "POST"
        url := DiscordWebhookUrl "?wait=true"

        if (currentMsgId != "" && allowPatch) {
            method := "PATCH"
            url := DiscordWebhookUrl "/messages/" currentMsgId
        }

        req.Open(method, url, false) ; <-- False makes this run synchronously
        req.SetRequestHeader("Content-Type", "application/json; charset=utf-8")
        req.Send(utf8Body) ; Blocks execution context for ~200ms until complete

        status := req.Status
        if (status >= 200 && status <= 299) {
            if (allowPatch && generation == DashboardState.generation) {
                if RegExMatch(req.ResponseText, '"id":\s*"(?P<id>\d+)"', &match) {
                    DashboardState.msgId := match.id
                }
            }
        }
    } catch Error as err {
        ; Fail silently and keep macro alive if internet drops mid-save
    }
}

PollPendingWebhooks() {
    global PendingWebhooks, ActiveDashboardRequests, DashboardState
    
    if (PendingWebhooks.Length == 0) {
        SetTimer(PollPendingWebhooks, 0) 
        return
    }

    count := PendingWebhooks.Length
    
    Loop count {
        idx := count - A_Index + 1
        item := PendingWebhooks[idx]

        try {
            if item.req.WaitForResponse(0) {
                status := item.req.Status
                if (status >= 200 && status <= 299) {
                    if (item.allowPatch) {
                        if RegExMatch(item.req.ResponseText, '"id":\s*"(?P<id>\d+)"', &match) {
                            ; 🟢 FIX 5: Discard the response if it belongs to an older macro generation loop
                            if (item.generation == DashboardState.generation) {
                                DashboardState.msgId := match.id
                            }
                        }
                    }
                } else if (status == 404) {
                    if (item.generation == DashboardState.generation) {
                        DashboardState.msgId := ""
                    }
                }
                
                if (item.allowPatch)
                    ActiveDashboardRequests--

                PendingWebhooks.RemoveAt(idx)
            }
        } catch Error as err {
            if (item.allowPatch)
                ActiveDashboardRequests--
            PendingWebhooks.RemoveAt(idx)
        }
    }
    
    if (ActiveDashboardRequests < 0)
        ActiveDashboardRequests := 0
}

; ══════════════════════════════════════════════
;  HISTORICAL LOG ENGINE (Always Posts New Messages)
; ══════════════════════════════════════════════
DiscordNotify(type, title, message := "") {
    global DiscordEnabled, DiscordWebhookUrl

    if (DiscordEnabled != "1" || DiscordWebhookUrl = "")
        return

    if InStr(title, "Car Stats detected")
        return

    switch StrLower(type) {
        case "success":                  emoji := "✅", color := 3066993   
        case "error", "fail", "failure": emoji := "❌", color := 15158332  
        case "warning", "warn":          emoji := "⚠️", color := 16755200  
        default:                         emoji := "ℹ️", color := 3447003   
    }

    mentionPrefix := ""
    if (StrLower(type) == "critical" || StrLower(type) == "fatal" || StrLower(type) == "panic") {
        mentionPrefix := "@here 🚨 **CRITICAL MACRO HALT!**"
        color := 12058624
    }

    payload := '{"username":"FH6 Automation Bot",'
    if (mentionPrefix != "") {
        payload .= '"content":"' _DiscordEscape(mentionPrefix) '",'
    }
    payload .= '"embeds":[{'
    payload .= '"title":"'       _DiscordEscape(emoji " " title) '",'
    payload .= '"color":'        color ','
    payload .= '"description":"' _DiscordEscape((message != "") ? "> " message : "") '",'
    payload .= '"footer":{"text":"' _DiscordEscape("Event Time: " . FormatTime(, "HH:mm:ss")) '"}'
    payload .= '}]}'

    ; Pass explicitly as standard new message values
    _ExecuteWebhookRequest(payload, "", 0, false) 
}

_ToUtf8Bytes(str) {
    size := StrPut(str, "UTF-8") - 1   
    tempBuf := Buffer(size)
    StrPut(str, tempBuf, "UTF-8")
    arr := ComObjArray(0x11, size)
    Loop size
        arr[A_Index - 1] := NumGet(tempBuf, A_Index - 1, "UChar")
    return arr
}

_DiscordEscape(str) {
    str := StrReplace(str, "\", "\\")
    str := StrReplace(str, '"', '\"')
    str := StrReplace(str, "`r", "")
    str := StrReplace(str, "`n", "\n")
    return str
}

; ══════════════════════════════════════════════
;  SETTINGS UI HANDLERS (called from MainGUI.ahk)
; ══════════════════════════════════════════════
DiscordToggle(ctrl, *) {
    global DiscordEnabled, DiscordWebhookUrl, p

    if GetKeyState("Ctrl", "P") {
        PromptWebhookUrl(ctrl)
        return
    }

    if (!ctrl.State && DiscordWebhookUrl = "") {
        ShowNotif("error", "Discord Webhook Missing", "Paste a webhook URL into the field above before enabling.")
        return
    }

    ctrl.State := !ctrl.State
    DiscordEnabled := ctrl.State
    WriteMacroIni("Settings", "DiscordEnabled", DiscordEnabled)

    if (ctrl.State) {
        ctrl.Opt("c" p["accent"]) 
        ctrl.Text := "▰  DISCORD"
        ctrl.Redraw()
        DiscordNotify("success", "Discord Connected", "ForzaMasterFarm notifications are now live.")
    } else {
        ctrl.Opt("c" p["textDim"]) 
        ctrl.Text := "▱  DISCORD"
        ctrl.Redraw()
    }
}

PromptWebhookUrl(ctrl, *) {
    global DiscordWebhookUrl, MainGUI, p
    global ScaleX, ScaleY
    
    sW := Round(250 * ScaleX)
    sH := Round(230 * ScaleY) 
    
    MainGUI.GetPos(&mX, &mY, &mW, &mH)
    sX := mX + (mW // 2) - (sW // 2)
    sY := mY + (mH // 2) - (sH // 2)

    MainGUI.Opt("+Disabled")
    popup := Gui("+AlwaysOnTop -MaximizeBox -DPIScale -Caption +Border +Owner" MainGUI.Hwnd, "MHI | WEBHOOK MODULE")
    popup.BackColor := p["bg"]

    PopX := popup.Add("Text", "x" Round(225*ScaleX) " y" Round(12*ScaleY) " w" Round(16*ScaleX) " h" Round(16*ScaleY) " Center BackgroundTrans c" p["textDim"], "✕")
    PopX.OnEvent("Click", (*) => ClosePopup())

    SetFixedFont(popup, 12, "bold", "Light")
    popup.Add("Text", "x0 y" Round(30*ScaleY) " w" Round(250*ScaleX) " Center c" p["accent"], "WEBHOOK CONFIG")

    SetFixedFont(popup, 9, "norm", "Light")
    popup.Add("Text", "x" Round(20*ScaleX) " y+" Round(15*ScaleY) " w" Round(210*ScaleX) " BackgroundTrans c" p["text"], "⟡   Discord Webhook URL")
    
    urlEdit := popup.Add("Edit", "x" Round(20*ScaleX) " y+6 w" Round(210*ScaleX) " h" Round(65*ScaleY) " -E0x200 WantReturn Background" p["editBg"] " c" p["text"], DiscordWebhookUrl)

    popup.Add("Text", "x" Round(5*ScaleX) " y+10 w" Round(240*ScaleX) " Center BackgroundTrans c" p["divider"], "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

    SetFixedFont(popup, 9, "bold", "Semibold")
    btnSave   := popup.Add("Text", "x" Round(15*ScaleX) " y+10 w" Round(105*ScaleX) " h" Round(26*ScaleY) " Center 0x200 Background" p["activeBg"] " c" p["text"], "💾  SAVE")
    btnCancel := popup.Add("Text", "x" Round(130*ScaleX) " yp w" Round(105*ScaleX) " h" Round(26*ScaleY) " Center 0x200 Background" p["inactiveBg"] " c" p["text"], "✕  CANCEL")

    btnSave.OnEvent("Click", (*) => SaveAndClose())
    btnCancel.OnEvent("Click", (*) => ClosePopup())

    popup.OnEvent("Close", (*) => ClosePopup())
    popup.OnEvent("Escape", (*) => ClosePopup())

    SaveAndClose() {
        global DiscordWebhookUrl
        DiscordWebhookUrl := Trim(urlEdit.Value, " `t`r`n")
        WriteMacroIni("Settings", "DiscordWebhookUrl", DiscordWebhookUrl)
        try ShowNotif("success", "Webhook Updated", "New URL saved successfully.")
        ClosePopup()
    }

    ClosePopup() {
        MainGUI.Opt("-Disabled") 
        popup.Destroy()
    }

    popup.Show("x" sX " y" sY " w" sW " h" sH)
}