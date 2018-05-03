=head1 NAME

Win32::GUI::BorderlessWindow -- Win32::GUI::Window without 
borders of any kind.

=head1 DESCRIPTION



=cut





package Win32::GUI::BorderlessWindow;





use strict;

use Win32::GUI;





=head1 METHODS

=head2 new(%hOption)

Create a Win32::GUI::Window without borders. Other than 
this, it's a regular Window object.

=cut

sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;
    my (%hOption) = @_;

    $hOption{-style} =
            0x80000000 |        #WS_POPUP
            0;
    
    return(Win32::GUI::Window->new(%hOption));
    }





1;





#EOF
