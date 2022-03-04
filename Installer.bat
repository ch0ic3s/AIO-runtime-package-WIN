@echo off
color 17
setlocal EnableDelayedExpansion
::net file to test privileges, 1>NUL redirects output, 2>NUL redirects errors
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto START ) else ( goto getPrivileges ) 
:getPrivileges
if '%1'=='ELEV' ( goto START )
set "batchPath=%~f0"
set "batchArgs=ELEV"
::Add quotes to the batch path, if needed
set "script=%0"
set script=%script:"=%
IF '%0'=='!script!' ( GOTO PathQuotesDone )
    set "batchPath=""%batchPath%"""
:PathQuotesDone
::Add quotes to the arguments, if needed.
:ArgLoop
IF '%1'=='' ( GOTO EndArgLoop ) else ( GOTO AddArg )
    :AddArg
    set "arg=%1"
    set arg=%arg:"=%
    IF '%1'=='!arg!' ( GOTO NoQuotes )
        set "batchArgs=%batchArgs% "%1""
        GOTO QuotesDone
        :NoQuotes
        set "batchArgs=%batchArgs% %1"
    :QuotesDone
    shift
    GOTO ArgLoop
:EndArgLoop
::Create and run the vb script to elevate the batch file
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "cmd", "/c ""!batchPath! !batchArgs!""", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs" 
exit /B
:START
::Remove the elevation tag and set the correct working directory
IF '%1'=='ELEV' ( shift /1 )
cd /d %~dp0
::Do your adminy thing here...
CD /d %~dp0
CLS
:MENU
echo ...............................................
ECHO ch0ic3s' AIO runtime V1.1
ECHO ...............................................
echo changelog
echo 1.3:compacts code to minimize disc space
echo 1.2:patches issue #1 #2,adds XNAframework 4.0
echo 1.1:added menu to determin install options
echo 1.0:initial release
echo................................................
ECHO PRESS 1,2,3,4 or 5 
ECHO ...............................................
ECHO 1 - Install VCRedist,XNAframework and OpenAL
ECHO 2 - Install XNAframework
ECHO 3 - Install VCRedist
ECHO 4 - Install OpenAL
echo 5 - Exit
ECHO.
SET /P M=Type 1, 2, 3, 4 or 5 then press ENTER:
IF %M%==1 GOTO all
IF %M%==2 GOTO XNA
IF %M%==3 GOTO VCR
IF %M%==4 GOTO OAL
IF %M%==5 GOTO END
:all
set IS_X64=0 && if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set IS_X64=1) else (if "%PROCESSOR_ARCHITEW6432%"=="AMD64" (set IS_X64=1))
if "%IS_X64%" == "1" goto X64
start /wait vcredist2005_x86.exe /q
start /wait vcredist2008_x86.exe /qb
start /wait vcredist2010_x86.exe /passive /norestart
start /wait vcredist2012_x86.exe /passive /norestart
start /wait vcredist2013_x86.exe /passive /norestart
echo 2015, 2017 ^& 2019...
start /wait vcredist2015_2017_2019_2022_x86.exe /passive /norestart
goto END
:X64
start /wait vcredist2005_x86.exe /q
start /wait vcredist2005_x64.exe /q
start /wait vcredist2008_x86.exe /qb
start /wait vcredist2008_x64.exe /qb
start /wait vcredist2010_x86.exe /passive /norestart
start /wait vcredist2010_x64.exe /passive /norestart
start /wait vcredist2012_x86.exe /passive /norestart
start /wait vcredist2012_x64.exe /passive /norestart
start /wait vcredist2013_x86.exe /passive /norestart
start /wait vcredist2013_x64.exe /passive /norestart
start /wait vcredist2015_2017_2019_2022_x86.exe /passive /norestart
start /wait vcredist2015_2017_2019_2022_x64.exe /passive /norestart
start /wait XNA31.msi /passive /norestart
start /wait XNA30.msi /passive /norestart
start /wait XNA40.msi /passive /norestart
start /wait oalinst.exe -s
goto END
:VCR
set IS_X64=0 && if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set IS_X64=1) else (if "%PROCESSOR_ARCHITEW6432%"=="AMD64" (set IS_X64=1))
if "%IS_X64%" == "1" goto 64b
start /wait vcredist2005_x86.exe /q
start /wait vcredist2008_x86.exe /qb
start /wait vcredist2010_x86.exe /passive /norestart
start /wait vcredist2012_x86.exe /passive /norestart
start /wait vcredist2013_x86.exe /passive /norestart
start /wait vcredist2015_2017_2019_2022_x86.exe /passive /norestart
goto END
:XNA
start /wait XNA31.msi /passive /norestart
start /wait XNA30.msi /passive /norestart
start /wait XNA40.msi /passive /norestart
goto END
:OAL
start /wait oalinst.exe -s
goto end
:64b
start /wait vcredist2005_x86.exe /q
start /wait vcredist2005_x64.exe /q
start /wait vcredist2008_x86.exe /qb
start /wait vcredist2008_x64.exe /qb
start /wait vcredist2010_x86.exe /passive /norestart
start /wait vcredist2010_x64.exe /passive /norestart
start /wait vcredist2012_x86.exe /passive /norestart
start /wait vcredist2012_x64.exe /passive /norestart
start /wait vcredist2013_x86.exe /passive /norestart
start /wait vcredist2013_x64.exe /passive /norestart
start /wait vcredist2015_2017_2019_2022_x86.exe /passive /norestart
start /wait vcredist2015_2017_2019_2022_x64.exe /passive /norestart
goto END
:END
exit
