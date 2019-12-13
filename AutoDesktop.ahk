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
^b::
    WinGetTitle, title, A
    WinGetClass, winClass, A
    MsgBox, The title is %title%, the winClass is %winClass%
    return

^f::
    WinGetTitle, title, A
    XPos := screenWidth / 4
    XSize := screenWidth / 2
    YSize := screenHeight
    If (!normalSize(title)) {
        XPos -= 8
        XSize += 16
        YSize += 7
    }
    WinMove, %title%, , %XPos%, 0, %XSize%, %YSize%
    return

^1::
    WinGetTitle, title, A 
    XPos := 0
    X3rdSize := (screenWidth - 1400) / 2
    Y3rdSize := screenHeight
    If (!normalSize(title)) {
        XPos -= 8
        X3rdSize += 16
        Y3rdSize += 7
    }
    WinMove, %title%, , %XPos%, 0, %X3rdSize%, %Y3rdSize%
    return

^2::
    WinGetTitle, title, A 
    XPos := (screenWidth - 1400) / 2
    X3rdSize := 1400
    Y3rdSize := screenHeight
    If (!normalSize(title)) {
        XPos -= 8
        X3rdSize += 16
        Y3rdSize += 7
    }
    WinMove, %title%, , %XPos%, 0, %X3rdSize%, %Y3rdSize%
    return

^3::
    WinGetTitle, title, A 
    XPos := screenWidth - ((screenWidth - 1400) / 2)
    X3rdSize := (screenWidth - 1400) / 2
    Y3rdSize := screenHeight
    If (!normalSize(title)) {
        XPos -= 8
        X3rdSize += 16
        Y3rdSize += 7
    }
    WinMove, %title%, , %XPos%, 0, %X3rdSize%, %Y3rdSize%
    return