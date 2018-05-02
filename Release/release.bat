@echo off
echo Create Release of The GUI Loft
echo.


echo Remove old archives...
del *.zip

echo Create HTML from POD
call pod2html ..\..\Loft\lib\resource\manual.pod >..\..\Loft\lib\resource\manual.html
call pod2html ..\..\Loft\lib\resource\reference.pod >..\..\Loft\lib\resource\reference.html
call pod2html ..\..\Loft\lib\resource\changes.pod >..\..\Loft\lib\resource\changes.html

del *.?~*



echo Create PPM distro for the runtime...
cd ..\PPM\AdHoc
del /Q .\PPM\*.tar.gz
perl build_ppm.pl
cd ..\..\Release

cd ..\PPM\Loft
del /Q .\PPM\*.tar.gz
perl build_ppm.pl
cd ..\..\Release



echo Remove dynamic files...


echo Create ZIP archive of source...
cd ..\..
c:\appl\util\winzip\wzzip -a -r -P Loft\Release\Loft_source.zip Loft
cd Loft\Release


echo Create Perl Application (standalone GUI)...
cd ..\lib
rem perlapp.pl -script=Loft.pl -freestanding
call perlapp -script=tgl.pl -freestanding -gui


echo Collect Binary distribution...
mkdir ..\TheGUILoft
copy ..\readme.txt ..\TheGUILoft\
move /Y tgl.exe ..\TheGUILoft\tgl.exe
xcopy /E resource ..\TheGUILoft\resource\
rem xcopy /E Win32 ..\TheGUILoft\Win32\
xcopy /E ..\Demo ..\TheGUILoft\Demo\
xcopy /E ..\PPM\AdHoc\PPM ..\TheGUILoft\PPM\AdHoc\
xcopy /E ..\PPM\Loft\PPM ..\TheGUILoft\PPM\Loft\


echo Create ZIP archive...
cd ..\
c:\appl\util\winzip\wzzip -a -r -P Loft_binary.zip TheGUILoft


echo Clean up Binary collection...
del /S /Q TheGUILoft\
rmdir /S /Q TheGUILoft

echo Moving the ZIP to the Release dir...
move /Y Loft_binary.zip Release\

cd Release\


:end
