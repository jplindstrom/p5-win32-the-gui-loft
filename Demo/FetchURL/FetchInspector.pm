=head1 NAME

FetchInspector - Used to inspect the Fetch window controls
when they get built

=cut





package FetchInspector;
use base qw( Win32::GUI::Loft::ControlInspector );





use strict;





=head1 PROPERTIES

=head1 METHODS

=head2 buildOptions($objControl, $raOption)

This method gets called during the build process before the
creation of each control.

Return array of build options which in the unmodified case
is equivalent to returning @$aOption.

$raOption contains key, value pairs that will be passed on
to the AddXXXX method to create the object. Option names may
be present many times, so you may NOT treat it as a hash.

An example of a $raOption:

	[ "-name", "winMain", "-text", "Main window" ]

You may change the contents of $raOption. You may NOT change
$objControl!

This method is subclassed to change the window and assign a
Win32::GUI::Class object (with a (probably) ugly system
color).

Use the "Name" property to identify the control.

Return the array on success, else an empty array () in which
case the control will not be created.

=cut
sub buildOptions { my $self = shift; my $pkg = ref($self);
	my ($objControl, $raOption) = @_;

	#Modify the main window
	if($objControl->prop("Name") eq "winFetch") {

		#Create a class with a certain bg color
		my $clsFetch = Win32::GUI::Class->new(
		    	-name => "classFetchMisc",
		    	-color => 2,
				) or die("Could not create Class\n");
		push(@$raOption, "-class" => $clsFetch);


		#Add an extended style (to make it a toolwindow)
		#
		#(Note that you can do this from within The GUI Loft Editor,
		#this is just to illustrate how to do this kind of thing)
		push(@$raOption, "-addexstyle" => 0x00000080);		#WS_EX_TOOLWINDOW
		}

	return(@$raOption);
	}





1;





#EOF