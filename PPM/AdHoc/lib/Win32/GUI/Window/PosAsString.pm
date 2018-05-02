=head1 NAME

Win32::GUI::Window::PosAsString -- Add methods to
Win32::GUI::Window to serialize the size and location of
windows and it's contained controls.


=head1 DESCRIPTION

The Win32::GUI::Window::PosAsString class can help you deal
with storing/restoring a window's size and location.


=head1 VERSION

r2001-10-07 -- v0.01


=head1 SYNOPSIS

    use strict;
    use Win32::GUI::Window::PosAsString;

=cut





package Win32::GUI::Window::PosAsString;





use strict;
use Data::Dumper;





=head1 PROPERTIES

=head2 $winWindow->PosAsString([$strPos]);

$winWindow -- A Win32::GUI::Window object.

$strPos -- If passed, set the size + location of $winWindow 
to $strPos. $strPos was probably created by this method.

Return string representing the current size + location of 
$winWindow, or "" on errors.

=cut
sub Win32::GUI::Window::PosAsString {
    my $self = shift;
    my ($strPos) = @_;

	if(defined($strPos)) {
		my $VAR1; my $rhSelf = eval($strPos);
		return("") if($@);
		
		$self->Resize($rhSelf->{Width}, $rhSelf->{Height});
		$self->Move($rhSelf->{Left}, $rhSelf->{Top});
		}
		
	my $rhSelf = {
		Left => $self->Left(), Top => $self->Top(),
		Width => $self->Width(), Height => $self->Height(),
		rhControl => {},
		};
	$strPos = Dumper($rhSelf); $strPos =~ s{\s+}{ }gs;
	
    return($strPos);
    }





1;





=head1 COPYRIGHT

Copyright 2001.. Johan Lindström <johanl@bahnhof.se>

This program is free software; you can redistribute it and/or modify it
under the GPL-2.0

=cut





#EOF
