=head1 NAME Win32::GUI::Loft::Control::Intangible - A Intangible control

=head1 DESCRIPTION

This control removes all references to positional operations 
and provides the proper return value for the changed 
methods. Some properties are removed.

Inherit from this for intangible controls, e.g. Timer, 
ImageList etc.

This class is for all practical purposes abstract.

=cut





package Win32::GUI::Loft::Control::Intangible;
use base qw( Win32::GUI::Loft::Control );





use strict;





=head1 PROPERTIES

=head2 designIsTangible

Whether the control has the ability to be drawn in the 
Design window.

Default: 1

Readonly.

=cut
sub designIsTangible { my $self = shift; my $pkg = ref($self);
	return(0);
	}





=head1 METHODS

=head2 new()

Create new Control object.

=cut
sub new { my $pkg = shift; $pkg = ref($pkg) || $pkg;
	
	my $self = $pkg->SUPER::new();
	
	#Remove properties
	delete $self->rhControlProperty()->{"Visible"};
	delete $self->rhControlProperty()->{"Enable"};
	delete $self->rhControlProperty()->{"Left"};
	delete $self->rhControlProperty()->{"Top"};
	delete $self->rhControlProperty()->{"Width"};
	delete $self->rhControlProperty()->{"Height"};

	delete $self->rhControlProperty()->{"ResizeH"};
	delete $self->rhControlProperty()->{"ResizeHMod"};
	delete $self->rhControlProperty()->{"ResizeHValue"};
	delete $self->rhControlProperty()->{"ResizeV"};
	delete $self->rhControlProperty()->{"ResizeModV"};
	delete $self->rhControlProperty()->{"ResizeVValue"};
		
	return($self);
	}





=head2 isClicked($left, $top)

Return 1 if the coords are within the control, else 0.

=cut
sub isClicked { my $self = shift; my $pkg = ref($self);
	my ($left, $top) = @_;

	return(0);
	}





=head2 isClickedSelected($left, $top, $leftSel, $topSel)

Return 1 if the coords are within a selected box located at
$leftSel, $topSel, else return 0.

=cut
sub isClickedSelected { my $self = shift; my $pkg = ref($self);
	my ($left, $top, $leftSel, $topSel) = @_;

	return(0);
	}





=head2 clickedSelectCorner($left, $top)

Return corner index if the coords are within the control's
selected boxes.

	-1: No
  	 0: Bottom right
	 1: Bottom left
	 2: Top left
	 3: Top right

=cut
sub clickedSelectCorner { my $self = shift; my $pkg = ref($self);
	my ($left, $top) = @_;

	return(-1);
	}





=head2 isTouchedByRect($left, $top, $right, $bottom)

Return 1 if the control is within or touched by the
rectangle, else 0.

=cut
sub isTouchedByRect { my $self = shift; my $pkg = ref($self);
	my ($left, $top, $right, $bottom) = @_;

	return(0);
	}





=head2 propIncSnap($propertyName, $propertyValue, $snap)

Increase the value of $propertyName, snapping to a multiple
of $snap (if $snap != 0).

Return undef if the property doesn't exist.

=cut
sub propIncSnap { my $self = shift; my $pkg = ref($self);
	my ($propertyName, $val, $snap) = @_;

	return(undef);
	}





=head2 rhPosCache()

Return hash ref with a snapshot of the positional
properties, used for cashing the expensive lookups.

=cut
sub rhPosCache { my $self = shift; my $pkg = ref($self);
	return({});
	}





=head2 paint($dcDev, $rhBrush, $objDesign, $rhPosCache)

Paint the control in the $dcDev.

Return 1 on success, else 0.

=cut
sub paint { my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $objDesign, $rhPosCache) = @_;

	return(1);
	}





=head2 paintText($dcDev, $rhBrush, $rhPosCache)

Paint the Text property on the control if there is one.

Return 1 on success, else 0.

=cut
sub paintText { my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $rhPosCache) = @_;

	return(1);
	}





=head2 paintName($dcDev, $rhBrush, $rhPosCache)

Paint the Name property on the control if there is one.

Return 1 on success, else 0.

=cut
sub paintName { my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $rhPosCache) = @_;

	return(1);
	}





=head2 paintTextGeneric($dcDev, $rhBrush, $rhPosCache, $text)

Paint the $text property on the control.

Return 1 on success, else 0.

=cut
sub paintTextGeneric { my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $rhPosCache, $text) = @_;

	return(1);
	}





=head2 paintBitmap($dcDev, $rhBrush, $rhPosCache, $objDesign)

Paint the $bmBitmap on the control.

Return 1 on success, else 0.

=cut
sub paintBitmap { my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $rhPosCache, $objDesign) = @_;

	return(1);
	}





=head2 paintSelected($dcDev, $rhBrush, $rhPosCache)

Paint selection-markers on the control if
designIsSelected().

Return 1 on success, else 0.

=cut
sub paintSelected { my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $rhPosCache) = @_;

	return(1);
	}





1;





#EOF