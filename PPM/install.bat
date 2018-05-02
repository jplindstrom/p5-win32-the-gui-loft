@echo off
echo This will remove and install the current PPM files
echo   Win32::GUI::AdHoc
echo   Win32::GUI::Loft
pause
cd AdHoc\PPM
call ppm remove Win32::GUI::AdHoc
call ppm install -location=. Win32::GUI::AdHoc
cd ..\..

cd Loft\PPM
call ppm remove Win32::GUI::Loft
call ppm install -location=. Win32::GUI::Loft
cd ..\..

