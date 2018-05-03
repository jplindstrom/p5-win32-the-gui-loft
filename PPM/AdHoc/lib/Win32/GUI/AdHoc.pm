=head1 NAME

Win32::GUI::AdHoc -- Small utility routines for Win32::GUI

=head1 DESCRIPTION

This is a small collection of routines to aid you when
coding Win32::GUI applications.

No symbols are exported.

Note: Don't rely on this module to stay the same. It _will_ 
change.

=cut





package Win32::GUI::AdHoc;





$VERSION = '0.03';

use strict;
use Win32::API;
use Win32::GUI;

use Data::Dumper;





=head1 CONSTANTS

=head2 Custom message to exit from the Dialog() function.

    WM_EXITLOOP
    WM_APP

=cut

use constant WM_APP             => 0x8000;          #From winuser.h (Visual Studio)
use constant WM_EXITLOOP        => WM_APP + 1;      #From GUI.xs


=head2 RichEdit

    EM_LINESCROLL
    EM_SETPARAFORMAT

=cut

use constant EM_LINESCROLL      => 182;             #From podview.pl
use constant EM_SETPARAFORMAT   => 0x447;           #From the Win32 SDK


=head2 To make combo boxed non-editable

    CBS_DROPDOWNLIST
    CBS_DISABLENOSCROLL

=cut

use constant CBS_DROPDOWNLIST => 0x0003;            #From winuser.h
use constant CBS_DISABLENOSCROLL => 0x0800;


=head2 ExWindow

    GWL_EXSTYLE
    WS_EX_TOOLWINDOW

=cut

use constant GWL_EXSTYLE => (-20);                  #From wiuser.h
#use constant WS_EX_TOOLWINDOW => 0x00000080;       #From wiuser.h


=head2 Label image options

    SS_BITMAP

=cut
use constant SS_BITMAP => 0x0000000E;


=head2 Drag-drop

    WM_DROPFILES

=cut

use constant WM_DROPFILES => 0x0233;


=head2 Keys

Key codes for use with e.g. GetAsyncKeyState()

=cut

use constant VK_SHIFT => 0x10;
use constant VK_CONTROL => 0x11;
use constant VK_MENU => 0x12;





=head1 ROUTINES

=head2 blockGUIWarnings()

Install a warning handler to block certain types of warnings
that occur frequently when using Win32::GUI.

Rationale: Well... Win32::GUI sprinkles warnings left and
right, which makes it difficult to discern your own
warnings. And, it's plain annoying.

Original idea: Eric Bennett on the Win32::GUI mailing list.

=cut

sub blockGUIWarnings {
    my $self = shift;

    $SIG{'__WARN__'} = sub {
        my ($warning) = @_;

        if($warning =~ /^Use of uninitialized value in subroutine entry at .+? line \d+?\.$/) {
            return(0);
            }

        if($warning =~ m{cleanup.*EXISTS.*Win32/GUI\.pm line \d+? during global destruction\.$}) {
            return(0);
            }

        print STDERR $warning;
        };

    return(1);
    }





=head2 exitDialog($winSomewindow)

Exit from the Win32::GUI::Dialog event loop.

$winSomewindow -- A Win32::GUI window object we can send the
WM_EXITLOOP message to.

Return 1 on success, else 0.

=cut

sub exitDialog {
    my ($winSomewindow) = @_;

    $winSomewindow->PostMessage(WM_EXITLOOP, -1, 0);

    return(1);
    }





=head2 windowCenter($winSelf, [$winParent = <the desktop window>])

Center the $winSelf vertically and horizontally in the 
$winParent (Default: the Desktop window).

$winSelf and $winParent can be either a Win32::GUI::Window 
or a hwind.

Return 1 on success, else 0.

=cut

sub windowCenter {
    my ($winSelf, $winParent) = @_;
    defined($winParent) or $winParent = Win32::GUI::GetDesktopWindow();

    #Avoid OO notation to enable us to use either a hwind or a Win32::GUI::Window object
    my $x = Win32::GUI::Left($winParent) + (Win32::GUI::Width($winParent) / 2) - (Win32::GUI::Width($winSelf) / 2);
    my $y = Win32::GUI::Top($winParent) + (Win32::GUI::Height($winParent) / 2) - (Win32::GUI::Height($winSelf) / 2);
    
    Win32::GUI::Move($winSelf, $x, $y) and return(1);
    return(0);
    }





=head2 richEditScroll($reControl, $noCol, $noLines)

Scroll $reControl so that $noLines is the first visible
line.

Return 1 on success, else 0.

The actual functionality is taken from the podview.pl sample
file.

=cut

sub richEditScroll {
    my ($reControl, $noCol, $noLines) = @_;

    my $diff = $noLines - $reControl->FirstVisibleLine();
    $reControl->SendMessage(EM_LINESCROLL, $noCol, $diff);

    return(1);
    }





=head2 richEditTabstops($reControl, $tabSize)


Set the tab size in $reControl to $tabSize pixels wide.

Return 1 on success, else 0.

The actual functionality is taken from the wex.pl program by
Harald Piske.

=cut

my $rsSendMessage = new Win32::API ('User32', $_ = 'SendMessage', "INIP", "I");
sub richEditTabsizePixels {
    my ($reControl, $tabSize) = @_;

    my $formatParams = 'VVvvV3vvV32';
    my $params = pack($formatParams,
            0,                      # cbSize (filled in later)
            0x10,                   # dwMask
            0,                      # wNumbering
            0,                      # wReserved
            0,                      # dxStartIndent
            0,                      # dxRightIndent
            0,                      # dxOffset
            2,                      # wAlignment
            32,                     # cTabCount
            map { $tabSize * $_ }
                    (1..32),        # rgxTabs[MAX_TAB_STOPS]
            );
    my $lenParam = pack(substr($formatParams, 0, 1), length($params));
    substr($params, 0, length($lenParam)) = $lenParam;

    $rsSendMessage->Call($reControl->{-handle}, EM_SETPARAFORMAT, 0, $params);

    return(1);
    }





=head2 GetSysColorBrush($color)

Return a handle identifying a logical brush that corresponds 
to the specified color index. See the color contants above.

Example: COLOR_BTNFACE

=cut

my $rsGetSysColorBrush = new Win32::API("user32", "GetSysColorBrush", "N", "N");
sub GetSysColorBrush {
    my ($color) = @_;

    return( $rsGetSysColorBrush->Call($color) );
    }





=head2 GetSysColor($color)

Return the current color of the specified display element. 
Display elements are the parts of a window and the Windows 
display that appear on the system display screen. 

Example: COLOR_BTNFACE

=cut

my $rsGetSysColor = new Win32::API("user32", "GetSysColor", "N", "N");
sub GetSysColor {
    my ($color) = @_;

    return( $rsGetSysColor->Call($color) );
    }





=head2 GetAsyncKeyState($keyCode)

Retrieve the status of the specified virtual key. The status 
specifies whether the key is up, down, or toggled (on, off--
alternating each time the key is pressed). 

$keyCode -- If a..z0..9, use the ASCII code. Otherwise, use 
a virtual key code. Example: VK_SHIFT

Return 1 if the key is depressed, 0 if it's not.

=cut

my $rsGetAsyncKeyState = new Win32::API("user32", "GetAsyncKeyState", "N", "I");
sub GetAsyncKeyState {
    my ($keyCode) = @_;

    my $ret = $rsGetAsyncKeyState->Call($keyCode);
print $ret;
    return( $ret & 1 );
    }





=head2 GetKeyboardState()

Return array ref with the status of the 256 virtual keys. 

The index in the array is the virtual key code. If the value 
is true, that key is depressed. Caps-Lock keys etc. indicate the 
current state.

=cut

my $rsGetKeyboardState = new Win32::API("user32", "GetKeyboardState", "P", "I");
sub GetKeyboardState {

    my $buf = " " x 256;
    $rsGetKeyboardState->Call($buf) or return([]);
    
    my @aState = map { $_ & 128 } unpack("C256", $buf);

    return( \@aState );
    }





=head2 DrawFrameControl($dcDev, $left, $top, $right, $bottom, $type, $state)

Draw a frame control of the specified type and style.

$dcDev -- Identifies the device context of the window in 
which to draw the control.

Return 1 if the key is depressed, 0 if it's not.

=cut

my $rsDrawFrameControl = new Win32::API("user32", "DrawFrameControl", "NPII", "I");
sub DrawFrameControl {
    my ($dcDev, $left, $top, $right, $bottom, $type, $state) = @_;

    my $rect = pack("llll", $left, $top, $right, $bottom);
    my $ret = $rsDrawFrameControl->Call($dcDev->{-handle}, $rect, $type, $state);

    return( $ret );
    }





=head2 DrawIcon($dcDev, $left, $top, $icoIcon)

Draw $bmBitmapIcon on $dcDev at $left, $top.

$dcDev -- Identifies the device context of the window in 
which to draw.

$icoIcon -- Win32::GUI::Icon object.

Note: This is untested, but could very well work :)

Return 1 if the key is depressed, 0 if it's not.

=cut

my $rsDrawIcon = new Win32::API("user32", "DrawIcon", "NNNN", "I");
sub DrawIcon {
    my ($dcDev, $left, $top, $icoIcon) = @_;

    my $ret = $rsDrawIcon->Call($dcDev->{-handle}, int($left), int($top), $icoIcon->{-handle});

    return( $ret );
    }





=head2 SetBrushOrgEx($dcDev, $left, $top)

Set the brush origin to $left, $top.

Return two element array with the old origin, or () on 
errors.

=cut

my $rsSetBrushOrgEx = new Win32::API("gdi32", "SetBrushOrgEx", "NNNP", "I") or die();
sub SetBrushOrgEx {
    my ($dcDev, $left, $top) = @_;

    my $old = "  " x 2;
    $rsSetBrushOrgEx->Call($dcDev->{-handle}, $left, $top, $old) or return();
    my @aRet = unpack("LL", $old);

    return(@aRet);
    }





=head2 LockWindowUpdate([$winWindow = 0])

Disable or reenables drawing in the specified window. Only 
one window can be locked at a time. 

$winWindow -- Specifies the window in which drawing will be 
disabled. If not passed (or 0), drawing in the locked window 
is enabled.

Return 1 on success, else 0.

=cut

my $rsLockWindowUpdate = new Win32::API("user32", "LockWindowUpdate", "N", "I");
sub LockWindowUpdate {
    my ($winWindow) = @_;
    defined($winWindow) or $winWindow = 0;

    my $hwind = ($winWindow == 0) ? 0 : $winWindow->{-handle};
    my $ret = $rsLockWindowUpdate->Call($hwind);

    return( $ret );
    }





1;





#EOF
