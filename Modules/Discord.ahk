; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║       Discord Webhook Notifications     ║
; ╚═════════════════════════════════════════╝

; ══════════════════════════════════════════════
;  DISCORD WEBHOOK INTEGRATION
; ══════════════════════════════════════════════
; Mirrors every in-app ShowNotif() toast to a Discord channel via webhook.
; Hooked once inside ShowNotif() (see MiniGUI.ahk) — no changes needed
; anywhere else in the codebase to cover race/buy/unlock/spin/master-loop
; events, since every one of those already routes through ShowNotif().

DiscordNotify(type, title, message := "") {
    global DiscordEnabled, DiscordWebhookUrl

    if (DiscordEnabled != "1" || DiscordWebhookUrl = "")
        return

    switch StrLower(type) {
        case "success":
            emoji := "✅"
        case "error", "fail", "failure":
            emoji := "❌"
        default:
            emoji := "ℹ️"
    }

    ; Build the full human-readable content first, with real newlines —
    ; then escape the WHOLE thing once at the end. Escaping title/message
    ; individually and concatenating raw newlines afterward (the previous
    ; bug here) leaves literal, unescaped line breaks inside the JSON
    ; string value, which is invalid JSON and gets rejected with a 400.
    content := emoji " **" title "**"
    if (message != "")
        content .= "`n> " message
    content .= "`n-# " FormatTime(, "HH:mm:ss")

    payload := '{"content":"' _DiscordEscape(content) '"}'

    ; Synchronous request with short timeouts. This blocks the calling
    ; thread briefly (normally well under a second) but guarantees the
    ; request is actually sent before the COM object is released —
    ; an async "fire and forget" WinHttp call risks being cancelled
    ; when the object goes out of scope before the request completes.
    ; Timeouts are capped so a dead network delays the loop by at most
    ; ~3 seconds, never hangs it indefinitely.
    try {
        ; req.Send() with a plain string converts it to bytes using the
        ; system's default ANSI codepage, NOT UTF-8 — on any non-English
        ; Windows locale this silently corrupts the emoji/accented bytes
        ; and Discord rejects the resulting malformed JSON. Encoding to
        ; a raw UTF-8 buffer first guarantees valid bytes regardless of
        ; system codepage.
        utf8Body := _ToUtf8Bytes(payload)

        req := ComObject("WinHttp.WinHttpRequest.5.1")
        req.SetTimeouts(2000, 2000, 3000, 3000)     ; resolve, connect, send, receive (ms)
        req.Open("POST", DiscordWebhookUrl, false)  ; false = synchronous
        req.SetRequestHeader("Content-Type", "application/json; charset=utf-8")
        req.Send(utf8Body)

        if (req.Status < 200 || req.Status > 299)
            ShowNotif("error", "Discord Send Failed", "HTTP " req.Status " — " req.StatusText, false)
    } catch as err {
        ; Reported via a local-only toast (mirrorToDiscord=false) so a
        ; broken webhook can't recursively try to notify itself about
        ; being broken.
        ShowNotif("error", "Discord Error", err.Message, false)
    }
}

; Encodes a string to a UTF-8 byte SAFEARRAY that WinHttpRequest.Send()
; can actually marshal. A plain Buffer object does NOT automatically
; convert to the VT_ARRAY|VT_UI1 VARIANT the COM method expects — passing
; one directly throws E_NOINTERFACE ("interface not supported"). ComObjArray
; is AHK v2's documented way to build a COM-compatible byte array.
_ToUtf8Bytes(str) {
    size := StrPut(str, "UTF-8") - 1   ; byte length, excluding null terminator

    ; Encode into a plain buffer first (StrPut needs a Buffer target)
    tempBuf := Buffer(size)
    StrPut(str, tempBuf, "UTF-8")

    ; Copy into a real COM SAFEARRAY of bytes (VT_UI1 = 0x11)
    arr := ComObjArray(0x11, size)
    Loop size
        arr[A_Index - 1] := NumGet(tempBuf, A_Index - 1, "UChar")

    return arr
}

; Escapes characters that would break the JSON payload or Discord markdown
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

; Mirrors SpecialKToggle's style/behavior in SpecialK.ahk
DiscordToggle(ctrl, *) {
    global DiscordEnabled, DiscordWebhookUrl, p

    if (!ctrl.State && DiscordWebhookUrl = "") {
        ShowNotif("error", "Discord Webhook Missing", "Paste a webhook URL into the field above before enabling.")
        return
    }

    ctrl.State := !ctrl.State
    DiscordEnabled := ctrl.State ? "1" : "0"
    WriteMacroIni("Settings", "DiscordEnabled", DiscordEnabled)

    if (ctrl.State) {
        ctrl.Opt("c" p["text"])
        ctrl.Text := "▰  DISCORD: ACTIVE"
        ctrl.Redraw()
        DiscordNotify("success", "Discord Connected", "ForzaMasterFarm notifications are now live.")
    } else {
        ctrl.Opt("c" p["textDim"])
        ctrl.Text := "▱  DISCORD: INACTIVE"
        ctrl.Redraw()
    }
}

; Saves the webhook URL as the user edits the input field
DiscordUrlChanged(ctrl, *) {
    global DiscordWebhookUrl
    DiscordWebhookUrl := Trim(ctrl.Text)
    WriteMacroIni("Settings", "DiscordWebhookUrl", DiscordWebhookUrl)
}
