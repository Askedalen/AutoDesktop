#Include createDefaultGrids.ahk

getConfig() {
    global grids
    global currentGrid
    configFile := FileOpen("config.conf", "r")
    if (configFile) {
        while (lineString := configFile.ReadLine()) {
            if (InStr(lineString, ";")) {
                continue
            }
            if (InStr(lineString, "[Start grids]")) {
                readGrids(configFile)
                continue
            } else {
                readConfig(lineString)
            }
        }
        configFile.Close()
    } else {
        configFile.Close()
        configFile := FileOpen("config.conf", "w")
        configFile.WriteLine(";   First cell          `| Second cell         `| ...")
        configFile.WriteLine(";   X    Y    W    H    `| X    Y    W    H    `| ...")
        configFile.WriteLine("[Start grids]")
        grids := createDefaultGrids()
        for i, grid in grids {
            line := ""
            for j, box in grid {
                for h, value in box {
                    if (j == 1 && h == 1) {
                        line .= "    "
                    }
                    line .= Floor(value) . (value < 10 
                                            ? "    " 
                                            : (value < 100 
                                               ? "   " 
                                               : (value < 1000 
                                                  ? "  " 
                                                  : " "))) 
                                         . (j < grid.MaxIndex() && h >= box.MaxIndex()
                                               ? "| " 
                                               : "")
                }
            }
            configFile.WriteLine(line)
        }
        configFile.WriteLine("[End grids]")
        createDefaultConfiguration(configFile)
        configFile.Close()
    }
    return
}

readGrids(ByRef configFile) {
    global grids
    while (lineString := configFile.ReadLine()) {
        if (InStr(lineString, "[End grids]")) {
            return
        }
        cellsString := StrSplit(lineString, "|")
        gridArray := []
        for i, singleCellString in cellsString {
            valuesString := StrSplit(singleCellString, " ")
            cellArray := []
            for j, singleValueString in valuesString {
                if (singleValueString != "") {
                    cellArray.Push(Trim(singleValueString, " `n"))
                }
            }
            gridArray.push(cellArray)
        }
        grids.push(gridArray)
    }
    return
}

readConfig(lineString) {
    if (!InStr(lineString, "=")) {
        return
    } 

    keyValue := StrSplit(lineString, "=")
    key := Trim(keyValue[1], " `n")
    value := Trim(keyValue[2], " `n")

    Switch key {
    Case "defaultGrid":
        global currentGrid
        currentGrid := value
    Default:
    }
}

createDefaultConfiguration(ByRef configFile) {
    configFile.WriteLine("; Configuration")
    configFile.WriteLine("defaultGrid=3")
    ; TODO: Read config after write
    global currentGrid
    currentGrid := 3
}

printGrids() {
    global grids
    string := ""
    for i, grid in grids {
        for j, cell in grid {
            for h, value in cell {
                string .= value . " "
            }
            string .= "`n"
        }
        string .= "`n"
    }
    MsgBox %string%
}