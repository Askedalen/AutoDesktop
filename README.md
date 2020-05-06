# AutoDesktop
Desktop manager.
This script splits your screen, allowing you to snap windows to different grids. 
Note: The script uses the SetWinEventHook function in Windows, which does not distinguish between moving a window and resizing it, so you cannot manually resize windows without holding  `Ctrl`. 

## Grids
There are currently five grids, each with a shortcut to select it:
- Whole screen - `Alt + 2`
- Two parts, split by the middle - `Alt + 3`
- Centered 1920x1080 (default) - `Alt + 4` 
- Three parts, center is 1400px - `Alt + 5`
- Four parts, similar to previous one, but left part is split horizontally - `Alt + 6`

In addition, `Alt + 1` can be used to exclude a window, causing it to not be resized. 
In order to temporarily disable the grid, hold `Ctrl`.

## Installation
- Install AutoHotKey from https://www.autohotkey.com/
- Download AutoDesktop.ahk, and place a shortcut in your startup folder (%appdata%/Microsoft/Windows/Start Menu/Programs/Startup)
