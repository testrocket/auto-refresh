#include lib\lib_log.ahk

BrowserRefreshLog("Removing previous log files.")

FileDelete, err.txt
FileDelete, log.txt

CONFIG := "config.ini"

IfNotExist, %CONFIG%
{
  BrowserRefreshErr("Configuration file config.ini does not exist: " A_WorkingDir)
  ExitApp
}

BrowserRefreshLog("Reading data from config: " CONFIG)

IniRead, loopTimeout, %CONFIG%, settings, loopTimeout, 1000
IniRead, iterations, %CONFIG%, settings, iterations, 40
IniRead, preferredBrowser, %CONFIG%, settings, preferredBrowser, chrome
IniRead, refreshTimeout, %CONFIG%, settings, refreshTimeout, 60
IniRead, supportedBrowsers, %CONFIG%, settings, supportedBrowsers, chrome`,firefox`,ie

if preferredBrowser not in supportedBrowsers
{
  BrowserRefreshErr("Unsupported browser: " preferredBrowser ". Supported browsers: " supportedBrowsers)
  ExitApp
}

BrowserRefreshLog("Timeout set to: " timeout)
BrowserRefreshLog("Iterations set to: " iterations)
BrowserRefreshLog("PreferredBrowser set to: " preferredBrowser)


