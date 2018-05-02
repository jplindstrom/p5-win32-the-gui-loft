=head1 NAME Win32::GUI::Loft::Control::Button - A Button control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::Button;
use base qw( Win32::GUI::Loft::Control );





use strict;

#use Data::Denter;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "btnButton".

Readonly.

=cut
sub nameDefault {
    my $self = shift; my $pkg = ref($self);
	return("btnButton");
	}





=head2 type

The control's type name.

E.g. "Button".

Readonly.

=cut
sub type {
    my $self = shift; my $pkg = ref($self);
	return("Button");
	}





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut
sub addMethod {
    my $self = shift; my $pkg = ref($self);
	return("AddButton");
	}





=head2 offsetTextRight

The offset from the right side of the control that texts
should be located for this type of control.

=cut
sub offsetTextRight {
    my $self = shift; my $pkg = ref($self);
	return(4);
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
			"Width", 60));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Height", 21));

	#New properties
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Tabstop", 1, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Text", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Align", "", [ "", "left", "center", "right" ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Valign", "", [ "", "top", "center", "bottom" ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Default", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Ok", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Cancel", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Bitmap", "", [], "", ""));

	#Missing: -icon

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

	if($self->prop("Bitmap") ne "") {
		my $bmBitmap = $objDesign->rhBitmap()->{ $self->prop("Bitmap") };
		push(@aOption, ("-bitmap", $bmBitmap)) if($bmBitmap);
		}

	if($self->prop("Align") || "" ne "") {
		push(@aOption, ("-align", $self->prop("Align")));
		}
	if($self->prop("Valign") || "" ne "") {
		push(@aOption, ("-valign", $self->prop("Valign")));
		}

	return(@aOption);
	}





=head2 paint($dcDev, $rhBrush, $objDesign, $rhPosCache)

Paint the control in the $dcDev.

Return 1 on success, else 0.

=cut
sub paint {
    my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $objDesign, $rhPosCache) = @_;

	return(1) if(!$self->designIsVisible());

	#Enable
	my $enable = 0;
	$enable = 0x0100 if(!$self->prop("Enable"));			#DFCS_INACTIVE           

	#Draw button
	Win32::GUI::AdHoc::DrawFrameControl($dcDev,
			$rhPosCache->{left},
			$rhPosCache->{top},
			$rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top} + $rhPosCache->{height},
			4,							#DFC_BUTTON
			0x0010 | $enable			#DFCS_BUTTONPUSH         
			);
	$dcDev->BkMode(1);

	if($self->prop("Bitmap")) {
		$self->paintBitmap($dcDev, $rhBrush, $rhPosCache, $objDesign);
		}
	else {
		$self->paintText($dcDev, $rhBrush, $rhPosCache);
		}
	
	
#	$self->paintSelected($dcDev, $rhBrush, $rhPosCache);

	return(1);
	}





1;





#EOF
