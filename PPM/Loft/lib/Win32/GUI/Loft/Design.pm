=head1 NAME

Win32::GUI::Loft::Design - A "design", a window and a set of controls

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Design;
@ISA = qw( Win32::GUI::Loft::View );
use Win32::GUI::Loft::View;





use strict;
use Data::Dumper;
use Storable qw(nstore store_fd nstore_fd freeze thaw dclone);
#use Data::Denter;
use Carp qw( cluck );
use File::Basename;
use Cwd;

use Win32::GUI;
use Win32::GUI::Resizer;
use Win32::GUI::ToolbarWindow;
use Win32::GUI::BorderlessWindow;

use Win32::GUI::Loft;
use Win32::GUI::Loft::Cluster;
use Win32::GUI::Loft::ControlProperty;
use Win32::GUI::Loft::ControlProperty::Readonly;
use Win32::GUI::Loft::ControlInspector;

use Win32::GUI::Loft::Control;

#Must use them explicitly due to PerlApp * sigh *
use Win32::GUI::Loft::Control::Window;
use Win32::GUI::Loft::Control::Button;
use Win32::GUI::Loft::Control::Textfield;
use Win32::GUI::Loft::Control::RichEdit;
use Win32::GUI::Loft::Control::Label;
use Win32::GUI::Loft::Control::Checkbox;
use Win32::GUI::Loft::Control::Radiobutton;
use Win32::GUI::Loft::Control::Listbox;
use Win32::GUI::Loft::Control::Combobox;
use Win32::GUI::Loft::Control::TreeView;
use Win32::GUI::Loft::Control::ListView;
use Win32::GUI::Loft::Control::Groupbox;
use Win32::GUI::Loft::Control::Toolbar;
use Win32::GUI::Loft::Control::StatusBar;
use Win32::GUI::Loft::Control::ProgressBar;
use Win32::GUI::Loft::Control::TabStrip;
use Win32::GUI::Loft::Control::Splitter;
use Win32::GUI::Loft::Control::ImageList;
use Win32::GUI::Loft::Control::Timer;
use Win32::GUI::Loft::Control::Custom;
use Win32::GUI::Loft::Control::Graphic;

#Store them anyway, we need them later on
my @gaControlClass = qw(
        Win32::GUI::Loft::Control::Window
        Win32::GUI::Loft::Control::Button
        Win32::GUI::Loft::Control::Textfield
        Win32::GUI::Loft::Control::RichEdit
        Win32::GUI::Loft::Control::Label
        Win32::GUI::Loft::Control::Checkbox
        Win32::GUI::Loft::Control::Radiobutton
        Win32::GUI::Loft::Control::Listbox
        Win32::GUI::Loft::Control::Combobox
        Win32::GUI::Loft::Control::TreeView
        Win32::GUI::Loft::Control::ListView
        Win32::GUI::Loft::Control::Groupbox
        Win32::GUI::Loft::Control::Toolbar
        Win32::GUI::Loft::Control::StatusBar
        Win32::GUI::Loft::Control::ProgressBar
        Win32::GUI::Loft::Control::TabStrip
        Win32::GUI::Loft::Control::Splitter
        Win32::GUI::Loft::Control::ImageList
        Win32::GUI::Loft::Control::Timer
        Win32::GUI::Loft::Control::Custom
        Win32::GUI::Loft::Control::Graphic
        );





=head1 PROPERTIES

=head2 mnuMenu

Win32::GUI::Menu object to use when building the window, or
undef if no menu should be used.

Set to 0 to undef.

=cut
sub mnuMenu {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{mnuMenu} = $val;
        $self->{mnuMenu} = undef if($val eq "0");
        }

    return($self->{mnuMenu});
    }





=head2 objApp

Some user-defined object, normally used to connect a
application object responsible for this window.

Default: undef

Set to 0 to undef.

=cut
sub objApp {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objApp} = $val;
        $self->{objApp} = undef if($val eq "0");
        }

    return($self->{objApp});
    }





=head2 isDirty

Whether the Design has been changed in a meaningful way
since it was last saved or not.

Default: 0

=cut
sub isDirty {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{isDirty} = $val;
        }

    return($self->{isDirty});
    }





=head2 isPreview

Whether the desing is in preview mode, i.e. it's being
Tested within The GUI Loft.

If true, the certain controls will insert preview/test data
to visualize the settings.

Default: 0 (for all newly created/loaded designs)

=cut
sub isPreview {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{isPreview} = $val;
        }

    return($self->{isPreview});
    }





=head2 fileName

Absolute file name where the Design was loaded from, or ""
if none.

=cut
sub fileName {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{fileName} = $val;
        }

    return($self->{fileName});
    }





=head2 buildWindowName

If set, this is used as the -name of the built window
instead of the one in the design.

Use this if you want to change the name of the window at run
time/build time.

=cut
sub buildWindowName {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{buildWindowName} = $val;
        }

    return($self->{buildWindowName});
    }





=head2 buildControlNameBase

If set, this is appended to the -name of the built controls
(except the window).

Use this if you want to modify the name of controls at run
time/build time.

=cut
sub buildControlNameBase {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{buildControlNameBase} = $val;
        }

    return($self->{buildControlNameBase});
    }





=head2 raControl

Array ref with Win32::GUI::Loft::Control objects that are present in the
current design

=cut
sub raControl {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{raControl} = $val;
        }

    return($self->{raControl});
    }





=head2 raCluster

Array ref with Win32::GUI::Loft::Cluster objects.

=cut
sub raCluster {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{raCluster} = $val;
        }

    return($self->{raCluster});
    }





=head2 rhWingcTabStripGroup

Hash ref with (key = control name, value =
Win32::GUI::TabStripGroup control).

This property is populated as the window is built.

=cut
sub rhWingcTabStripGroup {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{rhWingcTabStripGroup} = $val;
        }

    return($self->{rhWingcTabStripGroup});
    }





=head2 rhClusterWingc

Hash ref with (key = Cluster name, value = array ref (with
Win32::GUI controls)).

This property is populated as the window is built. It
contains the controls that belong to Clusters, so you have
access to these at run-time.

=cut
sub rhClusterWingc {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{rhClusterWingc} = $val;
        }

    return($self->{rhClusterWingc});
    }





=head2 objControlWindow

The Win32::GUI::Loft::Control object that is the designed window.

Set to 0 to undef.

=cut
sub objControlWindow {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objControlWindow} = $val;
        $self->{objControlWindow} = undef if($val == 0);
        }

    return($self->{objControlWindow});
    }





=head2 pathBase

Path (with trailing \) used for all relative file names (e.g. image names). If
set without trailing \, one will be added.

Default: ".\\"

When a Win32::GUI::Loft::Design is saved and loaded, pathBase is set to
the directory of the data file. You may reset the value
after those operations.

=cut
sub pathBase {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{pathBase} = $val;
        $self->{pathBase} .= "\\" if($val !~ m{\\$});
        }

    return($self->{pathBase});
    }





=head2 snapX

The x/left/width snap value.

Default: 4

=cut
sub snapX {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        no warnings;    #Ignore non-numeric warnings in this code block
        $self->{snapX} = int($val) if(int($val) >= 0);
        }

    return($self->{snapX});
    }





=head2 snapY

The y/top/height snap value.

Default: 4

=cut
sub snapY {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        no warnings;    #Ignore non-numeric warnings in this code block
        $self->{snapY} = int($val) if(int($val) >= 0);
        }

    return($self->{snapY});
    }





=head2 gridShow

Whether the grid should be displayed.

Default: 0

=cut
sub gridShow {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{gridShow} = $val;
        }

    return($self->{gridShow});
    }





=head2 gridSnap

Whether the grid should be snapped to.

Default: 1

=cut
sub gridSnap {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{gridSnap} = $val;
        }

    return($self->{gridSnap});
    }





=head2 objResizer

The runtime Win32::GUI::Resizer object, if one is used, else
undef.

Set to 0 to undef.

=cut
sub objResizer {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objResizer} = $val;
        $self->{objResizer} = undef if($val == 0);
        }

    return($self->{objResizer});
    }





=head2 rhBitmap

Hash ref with (key = file name, value = Win32::GUI::Bitmap,
or undef).

This is where bitmaps are loaded and stored before they are
used on buttons, labels etc.

=cut
sub rhBitmap {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{rhBitmap} = $val;
        }

    return($self->{rhBitmap});
    }





=head2 rhIcon

Hash ref with (key = file name, value = Win32::GUI::Icon,
or undef).

This is where icons are loaded and stored before they are
used on windows, buttons, labels etc.

=cut
sub rhIcon {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{rhIcon} = $val;
        }

    return($self->{rhIcon});
    }





=head2 rhImageList

Hash ref with (key = file name, value =
Win32::GUI::ImageList, or undef).

This is where ImageLists are loaded and stored before they
are used in TreeViews, ListViews etc.

=cut
sub rhImageList {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{rhImageList} = $val;
        }

    return($self->{rhImageList});
    }





=head1 METHODS

=head2 new()

Create new design.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;

    my $self = $pkg->SUPER::new();

    $self->newDefaults();
    $self->newInit();


    #Always create a window control
    $self->objControlWindow( Win32::GUI::Loft::Control::Window->new() );


    return($self);
    }





=head2 newInit()

Init all vars for the newX methods.

Return 1 on success, else 0.

=cut
sub newInit {
    my $self = shift; my $pkg = ref($self);

    $self->mnuMenu(0);
    $self->isDirty(0);
    $self->isPreview(0);
    $self->objResizer(0);
    $self->rhBitmap({});
    $self->rhIcon({});
    $self->rhImageList({});
    $self->rhWingcTabStripGroup({});
    $self->rhClusterWingc({});

    return(1);
    }





=head2 newDefaults()

Set default values for all undefined values.

Return 1 on success, else 0.

=cut
sub newDefaults {
    my $self = shift; my $pkg = ref($self);

    $self->raCluster( [] ) if(!defined( $self->raCluster() ));
    $self->fileName("") if(!defined( $self->fileName() ));
    $self->raControl([]) if(!defined( $self->raControl() ));
    $self->buildWindowName("") if(!defined( $self->buildWindowName() ));
    $self->buildControlNameBase("") if(!defined( $self->buildControlNameBase() ));
    $self->pathBase(".\\") if(!defined( $self->pathBase() ));

    $self->snapX(4) if(!defined( $self->snapX() ));
    $self->snapY(4) if(!defined( $self->snapY() ));
    $self->gridShow(0) if(!defined( $self->gridShow() ));
    $self->gridSnap(1) if(!defined( $self->gridSnap() ));

    return(1);
    }





=head2 newRehash()

Rehash all important hash refs that might have been ruined
after a save+load.

Return 1 on success, else 0.

=cut
sub newRehash {
    my $self = shift; my $pkg = ref($self);

    for my $objCluster (@{$self->raCluster()}) {
        $objCluster->rhControl( $self->rehash( $objCluster->rhControl() ) );
        }

    return(1);
    }





=head2 resetInstanceCount()

Reset the counter for all control classes that is used to
keep track of how many instances of this object that are
created.

Note: This is a class method. Call it like so:

    Win32::GUI::Loft::Design->resetInstanceCount()


Return 1 on success, else 0.

=cut
sub resetInstanceCount {
    my $pkg = shift;

    for my $class (@gaControlClass) {
        $class->resetInstanceCount();
        }

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

    my %hProp = map { $_ => 1 } @$raPropName;

    #Load bitmap image if it changed
    if(exists $hProp{"Bitmap"}) {
        for my $objControl (values %{$rhControl}) {
            $self->bitmapLoad( $objControl->prop("Bitmap") );
            }
        }

    #Load icon if it changed
    if(exists $hProp{"WindowIcon"}) {
        for my $objControl (values %{$rhControl}) {
            $self->iconLoad( $objControl->prop("WindowIcon") );
            }
        }

    return(1);
    }





=head2 newLoad($fileName)

Note: This is a class/object method.

Create new design. Load $fileName that must be in "gld"
format.

$pathBase -- optional pathBase (will set pathBase()).

Return the new object, or undef on errors.

=cut
sub newLoad {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;
    my ($fileName) = @_;

    #Open as text
    my $fhIn;
    open($fhIn, "<$fileName") or return(undef);
    local $/;
    my $code = <$fhIn>;
    close($fhIn) or return(undef);


    if($code =~ /^\$VAR2 =/) {      #Storable format? It's binary.
        open($fhIn, "<$fileName") or return(undef);
        binmode($fhIn);
        local $/;
        $code = <$fhIn>;
        close($fhIn) or return(undef);
        }

    return( __PACKAGE__->newScalar($code, $fileName) );
    }





=head2 newScalar($text, [$fileName])

Note: This is a class/object method.

Create new design. Use the scalar $text that contains the a 
Design definition in "gld" format (must probably be read 
from file using binmode()).

$fileName -- If passed, it is used to set the fileName() 
property.

Return the new object, or undef on errors.

=cut
sub newScalar {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;
    my ($code, $fileName) = @_;

    my $self;

    #Is it legacy Dumper format?
    if($code =~ /^\$VAR1 =/) {
        my $VAR1;
        eval($code);
        return(undef) if($@);
        $self = $VAR1;

        bless $self, $pkg;
        }
    elsif($code =~ /^\$VAR2 =/) {       #Storable format?
        $code = substr($code, length('$VAR2 ='));   #Remove ident tag

        eval { $self = thaw($code)->[0]; };
        return(undef) if($@);
        }
    else {      #Other format? There IS NO OTHER FORMAT, what are you MAD???
        return(undef);
        }

    $self->newDefaults();
    $self->newInit();
    $self->newRehash();


#print Dumper($self);
    $self->transformFatten();
#print Dumper($self);

    #Init data
    $self->fileName($fileName);
    $self->isDirty(0);
    $self->pathBase(dirname($fileName) || ".");

    #Recreate bitmaps
    $self->bitmapParseControls();

    #Recreate icons
    $self->iconParseControls();


    return($self);
    }





=head2 fileSave([$fileName])

Save the design to the file fileName(), or to $fileName if
passed. Set the fileName().

$fileName is not validated for funny characters.

Return 1 on success, else 0.

=cut
sub fileSave {
    my $self = shift; my $pkg = ref($self);
    my ($fileName) = @_;
    defined($fileName) or $fileName = $self->fileName();
    return(0) if(!$fileName);

    my $fhOut;
    open($fhOut, ">$fileName") or return(0);

    #Init data
    $self->fileName($fileName);
    $self->pathBase(dirname($fileName) || ".");
    $self->isDirty(0);

    #Pre process
    my $rhBitmapTemp = $self->rhBitmap(); $self->rhBitmap({});
    my $buildControlNameBase = $self->buildControlNameBase(); $self->buildControlNameBase("");
    my $buildWindowName = $self->buildWindowName(); $self->buildWindowName("");


    #Save
#Non-Obsolete Dumper code
    $self->transformSlim();
#   my $objDumper = Data::Dumper->new([$self]);
#   $objDumper->Indent(1);
#   $objDumper->Purity(1);
#   print $fhOut $objDumper->Dump();
    binmode($fhOut);
    $fhOut->print('$VAR2 =' . freeze([$self]));
#Not-yet ready Denter code (it's too slow)
#   my $indented = Indent($self);
#   print $fhOut $indented;
    close($fhOut);      #Never fail, we need to clean up in post process

    $self->transformFatten();

    #Post process
    $self->rhBitmap( $rhBitmapTemp );
    $self->buildControlNameBase( $buildControlNameBase );
    $self->buildWindowName( $buildWindowName );

    return(1);
    }





=head2 transformSlim()

Transform the object to be a slimmed down representation of
the important property values.

Return 1 on success, else 0.

=cut
sub transformSlim {
    my $self = shift; my $pkg = ref($self);

    for my $objControl (@{$self->raControl()}) {
        $objControl->transformSlim();
        }

    $self->objControlWindow()->transformSlim();

    return(1);
    }





=head2 transformFatten()

Transform the object to be fully functional in terms of
property values.

Return 1 on success, else 0.

=cut
sub transformFatten {
    my $self = shift; my $pkg = ref($self);

    for my $objControl (@{$self->raControl()}) {
        $objControl->transformFatten();
        }

    $self->objControlWindow()->transformFatten();

    return(1);
    }





=head2 bitmapLoad($fileBitmap)

Load the bitmap in $fileBitmap (using the pathBase()) and
store it in raBitmap().

Return 1 on success, else 0.

=cut
sub bitmapLoad {
    my $self = shift; my $pkg = ref($self);
    my ($fileBitmap) = @_;
    return(0) if($fileBitmap eq "");
    my $file = $self->pathBase() . $fileBitmap;

    my $cwd = cwd(); $file =~ s{^\.}{$cwd};

    my $bmpBitmap = Win32::GUI::Bitmap->new($file) or return(0);

    $self->rhBitmap()->{$fileBitmap} = $bmpBitmap;

    return(1);
    }





=head2 bitmapParseControls()

Look at the controls, take note of Bitmap properties and
load those bitmaps.

Return 1 on success, else 0.

=cut
sub bitmapParseControls {
    my $self = shift; my $pkg = ref($self);

    for my $objControl ( (@{$self->raControl()}, $self->objControlWindow() ) ) {
        if(($objControl->prop("Bitmap") || "") ne "") {
            $self->bitmapLoad( $objControl->prop("Bitmap") );
            }
        }

    return(1);
    }





=head2 iconLoad($fileIcon)

Load the icon in $fileIcon (using the pathBase()) and
store it in raIcon().

Return 1 on success, else 0.

=cut
sub iconLoad {
    my $self = shift; my $pkg = ref($self);
    my ($fileIcon) = @_;
    return(0) if($fileIcon eq "");
    my $file = $self->pathBase() . $fileIcon;

    my $cwd = cwd(); $file =~ s{^\.}{$cwd};

    my $icoIcon = Win32::GUI::Icon->new($file) or return(0);

    $self->rhIcon()->{$fileIcon} = $icoIcon;

    return(1);
    }





=head2 iconParseControls()

Look at the controls, take note of WindowIcon properties and
load those icons.

Return 1 on success, else 0.

=cut
sub iconParseControls {
    my $self = shift; my $pkg = ref($self);

##todo: other properties containing Icon objects?
    for my $objControl ( (@{$self->raControl()}, $self->objControlWindow() ) ) {
        if(($objControl->prop("WindowIcon") || "") ne "") {
            $self->iconLoad( $objControl->prop("WindowIcon") );
            }
        }

    return(1);
    }





=head2 clipboardParseControl($clipboard)

Create new controls from the contents of $clipboard.

Return hash ref with the newly created controls, or {} on
errors.

=cut
sub clipboardParseControl {
    my $self = shift; my $pkg = ref($self);
    my ($clipboard) = @_;

    my $VAR1;
    eval($clipboard);
    return({}) if($@);
    my $rhControl = $VAR1;

    return($rhControl);
    }





=head2 controlAdd($objControl, [$objControlContainer = the window])

Add the $objControl to the design.

Return 1 on success, else 0.

=cut
sub controlAdd {
    my $self = shift; my $pkg = ref($self);
    my ($objControl, $objControlContainer) = @_;
    defined($objControlContainer) or $objControlContainer = $self->objControlWindow();

    push(@{$self->raControl()}, $objControl);

    $objControl->objContainer( $objControlContainer );

    return(1);
    }





=head2 controlDelete($rhControl)

Delete the controls in $rhControl.

Return 1 on success, else 0.

=cut
sub controlDelete {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl) = @_;

    my @aControlLeft;
    for my $objControl (@{$self->raControl()}) {
        push(@aControlLeft, $objControl) if(! exists $rhControl->{$objControl});
        }

    $self->raControl(\@aControlLeft);

    return(1);
    }





=head2 controlCopy($rhControl)

Copy the controls.

Return the resulting string (to be put in the clipboard) on
success, else return "".

=cut
sub controlCopy {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl) = @_;

    #Clear the container
    for my $objControl (values %{$rhControl}) {
        $objControl->objContainer(0);
        }

    #Serialize
    my $objDumper = Data::Dumper->new([$rhControl]);
    $objDumper->Indent(1);
    $objDumper->Purity(1);
    my $clipboard = $objDumper->Dump();

    #Restore the container object
    for my $objControl (values %{$rhControl}) {
        $objControl->objContainer( $self->objControlWindow() );
        }

    return($clipboard);
    }





=head2 controlCopyName($rhControl)

Copy the name of controls.

Return the resulting string (to be put in the clipboard) on
success, else return "".

If there is only one control, don't finish with a \n.

=cut
sub controlCopyName {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl) = @_;

    my $clipboard = join("\n", map { $_->prop("Name") } values %{$rhControl});

    $clipboard .= "\n" if($clipboard =~ /\n/);

    return($clipboard);
    }





=head2 controlPaste($rhControl)

Copy the controls to the Windows clipboard.

Return 1 on success, else 0.

=cut
sub controlPaste {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl) = @_;

    #Insert objects
    for my $objControl (values %{$rhControl}) {
        $self->controlAdd($objControl);     #Will use the window as container
        }

    return(1);
    }





=head2 controlMove($objControl, $leftDelta, $topDelta, $snapX, $snapY)

Move the $objControl the delta distance and set the dirty
flag.

Return 1 on success, else 0.

=cut
sub controlMove {
    my $self = shift; my $pkg = ref($self);
    my ($objControl, $leftDelta, $topDelta, $snapX, $snapY) = @_;

    $objControl->propIncSnap("Left", $leftDelta, $snapX);
    $objControl->propIncSnap("Top", $topDelta, $snapY);
    $self->isDirty(1);

    return(1);
    }





=head2 controlMoveResize($objControl, $corner, $leftDelta, $topDelta, $snapX, $snapY)

Move and/or resize the $objControl the delta distance and
set the dirty flag. The changes to position and size depends
on the $corner index:

     0: Bottom right
     1: Bottom left
     2: Top left
     3: Top right

Return 1 on success, else 0.

=cut
my $rhChange = {
        0 => { "Left" => 0, "Top" => 0, "Width" =>  1, "Height" =>  1, "H snap" => 1, "W snap" => 1 },
        1 => { "Left" => 1, "Top" => 0, "Width" => -1, "Height" =>  1, "H snap" => 1, "W snap" => 0 },
        2 => { "Left" => 1, "Top" => 1, "Width" => -1, "Height" => -1, "H snap" => 0, "W snap" => 0 },
        3 => { "Left" => 0, "Top" => 1, "Width" =>  1, "Height" => -1, "H snap" => 0, "W snap" => 1 },
        };
sub controlMoveResize {
    my $self = shift; my $pkg = ref($self);
    my ($objControl, $corner, $leftDelta, $topDelta, $snapX, $snapY) = @_;

    return(1) if(!$objControl->designIsTangible());

    my $left = $leftDelta * $rhChange->{$corner}->{"Left"};
    my $width = $leftDelta * $rhChange->{$corner}->{"Width"};
    my $top = $topDelta * $rhChange->{$corner}->{"Top"};
    my $height = $topDelta * $rhChange->{$corner}->{"Height"};

##todo: Fix the snap thing. This seems to be a solution in the wrong place.
##      Mouse snap should be restricted at the mouse level perhaps...
#   my $snapH = $snap * $rhChange->{$corner}->{"H snap"};
#   my $snapW = $snap * $rhChange->{$corner}->{"W snap"};

    my $snapH = 1;      #Just make it work
    my $snapW = 1;

    $objControl->propIncSnap("Left",   $left, $snapX) if($left);
    $objControl->propIncSnap("Width",  $width, $snapW) if($width);
    $objControl->propIncSnap("Top",    $top, $snapY) if($top);
    $objControl->propIncSnap("Height", $height, $snapH) if($height);

    $self->isDirty(1);

    return(1);
    }





=head2 controlMultipleMoveResize($rhControl, $x, $y, $downShift, $downCtrl)

Move or resize the selected controls the $x and $y distance.
If Shift, resize. If Ctrl, multiply the distance.

Return 1 on success, else 0.

=cut
sub controlMultipleMoveResize {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl, $x, $y, $downShift, $downCtrl) = @_;

    if($downCtrl) {
        $x *= (1 * $self->snapX());
        $y *= (1 * $self->snapY());
        }

    for my $objControl (values %{$rhControl}) {
        if($downShift) {
            $self->controlMoveResize($objControl, 0, $x, $y, 0, 0)
            }
        else {
            $self->controlMove($objControl, $x, $y, 0, 0);
            }
        }

    return(1);
    }





=head2 controlRearrange($dir, $raSelected)

Move the selected controls in the $dir (0: down, 1: up, 2:
bottom, 3: top).

$raSelected - array ref with indexes into raControl() that
should move.

Return 1 on success, else 0.

=cut
sub controlRearrange {
    my $self = shift; my $pkg = ref($self);
    my ($dir, $raSelected) = @_;

    #Find the new insertion point
#   my $indexNew = $raSelected->[0] + ($dir ? -1 : 1);  #One up
    my $indexNew;
    if(0 == $dir) {
        $indexNew = $raSelected->[0] + 1;   #One down
        }
    elsif(1 == $dir) {
        $indexNew = $raSelected->[0] - 1;   #One up
        }
    elsif(2 == $dir) {
        $indexNew = (scalar( @{$self->raControl()} ) - scalar(@$raSelected));   #Top
        }
    elsif(3 == $dir) {
        $indexNew = 0;  #Bottom
        }
    else {
        die("Invalid dir ($dir) != (0..3)");
        }

    return(0) if($indexNew < 0 && $dir);        #Upper bound works without check

    #Find the selected controls
    my %hSelected = map { $_ => 1 } @{$raSelected};
    my @aControlRemoved;
    my @aControlNew;
    my $i = 0;
    for my $objControl (@{$self->raControl()}) {
        if(exists $hSelected{$i}) {
            push(@aControlRemoved, $objControl);
            }
        else {
            push(@aControlNew, $objControl);
            }

        $i++;
        }

    #Insert cut cells
    splice(@aControlNew, $indexNew, 0, @aControlRemoved);

    #Replace existing list
    $self->raControl(\@aControlNew);

    return(1);
    }





=head2 controlAlign($objControl, $raTowhere)

Align the $objControl in the window using the specifics in
$raTowhere, which can take values of:

"center" -- Center horiz

"middle" -- Center vertival

Set the dirty flag.

Return 1 on success, else 0.

=cut
sub controlAlign {
    my $self = shift; my $pkg = ref($self);
    my ($objControl, $raTowhere) = @_;

    for my $where (@{$raTowhere}) {
        if($where eq "center") {
            my $left = int(($self->objControlWindow->prop("Width") / 2) -
                    ($objControl->prop("Width") / 2));
            $objControl->prop("Left", $left);
            }

        if($where eq "middle") {
            my $left = int(($self->objControlWindow->prop("Height") / 2) -
                    ($objControl->prop("Height") / 2));
            $objControl->prop("Top", $left);
            }
        }

    $self->isDirty(1);

    return(1);
    }





=head2 controlAlignMultiple($raControl, $how)

Align the controls to each other according to $how:

    right
    left
    top
    bottom
    maxwidth
    maxheight

Set the dirty flag.

Return 1 on success, else 0.

=cut
sub controlAlignMultiple {
    my $self = shift; my $pkg = ref($self);
    my ($raControl, $how) = @_;
    my ($offset, $len);

    if($how eq "right" || $how eq "left" || $how eq "center" || $how eq "maxwidth") {
        $offset = "Left";
        $len = "Width";
        }
    elsif($how eq "top" || $how eq "bottom" || $how eq "middle" || $how eq "maxheight") {
        $offset = "Top";
        $len = "Height";
        }

    my ($offsetMin, $offsetMax, $offsetMid, $lenMin, $lenMax, $lenMid, $offsetlenMax) =
            $self->controlDetermineLocation($raControl, $offset, $len);

    if($how eq "right" || $how eq "bottom") {
        for my $objControl (@$raControl) {
            $objControl->prop($offset, ($offsetlenMax - $objControl->prop($len)));
            }
        }
    elsif($how eq "left" || $how eq "top") {
        for my $objControl (@$raControl) {
            $objControl->prop($offset, $offsetMin);
            }
        }
    elsif($how eq "center" || $how eq "middle") {
        my $offsetMidActual = $offsetMin + ( ($offsetlenMax - $offsetMin) / 2 );
        for my $objControl (@$raControl) {
            $objControl->prop($offset, $offsetMidActual - ($objControl->prop($len) / 2));
            }
        }
    elsif($how eq "maxheight" || $how eq "maxwidth") {
        my $lenMaxActual = $offsetlenMax - $offsetMin;
        for my $objControl (@$raControl) {
            $objControl->prop($offset, $offsetMin);
            $objControl->prop($len, $lenMaxActual);
            }
        }
    else {
        die("Ivalid \$how ($how)");
        }

    $self->isDirty(1);

    return(1);
    }





=head2 controlDetermineLocation($raControl, $offset, $len)

Return the max, min, mid of the locations of the controls in
$raControl.

$offset -- Example: "Left", "Top"

$len -- Example: "Width", "Height"

Return ($offsetMin, $offsetMax, $offsetMid, $lenMin, $lenMax, $lenMid, $offsetlenMax)

=cut
sub controlDetermineLocation {
    my $self = shift; my $pkg = ref($self);
    my ($raControl, $offset, $len) = @_;
    my ($offsetMin, $offsetMax, $offsetMid, $lenMin, $lenMax, $lenMid, $offsetlenMax);

    for my $objControl (@$raControl) {
        my $offsetVal = $objControl->prop($offset);
        my $lenVal = $objControl->prop($len);

        defined($offsetMin) or $offsetMin = $offsetVal;
        defined($offsetMax) or $offsetMax = $offsetVal;
        defined($lenMin) or $lenMin = $lenVal;
        defined($lenMax) or $lenMax = $lenVal;
        defined($offsetlenMax) or $offsetlenMax = $offsetVal + $lenVal;

        $offsetMin = $offsetVal if($offsetVal < $offsetMin);
        $offsetMax = $offsetVal if($offsetVal > $offsetMax);
        $lenMin = $lenVal if($lenVal < $lenMin);
        $lenMax = $lenVal if($lenVal > $lenMax);
        $offsetlenMax = $offsetVal + $lenVal if($offsetVal + $lenVal > $offsetlenMax);
        }

    $offsetMid = ($offsetlenMax - $offsetMin) / 2;
    $lenMid = ($lenMax - $lenMin) / 2;

    return($offsetMin, $offsetMax, $offsetMid, $lenMin, $lenMax, $lenMid, $offsetlenMax);
    }





=head2 controlWindowMove($left, $top)

Move the window control (not the Win32::GUI window) and set
the dirty flag if it is to a new position.

Return 1 on success, else 0.

=cut
sub controlWindowMove {
    my $self = shift; my $pkg = ref($self);
    my ($left, $top) = @_;

    if(     $left eq $self->objControlWindow()->prop("Left") &&
            $top  eq $self->objControlWindow()->prop("Top")) {
        return(1);
        }

    $self->objControlWindow()->prop("Left", $left);
    $self->objControlWindow()->prop("Top", $top);
    $self->isDirty(1);

    return(1);
    }





=head2 controlWindowResize($width, $height)

Resize the window control (not the Win32::GUI window) and
set dirty flag if to a new size.

Return 1 on success, else 0.

=cut
sub controlWindowResize {
    my $self = shift; my $pkg = ref($self);
    my ($width, $height) = @_;

    if(     $width  eq $self->objControlWindow()->prop("Width") &&
            $height eq $self->objControlWindow()->prop("Height")) {
        return(1);
        }

    $self->objControlWindow()->prop("Width", $width);
    $self->objControlWindow()->prop("Height", $height);
    $self->isDirty(1);

    return(1);
    }





=head2 controlFindByCluster($objCluster)

Return array with Win32::GUI::Loft::Control objects that has
a Clusters property that contain $objCluster.

Return () on failure.

=cut
sub controlFindByCluster {
    my $self = shift; my $pkg = ref($self);
    my ($objCluster) = @_;

    my @aControl;
    for my $objControl (@{$self->raControl()}) {
        push(@aControl, $objControl) if($objControl->isUsingCluster($objCluster));
        }

    return(@aControl);
    }





=head2 wingcTabStripGroupAdd($tsTabStrip)

Create a new Win32::GUI::TabStripGroup object connected to
$tsTabStrip and store it in rhWingcTabStripGroup.

Return the new object on success, else undef.

=cut
sub wingcTabStripGroupAdd {
    my $self = shift; my $pkg = ref($self);
    my ($tsTabStrip) = @_;

    my $objTabStripGroup = Win32::GUI::TabStripGroup->new($tsTabStrip) or return(undef);

    $self->rhWingcTabStripGroup()->{ $tsTabStrip->{-name} } = $objTabStripGroup;

    return($objTabStripGroup);
    }





=head2 wingcTabStripRegister($objControl, $objControlWin32)

For $objControl, find the cluster it belongs to; then find
the TabStrips the cluster is used in; then find the already
created Win32::GUI::TabStripGroups; then find the correct
Tab in the TabStrip.

Register the $objControlWin32 with the TabStripGroup at the
Tab indicated by the TabStrip's Clusters property.

If any of this doesn't work, fail.

Return 1 on success, else 0.

=cut
sub wingcTabStripRegister {
    my $self = shift; my $pkg = ref($self);
    my ($objControl, $objControlWin32) = @_;

    my $objCluster = $self->clusterFindByControl($objControl) or return(0);
    my @aTabStrips = $self->controlFindByCluster($objCluster) or return(0);

    for my $objTabStrip (@aTabStrips) {
        my $objTabStripGroup = $self->wingcTSGFindByTabStrip($objTabStrip)
                or next;

        defined( my $tab = $objTabStrip->tabIndexFindByName( $objCluster->name() ) )
                or next;

        $objTabStripGroup->registerControl($tab, $objControlWin32) or next;
        }

    return(1);
    }





=head2 wingcTSGFindByTabStrip($objTabStrip)

Return the already created Win32::GUI::TabStripGroup that
corresponds to $objTabStrip (a Loft::Control::TabStrip), or
undef if not found.

=cut
sub wingcTSGFindByTabStrip {
    my $self = shift; my $pkg = ref($self);
    my ($objTabStrip) = @_;

##todo: move to single method for runtime-name
    return( $self->rhWingcTabStripGroup()->{ $objTabStrip->runtimeName($self) } );
    }





=head2 clusterNew($rhControlSelected, $name)

Create a new cluster with $name, and the selected
controls in $rhControlSelected.

Remove controls from other clusters, and set the insivible
state for all controls.

Return 1 on success, else 0.

=cut
sub clusterNew {
    my $self = shift; my $pkg = ref($self);
    my ($rhControlSelected, $name) = @_;

    my $objCluster = Win32::GUI::Loft::Cluster->new();
    $objCluster->name($name);

    $self->raCluster( [ @{$self->raCluster()}, $objCluster ] );

    $self->clusterMemorize($objCluster, $rhControlSelected);

    return(1);
    }





=head2 clusterDelete($objCluster)

Remove $objCluster from the Design and "release" all
clustered controls.

Return 1 on success, else 0.

=cut
sub clusterDelete {
    my $self = shift; my $pkg = ref($self);
    my ($objCluster) = @_;

    my @aNew;
    for my $objClustCur (@{$self->raCluster}) {
        push(@aNew, $objClustCur) if($objClustCur != $objCluster);
        }

    #The new list doen't contain the obj-to-be-deleted
    $self->raCluster(\@aNew);

    #"Release" clustered controls
    for my $objControl (values %{$objCluster->rhControl()}) {
        $objControl->designIsVisible(1);
        }

    return(1);
    }





=head2 clusterMemorize($objCluster, $rhControl)

Memorize the controls in $rhControl for the cluster
$objCluster. Remove these controls from all other clusters.

Return 1 on success, else 0.

=cut
sub clusterMemorize {
    my $self = shift; my $pkg = ref($self);
    my ($objCluster, $rhControl) = @_;

    #Remove from all
    for my $objClustCur (@{$self->raCluster()}) {
        $objClustCur->controlDelete($rhControl);
        }

    #Clear $objCluster
    $objCluster->rhControl( {} );

    #Add to $objCluster
    $objCluster->controlAdd($rhControl);

    #Set visibility state
    for my $objClustCur (@{$self->raCluster()}) {
        $objClustCur->setDesignIsVisible();
        }

    return(1);
    }





=head2 clusterFindByControl($objControl)

Retrurn the Cluster that contains $objControl, or undef if
$objControls isn't clustered.

=cut
sub clusterFindByControl {
    my $self = shift; my $pkg = ref($self);
    my ($objControl) = @_;

    for my $objCluster (@{$self->raCluster()}) {
        return($objCluster) if($objCluster->controlIsClustered($objControl));
        }

    return(undef);
    }





=head2 fileMakeRelative($file)

Make $file relative to the pathBase(). It may still be an
absolute file name.

Return the relative file name on success, else "".

=cut
sub fileMakeRelative {
    my $self = shift; my $pkg = ref($self);
    my ($file) = @_;

    my $pathBase = $self->pathBase();

    $pathBase = cwd() . "\\" if($pathBase eq ".\\");
    $pathBase =~ s{/}{\\}g;
    $pathBase = quotemeta($pathBase);

    $file =~ s{^$pathBase}{};

    return($file);
    }





=head2 controlNew($type)

Create new control of $type and put it in the middle of the
window.

Return the newly created Win32::GUI::Loft::Control::$type, or undef on
failure.

=cut
sub controlNew {
    my $self = shift; my $pkg = ref($self);
    my ($type) = @_;

    my $pkgNew = "Win32::GUI::Loft::Control::$type";
    my $objNew = $pkgNew->new();
    $objNew->prop("Text", $objNew->prop("Name")) if($objNew->hasProperty("Text"));
    $self->controlAlign($objNew, ["center", "middle"]) if($objNew->designIsTangible());

    $self->controlAdd( $objNew );

    return($objNew);
    }





=head2 perlBuildWindow([$winParent, $objInspector])

Create Perl code to build the window in the design and
return it.

$winParent -- Optional owner window.

$objInspector -- Win32::GUI::Loft::ControlInspector object used to
inspect and modify the controls during build. Refer to the
class' POD.

Return undef on errors, warn on questionable conditions.

=cut
sub perlBuildWindow {
    my $self = shift; my $pkg = ref($self);
    my ($winParent, $objInspector) = @_;
    defined($objInspector) or $objInspector = Win32::GUI::Loft::ControlInspector->new();

##todo: use alternate name, and use alternate namebase for all controls

    #Remember window size and adjust for window type and menu presence
    my $widthChange = 0;
    my $heightChange = 0;

    #Window, dialog, or toolbar?
    my $dialog = $self->objControlWindow()->prop("DialogBox");
    my $pkgNew = "Win32::GUI::Window";      #"window"
    if($dialog eq "dialog") {
        $pkgNew = "Win32::GUI::DialogBox";
        $widthChange += -3;
        $heightChange += -1;
        }
    elsif($dialog eq "toolbar") {
        $pkgNew = "Win32::GUI::ToolbarWindow";
        $widthChange += -1;
        $heightChange += -4;
        }

    #Owner parent?
    my @aParent = ();
    if(defined($winParent)) {
        @aParent = ( -parent => $winParent );
        }

    #Adjust for menu
    my @aMenu = ();
    if(defined($self->mnuMenu())) {
        @aMenu = ( -menu => $self->mnuMenu() );
        $heightChange += 19;
        }

    #Adjust the window size
    $self->objControlWindow()->propIncSnap("Width", $widthChange, 0);
    $self->objControlWindow()->propIncSnap("Height", $heightChange, 0);


    #Create object
    my @aOption = $objInspector->buildOptions(                      ##perl
            $self->objControlWindow(),
                [$self->objControlWindow()->buildOptions($self),
                @aMenu,
                @aParent,
                ],
            ) or return(undef);

    my $winWin = $pkgNew->new(
            @aOption,
            ) or return(undef);

    $self->objControlWindow()->buildMethods($winWin);               ##perl
    $self->objControlWindow()->buildMethodsSpecial($winWin, $self); ##perl


    ##Fill it with controls
    #Ignore errors, like when a custom control can't be created

    #Empty the current list of TabStripGroup objects.
    $self->rhWingcTabStripGroup({});


    #Pre
    for my $objControl (@{$self->raControl()}) {
        $objControl->buildAdd($self, $winWin, $objInspector)        ##perl
                if($objControl->buildPreControlPhase());
        }

    #Control
    for my $objControl (@{$self->raControl()}) {
        $objControl->buildAdd($self, $winWin, $objInspector)        ##perl
                if($objControl->buildControlPhase());
        }

    #Post
    for my $objControl (@{$self->raControl()}) {
        $objControl->buildAdd($self, $winWin, $objInspector)        ##perl
                if($objControl->buildPostControlPhase());
        }


    ##Register clustered objects
    my $rhClusterControl = {};
    for my $objCluster (@{$self->raCluster()}) {
        for my $objControl (values %{$objCluster->rhControl()}) {
            my $name = $objControl->runtimeName($self);
            push(@{$rhClusterControl->{$objCluster->name()}}, $winWin->{$name});
            }
        }
    $self->rhClusterWingc($rhClusterControl);


    ##Build the resizer stuff
    $self->buildResizer($winWin, $objInspector) or return(undef);   ##perl


    #Readjust the window size
    $self->objControlWindow()->propIncSnap("Width", 0 - $widthChange, 0);
    $self->objControlWindow()->propIncSnap("Height", 0 - $heightChange, 0);

    #Keep the newly created Window in a global hash, so that
    #everyone who doesn't use a Singleton to keep track of the instance
    #have some unified way of doing that.
    $Win32::GUI::Loft::window{ $self->objControlWindow()->runtimeName($self) } = $winWin;

    #This Design object ($self) MUST be kept in scope, beacuse it contains the
    #bitmaps and imagelists for the window.
    $Win32::GUI::Loft::design{ $self->objControlWindow()->runtimeName($self) } = $self;

    return($winWin);
    }





=head2 buildWindow([$winParent, $objInspector])

Build window in the design and return a Win32::GUI::Window
or Win32::GUI::Dialog object.

$winParent -- Optional owner window.

$objInspector -- Win32::GUI::Loft::ControlInspector object used to
inspect and modify the controls during build. Refer to the
class' POD.

Return undef on errors, warn on questionable conditions.

=cut
sub buildWindow {
    my $self = shift; my $pkg = ref($self);
    my ($winParent, $objInspector) = @_;
    defined($objInspector) or $objInspector = Win32::GUI::Loft::ControlInspector->new();

##todo: use alternate name, and use alternate namebase for all controls

    #Remember window size and adjust for window type and menu presence
    my $widthChange = 0;
    my $heightChange = 0;

    #Window, dialog, or toolbar?
    my $dialog = $self->objControlWindow()->prop("DialogBox");
    my $pkgNew = "Win32::GUI::Window";      #"window"
    if($dialog eq "dialog") {
        $pkgNew = "Win32::GUI::DialogBox";
        $widthChange += -3;
        $heightChange += -1;
        }
    elsif($dialog eq "toolbar") {
        $pkgNew = "Win32::GUI::ToolbarWindow";
        $widthChange += -1;
        $heightChange += -4;
        }
    elsif($dialog eq "borderless") {
        $pkgNew = "Win32::GUI::BorderlessWindow";
        $widthChange += -0;
        $heightChange += -20;
        }

    #Owner parent?
    my @aParent = ();
    if(defined($winParent)) {
        @aParent = ( -parent => $winParent );
        }

    #Adjust for menu
    my @aMenu = ();
    if(defined($self->mnuMenu())) {
        @aMenu = ( -menu => $self->mnuMenu() );
        $heightChange += 19;
        }

    #Adjust the window size
    $self->objControlWindow()->propIncSnap("Width", $widthChange, 0);
    $self->objControlWindow()->propIncSnap("Height", $heightChange, 0);


    #Create object
    my @aOption = $objInspector->buildOptions(                      ##perl
            $self->objControlWindow(),
                [$self->objControlWindow()->buildOptions($self),
                @aMenu,
                @aParent,
                ],
            ) or return(undef);

    my $winWin = $pkgNew->new(
            @aOption,
            ) or return(undef);

    $self->objControlWindow()->buildMethods($winWin);               ##perl
    $self->objControlWindow()->buildMethodsSpecial($winWin, $self); ##perl


    ##Fill it with controls
    #Ignore errors, like when a custom control can't be created

    #Empty the current list of TabStripGroup objects.
    $self->rhWingcTabStripGroup({});


    #Pre
    for my $objControl (@{$self->raControl()}) {
        $objControl->buildAdd($self, $winWin, $objInspector)        ##perl
                if($objControl->buildPreControlPhase());
        }

    #Control
    for my $objControl (@{$self->raControl()}) {
        $objControl->buildAdd($self, $winWin, $objInspector)        ##perl
                if($objControl->buildControlPhase());
        }

    #Post
    for my $objControl (@{$self->raControl()}) {
        $objControl->buildAdd($self, $winWin, $objInspector)        ##perl
                if($objControl->buildPostControlPhase());
        }


    ##Register clustered objects
    my $rhClusterControl = {};
    for my $objCluster (@{$self->raCluster()}) {
        for my $objControl (values %{$objCluster->rhControl()}) {
            my $name = $objControl->runtimeName($self);
            push(@{$rhClusterControl->{$objCluster->name()}}, $winWin->{$name});
            }
        }
    $self->rhClusterWingc($rhClusterControl);


    ##Build the resizer stuff
    $self->buildResizer($winWin, $objInspector) or return(undef);   ##perl


    #Readjust the window size
    $self->objControlWindow()->propIncSnap("Width", 0 - $widthChange, 0);
    $self->objControlWindow()->propIncSnap("Height", 0 - $heightChange, 0);

    #Keep the newly created Window in a global hash, so that
    #everyone who doesn't use a Singleton to keep track of the instance
    #have some unified way of doing that.
    $Win32::GUI::Loft::window{ $self->objControlWindow()->runtimeName($self) } = $winWin;

    #This Design object ($self) MUST be kept in scope, beacuse it contains the
    #bitmaps and imagelists for the window.
    $Win32::GUI::Loft::design{ $self->objControlWindow()->runtimeName($self) } = $self;

    return($winWin);
    }





=head2 buildResizer($winWin, $objInspector)

If any control contains resizer instructions, build the
Win32::GUI::Resizer object with the appropriate controls.

Return 1 on success, else 0.

=cut
sub buildResizer {
    my $self = shift; my $pkg = ref($self);
    my ($winWin, $objInspector) = @_;

    my $perlRel = $self->perlResizer() or return(1);

    my $objResizer = Win32::GUI::Resizer->new($winWin);
    eval $perlRel;
    $@ and return(0);


    $self->objResizer($objResizer);


    #Create the window's Resize event handler

    #Create a _Change events
    my $nameEvent = $self->perlEventName($self->objControlWindow(), "Resize");
    my $perlVarLoft = $self->perlVarLoft() or return(0);
    my $code = '$design->objResizer()->resize();';

    my $perl = <<EOP;
sub $nameEvent {

$perlVarLoft

$code

return(1);
}
EOP
#print "((($perl)))\n";
#print "window: " . $self->objControlWindow()->runtimeName($self) . "\n";


    eval($perl);
    if($@) {
        warn($@);
        return(0);
        }

    $objResizer->memorize();

    return(1);
    }





=head2 perlResizer($winWin, $objInspector)

If any control contains resizer instructions, return the
Perl code for a Win32::GUI::Resizer object with the
appropriate controls.

Return "" on failure.

=cut
sub perlResizer {
    my $self = shift; my $pkg = ref($self);

    my %hValue;
    my @aControl;
    for my $objControl (@{$self->raControl()}) {
        #Find out if we use this contorl at all
        next if(!$objControl->isResizable());

        #Take note of which specialValues to use
        (my $valueH = $objControl->prop("ResizeHValue") || "") or $hValue{"winWidth"} = 1;
        $hValue{$valueH} = 1;
        (my $valueV = $objControl->prop("ResizeVValue") || "") or $hValue{"winHeight"} = 1;
        $hValue{$valueV} = 1;

        push(@aControl, $objControl);
        }
    delete $hValue{""};


    #Do we have any resizable controls?
    return("") if(0 == @aControl);


    #For each value, do the appropriate controls and their properties
    my $perlRel = "\$objResizer->raRelations([\n";
    for my $value (keys %hValue) {
        $perlRel .= "\t'$value' => [\n";
        for my $objControl (@aControl) {
            for my $hv ("H", "V") {
                my $controlValue = $objControl->prop("Resize${hv}Value") || "";
                if($controlValue eq "") {
                    $controlValue = "winHeight" if($hv eq "V");
                    $controlValue = "winWidth" if($hv eq "H");
                    }

                if($controlValue eq $value) {
                    #This control is using this value

                    if((my $controlMethod = $objControl->prop("Resize${hv}")) ne "") {
                        #This control is using H/V

                        my $property = ucfirst($controlMethod);
                        my $resizeMethod = $self->perlVarControl($objControl) . "->$property()";
                        $resizeMethod =~ s{^\$win-}{\$winResize-};  #The window var is $win from perlVarControl()

                        $perlRel .= "\t\t['$resizeMethod'],\n";

                        if((my $controlMod = $objControl->prop("Resize${hv}Mod") || "") ne "") {
                            #This control us using a modifyer

                            $perlRel =~ s#\'\],\n$#', sub { \$_ = \$_[0]; $controlMod; } ],\n#ms;
                            }
                        }
                    }
                }
            }

        $perlRel .= "\t\t],\n";
        }
    $perlRel .= "\t]);";

    return($perlRel);
    }





=head2 perlEventName($objControl, $nameEvent)

Return Perl code to reference an event handler sub.

Return "" on failure.

=cut
sub perlEventName {
    my $self = shift; my $pkg = ref($self);
    my ($objControl, $nameEvent) = @_;

    my $nameControl = $objControl->runtimeName($self);

    return("::" . $nameControl . "_$nameEvent");
    }





=head2 perlVarLoft()

Return Perl code to create two vars: $win, and $design.

=cut
sub perlVarLoft {
    my $self = shift; my $pkg = ref($self);

    my $name = $self->objControlWindow()->runtimeName($self);

    return(<<EOP);
    defined(my \$win = \$Win32::GUI::Loft::window{'$name'}) or return(1);
    defined(my \$design = \$Win32::GUI::Loft::design{'$name'}) or return(1);
EOP
    }





=head2 perlVarControl($objControl)

Return Perl code to reference the Win32::GUI control that
corresponds with the Win32::GUI::Loft::Control $objControl.

=cut
sub perlVarControl {
    my $self = shift; my $pkg = ref($self);
    my ($objControl) = @_;

    my $nameControl = $objControl->runtimeName($self);

    return("\$win->$nameControl()");
    }





=head2 perlVarTabStripGroup($objTabStrip)

Return Perl code to reference the Win32::GUI::TabStripGroup
object that's indicated by $objTabStrip.

=cut
sub perlVarTabStripGroup {
    my $self = shift; my $pkg = ref($self);
    my ($objTabStrip) = @_;

    my $name = $objTabStrip->runtimeName($self);
    return("\$design->rhWingcTabStripGroup()->{'$name'}");
    }





=head2 perlWindow([$objInspector])

Create Perl code for the window in the design and return it.

$objInspector -- Win32::GUI::Loft::ControlInspector object used to
inspect and modify the controls during build. Refer to the
class POD.

Return undef on errors, warn on questionable conditions.

=cut
sub perlWindow {
    my $self = shift; my $pkg = ref($self);
    my ($objInspector) = @_;
    defined($objInspector) or $objInspector = Win32::GUI::Loft::ControlInspector->new();

    ##todo: etc, refactor the buildWindow
print "Building Perl code\n";

return("print 'Hello world!\\n'\n");

    return(undef);
    }





=head2 rehash($rhOld)

"Rehash" $rhOld, i.e. make the stringified values become
keys. Return new hash ref with valid keys/value pairs.

=cut
sub rehash {
    my $self = shift; my $pkg = ref($self);
    my ($rhOld) = @_;

    my $rhNew;

    for my $item (values %$rhOld) {
        $rhNew->{$item} = $item;
        }

    return($rhNew);
    }





1;





#EOF
