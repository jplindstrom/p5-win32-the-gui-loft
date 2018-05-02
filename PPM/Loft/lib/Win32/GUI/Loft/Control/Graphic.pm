=head1 NAME 

Win32::GUI::Loft::Control::Graphic - A Graphic control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::Graphic;
use base qw( Win32::GUI::Loft::Control );





use strict;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "btnButton".

Readonly.

=cut
sub nameDefault { my $self = shift; my $pkg = ref($self);
	return("grGraphic");
	}





=head2 type

The control's type name.

E.g. "Graphic".

Readonly.

=cut
sub type { my $self = shift; my $pkg = ref($self);
	return("Graphic");
	}





=head2 addMethod

If it starts with "Add", the name of the AddXxxx() method to 
use when adding this control to a container object.

If it doesn't, the class name to invoke new() on, with the 
container object as the first param.

Readonly

=cut
sub addMethod { my $self = shift; my $pkg = ref($self);
	return("Win32::GUI::Graphic");
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
			"Height", 50));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Interactive", 1, [ 0, 1 ], undef, ""));


	return($self);
	}





=head2 paint($dcDev, $rhBrush, $objDesign, $rhPosCache)

Paint the control in the $dcDev.

Return 1 on success, else 0.

=cut
sub paint { my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $objDesign, $rhPosCache) = @_;

	return(1) if(!$self->designIsVisible());

	#Draw Graphic
	$dcDev->SelectObject($rhBrush->{noBrush});
	$dcDev->SelectObject($rhBrush->{blackPen});


	$dcDev->DrawEdge(
			$rhPosCache->{left},
			$rhPosCache->{top},
			$rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top} + $rhPosCache->{height},
			1,
			0x4000 | 0x8000 | 15,	#BF_FLAT, BF_MONO, BF_LEFT, BF_TOP, BF_RIGHT, BF_BOTTOM

			);
    $dcDev->MoveTo($rhPosCache->{left},
			$rhPosCache->{top});
	$dcDev->LineTo($rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top} + $rhPosCache->{height});
    $dcDev->MoveTo($rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top});
	$dcDev->LineTo($rhPosCache->{left},
			$rhPosCache->{top} + $rhPosCache->{height});

	$dcDev->BkMode(1);

	$self->paintName($dcDev, $rhBrush, $rhPosCache);

	return(1);
	}





1;





#EOF