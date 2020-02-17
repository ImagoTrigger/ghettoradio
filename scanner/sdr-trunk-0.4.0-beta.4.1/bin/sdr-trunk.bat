@rem
@rem Copyright 2015 the original author or authors.
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem      https://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@if "%DEBUG%" == "" @echo off
@rem ##########################################################################
@rem
@rem  sdr-trunk startup script for Windows
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%..

@rem Add default JVM options here. You can also use JAVA_OPTS and SDR_TRUNK_OPTS to pass JVM options to this script.
set DEFAULT_JVM_OPTS=

@rem Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto init

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto init

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:init
@rem Get command-line arguments, handling Windows variants

if not "%OS%" == "Windows_NT" goto win9xME_args

:win9xME_args
@rem Slurp the command line arguments.
set CMD_LINE_ARGS=
set _SKIP=2

:win9xME_args_slurp
if "x%~1" == "x" goto execute

set CMD_LINE_ARGS=%*

:execute
@rem Setup the command line

set CLASSPATH=%APP_HOME%\lib\sdr-trunk-0.4.0-beta.4.jar;%APP_HOME%\lib\commons-math3-3.6.1.jar;%APP_HOME%\lib\java-lame-3.98.4.jar;%APP_HOME%\lib\jmbe-api-1.0.0.jar;%APP_HOME%\lib\libresample4j-0.1.3.jar;%APP_HOME%\lib\radio-reference-api-15.1.2.jar;%APP_HOME%\lib\logback-classic-1.2.3.jar;%APP_HOME%\lib\logback-core-1.2.3.jar;%APP_HOME%\lib\jackson-dataformat-xml-2.9.8.jar;%APP_HOME%\lib\jSerialComm-2.5.0.jar;%APP_HOME%\lib\jiconfont-font_awesome-4.7.0.1.jar;%APP_HOME%\lib\jiconfont-javafx-1.0.0.jar;%APP_HOME%\lib\jiconfont-swing-1.0.1.jar;%APP_HOME%\lib\JTransforms-3.1.jar;%APP_HOME%\lib\guava-27.0.1-jre.jar;%APP_HOME%\lib\jide-oss-3.6.18.jar;%APP_HOME%\lib\miglayout-swing-5.2.jar;%APP_HOME%\lib\charts-1.0.5.jar;%APP_HOME%\lib\usb4java-javax-1.3.0.jar;%APP_HOME%\lib\usb-api-1.0.2.jar;%APP_HOME%\lib\tablefilter-swing-5.4.0.jar;%APP_HOME%\lib\usb4java-1.3.0.jar;%APP_HOME%\lib\commons-lang3-3.8.1.jar;%APP_HOME%\lib\mina-http-2.0.19.jar;%APP_HOME%\lib\mina-core-2.0.19.jar;%APP_HOME%\lib\javafx-controls-11.0.2-win.jar;%APP_HOME%\lib\javafx-controls-11.0.2-linux.jar;%APP_HOME%\lib\javafx-controls-11.0.2-mac.jar;%APP_HOME%\lib\javafx-swing-11.0.2-win.jar;%APP_HOME%\lib\javafx-swing-11.0.2-linux.jar;%APP_HOME%\lib\javafx-swing-11.0.2-mac.jar;%APP_HOME%\lib\javafx-graphics-11.0.2-win.jar;%APP_HOME%\lib\javafx-graphics-11.0.2-linux.jar;%APP_HOME%\lib\javafx-graphics-11.0.2-mac.jar;%APP_HOME%\lib\javafx-graphics-11.0.2.jar;%APP_HOME%\lib\javafx-base-11.0.2-win.jar;%APP_HOME%\lib\javafx-base-11.0.2-linux.jar;%APP_HOME%\lib\javafx-base-11.0.2-mac.jar;%APP_HOME%\lib\javafx-base-11.0.2.jar;%APP_HOME%\lib\slf4j-api-1.7.25.jar;%APP_HOME%\lib\libusb4java-1.3.0-linux-x86.jar;%APP_HOME%\lib\libusb4java-1.3.0-linux-x86-64.jar;%APP_HOME%\lib\libusb4java-1.3.0-win32-x86.jar;%APP_HOME%\lib\libusb4java-1.3.0-win32-x86-64.jar;%APP_HOME%\lib\libusb4java-1.3.0-darwin-x86-64.jar;%APP_HOME%\lib\libusb4java-1.3.0-linux-arm.jar;%APP_HOME%\lib\libusb4java-1.3.0-linux-aarch64.jar;%APP_HOME%\lib\JLargeArrays-1.6.jar;%APP_HOME%\lib\jackson-module-jaxb-annotations-2.9.8.jar;%APP_HOME%\lib\jackson-databind-2.9.8.jar;%APP_HOME%\lib\jackson-core-2.9.8.jar;%APP_HOME%\lib\jackson-annotations-2.9.0.jar;%APP_HOME%\lib\woodstox-core-5.0.3.jar;%APP_HOME%\lib\stax2-api-3.1.4.jar;%APP_HOME%\lib\jiconfont-1.0.0.jar;%APP_HOME%\lib\commons-math3-3.5.jar;%APP_HOME%\lib\failureaccess-1.0.1.jar;%APP_HOME%\lib\listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar;%APP_HOME%\lib\jsr305-3.0.2.jar;%APP_HOME%\lib\checker-qual-2.5.2.jar;%APP_HOME%\lib\error_prone_annotations-2.2.0.jar;%APP_HOME%\lib\j2objc-annotations-1.1.jar;%APP_HOME%\lib\animal-sniffer-annotations-1.17.jar;%APP_HOME%\lib\miglayout-core-5.2.jar;%APP_HOME%\lib\commons-io-1.3.2.jar

@rem Execute sdr-trunk
"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %SDR_TRUNK_OPTS%  -classpath "%CLASSPATH%" io.github.dsheirer.gui.SDRTrunk %CMD_LINE_ARGS%

:end
@rem End local scope for the variables with windows NT shell
if "%ERRORLEVEL%"=="0" goto mainEnd

:fail
rem Set variable SDR_TRUNK_EXIT_CONSOLE if you need the _script_ return code instead of
rem the _cmd.exe /c_ return code!
if  not "" == "%SDR_TRUNK_EXIT_CONSOLE%" exit 1
exit /b 1

:mainEnd
if "%OS%"=="Windows_NT" endlocal

:omega
