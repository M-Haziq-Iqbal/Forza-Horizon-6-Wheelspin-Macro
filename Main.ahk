; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

#Requires AutoHotkey v2.0

; AUTOMATIC ADMIN ENFORCER
; If the script isn't Admin, it restarts itself as Admin so it can control the game window.
; if !A_IsAdmin {
;     Run('*RunAs "' A_ScriptFullPath '"')
;     ExitApp()
; }

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
#Include modules\SpecialK.ahk

;@Ahk2Exe-SetVersion 1.9.0
;@Ahk2Exe-SetDescription MHI - FH6 Wheelspin Macro
;@Ahk2Exe-SetMainIcon assets\icon.ico
; Setup tray icon dynamically
TraySetIcon(A_IsCompiled ? A_ScriptFullPath : A_ScriptDir "\assets\icon.ico")

UpdateMonitorMetrics()

BuildMainGui()
BuildMiniGui()
UpdateMiniWidgetMode("")

; Tell AHK to keep running in the background to listen for hotkeys
Persistent(true)

#HotIf WinActive(GameTitle)
\::StartRace()
[::StartBuy()
]::StartUnlock()
/::ToggleAll()
`::TogglePause()
F12::Reload()
^+c::GetCoordsColor()
!LButton::MoveWindow()
#HotIf

#HotIf IsSpinGuiOpen()
=::StartSpin() 
#HotIf