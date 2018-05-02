#!/usr/local/bin/perl -w
=head1 Name

List files and display them.

=cut





use strict;





use Win32::GUI;
use Win32;
use Win32::GUI::Loft;
use Win32::GUI::Resizer;

use Data::Dumper;

use Cwd;






eval {
	main();
	};
Win32::GUI::MessageBox(0, "Error: $@", "Fetch URL Demo") if($@);





sub main {

	my $fileWindow = "filedisplay.gld";
	my $objDesign = Win32::GUI::Loft::Design->newLoad($fileWindow) or
			die("Could not open window file ($fileWindow)");

	#Create a menu and assign it to the design object before
	#building the window.
	$objDesign->mnuMenu( Win32::GUI::MakeMenu(
			"&File"   					=> "mnuFile",
			" > E&xit"					=> "mnuFileExit",
			) );

	my $win = $objDesign->buildWindow() or die("Could not build window ($fileWindow)");

	#This is the same object as $objDesign. It was placed in the
	#Win32::GUI:Loft::design hash by the buildWindow() method.
	my $design = $Win32::GUI::Loft::design{winFileDisplay};


	#The window contains a Splitter control, so the resize has to be 
	#manually coded. So we replace the already-built Win32::GUI::Resizer
	#object with our own.
	my $objResizer = Win32::GUI::Resizer->new($win);
	$design->objResizer($objResizer);
	
	#The Splitter is called splMiddle. Remember it's position and define
	#the relations between the controls and the window.
	$objResizer->specialValue("splMiddle", $win->splMiddle()->Left, 0);
	$objResizer->raRelations([
		'winWidth' => [
			['$winResize->reFileSelected()->Width()'],
			['$winResize->btnExit()->Left()'],
			['$winResize->sbStatus()->Width()'],
			],
		'winHeight' => [
			['$winResize->lbFile()->Height()'],
			['$winResize->reFileSelected()->Height()'],
			['$winResize->btnOpen()->Top()'],
			['$winResize->btnExit()->Top()'],
			['$winResize->splMiddle()->Height()'],
			['$winResize->sbStatus()->Top()'],
			],
		'splMiddle' => [
			['$winResize->lbFile()->Width()'],
			['$winResize->reFileSelected()->Width()', \&Win32::GUI::Resizer::negResize],
			['$winResize->reFileSelected()->Left()'],
			['$winResize->btnOpen()->Width()'],
			],

		]);
	$objResizer->memorize();
	
	
	#Init
	listboxPopulate($win->lbFile, $win->sbStatus);
	

	#We're ready to go!
	$win->Show();
	Win32::GUI::Dialog();


	return(1);
	}





=head1 WIN32::GUI EVENT HANDLERS

=head2 winFileDisplay_Terminate()

Terminate app.

=cut
#Note that we use :: to place the sub in package main,
#just in case you are in another package.

#Note how we verify that the window is actually there
#while assigning the shortcut variable $win.
sub ::winFileDisplay_Terminate { defined(my $win = $Win32::GUI::Loft::window{winFileDisplay}) or return(1);

	#Just exit

	return(-1);
	}





=head2 btnExit_Click()

Terminate app.

=cut
sub ::btnExit_Click { defined(my $win = $Win32::GUI::Loft::window{winFileDisplay}) or return(1);

	#Just exit

	return(-1);
	}





=head2 btnOpen_Click()

Display the selected file, or go to the selected dir.

=cut
sub ::btnOpen_Click { defined(my $win = $Win32::GUI::Loft::window{winFileDisplay}) or return(1);

	my $file = $win->lbFile()->GetString( $win->lbFile()->SelectedItem() ) or return(1);
	
	if(-d $file) {
		#It's a dir		
		chdir($file);
		listboxPopulate($win->lbFile, $win->sbStatus);
		}
	else {
		#It's a file
		fileDisplay($win->reFileSelected(), $file);
		}

	return(1);
	}





=head2 lbFile_DblClick()

Display the selected file, or go to the selected dir.

=cut
sub ::lbFile_DblClick {
	return( ::btnOpen_Click() );
	}





=head2 splMiddle_Release()

Move the middle splitter.

=cut
sub ::splMiddle_Release {
	my ($left) = @_;

	defined(my $win = $Win32::GUI::Loft::window{winFileDisplay}) or return(1);
	my $design = $Win32::GUI::Loft::design{winFileDisplay};

	$design->objResizer()->specialValue("splMiddle", $left);

	#A bug in the splitter will leave pixel debris in this
	#control, so force Windows to repaint it.
	Win32::GUI::InvalidateRect($win->reFileSelected(), 1);

	return(1);
	}





=head2 mnuFileExit_Click()

Terminate app.

=cut
sub ::mnuFileExit_Click { defined(my $win = $Win32::GUI::Loft::window{winFileDisplay}) or return(1);

	#Just exit

	return(-1);
	}





=head1 APPLICATION ROUTINES

Note how none of the routines directly reference the window 
controls.


=head2 listboxPopulate($lbListbox, $sbStatus)

Populate the $lbListbox with the file names of the files in 
the cwd. Set the Text() of $sbStatus to the cwd.

Return 1 on success, else 0.

=cut
sub listboxPopulate {
	my ($lbListbox, $sbStatus) = @_;

	my $fh;
	my @aFile;
	my @aDir;
	opendir($fh, ".") or return(0);
	while(my $file = readdir($fh)) {
		push(@aFile, $file) if(-r $file && ! -d $file);
		push(@aDir, $file) if(-r $file && -d $file);
		}
	closedir($fh) or warn("Could not close dir");
	
	
	$lbListbox->Clear();		
	for my $file (@aDir) {
		$lbListbox->AddString($file);
		}
	for my $file (@aFile) {
		$lbListbox->AddString($file);
		}
		
		
	#The status bar
	my $wd = cwd();
	$wd =~ s{/}{\\}gs;
	$sbStatus->Text( $wd );

	return(1);
	}





=head2 fileDisplay($reEdit, $file)

Display the contents of $file in $reEdit.

Return 1 on success, else 0.

=cut
sub fileDisplay {
	my ($reEdit, $file) = @_;

#	my $fh;
#	my $text = "";
#	open($fh, "<$file") or return(0);
#	{ local $/; $text = <$fh>; }
#	close($fh);
	
#	$reEdit->Text($text);
	$reEdit->Load($file, 1);
	
	return(1);
	}





#EOF