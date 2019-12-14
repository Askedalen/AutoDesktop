#SingleInstance, force

; WINDOW HOOK
#Persistent
    windowMovingAdr := RegisterCallback("windowMoving", "F")
    setEventHook(0xA, 0xB, 0, windowMovingAdr, 0, 0, 0)
    CoordMode, Mouse, Screen
    currentGrid = 1
    windowGrid := [[[0
                    ,0
                    ,(getScreenWidth() - 1400) / 2
                    ,getScreenHeight()]
                   ,[(getScreenWidth() - 1400) / 2
                    ,0
                    ,1400
                    ,getScreenHeight()]
                   ,[getScreenWidth() - ((getScreenWidth() - 1400) / 2)
                    ,0
                    ,(getScreenWidth() - 1400) / 2
                    ,getScreenHeight()]]
                  ,[[0
                    ,0
                    ,getScreenWidth() / 4
                    ,getScreenHeight()]
                   ,[getScreenWidth() / 4
                    ,0
                    ,getScreenWidth() / 2
                    ,getScreenHeight()]
                   ,[getScreenWidth() - (getScreenWidth() / 4)
                    ,0
                    ,getScreenWidth()/4
                    ,getScreenHeight()]]]
return

windowMoving(hWinEventHook, event, hwind, idObject, idChild, dwEventThread, dwmsEventTime) {
    if (!GetKeyState("Control", "P")) {
        if (event = 10) {
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
        } else if (event = 11) {
            MouseGetPos, mouseX, mouseY
            grid := getGrid()
            for i, cell in grid {
                Gui, win%i%:Destroy
                if ((mouseX >= cell[1]) && (mouseX <= (cell[1] + cell[3]))){
                    moveWindow(cell)
                }
            }
        }
    }
    return
}

setEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags) {
    DllCall("CoInitializeEx", "uint", 0, "uint", 0)
    return DllCall("SetWinEventHook", "uint", eventMin, "uint", eventMax, "uint", hmodWinEventProc, "uint", lpfnWinEventProc, "uint", idProcess, "uint", idThread, "uint", dwFlags)
}

; PLACEMENT FUNCTIONS
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
    } else {
        currentGrid := 1
    }
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
    MsgBox, Title: %title% `nClass: %winClass%
    return
}

moveWindow(dimensions) {
    WinGetTitle, title, A
    x := dimensions[1]
    y := dimensions[2]
    w := dimensions[3]
    h := dimensions[4]
    if (!normalSize(title)) {
        x -= 8
        w += 16
        h += 7
    }
    WinMove, %title%, , %x%, %y%, %w%, %h%
}

; HOTKEYS
^+a::
    swapGrid()
    return

^+F1::
    getWindowInfo()
    return

    