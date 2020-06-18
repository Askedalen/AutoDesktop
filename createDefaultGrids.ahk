getScreenWidth() {
    SysGet, workArea, MonitorWorkArea
    return workAreaRight
}

getScreenHeight() {
    SysGet, workArea, MonitorWorkArea
    return workAreaBottom
}

createDefaultGrids() {
    screenWidth := getScreenWidth()
    screenHeight := getScreenHeight()
    return [[[0
             ,0
             ,screenWidth
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
             ,screenHeight]]]
}