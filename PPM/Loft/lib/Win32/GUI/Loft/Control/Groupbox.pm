=head1 NAME Win32::GUI::Loft::Control::Groupbox - A Groupbox control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::Groupbox;
use base qw( Win32::GUI::Loft::Control );





use strict;

use Win32::GUI::AdHoc;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "rbGroupbox".

Readonly.

=cut
sub nameDefault {
    my $self = shift; my $pkg = ref($self);
	return("gbGroupbox");
	}





=head2 alignDefault

The default align option for control type.

Example: "left"

Readonly.

=cut
sub alignDefault {
    my $self = shift; my $pkg = ref($self);
	return("left");
	}





=head2 valignDefault

The default valign option for control type.

Example: "top"

Readonly.

=cut
sub valignDefault {
    my $self = shift; my $pkg = ref($self);
	return("top");
	}





=head2 bkModeDefault

The default value for the BkMode when it isn't obvious it 
should be transparent. 1|2.

Readonly.

=cut
sub bkModeDefault {
    my $self = shift; my $pkg = ref($self);
	return(2);
	}





=head2 type

The control's type name.

E.g. "Groupbox".

Readonly.

=cut
sub type {
    my $self = shift; my $pkg = ref($self);
	return("Groupbox");
	}





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut
sub addMethod {
    my $self = shift; my $pkg = ref($self);
	return("AddGroupbox");
	}





=head2 offsetTextLeft

The offset from the left side of the control that texts
should be located for this type of control.

=cut
sub offsetTextLeft {
    my $self = shift; my $pkg = ref($self);
	return(9);
	}





=head2 offsetTextTop

The offset from the top side of the control that texts 
should be located for this type of control.

=cut
sub offsetTextTop {
    my $self = shift; my $pkg = ref($self);
	return(0);
	}





=head1 METHODS

=head2 new()

Create new Control object.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;

	my $self = $pkg->SUPER::new();

	#New defaults
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Width", 100));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Height", 50));

	#New properties
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Tabstop", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Text", ""));
#	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
#			"Groupstart", 0, [ 0, 1 ], "", ""));

	return($self);
	}





=head2 paint($dcDev, $rhBrush, $objDesign, $rhPosCache)

Paint the control in the $dcDev.

Return 1 on success, else 0.

=cut
sub paint {
    my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $objDesign, $rhPosCache) = @_;

	return(1) if(!$self->designIsVisible());

	my $check = $self->prop("Checked") ? 0x0400 : 0;		#DFCS_CHECKED            
	
	#Draw Groupbox
	$dcDev->DrawEdge(
			$rhPosCache->{left},
			$rhPosCache->{top} + 6,
			$rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top} + $rhPosCache->{height},
			0x0002 | 0x0004					#BDR_SUNKENOUTER | BDR_RAISEDINNER
			);

#	$dcDev->BkMode(1);
	$self->paintText($dcDev, $rhBrush, $rhPosCache);
#	$self->paintSelected($dcDev, $rhBrush, $rhPosCache);

	return(1);
	}





1;





#EOF
