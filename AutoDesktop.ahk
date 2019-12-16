#SingleInstance, force

; WINDOW HOOK
#Persistent
    windowMovingAdr := RegisterCallback("windowMoving", "F")
    setEventHook(0xA, 0xB, 0, windowMovingAdr, 0, 0, 0)
    CoordMode, Mouse, Screen
    DetectHiddenWindows, Off
    screenWidth := getScreenWidth()
    screenHeight := getScreenHeight()
    currentGrid := 1
    windowGrid := [[[0
                    ,0
                    ,(screenWidth - 1400) / 2
                    ,screenHeight]
                   ,[(screenWidth - 1400) / 2
                    ,0
                    ,1400
                    ,screenHeight]
                   ,[screenWidth - ((screenWidth - 1400) / 2)
                    ,0
                    ,(screenWidth - 1400) / 2
                    ,screenHeight]]
                  ,[[0
                    ,0
                    ,screenWidth / 4
                    ,screenHeight]
                   ,[screenWidth / 4
                    ,0
                    ,screenWidth / 2
                    ,screenHeight]
                   ,[screenWidth - (screenWidth / 4)
                    ,0
                    ,screenWidth/4
                    ,screenHeight]]
                  ,[[0
                    ,0
                    ,screenWidth / 2
                    ,screenHeight]
                   ,[screenWidth / 2
                    ,0
                    ,screenWidth / 2
                    ,screenHeight]]]
return

windowMoving(hWinEventHook, event, hwind, idObject, idChild, dwEventThread, dwmsEventTime) {
    if (!GetKeyState("Control", "P")) {
        if (event = 0xA) {
            MouseGetPos, mouseX, mouseY, mouseOverWindow
            grid := getGrid()
            for i, cell in grid {
                x := cell[1] + 10
                y := cell[2] + 10
                w := cell[3] - 20
                h := cell[4] - 20
                Gui, win%i%:New, +AlwaysOnTop +LastFound -Caption +Owner +Disabled
                Gui, win%i%:Color, 7be098
                WinSet, Transparent, 50
                WinSet, ExStyle,^0x20
                Gui, win%i%:Show, W%w% H%h% X%x% Y%y% NoActivate
            }
        } else if (event = 0xB) {
            MouseGetPos, mouseX, mouseY
            grid := getGrid()
            for i, cell in grid {
                Gui, win%i%:Destroy
                if ((mouseX >= cell[1]) 
                 && (mouseX <= (cell[1] + cell[3]))
                 && (mouseY >= cell[2]) 
                 && (mouseY <= (cell[2] + cell[4]))){
                    moveWindow(cell, hwind)
                }
            }
        }
    }
    return
}

setEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags) {
    DllCall("CoInitializeEx", "uint", 0, "uint", 0)
    return DllCall("SetWinEventHook"
                  ,"uint", eventMin
                  ,"uint", eventMax
                  ,"uint", hmodWinEventProc
                  ,"uint", lpfnWinEventProc
                  ,"uint", idProcess
                  ,"uint", idThread
                  ,"uint", dwFlags)
}

; PLACEMENT FUNCTIONS
normalSize(hwind) {
    ; Checks if the application is in the list of apps that act normal
    isNormal := false
    WinGetTitle, title, ahk_id %hwind%
    WinGet, processName, ProcessName, ahk_id %hwind%
    
    if (InStr(title, "Visual Studio Code")) {
        isNormal := true
    } else if (processName == "Photoshop.exe") {
        isNormal := true
    } else if (InStr(title, "Microsoft Visual Studio")) {
        isNormal := true
    } else if (processName == "Spotify.exe") {
        isNormal := true
    } else if (InStr(title, "GitHub")) {
        isNormal := true
    } else if (InStr(title, "Epic Games")) {
        isNormal := true
    }
    return isNormal
}

getGrid() {
    global windowGrid
    global currentGrid
    return windowGrid[currentGrid]
}

swapGrid() {
    global currentGrid
    if (currentGrid == 1) {
        currentGrid := 2
    } else if (currentGrid == 2) {
        currentGrid := 3
    } else {
        currentGrid := 1
    }
    moveAllOpenWindows()
    return
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
    WinGet, id, ID, A
    WinGet, pid, PID, ahk_id %id%
    WinGet, processName, ProcessName, ahk_id %id%
    WinGetTitle, title, ahk_id %id%
    WinGetClass, winClass, ahk_id %id%
    MsgBox, Title: %title% `nClass: %winClass% `nID: %id% `nPID: %pid% `nProcess: %processName%
    return
}

moveWindow(dimensions, hwind) {
    WinGetTitle, title, ahk_id %hwind%
    x := dimensions[1]
    y := dimensions[2]
    w := dimensions[3]
    h := dimensions[4]
    if (!normalSize(hwind)) {
        x -= 8
        w += 16
        h += 7
    }
    WinMove, %title%, , %x%, %y%, %w%, %h%
    return
}

moveAllOpenWindows() {
    WinGet, openWindows, list
    grid := getGrid()
    Loop %openWindows% {
        id := openWindows%A_Index%
        WinGetPos, x, y, w, h, ahk_id %id%
        winX := x + (w / 2)
        winY := y + (h / 2)
        for i, cell in grid {
            if ((winX >= cell[1]) 
             && (winX <= (cell[1] + cell[3]))
             && (winY >= cell[2]) 
             && (winY <= (cell[2] + cell[4]))){
                moveWindow(cell, id)
            }
        }
    }
    return
}

; HOTKEYS
^+a::
    swapGrid()
    return

^+F1::
    getWindowInfo()
    return

    