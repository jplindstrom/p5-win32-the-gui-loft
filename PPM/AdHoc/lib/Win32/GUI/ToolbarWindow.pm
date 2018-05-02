=head1 NAME

Win32::GUI::ToolbarWindow -- Toolbar Window without close-X-
button or max/min.

=head1 DESCRIPTION



=cut





package Win32::GUI::ToolbarWindow;





use strict;

use Win32::GUI;





=head1 METHODS

=head2 new(%hOption)

Create a Win32::GUI::Window which is a toolbar window. No 
small buttons in the caption. Other than this, it's a 
regular Window object.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;
    my (%hOption) = @_;

    $hOption{-style} =
            0x00C00000 |        #WS_CAPTION
            0x80000000 |        #WS_POPUP
            0x00800000 |        #WS_BORDER
            0;
    $hOption{-addexstyle} = WS_EX_TOOLWINDOW;
    
    return(Win32::GUI::Window->new(%hOption));
    }





1;





#EOF
