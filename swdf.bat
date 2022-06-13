@echo off
title System-wide data finder for Windows
:: use EnableDelayedExpansion to evaluate variables at runtime rather than at parse time
:: This is usefull in "for" cicles where variables changes dinamically during execution

:: main global variables
set PATTERN=%1
set SEPARATOR=______________________________

:: check that atleast a pattern and an option is given
if "%1"=="" call :function_error No pattern given
if "%2"=="" call :function_error You need to provied atleast one option
:: Note: command "call" is used because it send runtime evaluated variables to the underlying command

call :function_showManual

:loop_parseArguments
if "%2"=="" goto :end

if "%2"=="/D" (
call :function_scanDisk %PATTERN%
:: Do not print separator since the function will already do that internally
goto :continue_parseArguments_noSeparator
)

if "%2"=="/F" (
call :function_scanFolder %PATTERN%
goto :continue_parseArguments
)

if "%2"=="/K" (
call :function_scanRegistry 1 %PATTERN%
:: Do not print separator since the function will already do that internally
goto :continue_parseArguments_noSeparator
)

if "%2"=="/V" (
call :function_scanRegistry 2 %PATTERN%
:: Do not print separator since the function will already do that internally
goto :continue_parseArguments_noSeparator
)

if "%2"=="/C" (
call :function_scanConnections %PATTERN%
goto :continue_parseArguments
)

if "%2"=="/P" (
call :function_scanProcess %PATTERN%
goto :continue_parseArguments
)

echo Error: "%2" is not a valid option: ignored

:continue_parseArguments
echo %SEPARATOR%
:continue_parseArguments_noSeparator
shift
goto :loop_parseArguments

:end
echo Execution terminated
pause
exit /b

:function_scanFolder
setlocal EnableDelayedExpansion
set pattern=%1
echo Scanning current folder: %cd%
dir /s /b %cd%\%pattern%
endlocal
goto :eof

:function_scanDisk
setlocal EnableDelayedExpansion
set pattern=%1
set tempFile=%tmp%\function_scanDisk.%random%.tmp
set separator=______________________________
:: Get disks label with 'wmic'
:: Normally the output will be something like:
::     Caption  
::     C:       
::     D:       
:: by using 'findstr ":"' we can filter for disk labels only.
:: Note that each line contains extra spaces: they need to be removed in order to be used as arguments in "dir" command
wmic logicaldisk get deviceid | findstr "^.:" > %tempFile%
for /f "tokens=*" %%a in (%tempFile%) do (
set line=%%a
:: remove extra spaces
set disk=!line: =!
call echo Scanning disk !disk!
call dir /s /b !disk!\%pattern%
echo %separator%
)
del %tempFile%
endlocal
goto :eof

:function_scanRegistry
setlocal EnableDelayedExpansion
set mode=%1
set pattern=%2
set rootKeys=HKCR HKCU HKLM HKU HKCC
set separator=______________________________
for %%a in (%rootKeys%) do (
if "%mode%"=="1" (
echo Scanning registry keys in %%a
reg query %%a /s /k /f %pattern%
)
if "%mode%"=="2" (
echo Scanning registry values in %%a
reg query %%a /s /d /f %pattern%
)
echo %separator%
)
endlocal
goto :eof

:function_scanConnections
setlocal EnableDelayedExpansion
set pattern=%1
echo Scanning for connections
call :function_asterisksToRegex %pattern%
:: Use "net session" to check if the script runs as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
call netstat -anob | findstr !retval_asterisksToRegex!
) else (
echo Not running as administrator: using 'netstat' without option '-b'
call netstat -ano  | findstr !retval_asterisksToRegex!
)
endlocal
goto :eof

:function_scanProcess
setlocal EnableDelayedExpansion
set pattern=%1
set tempFile=%tmp%\function_asterisksToRegex.%random%.tmp
echo Scanning for processes
call :function_asterisksToRegex %pattern%
call tasklist /V    >  %tempFile% 
call tasklist /SVC  >> %tempFile%
call tasklist /APPS >> %tempFile%
call findstr !retval_asterisksToRegex! %tempFile% 
del %tempFile%
endlocal
goto :eof

:: Show the Help menu
:function_showManual
echo               .andAHHAbnn.               
echo            .aAHHHAAUUAAHHHAn.            
echo           dHP-~*        *~-THb.          
echo     .   .AHF                YHA.   .     System-wide data finder for Windows
echo     I  .AHHb.              .dHHA.  I     
echo     I  HHAUAAHAbn      adAHAAUAHA  I     Look for a pattern in various places in your system
echo     I  HF~L_____        ____ IHHH  I     
echo    HHI HAPK**~AYUHb  dAHHHHHHHHHH IHH    Usage:
echo    HHI HHHD~ .andHH  HHUUPA~YHHHH IHH        swdffw.bat [PATTERN] [/D] [/F] [/K] [/V] [/C] [/P]
echo    YUI LHHP     *~Y  P~*     THHI IUP    
echo     V  'HK                   LHH'  V     /D match file names in the whole disk
echo         THAn.  .d.aAAn.b.  .dHHP         /F match file name in the current working directory (recursive)
echo         LHHHHAAUP* ~~ *YUAAHHHHI         /K match registry keys
echo         'HHPA~*  .annn.  *~AYHH'         /V match registry values (slow search)
echo          YHb    ~* ** *~    dHF          /C match netstat connections
echo           *YAb..abdHHbndbndAP*           /P match processes
echo            THHAAb.  .adAHHF              
echo             *UHHHHHHHHHHU*               You can use the wildcard character '*' to match 'any string'.
echo               LHHUUHHHHHHI               
echo             .adHHb *HHHHHbn.             Sample usage:
echo      ..andAAHHHHHHb.AHHHHHHHAAbnn..          swdffw.bat *foo*bar* /D
echo .ndAAHHHHHHUUHHHHHHHHHHUP-~*~-YUHHHAAbn. 
echo;
goto :eof


:: Print an error, show the manual and exit the program
:function_error
call :function_showManual
echo Error: %*
call :function_exit 2> nul
goto :eof

:: Calling "exit" inside a function  will stop the function but not the parent script.
:: To stop the parent script too we can create an empty code block that will generate a fatal syntax error.
:: To suppress the error we can put the empty code block in a function and redirect stderr to null
:function_exit
()
goto :eof


:: Replace every '*' with '.*'
:function_asterisksToRegex
setlocal EnableDelayedExpansion
set string=%1
set position=0
:loop_asterisksToRegex
set /a positionPlusOne=%position%+1
if "!string:~%position%,1!"=="*" (
set string=!string:~0,%position%!.*!string:~%positionPlusOne%!
set /a position=%position%+2
) else (
set /a position=%position%+1
)

if not "!string:~%position%,1!"=="" goto :loop_asterisksToRegex
:: To set multiple global variables to the value of local variables, use the following trick
:: The variables in the code block are expanded before endlocal is executed
endlocal & (
set "retval_asterisksToRegex=%string%"
)
goto :eof