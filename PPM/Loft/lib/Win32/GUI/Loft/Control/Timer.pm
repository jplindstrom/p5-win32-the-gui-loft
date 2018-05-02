=head1 NAME Win32::GUI::Loft::Control::Timer - A Timer control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::Timer;
use base qw( Win32::GUI::Loft::Control::Intangible );





use strict;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "timTimer".

Readonly.

=cut
sub nameDefault {
    my $self = shift; my $pkg = ref($self);
	return("timTimer");
	}





=head2 type

The control's type name.

E.g. "Timer".

Readonly.

=cut
sub type {
    my $self = shift; my $pkg = ref($self);
	return("Timer");
	}





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut
sub addMethod {
    my $self = shift; my $pkg = ref($self);
	return("AddTimer");
	}





=head2 buildControlPhase

Whether the control should be built during the "control" 
phase.

Default: 0

Readonly.

=cut
sub buildControlPhase {
    my $self = shift; my $pkg = ref($self);
	return(0);
	}





=head2 buildPostControlPhase

Whether the control should be built after the "control" 
phase.

Default: 1

Readonly.

=cut
sub buildPostControlPhase {
    my $self = shift; my $pkg = ref($self);
	return(1);
	}





=head1 METHODS

=head2 new()

Create new Control object.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;

	my $self = $pkg->SUPER::new();

	#Redefine properties
#	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
#			"Name", "", [], "", ""));

	#New properties
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Interval", "1000", [], "", ""));

	return($self);
	}





=head2 buildAdd($objDesign, $objControlContainerDefault, $objInspector)

Create Win32::GUI control and add it to it's container
object, or to $objControlContainerDefault if it doesn't have
one.

If the container object doesn't exist, create it first.

[implementation note: currently, only the
$objControlContainerDefault is used as container]

Return the new control object, or undef on errors.

=cut
sub buildAdd {
    my $self = shift; my $pkg = ref($self);
	my ($objDesign, $objControlContainerDefault, $objInspector) = @_;

##todo: Implement the container object stuff
##Meanwhile, always use the
	my $objContainer = $objControlContainerDefault;

	##todo: pass this to the inspector somehow,
	#		probably in a new (generic?) method
	my $objNew = $objContainer->AddTimer(
			$self->prop("Name"),
			$self->prop("Interval")
			);

	return($objNew);
	}





1;





#EOF
