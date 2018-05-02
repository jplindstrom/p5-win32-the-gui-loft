#!/usr/local/bin/perl -w

use strict;
#use Date::Format;
#my $now = time2str("%Y-%m-%e", time);

use lib ("lib");
use Win32::GUI::AdHoc;
my $ver = $Win32::GUI::AdHoc::VERSION;
my $name = "Win32-GUI-AdHoc-$ver-PPM";
my $filePPD = "Win32-GUI-AdHoc.ppd";


print "\n\n*** Clean up before make";
system("rmdir /S /Q blib");
system("del pm_to_blib");


print "\n\n*** Make\n";
system("nmake") and die();


print "\n\n*** Cleaning up old tar & gzip files\n";
unlink "$name.tar";
unlink "$name.tar.gz";


print "\n\n*** tar & gzip\n";
system("tar cvf $name.tar blib") and die();
system("gzip --best $name.tar") and die();


print "\n\n*** Create PPD\n";
system("nmake ppd") and die();


print "\n\n*** Adapt PPD file\n";
my $text;
{
local $/; my $fh; open($fh, $filePPD) or die();
$text = <$fh>; close($fh);
}
$text =~ s/CODEBASE HREF=""/CODEBASE HREF="$name.tar.gz"/s;
{
my $fh; open($fh, ">$filePPD") or die();
print $fh $text; close($fh);
}


print "\n\n*** Move to PPM dir";
system("move /Y $name.tar.gz PPM") and die();
system("move /Y $filePPD PPM") and die();


print "\n\n*** Clean up";
system("rmdir /S /Q blib");
system("del pm_to_blib");



print "\n\n*** Install PPM\n";
chdir("PPM") or die();
system("call install.bat") and die();
chdir("..") or die();



print "\n\n*** DONE!";

