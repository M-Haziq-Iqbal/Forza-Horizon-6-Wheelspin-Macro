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

#Include lib\OCR.ahk
#Include modules\Config.ahk
#Include modules\GUI_Main.ahk
#Include modules\GUI_Mini.ahk
#Include modules\GUI_Editor.ahk
#Include modules\Engine.ahk
#Include modules\Mode_FullLoop.ahk
#Include modules\Mode_Buy.ahk
#Include modules\Mode_Race.ahk
#Include modules\Mode_Spin.ahk
#Include modules\Mode_Unlock.ahk
#Include modules\SpecialK.ahk
#Include modules\Discord.ahk

; Setup tray icon dynamically
TraySetIcon(A_IsCompiled ? A_ScriptFullPath : A_ScriptDir "\assets\icon.ico")

UpdateMonitorMetrics()
InitializeDatabase()
BuildMainGui()
BuildMiniGui()
UpdateMiniWidgetMode("")

; Tell AHK to keep running in the background to listen for hotkeys
Persistent(true)

F12::Reload()
^+c::GetCoordsColor()

#HotIf WinActive(GameTitle)
\::StartRace()
[::StartBuy()
]::StartUnlock()
/::StartFullLoop()
`::TogglePause()
#HotIf

#HotIf WinActive(GameTitle) && IsSpinGuiOpen()
=::StartSpin() 
#HotIf

#HotIf WinActive(GameTitle) && CheckWindowed()
!LButton::MoveWindow()
#HotIf