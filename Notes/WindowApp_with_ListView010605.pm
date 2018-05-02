=head1 NAME

Loft::WindowApp -- The main application

=head1 SYNOPSIS

Oh, man...

=cut





package Loft::WindowApp;
@ISA = qw( Win32::GUI::AppWindow Loft::View );
use Win32::GUI::AppWindow;
use Loft::View;





use strict;
use Carp qw(cluck);
use Data::Dumper;
use Pod::Text;
use File::Basename;
use Cwd;

use Win32::GUI;
use Win32;
use Win32::GUI::AdHoc;
use Win32::GUI::Resizer qw( negResize );
use Win32::GUI::Modalizer;

use Loft::WindowDesign;
use Loft::WindowProp;
use Loft::WindowTool;

use Loft::Design;
use Loft::Canvas;
use Loft::Control;
use Loft::Control::Window;
use Loft::Control::Button;





#This class is a singleton. This is that object.
my $gObjSingleton = undef;

#Some things like bitmaps and stuff _needs_ to be persistent
#outside of their scope.
my %ghPerm;





#The program dir
my $pathBase = dirname($0);
$pathBase = cwd() if($pathBase eq ".");
$pathBase =~ s{/}{\\}g;





#Block GUI warnings
Win32::GUI::AdHoc::blockGUIWarnings();





=head1 PROPERTIES

=head2 winMain

The main window object

=cut
sub winMain { my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{winMain} = $val;
		}

	return($self->{winMain});
	}





=head2 mnuMain

The menu for the main window

=cut
sub mnuMain { my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{mnuMain} = $val;
		}

	return($self->{mnuMain});
	}





=head2 objResizerMain

The Win32::GUI::Resizer object used to resize the controls
in the winMain window.

=cut
sub objResizerMain { my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objResizerMain} = $val;
		}

	return($self->{objResizerMain});
	}





=head2 objModalizer

The Win32::GUI::Modalizer object used to make dialogs modal.

=cut
sub objModalizer { my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objModalizer} = $val;
		}

	return($self->{objModalizer});
	}





=head2 objWindowProp

The Properties window object (not the design
Win32::GUI::Window object).

=cut
sub objWindowProp { my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objWindowProp} = $val;
		}

	return($self->{objWindowProp});
	}





=head2 objWindowDesign

The Design window object (not the design Win32::GUI::Window
object).

=cut
sub objWindowDesign { my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objWindowDesign} = $val;
		}

	return($self->{objWindowDesign});
	}





=head2 objWindowTool

The Toolbox window object (not the design Win32::GUI::Window
object).

=cut
sub objWindowTool { my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objWindowTool} = $val;
		}

	return($self->{objWindowTool});
	}





=head2 objCanvas

The Loft::Canvas that is the current state of the objDesign()

Set to 0 to undef

=cut
sub objCanvas { my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objCanvas} = $val;
		$self->{objCanvas} = undef if($val == 0);
		}

	return($self->{objCanvas});
	}





=head2 objDesign

The Loft::Design object that is the current design, or undef
if no such thing exists.

Set to 0 to undef

=cut
sub objDesign { my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objDesign} = $val;
		$self->{objDesign} = undef if($val == 0);
		}

	return($self->{objDesign});
	}





=head1 METHODS

=head2 new()

Create new UI for Windows.

=cut
sub new { my $pkg = shift; $pkg = ref($pkg) || $pkg;
	defined($gObjSingleton) and return($gObjSingleton);

	my $self = $gObjSingleton = $pkg->SUPER::new();

	$self->winMain(undef);
	$self->mnuMain(undef);

	$self->objWindowDesign( Loft::WindowDesign->new() );
	$self->objWindowProp( Loft::WindowProp->new() );
	$self->objWindowTool( Loft::WindowTool->new() );


	return($self);
	}





=head2 init()

Init application, info, windows etc.

Return 1 on succes, else 0.

=cut
sub init { my $self = shift; my $pkg = ref($self);


	###Build GUI

	#The main window
	my $mnuMain = Win32::GUI::MakeMenu(
			"&File"   					=> "mnuFile",
			" > &New"					=> "mnuFileNew",
			" > &Open..."				=> "mnuFileOpen",
			" > &Save"					=> "mnuFileSave",
			" > Save &as..."			=> "mnuFileSaveAs",
		    " > -"						=>  0,
			" > E&xit"					=> "mnuFileExit",

			"&Design"   				=> "mnuDesign",
			" > &Test window"			=> "mnuDesignTest",

			"&Help"   					=> "mnuHelp",
			" > &Topics"				=> "mnuHelpTopics",
		    " > -"						=>  0,
			" > &About..."				=> "mnuHelpAbout",
			);

	$self->mnuMain($mnuMain);


	my $winMain = new Win32::GUI::Window(
	      -left   => 0,
	      -top    => 100,
	      -width  => 200,
	      -height => 500,
	      -name   => "winMain",
	      -text   => "The GUI Loft",
	      -menu   => $mnuMain,
	      );
	$winMain->{-dialogui} = 1;

	$self->winMain($winMain);
	my ($width, $height) = ($winMain->GetClientRect)[2..3];


	#Modalizer
	$self->objModalizer(Win32::GUI::Modalizer->new($winMain));
#	$self->objWindowDesign()->objModalizer( $self->objModalizer() );


	#Change the window icon
##todo: fix icon
	my $icoWin = Win32::GUI::Icon->new($self->rhConfig()->{fileIconMain});
	$winMain->ChangeIcon($icoWin);
	$winMain->ChangeSmallIcon($icoWin);

#	my $hw = 16;
#	my $pathIcon = $self->rhConfig()->{dirIcon};
#	my $ilIcon = new Win32::GUI::ImageList($hw, $hw, 0, @gaBitmap + 1, @gaBitmap + 1);
#	for my $icon (@gaBitmap) {
#		my $fileIcon =  "$pathIcon\\$icon";
#		$ilIcon->Add(new Win32::GUI::Bitmap($fileIcon), 0);
#		}


	my $wb = 20;
	my $hb = 20;
	my $x = 0;
	my $y = 0;
	$winMain->AddButton(
	       -text    => "&Up",
	       -name    => "btnUp",
	       -left    => $x,
	       -top     => $y,
	       -width   => $wb,
	       -height  => $hb,
	      );
	$x += $wb;

	$winMain->AddButton(
	       -text    => "&Dn",
	       -name    => "btnDown",
	       -left    => $x,
	       -top     => $y,
	       -width   => $wb,
	       -height  => $hb,
	      );
	$x += $wb;
	$y += $hb;

=pod
	my $lbControl = $winMain->AddListbox(
			-name      => "lbControl",
			-text      => "",
			-left      => 0,
			-top       => $y,
			-width     => $width,
			-height    => $height,
			-style     =>
					WS_CHILD |
					WS_VISIBLE |
					1,
			-multisel  => 1,
			);
=cut

	my $lvwControl = $winMain->AddListView(
			-name      => "lvwControl",
			-text      => "",
			-left      => 0,
			-top       => $y,
			-width     => $width,
			-height    => $height - $y,
			-style     =>
					WS_CHILD |
					WS_VISIBLE |
					1,
			-fullrowselect => 1,
			-gridlines => 1,
			);

	$lvwControl->InsertColumn(
			-index => 0,
			-width => $width / 2,
			-text  => "Control",
			);
	$lvwControl->InsertColumn(
			-index => 1,
			-width => $width / 2,
			-text  => "Type",
			);


	##The dialog is done, now arrange it.
	my $objResizer = Win32::GUI::Resizer->new($winMain);
	$self->objResizerMain($objResizer);
	$objResizer->raRelations([
			'winWidth' => [
					['$winResize->lvwControl->Width()'],
					],
			'winHeight' => [
					['$winResize->lvwControl->Height()'],
					],
			]);
	$objResizer->memorize();


	##Resize to the saved position
	my $rhWindowConfig = $self->rhWindowConfig();
	$winMain->Left( $self->default($rhWindowConfig->{posMainLeft}, 100) );
	$winMain->Top( $self->default($rhWindowConfig->{posMainTop}, 100) );
	$winMain->Width( $self->default($rhWindowConfig->{posMainWidth} ,620) );
	$winMain->Height( $self->default($rhWindowConfig->{posMainHeight} ,400) );


	##Tadaaa!
	$self->setWindowState();
	$winMain->Show();


	##The Design window
	$self->objWindowDesign()->rhConfig( $self->rhConfig() );
	$self->objWindowDesign->init($winMain);


	##The Properties window
	$self->objWindowProp()->rhConfig( $self->rhConfig() );
	$self->objWindowProp()->objWindowDesign($self->objWindowDesign());
	$self->objWindowProp->init($winMain);

	$self->objWindowProp()->winProp()->Left( $self->default($rhWindowConfig->{posPropLeft}, 600) );
	$self->objWindowProp()->winProp()->Top( $self->default($rhWindowConfig->{posPropTop}, 50) );
	$self->objWindowProp()->winProp()->Width( $self->default($rhWindowConfig->{posPropWidth} ,250) );
	$self->objWindowProp()->winProp()->Height( $self->default($rhWindowConfig->{posPropHeight} ,400) );

	##The Toolbox window
	$self->objWindowTool()->rhConfig( $self->rhConfig() );
	$self->objWindowTool->init($winMain);


	$self->canvasClose();

	$winMain->SetForegroundWindow();

	$self->objWindowProp()->winProp()->Show();
	$self->objWindowTool()->winTool()->Show();

	return(1);
	}





=head2 run()

Run the UI.

Return 1 on success, else 0.

=cut
sub run { my $self = shift; my $pkg = ref($self);

	Win32::GUI::Dialog();

	return(1);
	}





=head2 shutdown()

Shutdown application, close stuff, save etc.

Return 1 on succes, else 0.

=cut
sub shutdown { my $self = shift; my $pkg = ref($self);

	$self->configWindowSave(
			$self->winMain->Left(),
			$self->winMain->Top(),
			$self->winMain->Width(),
			$self->winMain->Height(),
			$self->objWindowProp()->winProp->Left(),
			$self->objWindowProp()->winProp->Top(),
			$self->objWindowProp()->winProp->Width(),
			$self->objWindowProp()->winProp->Height(),
			);

	$self->configSave();

	$self->isClosed(1);

	return(1);
	}





=head2 configLoad($fileConfig)

Load the config from file $fileConfig, and from the files
defined in that config file.

Return 1 on success, else die().

=cut
sub configLoad { my $self = shift; my $pkg = ref($self);
	my ($fileConfig) = @_;

	$self->fileConfig($fileConfig);

	$self->rhConfig($self->loadXMLFile($fileConfig));

	$self->rhWindowConfig($self->loadXMLFile( $self->rhConfig()->{fileWindow} ) ) if(-r $self->rhConfig()->{fileWindow});

	return(1);
	}





=head2 configSave()

Save the rhConfig.

Return 1 on success, else 0.

=cut
sub configSave { my $self = shift; my $pkg = ref($self);
	return($self->saveXMLFile($self->fileConfig(), $self->rhConfig()));
	}





=head2 configWindowSave($mainLeft, $mainTop, $mainWidth, $mainHeight, $propLeft, $propTop, $propWidth, $propHeight)

Save the window state config file

Return 1 on success, else 0.

=cut
sub configWindowSave { my $self = shift; my $pkg = ref($self);
	my ($mainLeft, $mainTop, $mainWidth, $mainHeight, $propLeft,
			$propTop, $propWidth, $propHeight) = @_;

	$self->rhWindowConfig()->{posMainLeft} = $mainLeft;
	$self->rhWindowConfig()->{posMainTop} = $mainTop;
	$self->rhWindowConfig()->{posMainWidth} = $mainWidth;
	$self->rhWindowConfig()->{posMainHeight} = $mainHeight;
	$self->rhWindowConfig()->{posPropLeft} = $propLeft;
	$self->rhWindowConfig()->{posPropTop} = $propTop;
	$self->rhWindowConfig()->{posPropWidth} = $propWidth;
	$self->rhWindowConfig()->{posPropHeight} = $propHeight;

	$self->saveXMLFile($self->rhConfig()->{fileWindow}, $self->rhWindowConfig());

	return(1);
	}





=head2 setWindowState()

Set the state of controls so that they match the state of
the application.

Return 1.

=cut
sub setWindowState { my $self = shift; my $pkg = ref($self);

	my $winMain = $self->winMain();
	my $mnuMain = $self->mnuMain();

#...

	return(1);
	}





=head2 canvasNew([Loft::Design $objNew])

Reset current design and create a new one. If $objNew is
passed, use that one as the new design.

Return 1 on success, else 0.

=cut
sub canvasNew { my $self = shift; my $pkg = ref($self);
	my ($objNew) = @_;
	defined($objNew) or ($objNew = Loft::Design->new()) or return(0);


	#Create new canvas, maybe using the existing design
	$self->objDesign($objNew);
	$self->objCanvas( Loft::Canvas->new() );
	$self->objCanvas()->objDesign($objNew);
	$self->objCanvas()->raView( [
			$self->objWindowDesign(),
			$self->objWindowProp(),
			$self,
			] );


	$self->objWindowDesign()->objDesign($objNew);
	$self->objWindowDesign()->objCanvas( $self->objCanvas() );
	$self->objWindowDesign()->canvasNew();

	$self->objWindowProp()->objCanvas( $self->objCanvas() );
	$self->objWindowProp()->objDesign( $self->objDesign() );

	$self->objWindowTool()->objCanvas( $self->objCanvas() );
	$self->objWindowTool()->objDesign( $self->objDesign() );
	$self->objWindowTool()->objWindowDesign( $self->objWindowDesign() );


	#Display design window
	$self->objWindowDesign()->winDesign()->Show();



	return(1);
	}





=head2 canvasClose()

Close the current design and reset the state of the app.
Make sure the user gets the opportunity to save if need be.

Return 1 on success, else 0.

=cut
sub canvasClose { my $self = shift; my $pkg = ref($self);

	if($self->objDesign() && $self->objDesign()->isDirty()) {
		my $fileName = basename($self->objDesign()->fileName()) || "current design";
		my $ret = Win32::MsgBox(
				"Save changes to $fileName?",
				MB_YESNOCANCEL | MB_ICONQUESTION | MB_DEFBUTTON1 | MB_APPLMODAL,
				"Perl GUI Loft");
		return(0) if($ret == 2);				#IDCANCEL
		::mnuFileSave_Click() if($ret == 6);	#IDYES
		}

	$self->objWindowDesign()->winDesign()->Hide();
	$self->objDesign(0);

	return(1);
	}





=head2 propNotifyChange($rhControl, $raPropName)

Update the properties in $raPropName for the controls in
$rhControl.

Return 1 on success, else 0.

=cut
sub propNotifyChange { my $self = shift; my $pkg = ref($self);
	my ($rhControl, $raPropName) = @_;

	for my $prop (@{$raPropName}) {
		$self->controlPopulate() if($prop eq "Name");
		}

	return(1);
	}





=head2 propNotifyFundamental()

The number of controls has changed.

Return 1 on success, else 0.

=cut
sub propNotifyFundamental { my $self = shift; my $pkg = ref($self);
	my ($rhControl, $raPropName) = @_;

	$self->controlPopulate();

	return(1);
	}





=head2 propNotifySelected($rhControl)

The number of conrols that are selected has changed.

Return 1 on success, else 0.

=cut
sub propNotifySelected { my $self = shift; my $pkg = ref($self);
	my ($rhControl) = @_;

	$self->controlSelect( $rhControl );

	return(1);
	}





=head2 controlPopulate()

Fill the list with the available controls.

Return 1 on success, else 0.

=cut
sub controlPopulate { my $self = shift; my $pkg = ref($self);

	$self->winMain()->lvwControl()->Clear();

	$self->winMain()->lvwControl()->InsertItem( 
			-text => [ $self->objDesign()->objControlWindow()->prop("Name") , "Window" ] 
			);

	for my $objControl (@{$self->objDesign()->raControl()}) {
		$self->winMain()->lvwControl()->InsertItem( 
				-text => [ $objControl->prop("Name"), $objControl->type() ] );
		}

	$self->controlSelect();

	return(1);
	}





=head2 controlSelect()

Sync the ListBox with the selected controls.

Return 1 on success, else 0.

=cut
sub controlSelect { my $self = shift; my $pkg = ref($self);

	my $check = ( keys %{$self->objCanvas()->rhControlSelected()}  ) ? 0 : 1;
#	$self->winMain()->lbControl()->SendMessage(0x0185, $check, 0);				#LB_SETSEL
	$self->winMain()->lvwControl()->Select(0);	#, $check);

	my $i = 1;
	for my $objControl (@{$self->objDesign()->raControl()}) {
#		$self->winMain()->lbControl()->SendMessage(0x0185,
#				$objControl->designIsSelected(), $i);				#LB_SETSEL
		$self->winMain()->lvwControl()->Select($1);	#, $objControl->designIsSelected());	
		$i++;
		}

	return(1);
	}





=head2 controlSetSelection()

Impose the state of the List Box on the model by selecting
the correct controls.

Return 1 on success, else 0.

=cut
sub controlSetSelection { my $self = shift; my $pkg = ref($self);

	#First, deselect the window if any other controls are selected
#	my @aSelected = $self->winMain()->lbControl()->SelectedItems();
	my @aSelected = $self->winMain()->lvwControl()->SelectedItems();

	my %hSelected = map { $_ => 1 } @aSelected;
	my $i = 1;
	for my $objControl (@{$self->objDesign()->raControl()}) {
		my $check = exists $hSelected{$i} ? 1 : 0;
		$self->objCanvas()->controlSelected($objControl, $check);

		$i++;
		}

	$self->controlSelect();
	$self->objCanvas()->propNotifySelected($self);

	return(1);
	}





=head2 controlMove($dir)

Move the selected controls in the $dir (0: down, 1: up). 

Don't do anything with the window control, and don't move 
above the window control since it is the main container.

Return 1 on success, else 0.

=cut
sub controlMove { my $self = shift; my $pkg = ref($self);
	my ($dir) = @_;

	my @aSelected = map { $_ - 1 } $self->winMain()->lvwControl()->SelectedItems();	
	return(0) if(@aSelected && -1 == $aSelected[0]);

	$self->objDesign()->controlRearrange($dir, \@aSelected);

	$self->objCanvas()->propNotifyFundamental();

	return(1);
	}





=head1 Win32::GUI EVENTS

=head2 winMain_Terminate()

Terminate the main window

=cut
sub ::winMain_Terminate {

	$gObjSingleton->shutdown();

	return(-1);
	}





=head2 winMain_Resize()

Resize the main window.

=cut
sub ::winMain_Resize { my $self = Loft::WindowApp->new();
	defined($self->objResizerMain()) and $self->objResizerMain()->resize();
	}





=head2 lbControl_Click()

The selected state change, so reflect that.

=cut
sub ::lbControl_Click { my $self = Loft::WindowApp->new();

	$self->controlSetSelection();

	return(1);
	}





=head2 btnUp_Click()

Move selected controls up one step

=cut
sub ::btnUp_Click { my $self = Loft::WindowApp->new();

	$self->controlMove(1);

	return(1);
	}





=head2 btnDown_Click()

Move selected controls down one step

=cut
sub ::btnDown_Click { my $self = Loft::WindowApp->new();

	$self->controlMove(0);

	return(1);
	}





=head2 mnuFileNew_Click()

Exit the app.

=cut
sub ::mnuFileNew_Click { my $self = Loft::WindowApp->new();

	$self->canvasClose() or return(1);
	$self->canvasNew();

	return(1);
	}





=head2 mnuFileOpen_Click()

Open new design and replace the existing one.

=cut
sub ::mnuFileOpen_Click { my $self = Loft::WindowApp->new();

	my $dir = ($self->objDesign() and dirname($self->objDesign()->fileName())
			or "");
	my $fileRet = GUI::GetOpenFileName(
			-owner => $self->winMain(),
			-title  => "Open",
			-directory => $dir,
			-filter => [
			        "GUI Loft Design files (*.gld)" => "*.gld",
			        "All files (*.*)", "*.*",
	    			],
			);

	return(1) if(!$fileRet);

	$self->canvasClose() or return(1);

	my $objNew = Loft::Design->newLoad($fileRet);
	if(!$objNew) {
		$self->errorReport("Could not open Design");
		return(1);
		}

	$self->canvasNew($objNew);

	return(1);
	}





=head2 mnuFileSave_Click()

Save the current design.

=cut
sub ::mnuFileSave_Click { my $self = Loft::WindowApp->new();
	return(1) if(!$self->objDesign());

	my $fileName = $self->objDesign()->fileName() || "";

	if(!$fileName) {
		return(::mnuFileSaveAs_Click());
		}

	$self->objDesign()->fileSave($fileName) or $self->errorReport("Could not save Design");

	return(1);
	}





=head2 mnuFileSaveAs_Click()

Save the current design.

=cut
sub ::mnuFileSaveAs_Click { my $self = Loft::WindowApp->new();
	return(1) if(!$self->objDesign());

	my $fileRet = GUI::GetSaveFileName(
			-title  => "Save As...",
#			-file   => "\0" . " " x 256,
			-filter => [
			        "GUI Loft Design files (*.gld)" => "*.gld",
			        "All files (*.*)", "*.*",
	    			],
			);

	return(1) if(!$fileRet);
	$fileRet .= ".gld" if($fileRet !~ /\./);

	$self->objDesign()->fileName($fileRet);

	::mnuFileSave_Click();

	return(1);
	}





=head2 mnuFileExit_Click()

Exit the app.

=cut
sub ::mnuFileExit_Click {

	$gObjSingleton->shutdown();

	return(-1);
	}





=head2 mnuDesignTest_Click()

Test the window

=cut
sub ::mnuDesignTest_Click { my $self = Loft::WindowApp->new();

	my $winTest = $self->objDesign()->winWindowBuild();
	$winTest->Show();

	return(1);
	}





1;





#EOF