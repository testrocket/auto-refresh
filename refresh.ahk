#include lib\lib_log.ahk
#include lib\lib_config.ahk

BrowserRefreshLoop()
{
  global iterations
  global loopTimeout
  global preferredBrowser
  global refreshTimeout
  global browserNamePart
  
  if (preferredBrowser == "firefox")
    browserNamePart := " - Mozilla Firefox"
  else if (preferredBrowser == "chrome")
    browserNamePart := " - Google Chrome"
  
  ; change seconds to miliseconds
  refreshTimeout := refreshTimeout * 1000
  loopTimeout := loopTimeout * 1000
  
  ; timer start time
  startTime := A_TickCount
  
  fileModificationTime := 0
  Loop, %iterations%
  {
    Sleep, %loopTimeout%
    
    if ((A_TickCount - startTime) > refreshTimeout)
    {
      BrowserRefreshLog("Browser refresh loopTimeout: " (refreshTimeout / 1000) " seconds")
      ExitApp
    }
    
    ; make sure that notepad++ is running
    Process, Exist, notepad++.exe
    if !ErrorLevel
      Continue
    
    ; get exact window title for notepad++
    SetTitleMatchMode, 2
    WinGetTitle, notepadWindowTitle, - Notepad++
    if (notepadWindowTitle == "")
      Continue

    ; check if filePath with correct extension is currently opened
    if !RegExMatch(notepadWindowTitle, "(.*.html) - Notepad++", file)  
    {
      BrowserRefreshErr("Window with .html extension does not exist")
      ExitApp
    }
    ; get exact filePath location
    filePath := file1
    
    ; make sure that filePath has been modified
    FileGetTime, currentFileModificationTime, %filePath%
    if (currentFileModificationTime != fileModificationTime)
    {
      ; update file modification time
      fileModificationTime := currentFileModificationTime
      ; reset timer
      startTime := A_TickCount
      
      RegExMatch(filePath, ".*\\(.*).html", browserWindowTitle)
      
      BrowserRefreshPrepare(notepadWindowTitle, filePath, browserWindowTitle1)
      BrowserRefreshSendEvent(browserWindowTitle1)
    }
    
    ; if browser is not running at this point then stop script
    Process, Exist, %preferredBrowser%.exe
    if !ErrorLevel
    {
      BrowserRefreshLog("Browser has been closed: " preferredBrowser)
      ExitApp
    }
  }
}

BrowserRefreshSendEvent(browserWindowTitle)
{
  global preferredBrowser
  global browserNamePart
  
  BrowserRefreshLog("Sending refresh event to window title: " browserWindowTitle)
  ControlSend,,{f5}, %browserWindowTitle%%browserNamePart%
}

BrowserRefreshPrepare(notepadTitle, filePath, browserWindowTitle)
{
  global preferredBrowser
  global browserStarted
  
  if browserStarted
    return TRUE
  
  Process, Exist, %preferredBrowser%.exe
  if !ErrorLevel
  {
    BrowserRefreshLog("Starting browser with url: " filePath)

    Run, %preferredBrowser%.exe %filePath%
    if ErrorLevel
    {
      BrowserRefreshErr("Browser could not be started.")
      ExitApp
    }
    
    ; wait few seconds for window to become active
    WinWaitActive, %browserWindowTitle%,, 20
    if ErrorLevel
    {
      BrowserRefreshErr("loopTimeout while waiting for window with title: " filePath)
      ExitApp
    }
  }
  else
  {
    ; open new tab
  } 
  
  halfScreenWidth := A_ScreenWidth // 2
  
  WinGetPos,,,, browserWindowHeight, %browserWindowTitle%
  WinMove, %browserWindowTitle%,, %halfScreenWidth%, 0, %halfScreenWidth%, %browserWindowHeight%
  
  WinGetPos,,,, notepadWindowHeight, %notepadTitle%
  WinMove, %notepadTitle%,, 0, 0, %halfScreenWidth%, %notepadWindowHeight%
  
  BrowserRefreshLog("Browser started.")
  browserStarted := TRUE
  return TRUE
}

BrowserRefreshLoop()