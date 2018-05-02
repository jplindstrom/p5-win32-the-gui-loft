=head1 NAME

Loft -- Main package

=cut





package Win32::GUI::Loft;
require Exporter;
@ISA = qw( Exporter );
@EXPORT_OK = qw( tglApp );





$VERSION = '0.13';

use strict;
use warnings;
require 5.005_62;


use Win32::GUI::Loft::Design;





=head1 GLOBAL VARIABLES

=head2 %Win32::GUI::Loft::window

Hash with (key = window Name property, value = Win32::GUI 
window object).

All Win32::GUI windows that are created by Win32::GUI::Loft::Design are 
placed in this hash. Use it to reference your window from 
anywhere.

=cut
my %window = ();





=head2 %Win32::GUI::Loft::design

Hash with (key = window Name property, value = Win32::GUI::Loft::Design 
object).

All Win32::GUI windows that are created by Win32::GUI::Loft::Design have 
a corresponding Win32::GUI::Loft::Design object that is placed in this 
hash. Use it to reference your Design object from anywhere.

=cut
my %design = ();





=head1 UTILITY ROUTINES

=head2 Win32::GUI::Loft::tglApp($nameWindow)

Return three-value array with the ($win, $design, $app) that 
corresponds to $nameWindow, or return () if $nameWindow 
isn't a built TGL window.

=cut
sub tglApp {
    my ($nameWindow) = @_;
    
    my $win = $Win32::GUI::Loft::window{$nameWindow} or return();
    my $design = $Win32::GUI::Loft::design{$nameWindow} or return();
    my $app = $design->objApp();

    return($win, $design, $app);
    }





1;





#EOF