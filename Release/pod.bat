@echo off
echo Create Release of The GUI Loft
echo.

echo Create HTML from POD
call pod2html ..\..\Loft\lib\resource\manual.pod >..\..\Loft\lib\resource\manual.html
call pod2html ..\..\Loft\lib\resource\reference.pod >..\..\Loft\lib\resource\reference.html
call pod2html ..\..\Loft\lib\resource\changes.pod >..\..\Loft\lib\resource\changes.html
call pod2html ..\..\Loft\lib\resource\dev.pod >..\..\Loft\lib\resource\dev.html
call pod2html ..\..\Loft\lib\resource\faq.pod >..\..\Loft\lib\resource\faq.html

del *.?~*

