=head1 NAME

TGL::WindowDesign -- The Design window

=head1 SYNOPSIS

Oh, man...

=cut





package TGL::WindowDesign;
@ISA = qw( Win32::GUI::AppWindow Win32::GUI::Loft::View );
use Win32::GUI::AppWindow;
use Win32::GUI::Loft::View;





use strict;
use Carp qw(cluck);
use Data::Dumper;

use Win32::GUI;
use Win32;
use Win32::GUI::AdHoc;
use Win32::GUI::Resizer qw( negResize );
use Win32::GUI::DragDrop;

use Win32::GUI::Loft::Canvas;
use Win32::GUI::Loft::Control;
use Win32::GUI::Loft::Control::Window;
use Win32::GUI::Loft::Control::Button;





#This class is a singleton. This is that object.
my $gObjSingleton = undef;

#Some things like bitmaps and stuff _needs_ to be persistent
#outside of their scope.
my %ghPerm;





#Block GUI warnings
Win32::GUI::AdHoc::blockGUIWarnings();





=head1 PROPERTIES

=head2 winDesign

The design window object

=cut
sub winDesign {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{winDesign} = $val;
		}

	return($self->{winDesign});
	}





=head2 objWindowProp

The properties window object.

=cut
sub objWindowProp {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objWindowProp} = $val;
		}

	return($self->{objWindowProp});
	}





=head2 objWindowApp

The main window object

=cut
sub objWindowApp {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objWindowApp} = $val;
		}

	return($self->{objWindowApp});
	}





=head2 objResizerDesign

The Win32::GUI::Resizer object used to resize the controls
in the winMain window.

=cut
sub objResizerDesign {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objResizerDesign} = $val;
		}

	return($self->{objResizerDesign});
	}





=head2 objDesign

The Win32::GUI::Loft::Design object that is the current design, or undef
if no such thing exists.

Set to 0 to undef

=cut
sub objDesign {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objDesign} = $val;
		$self->{objDesign} = undef if($val == 0);
		}

	return($self->{objDesign});
	}





=head2 objCanvas

The Win32::GUI::Loft::Canvas object that is current state of the
objDesign().

=cut
sub objCanvas {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objCanvas} = $val;
		}

	return($self->{objCanvas});
	}





=head2 hwindMain

The window handle of the main window (the App window).

=cut
sub hwindMain {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{hwindMain} = $val;
		}

	return($self->{hwindMain});
	}





=head2 mouseIsDragging

Whether the mouse is in drag mode, i.e. it depressed on a
control, moved, and still hasn't released.

=cut
sub mouseIsDragging {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{mouseIsDragging} = $val;
		}

	return($self->{mouseIsDragging});
	}





=head2 mouseIsSelectBox

Whether the mouse is in select box mode, i.e. it depressed
outside of a control, moved, and still hasn't released.

=cut
sub mouseIsSelectBox {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{mouseIsSelectBox} = $val;
		}

	return($self->{mouseIsSelectBox});
	}





=head2 mouseResizeCorner

The corner index of the resize, or -1 if the the mouse isn't
in resize mode, i.e. it depressed inside a corner marker,
and still hasn't released.

	-1: No (default)
	 0: Bottom right
	 1: Bottom left
	 2: Top left
	 3: Top right

=cut
sub mouseResizeCorner {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{mouseResizeCorner} = $val if($val >= -1 && $val <= 3);
		}

	return($self->{mouseResizeCorner});
	}





=head2 mouseDragDirection

The direction the mouse started moving during a drag
operation (either of an object, or of a click corner).

	0 - no direction/not set
	1 - Horizontal
	2 - Vertical

=cut
sub mouseDragDirection {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{mouseDragDirection} = $val if($val >= 0 || $val <= 2);
		}

	return($self->{mouseDragDirection});
	}





=head2 mouseIsDown

Whether the mouse button is down or not.

=cut
sub mouseIsDown {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{mouseIsDown} = $val;
		}

	return($self->{mouseIsDown});
	}





=head2 downShift

Whether the shift button is depressed.

=cut
sub downShift {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{downShift} = $val;
		}

	return($self->{downShift});
	}





=head2 downCtrl

Whether the ctrl key is depressed.

=cut
sub downCtrl {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{downCtrl} = $val;
		}

	return($self->{downCtrl});
	}





=head2 raMousePosDown

Two element array ref with the coordinate where the mouse
was depressed. Only valid if mouseIsDown().

=cut
sub raMousePosDown {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{raMousePosDown} = $val;
		}

	return($self->{raMousePosDown});
	}





=head2 raMousePosLast

Two element array ref with the coordinate where the mouse
was last clicked or moved. Only valid if mouseIsDown().

=cut
sub raMousePosLast {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{raMousePosLast} = $val;
		}

	return($self->{raMousePosLast});
	}





=head1 METHODS

=head2 new()

Create new UI for Windows.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;
	defined($gObjSingleton) and return($gObjSingleton);

	my $self = $gObjSingleton = $pkg->SUPER::new();

	$self->winDesign(undef);
	$self->objWindowProp(undef);
	$self->objWindowApp(undef);
	$self->objCanvas(undef);
	$self->hwindMain(0);

	$self->mouseIsDragging(0);
	$self->mouseIsSelectBox(0);
	$self->mouseResizeCorner(-1);
	$self->mouseIsDown(0);
	$self->mouseDragDirection(0);
	$self->raMousePosDown([0, 0]);
	$self->raMousePosLast([0, 0]);

	$self->downShift(0);
	$self->downCtrl(0);


	$self->{timKeyBlock} = 0; 		#Only used in timKey_Timer()

	return($self);
	}





=head2 init($winMain)

Init application, info, windows etc.

Return 1 on succes, else 0.

=cut
sub init {
    my $self = shift; my $pkg = ref($self);
	my ($winMain) = @_;


	###Build GUI

	#The main window
#	my $mnuMain = Win32::GUI::MakeMenu(
#			"&File"   					=> "mnuFile",
#			" > E&xit"					=> "mnuFileExit",
#
#			);
#
#	$self->mnuMain($mnuMain);


	my $w = 400;
	my $h = 250;
	my $winDesign = new Win32::GUI::Window(
		  -parent => $winMain,
	      -left   => 100,
	      -top    => 100,
	      -width  => $w,
	      -height => $h,
	      -name   => "winDesign",
	      -text   => "",
	      -minheight	=> 10,
	      -minwidth		=> 10,
#	      -menu   => $mnuMain,
	      );
	$self->winDesign($winDesign);

	my $grCanvas = Win32::GUI::Graphic->new($winDesign,
			-left   => 0,
			-top    => 0,
	        -width  => $w,
	        -height => $h,
			-name   => "grCanvas",
			-interactive => 1,
			);


	#Keyboard handler timer
	$winDesign->AddTimer("timKey", 1000/15);


	my $objResizer = Win32::GUI::Resizer->new($winDesign);
	$self->objResizerDesign($objResizer);
	$objResizer->raRelations([
			'winWidth' => [
					['$winResize->grCanvas->Width()'],
					],
			'winHeight' => [
					['$winResize->grCanvas->Height()'],
					],
			]);
	$objResizer->memorize();
	
	$winDesign->DragAcceptFiles(1);


	return(1);
	}





=head2 propPopulate($rhControl)

Populate the properties list view with the controls in
$rhControl.

Return 1 on success, else 0.

=cut
sub propPopulate {
    my $self = shift; my $pkg = ref($self);
	my ($rhControl) = @_;


	return(1);
	}





=head2 propNotifyChange($rhControl, $raPropName)

Update the properties in $raPropName for the controls in
$rhControl.

Return 1 on success, else 0.

=cut
sub propNotifyChange {
    my $self = shift; my $pkg = ref($self);
	my ($rhControl, $raPropName) = @_;

	my @aControls = values %{$rhControl};
	if($aControls[0] == $self->objDesign()->objControlWindow()) {
		#It's the window
		for my $prop (@{$raPropName}) {
			$self->objDesign()->objControlWindow()->propGuiSet(
					$prop,
					$self->winDesign(),
					$self->objDesign());
			}

		}
	else {
		$self->winDesign()->InvalidateRect(1);
		}

	return(1);
	}





=head2 propNotifySelected($rhControl)

The number of conrols that are selected has changed.

Return 1 on success, else 0.

=cut
sub propNotifySelected {
    my $self = shift; my $pkg = ref($self);
	my ($rhControl, $raPropName) = @_;

	$self->winDesign()->InvalidateRect(1);

	return(1);
	}





=head2 propNotifyFundamental()

The number of controls has changed.

Return 1 on success, else 0.

=cut
sub propNotifyFundamental { my $self = shift; my $pkg = ref($self);

	$self->winDesign()->InvalidateRect(1);

	return(1);
	}





=head2 clusterNotifyFundamental()

The number of clustered controls has changed for one or more
clusters.

Return 1 on success, else 0.

=cut
sub clusterNotifyFundamental { my $self = shift; my $pkg = ref($self);

	$self->winDesign()->InvalidateRect(1);

	return(1);
	}





=head2 setWindowState()

Set the state of controls so that they match the state of
the application.

Return 1.

=cut
sub setWindowState { my $self = shift; my $pkg = ref($self);


	return(1);
	}





=head2 canvasNew()

Prepare the window for a new Design.

Return 1 on success, else 0.

=cut
sub canvasNew { my $self = shift; my $pkg = ref($self);

	$self->winDesign()->Hide();

	#Set size
	#Store temp height since the first call will trigger resize, which will
	#save the existing (faulty) value.
	my $tempHeight = $self->objDesign()->objControlWindow()->prop("Height");
	$self->objDesign()->objControlWindow()->propGuiSet("Text", $self->winDesign(), $self->objDesign());
	$self->objDesign()->objControlWindow()->propGuiSet("Width", $self->winDesign(), $self->objDesign());
	$self->objDesign()->objControlWindow()->prop("Height", $tempHeight);
	$self->objDesign()->objControlWindow()->propGuiSet("Height", $self->winDesign(), $self->objDesign());
	::winDesign_Resize();

	#Set pos
	$self->objDesign()->objControlWindow()->propGuiSet("Left", $self->winDesign(), $self->objDesign());
	$self->objDesign()->objControlWindow()->propGuiSet("Top", $self->winDesign(), $self->objDesign());

	#Set Window Icon
	$self->objDesign()->objControlWindow()->propGuiSet("WindowIcon", $self->winDesign(), $self->objDesign());


	#Keep track of selected controls
	for my $objControl (@{$self->objDesign()->raControl()}) {
		$self->objCanvas()->controlSelected($objControl, $objControl->designIsSelected() );
		}

	$self->winDesign()->Show();

	$self->objDesign()->isDirty(0);

	#Notify views
	$self->objCanvas()->propNotifyFundamental();


=pod
	##Init test data
	my $objBtnTest = Win32::GUI::Loft::Control::Button->new();
	$objBtnTest->prop("Text", "&Test");
	$objBtnTest->prop("Top", 34);
	$objBtnTest->prop("Left", 32);
	$self->objDesign()->controlAdd( $objBtnTest );

	my $objBtnOk = Win32::GUI::Loft::Control::Button->new();
	$objBtnOk->prop("Text", "&Ok");
	$objBtnOk->prop("Top", 123);
	$objBtnOk->prop("Left", 321);
	$self->objDesign()->controlAdd( $objBtnOk );

	$self->objDesign()->objControlWindow()->prop("Text", "Nurå!", $self->winDesign());
=cut

	return(1);
	}





=head2 paintSelectBox($dcDev, $rhBrush)

Paint a select box from raMousePosDown() and
raMousePosLast() on the $dcDev.

Return 1 on success, else 0.

=cut
sub paintSelectBox { my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush) = @_;

	my @aPos1 = @{$self->raMousePosDown()};
	my @aPos2 = @{$self->raMousePosLast()};

	($aPos1[0], $aPos2[0]) = ($aPos2[0], $aPos1[0]) if($aPos1[0] > $aPos2[0]);
	($aPos1[1], $aPos2[1]) = ($aPos2[1], $aPos1[1]) if($aPos1[1] > $aPos2[1]);

	$dcDev->SelectObject($rhBrush->{antPen});
#	$dcDev->SelectObject($rhBrush->{brushBlack});

#	$dcDev->BeginPath();
	$dcDev->MoveTo($aPos1[0],$aPos1[1]);
	$dcDev->LineTo($aPos2[0],$aPos1[1]);
	$dcDev->LineTo($aPos2[0],$aPos2[1]);
	$dcDev->LineTo($aPos1[0],$aPos2[1]);
	$dcDev->LineTo($aPos1[0],$aPos1[1]);
#	$dcDev->EndPath();

	$self->objCanvas()->propNotifySelectionBox($aPos1[0], $aPos1[1], $aPos2[0] - $aPos1[0], $aPos2[1] - $aPos1[1], $self);

	return(1);
	}





=head1 Win32::GUI EVENTS

=head2 winDesign_Terminate()

Block the close operation.

=cut
sub ::winDesign_Terminate { my $self = TGL::WindowDesign->new();

	return(0);
	}





=head2 winDesign_Minimize()

Block the minimize operation.

=cut
sub ::winDesign_Minimize { my $self = TGL::WindowDesign->new();

	return(0);
	}





=head2 winDesign_Maximize()

Block the maximize operation.

=cut
sub ::winDesign_Maximize { my $self = TGL::WindowDesign->new();

	return(0);
	}





=head2 winDesign_Resize()

Resize the main window. Store the size into the Design.

=cut
sub ::winDesign_Resize { my $self = TGL::WindowDesign->new();
	defined($self->objResizerDesign()) and $self->objResizerDesign()->resize();

	#Update the Design elements
	$self->objDesign()->controlWindowResize(
			$self->winDesign()->Width(),
			$self->winDesign()->Height()
			);

	#Update other windows
	$self->objCanvas()->propNotifyChange([ "Left", "Top" ], $self);

	return(1);
	}





=head2 winDesign_Activate()

Activate the window and perform Modalizer stuff.

=cut
sub ::winDesign_Activate { my $self = TGL::WindowDesign->new();
	defined($self->objWindowApp()->objModalizer()) and $self->objWindowApp()->objModalizer()->activate($self->winDesign());
	}





=head2 winDesign_Deactivate()

Deactivate the main window. Store the pos into the Design.

=cut
sub ::winDesign_Deactivate { my $self = TGL::WindowDesign->new();

	#Update the Design elements
	$self->objDesign()->controlWindowMove(
			$self->winDesign()->Left(),
			$self->winDesign()->Top()
			);

	#Update other windows
	$self->objCanvas()->propNotifyChange([ "Left", "Top" ], $self);

	return(1);
	}





sub ::winDesign_DropFiles {
    my $self = TGL::WindowApp->new();	#Note! The App window!
	my ($handleDrop) = @_;

	$self->dropFiles($handleDrop);

	return(1);
	}





=head2 grCanvas_Paint()

Manually paint the canvas.

=cut
my %hBrush = (
	noPen        => new Win32::GUI::Pen( -style => 5 ),				#PS_NULL
	grayPen      => new Win32::GUI::Pen( -color => [128,128,128], -width => 1 ),
	lightGrayPen => new Win32::GUI::Pen( -color => [190,190,190], -width => 1 ),
	whitePen     => new Win32::GUI::Pen( -color => [255,255,255], -width => 1 ),
	redPen       => new Win32::GUI::Pen( -color => [220,0,0], -width => 1 ),
	blackPen     => new Win32::GUI::Pen( -color => [0,0,0], -width => 1 ),
	antPen		 => new Win32::GUI::Pen( -color => [0,0,0], -width => 1, -style => 2 ),	#PS_DASHDOT
	buttonPen 	 => new Win32::GUI::Pen( -color => Win32::GUI::AdHoc::GetSysColor( COLOR_BTNFACE ), -width => 1 ),

	noBrush		 => new Win32::GUI::Brush( -style => 1 ),			#BS_NULL
	blackBrush  => new Win32::GUI::Brush( [0,0,0] ),
	grayBrush   => new Win32::GUI::Brush( [128,128,128] ),
	buttonBrush => Win32::GUI::AdHoc::GetSysColorBrush( COLOR_BTNFACE ),
	whiteBrush  => new Win32::GUI::Brush( [255,255,255] ),
	font		=> Win32::GUI::GetStockObject(17),
	colorWindow	=> Win32::GUI::AdHoc::GetSysColor( COLOR_BTNFACE ),		#COLOR_WINDOW
	);
sub ::grCanvas_Paint {
    my $self = TGL::WindowDesign->new();
	my($dcDev) = @_;

	return(0) if(!$dcDev);

#use Time::HiRes qw(gettimeofday tv_interval);
#my $start_time = [ gettimeofday ];
#for (0..100) {

#	my $grCanvas = $self->winDesign()->grCanvas();
#	my ($left, $top, $right, $bottom) =
#			(0, 0,
#			$grCanvas->Width() + 1,
#			$grCanvas->Height() + 1,
#			);

#	#Paint background?
#	$dcDev->Rectangle($left, $top, $right, $bottom) if
#	    $left or $top or $right or $bottom;


	#Paint Grid (maybe)
	##todo: Cache this!!! A bitmap perhaps?
	#		Hash cached bitmap using snapX;snapY;maxX;maxY
	#		Meanwhile, half the no lines
	#
	#		Or, perhaps, Inline this thing!
	#
	if($self->objDesign()->gridShow()) {
		my $snapX = $self->objDesign()->snapX();
		my $snapY = $self->objDesign()->snapY();

		if($snapX > 0 && $snapY > 0) {
			my $maxX = $self->objDesign()->objControlWindow()->prop("Width") - $snapX;
			my $maxY = $self->objDesign()->objControlWindow()->prop("Height") - $snapY;

			#Cache
#			my $cacheName = "$snapX;$snapY;$maxX;$maxY";
#			if(!defined($self->{cacheName}) or $self->{cacheName} ne $cacheName) {
#
#				##Draw and cache
#
				#Don't draw the outermost lines
				$dcDev->TextColor([0, 0, 0]);		#Black
				for(my $x = $snapX; $x < $maxX; $x += ($snapX * 2)) {
					for(my $y = $snapY; $y < $maxY; $y += ($snapY * 2)) {
						$dcDev->SetPixel($x, $y);
						}
					}

#				#Cache in bitmap
#				if(my $dcTemp = Win32::GUI::AdHoc::CreateCompatibleDC($dcDev)) {
#					if(my $hbmCache = Win32::GUI::AdHoc::CreateCompatibleBitmap($dcDev, $maxX, $maxY)) {
#						$dcCache->SelectObject($hbmCache);
#
#						Win32::GUI::AdHoc::BitBlt($dcTemp,
#								0,0,
#								$maxX, $maxY,
#								$dcDev,
#								0,0,
#								0xCC0020)) 		#SRCCOPY
#						}
#					}
#				}
#			else {
#				#Display cached bitmap
#						Win32::GUI::AdHoc::BitBlt($dcTemp,
#								0,0,
#								$maxX, $maxY,
#								$dcDev,
#								0,0,
#								0xCC0020)) 		#SRCCOPY
#						}
#					}
#
#				}

			}
		}

	my $rhCache;
	for my $objControl (@{$self->objDesign()->raControl()}) {
#		next if(!$objControl->designIsTangible() || !$objControl->designIsVisible());
		my $rhPosCache = $objControl->rhPosCache();		#Cache the expensive prop lookups
		$rhCache->{$objControl} = $objControl->rhPosCache();
		$objControl->paint($dcDev, \%hBrush, $self->objDesign(), $rhPosCache);
		}

	for my $objControl (@{$self->objDesign()->raControl()}) {
#		next if(!$objControl->designIsTangible() || !$objControl->designIsVisible());
		$objControl->paintSelected($dcDev, \%hBrush, $rhCache->{$objControl});
		}

	if($self->mouseIsSelectBox()) {
		$self->paintSelectBox($dcDev, \%hBrush);
		}



   	$dcDev->Validate();

#}
#my $elapsed = tv_interval($start_time); print "The sub took $elapsed seconds.\n";

   	return(1);
	}





=head2 grCanvas_LButtonDown()

Left mouse button depress.

a) Select one/many (Shift) controls, or probe deeper (Ctrl) to another control
b) Start of click-move on a control
c) Start of click-move on the window (selecting rectangle)
d) Start resizing

=cut
sub ::grCanvas_LButtonDown {
    my $self = TGL::WindowDesign->new();
	my ($dummy, @aPos) = @_;

	$self->mouseIsDown(1);
	$self->raMousePosDown(\@aPos);
	$self->raMousePosLast(\@aPos);
	$self->mouseDragDirection(0);

	##If on a selected control
	for my $objControl (values %{$self->objCanvas()->rhControlSelected()}) {
		next if(! $objControl->designIsVisible());

		#Check selected controls' selection dots. It's a resize.
		last if($self->mouseResizeCorner( $objControl->clickedSelectCorner(@aPos) ) != -1);

		if($objControl->isClicked(@aPos)) {
			$self->mouseIsDragging(1);
			last;
			}
		}

	if( ! $self->mouseIsDragging() && $self->mouseResizeCorner() == -1) {
		$self->mouseIsSelectBox(1);
		}

   	return(1);
	}





=head2 grCanvas_LButtonUp()

Left mouse button release.

a) End of click-move on a control
b) End of click-move on the window (selecting rectangle)
c) End of resizing

=cut
sub ::grCanvas_LButtonUp {
    my $self = TGL::WindowDesign->new();
	my ($dummy, @aPos) = @_;

	#Make sure we have a depressed state
	$self->mouseIsDown() == 1 or return(1);
	$self->mouseIsDown(0);


	my $raDownPos = $self->raMousePosDown();
	if($self->mouseResizeCorner() != -1) {
		#Don't do anything if we clicked on a selection marker

		$self->mouseResizeCorner(-1);
		}
	elsif($aPos[0] == $raDownPos->[0] && $aPos[1] == $raDownPos->[1]) {
		###It is a click (same pos as the depress)

		##Check controls.
		my @aClicked;
		for my $objControl (reverse @{$self->objDesign()->raControl()}) {
			if($objControl->isClicked(@aPos)) {
				push(@aClicked, $objControl);
				last;
				}
			}

		if(defined(my $objSel = $aClicked[0])) {
			#It's a select/deselect.

			#Is the Ctrl depressed?
			if($self->downCtrl()) {
				#It's a multi-select
				$self->objCanvas()->controlSelected($objSel, ! $objSel->designIsSelected() );
				}
			else {
				#It's a simple click, deselect all others first
				$self->objCanvas()->controlAllDeselect();
				$self->objCanvas()->controlSelected($objSel, 1);
				}
			}
		else {
			##None. It's a deselect all

			$self->objCanvas()->controlAllDeselect();
			}


		$self->objCanvas()->propNotifySelected($self);
		}
	elsif($self->mouseIsSelectBox()) {
		#Check which buttons should be selected

		#Create rect
		my @aPos1 = @{$self->raMousePosDown()};
		my @aPos2 = @aPos;

		($aPos1[0], $aPos2[0]) = ($aPos2[0], $aPos1[0]) if($aPos1[0] > $aPos2[0]);
		($aPos1[1], $aPos2[1]) = ($aPos2[1], $aPos1[1]) if($aPos1[1] > $aPos2[1]);

		#If Ctrl is depressed, contonue with the current selection, otherwise
		#deselect all controls before selecting the current controls.
		$self->objCanvas()->controlAllDeselect() if(!$self->downCtrl());

		for my $objControl (@{$self->objDesign()->raControl()}) {
			if($objControl->isTouchedByRect(@aPos1, @aPos2)) {
				#Select, or deselect if Shift is depressed
				$self->objCanvas()->controlSelected($objControl, ! $self->downShift());
				}
			}

		$self->objCanvas()->propNotifySelected($self);
		}
	else {
		###It's a drag of some kind
		$self->objCanvas()->propNotifyChange(
				[ "Left", "Top" ],
				$self );
		}

	$self->mouseDragDirection(0);
	$self->mouseIsDragging(0);
	$self->mouseIsSelectBox(0);
	$self->objCanvas()->propNotifySelectionBox(undef, undef, undef, undef, $self);

	$self->winDesign()->InvalidateRect(1);


	#Update other windows
	$self->objCanvas()->setAppState();


   	return(1);
	}





=head2 grCanvas_MouseMove()

Register the movement.

=cut
sub ::grCanvas_MouseMove {
    my $self = TGL::WindowDesign->new();
	my ($dummy, @aPos) = @_;

	return(1) if(!$self->mouseIsDown());

	#Snap management
	my $snapX = 0;
	my $snapY = 0;
	if($self->objDesign()->gridSnap()) {
		$snapX = $self->objDesign()->snapX();
		$snapY = $self->objDesign()->snapY();
		}

	#The mouse pos, snapped to grid point
	my @aPosOrg = @aPos;
	$aPos[0] = (int($aPos[0] / $snapX) + 1) * $snapX if($snapX != 0);
	$aPos[1] = (int($aPos[1] / $snapY) + 1) * $snapY if($snapY != 0);


	#Make sure we have a drag/move direction
	if($self->mouseDragDirection() == 0) {
		my $raDown = $self->raMousePosDown();
		my $x = abs($aPos[0] - $raDown->[0]);
		my $y = abs($aPos[1] - $raDown->[1]);

		my $thresholdSnapDirection = 4;
		if(abs($x - $y) > $thresholdSnapDirection) {
			$self->mouseDragDirection( ($x > $y) ? 1 : 2 );		#Horiz or verti?
			}
		}
	my $dragDir = $self->mouseDragDirection();


	##The mouse movement
	my $raLast = $self->raMousePosLast();
	my $leftDelta = $aPos[0] - $raLast->[0];
	my $topDelta = $aPos[1] - $raLast->[1];


	#Read keyboard
	my $raState = Win32::GUI::AdHoc::GetKeyboardState();
	my $downShift = $self->downShift($raState->[0x10]);	#VK_SHIFT


	#If SHIFT is depressed, only move in one direction
	if($downShift) {
		if($dragDir == 1) {
			$topDelta = 0;
			}
		elsif($dragDir == 2) {
			$leftDelta = 0;
			}
		else {
			#No direction yet, don't move at all
			$topDelta = 0;
			$leftDelta = 0;
			}
		}


	if($self->mouseIsDragging()) {
		#Move all selected controls
		for my $objControl (values %{$self->objCanvas()->rhControlSelected()}) {
			$self->objDesign()->controlMove($objControl, $leftDelta, $topDelta, $snapX, $snapY);
			}
		}
	elsif($self->mouseResizeCorner() != -1) {

		#Resize and/or move all selected controls
		for my $objControl (values %{$self->objCanvas()->rhControlSelected()}) {
			$self->objDesign()->controlMoveResize($objControl, $self->mouseResizeCorner(), $leftDelta, $topDelta, $snapX, $snapY);
			}
		}


	#Save the pos
	$self->raMousePosLast(\@aPos);

	$self->winDesign()->InvalidateRect(1);


	#Update other windows
	$self->objCanvas()->propNotifyChange(
			[ "Left", "Top" ],
			$self );


   	return(1);
	}





=head2 grCanvas_RButtonUp()

Popup menu.

=cut
my @gaMenu = (
		" > &Align"					=> "mnuEditAlign",
		" > > &Left"				=> "mnuEditAlignLeft",
		" > > &Center"				=> "mnuEditAlignCenter",
		" > > &Right"				=> "mnuEditAlignRight",
		" > > &Width"				=> "mnuEditAlignMaxWidth",
	    " > > -"					=>  0,
		" > > &Top"					=> "mnuEditAlignTop",
		" > > &Middle"				=> "mnuEditAlignMiddle",
		" > > &Bottom"				=> "mnuEditAlignBottom",
		" > > &Height"				=> "mnuEditAlignMaxHeight",

		" > &Bring"					=> "mnuEditBring",
		" > > To &front"			=> "mnuEditBringToBottom",
		" > > &Up"					=> "mnuEditBringDown",
		" > > &Down"				=> "mnuEditBringUp",
		" > > To &back"				=> "mnuEditBringToTop",

		" > -"						=> 0,

		" > &Cut\tCtrl+X"			=> "mnuEditCut",
		" > &Copy\tCtrl+C"		=> "mnuEditCopy",
		" > &Paste\tCtrl+V"		=> "mnuEditPaste",
		" > Copy &Perl"			=> "mnuEditCopyPerl",
		" > > Control &name"		=> "mnuEditCopyPerlName",
	    " > -"					=>  0,
		" > &Delete\tDel"			=> "mnuEditDelete",
		" > &Duplicate"			=> "mnuEditDuplicate",
		);
my $gControlId = 0;
sub ::grCanvas_RButtonUp {
    my $self = TGL::WindowDesign->new();
	my ($dummy, @aPos) = @_;

	#Any control selected?
	my $sep = scalar(keys %{ $self->objCanvas()->rhControlSelected() });
	
	#Clicked controls
	my @aClicked;
	my $controlBase = $gControlId;
	my %hClicked;
	for my $objControl (reverse @{$self->objDesign()->raControl()}) {
		if($objControl->isClicked(@aPos)) {
			my $nameMenu = "mnuPopupControl$gControlId";
			push(@aClicked, sprintf(" > %s", $objControl->prop("Name") ), $nameMenu);		##todo:

			$hClicked{$nameMenu} = $objControl;
			$gControlId++;
			}
		}
	if(@aClicked && $sep) {
		push(@aClicked, " > -", 0)
		}

	if($sep) {
		push(@aClicked, @gaMenu);
		}

	my $mnuPopup = Win32::GUI::MakeMenu(
			"popup"   					=> "popup",
			@aClicked,
			);
			
	
	#Set the check status in the menu and create event handlers
	for my $name (keys %hClicked) {
		my $objControl = $hClicked{$name};
		my $nameControl = $objControl->prop("Name");
		$mnuPopup->{$name}->Checked( $objControl->designIsSelected() );
		
		#Create the event handler
		my $perlEvent = qq{
{
my \$obj = \$objControl;		#Nice little closure
sub ::${name}_Click {			#Adding new subs _will_ leak memory...
	::mnuPopupSelect(\$obj);
	}
}
};
		eval $perlEvent;		#...not to mention string eval
		print "Error: $@" if($@);
		}
	

	my $win = $self->winDesign();
	$win->TrackPopupMenu($mnuPopup->{popup},
			$aPos[0] + $win->Left() + 2,
			$aPos[1] + $win->Top() + 20
			);


	return(1);
	}





=head2 mnuPopupSelect($objControl)

Change the selected property for $objControl and update 
everything.

Called from the popup event handlers.

=cut
sub ::mnuPopupSelect {
    my $self = TGL::WindowDesign->new();
	my ($objControl) = @_;
	
	$self->objCanvas()->controlSelected($objControl, !$objControl->designIsSelected());
	
	$self->objCanvas()->propNotifySelected();
	}





=head2 timKey_Timer()

Keep track of keypresses.

This whole manual keyboard management is a mess. But - no
events available!

=cut
my $timKeyBlockDefault = 4;
sub ::timKey_Timer {
    my $self = TGL::WindowDesign->new();

	#Some operations must not be processed too often. E.g. after a paste
	#operation, don't listen to keyboard events for a few events.
	$self->{timKeyBlock}--;
	return(1) if($self->{timKeyBlock} > 0);
	$self->{timKeyBlock} = 0;


	#Only react if this window, or the main window (which contains the list
	#box with controls) is on top
	my $hwindTop = Win32::GUI::GetForegroundWindow();
	if(		$hwindTop != $self->winDesign()->{-handle} &&
			$hwindTop != $self->hwindMain()) {
		return(0);
		}



	#Read keyboard
	my $raState = Win32::GUI::AdHoc::GetKeyboardState();

	my $downCtrl = $self->downCtrl($raState->[0x11]);	#VK_CONTROL
	my $downShift = $self->downShift($raState->[0x10]);	#VK_SHIFT

	my $leftPress = $raState->[0x25];	#VK_LEFT
	my $rightPress = $raState->[0x27];	#VK_RIGHT
	my $upPress = $raState->[0x26];		#VK_UP
	my $downPress = $raState->[0x28];	#VK_DOWN
	my $delPress = $raState->[0x2E];	#VK_DELETE


	#Arrows and properties shortcuts only work in the Design window
	if($hwindTop == $self->winDesign()->{-handle}) {
		if($leftPress) {
			$self->objDesign()->controlMultipleMoveResize(
					$self->objCanvas()->rhControlActuallySelected(),
					-1, 0, $self->downShift(), $self->downCtrl());
			$self->objCanvas()->propNotifyChange([ "Left", "Top", "Height", "Width" ]);
			}
		elsif($rightPress) {
			$self->objDesign()->controlMultipleMoveResize(
					$self->objCanvas()->rhControlActuallySelected(),
					1, 0, $self->downShift(), $self->downCtrl());
			$self->objCanvas()->propNotifyChange([ "Left", "Top", "Height", "Width" ]);
			}
		elsif($upPress) {
			$self->objDesign()->controlMultipleMoveResize(
					$self->objCanvas()->rhControlActuallySelected(),
					0, -1, $self->downShift(), $self->downCtrl());
			$self->objCanvas()->propNotifyChange([ "Left", "Top", "Height", "Width" ]);
			}
		elsif($downPress) {
			$self->objDesign()->controlMultipleMoveResize(
					$self->objCanvas()->rhControlActuallySelected(),
					0, 1, $self->downShift(), $self->downCtrl());
			$self->objCanvas()->propNotifyChange([ "Left", "Top", "Height", "Width" ]);
			}
		elsif($raState->[ord("N")] && !$downCtrl) {
			$self->objWindowProp()->winInitiatedProperty( $self->winDesign() );
			$self->objWindowProp()->setFocus("Name");
			}
		elsif($raState->[ord("T")] && !$downCtrl) {
			$self->objWindowProp()->winInitiatedProperty( $self->winDesign() );
			$self->objWindowProp()->setFocus("Text");
			}
		elsif($raState->[ord("B")] && !$downCtrl) {
			$self->objWindowProp()->winInitiatedProperty( $self->winDesign() );
			$self->objWindowProp()->setFocus("Bitmap");
			}
		}


	#Menu shortcuts
	if($downCtrl) {
		if($raState->[ord("N")]) {
			$self->{timKeyBlock} = $timKeyBlockDefault;
			::mnuFileNew_Click();
			}
		elsif($raState->[ord("O")]) {
			$self->{timKeyBlock} = $timKeyBlockDefault;
			::mnuFileOpen_Click();
			}
		elsif($raState->[ord("S")]) {
			$self->{timKeyBlock} = $timKeyBlockDefault;
			::mnuFileSave_Click();
			}

		elsif($raState->[ord("C")]) {
			$self->{timKeyBlock} = $timKeyBlockDefault;
			::btnCopy_Click();
			}
		elsif($raState->[ord("X")]) {
			$self->{timKeyBlock} = $timKeyBlockDefault;
			::btnCut_Click();
			}
		elsif($raState->[ord("V")]) {
			$self->{timKeyBlock} = $timKeyBlockDefault;
			::btnPaste_Click();
			}

		elsif($raState->[ord("T")]) {
			$self->{timKeyBlock} = $timKeyBlockDefault;
			::mnuDesignTest_Click();
			}


		}
	else {
		#Del key
		if($delPress) {
			$self->{timKeyBlock} = $timKeyBlockDefault;
			$self->objCanvas()->controlDelete();
			}
		}

	}





1;





#EOF
