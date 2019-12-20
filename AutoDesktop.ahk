#SingleInstance, force

; WINDOW HOOK
#Persistent
    windowMovingAdr := RegisterCallback("windowMoving", "F")
    setEventHook(0xA, 0xB, 0, windowMovingAdr, 0, 0, 0)
    CoordMode, Mouse, Screen
    DetectHiddenWindows, Off
    screenWidth := getScreenWidth()
    screenHeight := getScreenHeight()
    currentGrid := 2
    windowGrid := [[[0
                    ,0
                    ,(screenWidth - ((screenWidth / 3840) * 1400)) / 2
                    ,screenHeight]
                   ,[(screenWidth - ((screenWidth / 3840) * 1400)) / 2
                    ,0
                    ,((screenWidth / 3840) * 1400)
                    ,screenHeight]
                   ,[screenWidth - ((screenWidth - ((screenWidth / 3840) * 1400)) / 2)
                    ,0
                    ,(screenWidth - ((screenWidth / 3840) * 1400)) / 2
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
                    ,screenHeight]]
                  ,[[0
                    ,0
                    ,(screenWidth - ((screenWidth / 3840) * 1400)) / 2
                    ,screenHeight / 2]
                   ,[0
                    ,screenHeight / 2
                    ,(screenWidth - ((screenWidth / 3840) * 1400)) / 2
                    ,screenHeight / 2]
                   ,[(screenWidth - ((screenWidth / 3840) * 1400)) / 2
                    ,0
                    ,((screenWidth / 3840) * 1400)
                    ,screenHeight]
                   ,[screenWidth - ((screenWidth - ((screenWidth / 3840) * 1400)) / 2)
                    ,0
                    ,(screenWidth - ((screenWidth / 3840) * 1400)) / 2
                    ,screenHeight]]
                  ,[[0
                    ,0
                    ,screenWidth
                    ,screenHeight]]]
    deactivatedWindows := Array()
return

windowMoving(hWinEventHook, event, hwind, idObject, idChild, dwEventThread, dwmsEventTime) {
    global deactivatedWindows
    deactivated := false
    WinGet, hwnd, ID, A
    for i, window in deactivatedWindows {
        if (hwnd == window) {
            deactivated := true
        }
    }
    if (!deactivated) {
        static windowDrag := false
        if (event = 0xA) {
            windowDrag := true
            if (!GetKeyState("Control", "P")) { 
                createGui()
            }

            grid := getGrid()
            mouseOverGrid := []
            while (windowDrag) {
                if (!GetKeyState("Control", "P")) {
                    MouseGetPos, mouseX, mouseY
                    for i, cell in grid {
                        if ((mouseX >=  cell[1]) 
                        && (mouseX <= (cell[1] + cell[3]))
                        && (mouseY >=  cell[2]) 
                        && (mouseY <= (cell[2] + cell[4]))) {
                            Gui, win%i%: +LastFound
                            WinSet, Transparent, 200
                            mouseOverGrid[i] := true
                        } else if (mouseOverGrid[i]) {
                            Gui, win%i%: +LastFound
                            WinSet, Transparent, 90
                            mouseOverGrid[i] := false
                        }
                    }
                    sleep 10
                    continue
                }

                removeGui()
                while (GetKeyState("Control", "P")) { 
                    sleep 10
                    if (!GetKeyState("LButton", "P")) {
                        break 2
                    }
                }
                createGui()
            }
        } else if (event = 0xB) {
            windowDrag := false
            if (!GetKeyState("Control", "P")) {
                removeGui()
                MouseGetPos, mouseX, mouseY
                grid := getGrid()
                for i, cell in grid {
                    if ((mouseX >=  cell[1]) 
                    && (mouseX <= (cell[1] + cell[3]))
                    && (mouseY >=  cell[2]) 
                    && (mouseY <= (cell[2] + cell[4]))){
                        moveWindow(cell, hwind)
                    }
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

; Add/remove GUI overlay
createGui() {
    grid := getGrid()
    for i, cell in grid {
        x := cell[1] + 10
        y := cell[2] + 10
        w := cell[3] - 20
        h := cell[4] - 20
        Gui, win%i%:New, +AlwaysOnTop +LastFound -Caption +Owner +Disabled
        Gui, win%i%:Color, 000000
        WinSet, Transparent, 90
        WinSet, ExStyle,^0x20
        Gui, win%i%:Show, W%w% H%h% X%x% Y%y% NoActivate
    }
    return
}

removeGui() {
    grid := getGrid()
    for i, cell in grid {
        Gui, win%i%:Destroy
    }
    return
}

deactivateWindow() {
    global deactivatedWindows
    foundAt := 0
    WinGet, hwnd, ID, A
    for i, window in deactivatedWindows {
        if (hwnd == window) {
            foundAt := i
        }
    }
    if (!foundAt) {
        deactivatedWindows.Push(hwnd)
    } else {
        deactivatedWindows.RemoveAt(foundAt)
    }
    return
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
    } else if (InStr(title, "Discord")) {
        isNormal := true
    } else if (processName == "Steam.exe") {
        isNormal := true
    }
    return isNormal
}

getGrid() {
    global windowGrid
    global currentGrid
    return windowGrid[currentGrid]
}

swapGrid(gridNumber) {
    global currentGrid
    currentGrid := gridNumber
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
    global deactivatedWindows
    WinGet, openWindows, list
    grid := getGrid()
    Loop %openWindows% {
        id := openWindows%A_Index%
        deactivated := false
        WinGet, hwnd, ID, A
        for i, window in deactivatedWindows {
            if (id == window) {
                deactivated := true
            }
        }
        if (!deactivated) {
            id := openWindows%A_Index%
            WinGetPos, x, y, w, h, ahk_id %id%
            winX := x + (w / 2) + 1
            winY := y + (h / 2) + 1
            for i, cell in grid {
                if ((winX >= cell[1]) 
                && (winX <= (cell[1] + cell[3]))
                && (winY >= cell[2]) 
                && (winY <= (cell[2] + cell[4]))){
                    moveWindow(cell, id)
                }
            }
        }
    }
    return
}

; HOTKEYS
!1::
    deactivateWindow()
    return

!2::
    swapGrid(5)
    return

!3::
    swapGrid(3)
    return

!4::
    swapGrid(2)
    return

!5::
    swapGrid(1)
    return

!6::
    swapGrid(4)
    return

^+F1::
    getWindowInfo()
    return
    