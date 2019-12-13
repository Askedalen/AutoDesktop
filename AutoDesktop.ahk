#SingleInstance, force

; WINDOW HOOK
#Persistent
    windowMovingAdr := RegisterCallback("windowMoving", "F")
    setEventHook(0xA, 0xB, 0, windowMovingAdr, 0, 0, 0)
return

windowMoving(hWinEventHook, event, hwind, idObject, idChild, dwEventThread, dwmsEventTime) {
    ;if event = 10
        ; Do something
}

setEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags) {
    DllCall("CoInitializeEx", "uint", 0, "uint", 0)
    return DllCall("SetWinEventHook", "uint", eventMin, "uint", eventMax, "uint", hmodWinEventProc, "uint", lpfnWinEventProc, "uint", idProcess, "uint", idThread, "uint", dwFlags)
    
}

; PLACEMENT FUNCTIONS
SysGet, workArea, MonitorWorkArea
screenWidth := workAreaRight
screenHeight := workAreaBottom
normalSize(title) {
    ; Checks if the application is in the list of apps that act normal
    isNormal := false
    WinGetClass, winClass, %title%
    
    if (InStr(title, "Visual Studio Code")) {
        isNormal := true
    } else if (winClass == "Photoshop") {
        isNormal := true
    } else if (InStr(title, "Microsoft Visual Studio")) {
        isNormal := true
    } else if (InStr(title, "Spotify Premium")) {
        isNormal := true
    } else if (InStr(title, "GitHub")) {
        isNormal := true
    }
    return isNormal
}

getScreenWidth() {
    SysGet, workArea, MonitorWorkArea
    return workAreaRight
}

getScreenHeight() {
    SysGet, workArea, MonitorWorkArea
    return workAreaBottom
}

getWindowInfo() {
    WinGetTitle, title, A
    WinGetClass, winClass, A
    MsgBox, The title is %title%, the winClass is %winClass%
    return
}

middleScreenPos() {
    WinGetTitle, title, A
    xPos := getScreenWidth() / 4
    xSize := getScreenWidth() / 2
    ySize := getScreenHeight()
    If (!normalSize(title)) {
        xPos -= 8
        xSize += 16
        ySize += 7
    }
    WinMove, %title%, , %xPos%, 0, %xSize%, %ySize%
    return
}

leftThirdPos() {
    WinGetTitle, title, A 
    xPos := 0
    x3rdSize := (getScreenWidth() - 1400) / 2
    y3rdSize := getScreenHeight()
    If (!normalSize(title)) {
        xPos -= 8
        x3rdSize += 16
        y3rdSize += 7
    }
    WinMove, %title%, , %xPos%, 0, %x3rdSize%, %y3rdSize%
    return
}

middleThirdPos() {
    WinGetTitle, title, A 
    xPos := (getScreenWidth() - 1400) / 2
    x3rdSize := 1400
    y3rdSize := getScreenHeight()
    If (!normalSize(title)) {
        xPos -= 8
        x3rdSize += 16
        y3rdSize += 7
    }
    WinMove, %title%, , %xPos%, 0, %x3rdSize%, %y3rdSize%
    return
}

rightThirdPos() {
    WinGetTitle, title, A 
    xPos := getScreenWidth() - ((getScreenWidth() - 1400) / 2)
    x3rdSize := (getScreenWidth() - 1400) / 2
    y3rdSize := getScreenHeight()
    If (!normalSize(title)) {
        xPos -= 8
        x3rdSize += 16
        y3rdSize += 7
    }
    WinMove, %title%, , %xPos%, 0, %x3rdSize%, %y3rdSize%
    return
}

; HOTKEYS
^b::
getWindowInfo()
return

^f::
middleScreenPos()
return

^1::
leftThirdPos()
return

^2::
middleThirdPos()
return

^3::
rightThirdPos()
return

*~LButton::
    MouseGetPos, mouseX, mouseY, window
    
    return
    