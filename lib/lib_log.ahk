BrowserRefreshErr(message)
{
  BrowserRefreshLog(message, "err.txt")
}

BrowserRefreshLog(message, output="log.txt")
{
  FormatTime, time
  FileAppend, [%time%] %message%`n, %output%
}