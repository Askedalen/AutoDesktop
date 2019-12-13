#SingleInstance, force
SysGet, workArea, MonitorWorkArea
screenWidth := workAreaRight
screenHeight := workAreaBottom
normalSize(title) {
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