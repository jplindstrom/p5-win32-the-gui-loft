=head1 NAME Win32::GUI::Loft::Control::Radiobutton - A Radiobutton control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::Radiobutton;
use base qw( Win32::GUI::Loft::Control );





use strict;

use Win32::GUI::AdHoc;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "rbRadiobutton".

Readonly.

=cut
sub nameDefault {
    my $self = shift; my $pkg = ref($self);
	return("rbRadiobutton");
	}





=head2 type

The control's type name.

E.g. "Radiobutton".

Readonly.

=cut
sub type {
    my $self = shift; my $pkg = ref($self);
	return("Radiobutton");
	}





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut
sub addMethod {
    my $self = shift; my $pkg = ref($self);
	return("AddRadioButton");
	}





=head2 offsetTextLeft

The offset from the left side of the control that texts
should be located for this type of control.

=cut
sub offsetTextLeft {
    my $self = shift; my $pkg = ref($self);
	return(18);
	}





=head2 offsetTextRight

The offset from the right side of the control that texts
should be located for this type of control.

=cut
sub offsetTextRight {
    my $self = shift; my $pkg = ref($self);
	return(2);
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
			"Height", 20));

	#New properties
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Tabstop", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Text", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Align", "left", [ "left", "right" ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Checked", 0, [ 0, 1 ], "", undef));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Groupstart", 0, [ 0, 1 ], "", ""));

##notdone: valign, doesn't seem to work with expected values

	return($self);
	}





=head2 buildOptionsSpecial($objDesign)

Return array with special (particular to this control) 
options for the creation of the control.

Return an empty array on errors.

=cut
sub buildOptionsSpecial {
    my $self = shift; my $pkg = ref($self);
	my ($objDesign) = @_;
	my @aOption;

	if($self->prop("Groupstart")) {
		push(@aOption, ("-addstyle", 0x00020000));		#WS_GROUP
		}

	return(@aOption);
	}





=head2 paint($dcDev, $rhBrush, $objDesign)

Paint the control in the $dcDev.

Return 1 on success, else 0.

=cut
sub paint {
    my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $objDesign) = @_;


	return(1) if(!$self->designIsVisible());

	my $rhPosCache = $self->rhPosCache();		#Cache the expensive prop lookups

	my $offsetVert = int(($rhPosCache->{height} / 2) - 12);
	
	my $check = $self->prop("Checked") ? 0x0400 : 0;		#DFCS_CHECKED            
	
	#Enable
	my $enable = 0;
	$enable = 0x0100 if(!$self->prop("Enable"));			#DFCS_INACTIVE           
	
	
	#Draw Radiobutton
	Win32::GUI::AdHoc::DrawFrameControl($dcDev,
			$rhPosCache->{left} + 1,
			$rhPosCache->{top} + 4 + $offsetVert,
			$rhPosCache->{left} + 13,
			$rhPosCache->{top} + 19 + $offsetVert,
			4,							#define DFC_BUTTON
			0x0004 | $check | $enable	#DFCS_BUTTONRADIO
			);

	$dcDev->BkMode(1);

	$self->paintText($dcDev, $rhBrush, $rhPosCache);
#	$self->paintSelected($dcDev, $rhBrush, $rhPosCache);

	return(1);
	}





1;





#EOF
