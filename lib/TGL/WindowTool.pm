=head1 NAME

TGL::WindowTool -- The Toolbox window

=head1 SYNOPSIS

Oh, man...

=cut





package TGL::WindowTool;
@ISA = qw( Win32::GUI::AppWindow );
use Win32::GUI::AppWindow;





use strict;
use Carp qw(cluck);
use Data::Dumper;
#use Data::Denter;

use Win32::GUI;
use Win32;
use Win32::GUI::AdHoc;
use Win32::GUI::Resizer qw( negResize );
use Win32::GUI::DragDrop;

use Win32::GUI::Loft::Design;
use Win32::GUI::Loft::Control;





#This class is a singleton. This is that object.
my $gObjSingleton = undef;

#Some things like bitmaps and stuff _needs_ to be persistent
#outside of their scope.
my %ghPerm;





=head1 PROPERTIES

=head2 winTool

The Toolbox window object

=cut
sub winTool {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{winTool} = $val;
		}

	return($self->{winTool});
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

The Win32::GUI::Loft::Canvas that is the current state of the objDesign()

Set to 0 to undef

=cut
sub objCanvas {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objCanvas} = $val;
		$self->{objCanvas} = undef if($val == 0);
		}

	return($self->{objCanvas});
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





=head2 objWindowProp

The properties window object

=cut
sub objWindowProp {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objWindowProp} = $val;
		}

	return($self->{objWindowProp});
	}





=head2 objWindowDesign

The design window object

=cut
sub objWindowDesign {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objWindowDesign} = $val;
		}

	return($self->{objWindowDesign});
	}





=head1 METHODS

=head2 new()

Create new UI for Windows.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;
	defined($gObjSingleton) and return($gObjSingleton);

	my $self = $gObjSingleton = $pkg->SUPER::new();

	$self->objWindowProp(undef);
	$self->objWindowApp(undef);
	$self->objWindowDesign(undef);
	$self->objCanvas(undef);

	$self->winTool(undef);

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

	#The window
	my $fileWindow = "resource\\tool.gld";		##todo: Move to config
	my $objDesign = Win32::GUI::Loft::Design->newLoad($fileWindow) or
			$self->errorReport("Could not open window file ($fileWindow)");
	my $winTool = $objDesign->buildWindow( $self->objWindowApp()->winMain() ) or
			$self->errorReport("Could not build window ($fileWindow)");
	$winTool->DragAcceptFiles(1);

=pod
	my $w = 100;
	my $h = 250;
	my $winTool = new Win32::GUI::Window(
		  -parent => $winMain,
	      -left   => 200,
	      -top    => 350,
	      -width  => $w,
	      -height => $h,
	      -name   => "winTool",
	      -text   => "Tool Box",
	      );
	$winTool->{-dialogui} = 1;
	my ($width, $height) = ($winTool->GetClientRect)[2..3];

	my $wb = 100;
	my $hb = 20;
	my $x = 0;

	$winTool->AddButton(
	       -text    => "&Button",
	       -name    => "btnButton",
	       -left    => 0,
	       -top     => $x,
	       -width   => $wb,
	       -height  => $hb,
	      );
	$x += $hb;

	$winTool->AddButton(
	       -text    => "&Label",
	       -name    => "btnLabel",
	       -left    => 0,
	       -top     => $x,
	       -width   => $wb,
	       -height  => $hb,
	      );
	$x += $hb;

	$winTool->AddButton(
	       -text    => "&Textfield",
	       -name    => "btnTextfield",
	       -left    => 0,
	       -top     => $x,
	       -width   => $wb,
	       -height  => $hb,
	      );
	$x += $hb;

	$winTool->AddButton(
	       -text    => "&RichEdit",
	       -name    => "btnRichEdit",
	       -left    => 0,
	       -top     => $x,
	       -width   => $wb,
	       -height  => $hb,
	      );
	$x += $hb;

	$winTool->AddButton(
	       -text    => "&Checkbox",
	       -name    => "btnCheckbox",
	       -left    => 0,
	       -top     => $x,
	       -width   => $wb,
	       -height  => $hb,
	      );
	$x += $hb;

	$winTool->AddButton(
	       -text    => "&Radio Button",
	       -name    => "btnRadiobutton",
	       -left    => 0,
	       -top     => $x,
	       -width   => $wb,
	       -height  => $hb,
	      );
	$x += $hb;

	$winTool->AddButton(
	       -text    => "&Listbox",
	       -name    => "btnListbox",
	       -left    => 0,
	       -top     => $x,
	       -width   => $wb,
	       -height  => $hb,
	      );
	$x += $hb;

	$winTool->AddButton(
	       -text    => "&TreeView",
	       -name    => "btnTreeView",
	       -left    => 0,
	       -top     => $x,
	       -width   => $wb,
	       -height  => $hb,
	      );
	$x += $hb;

	$winTool->AddButton(
	       -text    => "&Group Box",
	       -name    => "btnGroupbox",
	       -left    => 0,
	       -top     => $x,
	       -width   => $wb,
	       -height  => $hb,
	      );
	$x += $hb;
=cut

	$self->winTool($winTool);

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





=head2 newControl($type, $prefix)

Create new control of $type.

Return 1 on success, else 0.

=cut
sub newControl { my $self = shift; my $pkg = ref($self);
	my ($type, $prefix) = @_;

	my $objNew = $self->objCanvas()->controlNew($type) or return(0);

	$self->objCanvas()->controlAllDeselect();
	$self->objCanvas()->controlSelected($objNew, 1);

	$self->objCanvas()->propNotifySelected();
	
	#Update status label
	$self->winTool()->lblStatus()->Text($prefix);
	
	#Select the Name option and focus the input field
#	$self->objWindowProp()->setFocus("Name");
#Removed beacuse it messed up which window should have focus etc.

	$self->objWindowDesign()->winDesign()->SetFocus();


	return(1);
	}





=head1 Win32::GUI EVENTS

=head2 winTool_Terminate()

Hide window.

=cut
sub ::winTool_Terminate { my $self = TGL::WindowTool->new();

	$self->winTool()->Hide();

	return(1);
	}





=head2 winTool_Activate()

Activate the window and perform Modalizer stuff.

=cut
sub ::winTool_Activate { my $self = TGL::WindowTool->new();
	defined($self->objWindowApp()->objModalizer()) and $self->objWindowApp()->objModalizer()->activate($self->winTool());
	}





=head2 winTool_Resize()

Resize the main window dynamically. Unimplemented.

=cut
sub ::winTool_Resize { my $self = TGL::WindowTool->new();

	}





sub ::winTool_DropFiles {
    my $self = TGL::WindowApp->new();	#Note! The App window!
	my ($handleDrop) = @_;

	$self->dropFiles($handleDrop);

	return(1);
	}





=head2 btnButton_Click()

Create new control

=cut
sub ::btnButton_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("Button", "btn") or $self->errorReport("Could not create new Button");

	return(1);
	}





=head2 btnRichEdit_Click()

Create new control

=cut
sub ::btnRichEdit_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("RichEdit", "re") or $self->errorReport("Could not create new RichEdit");

	return(1);
	}





=head2 btnTextfield_Click()

Create new control

=cut
sub ::btnTextfield_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("Textfield", "tf") or $self->errorReport("Could not create new Textfield");

	return(1);
	}





=head2 btnLabel_Click()

Create new control

=cut
sub ::btnLabel_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("Label", "lbl") or $self->errorReport("Could not create new Label");

	return(1);
	}





=head2 btnCheckbox_Click()

Create new control

=cut
sub ::btnCheckbox_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("Checkbox", "chb") or $self->errorReport("Could not create new Checkbox");

	return(1);
	}





=head2 btnRadiobutton_Click()

Create new control

=cut
sub ::btnRadiobutton_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("Radiobutton", "rb") or $self->errorReport("Could not create new Radiobutton");

	return(1);
	}





=head2 btnListbox_Click()

Create new control

=cut
sub ::btnListbox_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("Listbox", "lb") or $self->errorReport("Could not create new Listbox");

	return(1);
	}





=head2 btnTreeView_Click()

Create new control

=cut
sub ::btnTreeView_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("TreeView", "tvw") or $self->errorReport("Could not create new TreeView");

	return(1);
	}





=head2 btnListView_Click()

Create new control

=cut
sub ::btnListView_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("ListView", "lvw") or $self->errorReport("Could not create new ListView");

	return(1);
	}





=head2 btnCombobox_Click()

Create new control

=cut
sub ::btnCombobox_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("Combobox", "cb") or $self->errorReport("Could not create new Combobox");

	return(1);
	}





=head2 btnGroupbox_Click()

Create new control

=cut
sub ::btnGroupbox_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("Groupbox", "gb") or $self->errorReport("Could not create new Groupbox");

	return(1);
	}





=head2 btnGraphic_Click()

Create new control

=cut
sub ::btnGraphic_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("Graphic", "gr") or $self->errorReport("Could not create new Graphic");

	return(1);
	}





=head2 btnToolbar_Click()

Create new control

=cut
sub ::btnToolbar_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("Toolbar", "tb") or $self->errorReport("Could not create new Toolbar");

	return(1);
	}





=head2 btnStatusBar_Click()

Create new control

=cut
sub ::btnStatusBar_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("StatusBar", "sb") or $self->errorReport("Could not create new StatusBar");

	return(1);
	}





=head2 btnProgressBar_Click()

Create new control

=cut
sub ::btnProgressBar_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("ProgressBar", "pb") or $self->errorReport("Could not create new ProgressBar");

	return(1);
	}





=head2 btnTabStrip_Click()

Create new control

=cut
sub ::btnTabStrip_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("TabStrip", "ts") or $self->errorReport("Could not create new TabStrip");

	return(1);
	}





=head2 btnSplitter_Click()

Create new control

=cut
sub ::btnSplitter_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("Splitter", "spl") or $self->errorReport("Could not create new Splitter");

	return(1);
	}





=head2 btnTimer_Click()

Create new control

=cut
sub ::btnTimer_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("Timer", "tim") or $self->errorReport("Could not create new Timer");

	return(1);
	}





=head2 btnImageList_Click()

Create new control

=cut
sub ::btnImageList_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("ImageList", "il") or $self->errorReport("Could not create new ImageList");

	return(1);
	}





=head2 btnCustom_Click()

Create new control

=cut
sub ::btnCustom_Click {
    my $self = TGL::WindowTool->new();

	$self->newControl("Custom", "ctm") or $self->errorReport("Could not create new Custom control");

	return(1);
	}





1;





#EOF
