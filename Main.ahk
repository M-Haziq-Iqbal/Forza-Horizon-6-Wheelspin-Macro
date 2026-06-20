; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║        Cyber Noir Edition v1.7.0        ║
; ╚═════════════════════════════════════════╝

#Requires AutoHotkey v2.0

#MaxThreadsPerHotkey 2
#SingleInstance Force

#Include Lib\OCR.ahk

#Include modules\Config.ahk
#Include modules\MainGUI.ahk
#Include modules\MiniGUI.ahk
#Include modules\Engine.ahk
#Include modules\Task_Race.ahk
#Include modules\Task_Buy.ahk
#Include modules\Task_Unlock.ahk
#Include modules\Task_Spin.ahk

;@Ahk2Exe-SetMainIcon assets\icon.ico

; Setup tray icon dynamically
if A_IsCompiled {
    TraySetIcon(A_ScriptFullPath)  ; Pulls the embedded icon directly from the EXE
} else {
    TraySetIcon(A_ScriptDir "\assets\icon.ico") ; Standard path used while testing uncompiled
}

; ══════════════════════════════════════════════
;  GAME-FOCUS BOUNDED HOTKEYS
; ══════════════════════════════════════════════
#HotIf WinActive(GameTitle)

\::StartRace()
[::StartBuy()
]::StartUnlock()
/::ToggleAll()
=::StartSpin()
F12::Reload()
`::TogglePause()
^+c::GetCoordsColor()

#HotIf