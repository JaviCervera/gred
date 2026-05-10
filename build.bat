@echo off
setlocal

set BUILD_DIR=_cmake
set OUTPUT_DIR=_build

if not exist %BUILD_DIR% mkdir %BUILD_DIR%
if not exist %OUTPUT_DIR% mkdir %OUTPUT_DIR%

cd %BUILD_DIR%

cmake .. -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 goto :error

mingw32-make -j%NUMBER_OF_PROCESSORS%
if errorlevel 1 goto :error

cd ..
echo.
echo Build succeeded. Executable: %OUTPUT_DIR%\gred.exe
goto :end

:error
cd ..
echo.
echo Build FAILED.
exit /b 1

:end
endlocal
