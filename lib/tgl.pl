#!/usr/local/bin/perl -w
use Debug::WarnCallStack;





#The directory this program is running from.
use File::Basename;
my $pathBase;

BEGIN {
	unshift(@INC, ".");

	$pathBase = dirname($0);
	unshift(@INC, $pathBase);
	}


use strict;
use Carp qw( cluck );
#use Diagnostics;	#Does't work with PerlApp without the perldiag.pod file

use Getopt::Long;
use Pod::Usage;
use File::Path;

#Force load for XML::Simple/PerlApp's sake
use XML::Parser;
use File::Spec;
use XML::Simple;

use Win32::GUI;

use Data::Dumper;

use TGL::WindowApp;





$pathBase = dirname($0);


#The resource dir
my $pathResource = "$pathBase/resource";

#The config file
my $fileConfig = "$pathResource/loft.xml";





##todo: Decomment on release
#eval {
	main();
#	};
#Win32::GUI::MessageBox(0, "Error: $@", "Perl loft") if($@);





sub main {
	my $help;

	##Command line options
	GetOptions(
			"h" => \$help,
			"config:s" => \$fileConfig,
			);
	my $fileOpen = $ARGV[0] || "";
	

	my $objApp = TGL::WindowApp->new();

	#Syntax help?
	$objApp->usage() if $help;


	##Config
	#Read config files or die
	eval {
		$objApp->configLoad($fileConfig);
		};
	die($@) if($@);

	#Init stuff
	$objApp->init();

	#Create new canvas and setup the other windows
	$objApp->canvasNew();
	
	#Open file, possibly
	if($fileOpen ne "") {
		if(!$objApp->openFile($fileOpen)) {
			$objApp->canvasNew();
			$objApp->errorReport("Could not open Design ($fileOpen)");
			}
		}

	$objApp->run();
	}





#EOF