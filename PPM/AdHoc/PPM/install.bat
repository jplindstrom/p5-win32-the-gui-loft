@echo off
echo This will remove and install the current PPM file Win32::GUI::AdHoc
call ppm remove Win32::GUI::AdHoc
call ppm install -location=. Win32::GUI::AdHoc
