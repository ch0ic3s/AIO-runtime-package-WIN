@echo off
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
ver | findstr /i "5\.0\."        && (echo Windows 2000 & GOTO :NOTTESTEDWIN)
ver | findstr /i "5\.1\."        && (echo Windows XP 32bit & GOTO :NOTTESTEDWIN) 
ver | findstr /i "5\.2\."        && (echo Windows XP x64 / Windows Server 2003 & GOTO :NOTTESTEDWIN)
ver | findstr /i "6\.0\." > nul  && (echo Windows Vista / Server 2008 & GOTO :NOTTESTEDWIN)
ver | findstr /i "6\.1\." > nul  && (echo Windows 7 / Server 2008R2 & GOTO :TESTEDWIN)
ver | findstr /i "6\.2\." > nul  && (echo Windows 8 / Server 2012 & GOTO :NOTTESTEDWIN)
ver | findstr /i "6\.3\." > nul  && (echo Windows 8.1 / Server 2012R2 & GOTO :NOTTESTEDWIN)
ver | findstr /i "10\.0\." > nul && (echo Windows 10 / Server 2016 & GOTO :TESTEDWIN)
5
echo "Could not detect Windows version! exiting..."
color 4F & pause & exit /B 1

:NOTTESTEDWIN
echo "This is not a supported Windows version"
color 4F & pause & exit /B 1

:TESTEDWIN
CD /d %~dp0
CLS
:MENU
CLS
color 17
echo ########################################################
ECHO #ch0ic3s' AIO runtime V1.5                             #
echo ########################################################
ECHO #PRESS 1,2,3,4,5,6 or 7                                #
ECHO ########################################################
ECHO #1 - Install VCRedist,XNAframework,OpenAL and DirectX  #
ECHO #2 - Install XNAframework                              #
ECHO #3 - Install VCRedist                                  #
ECHO #4 - Install OpenAL                                    #
echo #5 - Install DirectX                                   #
echo #6 - View changelog                                    #
ech0 #7 - Exit                                              #
echo ########################################################
ECHO.
SET /P M=Type 1, 2, 3, 4 or 5 then press ENTER:
IF %M%==1 GOTO all 
IF %M%==2 GOTO XNA 
IF %M%==3 GOTO VCR 
IF %M%==4 GOTO OAL 
IF %M%==5 GOTO WEB
IF %M%==6 goto changelog
IF %M%==7 goto exit
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
start /wait webinst.exe /Q
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
:error
ECHO error:device not compatible
wait 10 /nobreak
:changelog
echo 1.5:added DirectX
echo 1.4:added OS checks
echo 1.3:compacts code to minimize disc space
echo 1.2:patches issue #1 #2,adds XNAframework 4.0
echo 1.1:added menu to determine install options
echo 1.0:initial release
timeout 30
goto :testedwin
:WEB
start /wait webinst.exe
