=head1 NAME Win32::GUI::Loft::Control::ProgressBar - A ProgressBar control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::ProgressBar;
use base qw( Win32::GUI::Loft::Control );





use strict;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "pbProgressBar".

Readonly.

=cut
sub nameDefault { my $self = shift; my $pkg = ref($self);
	return("pbProgressBar");
	}





=head2 valignDefault

The default valign option for control type.

Example: "top"

Readonly.

=cut
sub valignDefault { my $self = shift; my $pkg = ref($self);
	return("top");
	}





=head2 type

The control's type name. 

E.g. "ProgressBar".

Readonly.

=cut
sub type { my $self = shift; my $pkg = ref($self);
	return("ProgressBar");
	}





=head2 addMethod

The name of the AddXxxx() method to use when adding this 
control to a container object.

Readonly

=cut
sub addMethod { my $self = shift; my $pkg = ref($self);
	return("AddProgressBar");
	}





=head1 METHODS

=head2 new()

Create new Control object.

=cut
sub new { my $pkg = shift; $pkg = ref($pkg) || $pkg;
	
	my $self = $pkg->SUPER::new();
		
	#New defaults
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Width", 80));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Height", 20));

	#New properties	
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Tabstop", 0, [ 0, 1 ], undef, ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Smooth", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Vertical", 0, [ 0, 1 ], undef, ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Pos", 0, [], "", "SetPos"));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Step", 1, [], "", "SetStep"));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"RangeMin", 0, [], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"RangeMax", 99, [], "", ""));
	
	
	return($self);
	}





=head2 buildMethodsSpecial($objNew, $objDesign)

Set all properties on the $objNew that wasn't set using an 
option.

Return 1 on success, else 0.

=cut
sub buildMethodsSpecial { my $self = shift; my $pkg = ref($self);
	my ($objNew, $objDesign) = @_;

#	if($self->prop("Bitmap") ne "") {
#		my $bmBitmap = $objDesign->rhBitmap()->{ $self->prop("Bitmap") };
#		$objNew->SetImage($bmBitmap);
#		}

	return(1);
	}





=head2 paint($dcDev, $rhBrush, $objDesign, $rhPosCache)

Paint the control in the $dcDev.

Return 1 on success, else 0.

=cut
sub paint { my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $objDesign, $rhPosCache) = @_;
	
	return(1) if(!$self->designIsVisible());
	
	#Draw ProgressBar
	$dcDev->SelectObject($rhBrush->{noPen});
	$dcDev->SelectObject($rhBrush->{whiteBrush});
	$dcDev->BkMode(1);

		
	$dcDev->SelectObject($rhBrush->{grayPen});
    $dcDev->MoveTo($rhPosCache->{left}, 
    		$rhPosCache->{top} + $rhPosCache->{height});
    $dcDev->LineTo(
    		$rhPosCache->{left}, 
    		$rhPosCache->{top});
    $dcDev->LineTo(
    		$rhPosCache->{left} + $rhPosCache->{width} - 1, 
    		$rhPosCache->{top});
    		
    $dcDev->SelectObject($rhBrush->{whitePen});
    $dcDev->LineTo(
    		$rhPosCache->{left} + $rhPosCache->{width} - 1, 
    		$rhPosCache->{top} + $rhPosCache->{height} - 1);
    $dcDev->LineTo(
    		$rhPosCache->{left}, 
    		$rhPosCache->{top} + $rhPosCache->{height} - 1);
    
#					$rhPosCache->{left} + $rhPosCache->{width},
#					$rhPosCache->{top} + $rhPosCache->{height},
	
	$self->offsetTextLeft(1);
	$self->offsetTextRight(1);
	$self->offsetTextTop(1);

	$self->paintName($dcDev, $rhBrush, $rhPosCache);
		
	return(1);
	}





1;





#EOF