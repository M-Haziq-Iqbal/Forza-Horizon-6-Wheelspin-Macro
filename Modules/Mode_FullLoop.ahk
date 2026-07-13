; ╔═════════════════════════════════════════╗
; ║        MHI - FH6 Wheelspin Macro        ║
; ║            Cyber Noir Edition           ║
; ╚═════════════════════════════════════════╝

StartFullLoop() {
    global ActiveMode, MasterMode, StartLoopMode
    global LoopCount_In, SkillPtsScanSuccess
    global RadioRace, RadioBuy, RadioUnlock
    global DiscordWebhookRunning

    if FindGame() = false
        return

    ; Initialize state variables
    StartLoop := StartLoopMode
    FirstLoopMode := StartLoopMode
    SkillPtsScanSuccess := false
    LoopCount := 0
    CustomCarCount := 0
    MasterMode := !MasterMode

    Loop {
        if !MasterMode
            break

        SetTimer(TotalTimerTick, 1000)

        LoopCount++
        ResetMiniGuiTelemetry()
        ShowNotif("info", "Full Loop Started", "Sequence " LoopCount " Initiated", , true)

        ; 1. Race Segment
        if (!StartLoop || StartLoop = "Race") {
            _UpdateStartLoop(RadioRace, "Race")
            StartRace()
            StartLoop := ""
            if _CheckAbort()
                break
        }

        ; 2. Buy Segment
        if (!StartLoop || StartLoop = "Buy") {
            _UpdateStartLoop(RadioBuy, "Buy")
            StartBuy()
            StartLoop := ""
            if _CheckAbort()
                break
        }

        ; 3. Unlock Segment
        if (!StartLoop || StartLoop = "Unlock") {
            _UpdateStartLoop(RadioUnlock, "Unlock")
            StartUnlock()
            StartLoop := ""
            if _CheckAbort()
                break
        }
        
        ; 4. Optional Wheelspin Segment
        if (SpinInFullLoop) {
            OpenSpinPanel()
            StartSpin()
            OnSpinClose()
            if _CheckAbort()
                break
        }

        ; Only fires if the entire loop sequence survived without hitting an abort
        ShowNotif("success", "Full Loop", "Sequence " LoopCount " Finalized in " MiniTotalRunTime_UI.Value, , true)
        
        _UpdateStartLoop(RadioRace, "Race")

        SetTimer(TotalTimerTick, 0)

        LoopCount_In.Value--
        if LoopCount_In.Value = 0
            break

        Process("Restarting Full Loop with Race Mode...")
    }
    
    ; Clean up state at termination
    MasterMode := false
    return

    ; Nested helper to deduplicate your termination alerts
    _CheckAbort() {
        global MasterMode
        if (!MasterMode) {
            ShowNotif("warning", "Full Loop", "Sequence " LoopCount " interrupted and stopped.", true)
            return true
        }
        return false
    }
}