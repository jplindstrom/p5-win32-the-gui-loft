=head1 NAME Win32::GUI::Loft::Control::Splitter - A Splitter control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::Splitter;
use base qw( Win32::GUI::Loft::Control );





use strict;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "splSplitter".

Readonly.

=cut
sub nameDefault { my $self = shift; my $pkg = ref($self);
	return("splSplitter");
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

E.g. "Splitter".

Readonly.

=cut
sub type { my $self = shift; my $pkg = ref($self);
	return("Splitter");
	}





=head2 addMethod

The name of the AddXxxx() method to use when adding this 
control to a container object.

Readonly

=cut
sub addMethod { my $self = shift; my $pkg = ref($self);
	return("AddSplitter");
	}





=head1 METHODS

=head2 new()

Create new Control object.

=cut
sub new { my $pkg = shift; $pkg = ref($pkg) || $pkg;
	
	my $self = $pkg->SUPER::new();
		
	#New defaults
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Width", 4));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Height", 100));

	#New properties	
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Horizontal", 0, [ 0, 1 ], undef, ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Max", -1));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Min", -1));
	
	return($self);
	}





=head2 paint($dcDev, $rhBrush, $objDesign, $rhPosCache)

Paint the control in the $dcDev.

Return 1 on success, else 0.

=cut
sub paint { my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $objDesign, $rhPosCache) = @_;
	
	return(1) if(!$self->designIsVisible());
	
	#Draw Splitter
	$dcDev->SelectObject($rhBrush->{noPen});
	$dcDev->SelectObject($rhBrush->{whiteBrush});
#	$dcDev->Rectangle(
#			$rhPosCache->{left} + 1, 
#			$rhPosCache->{top} + 1, 
#			$rhPosCache->{left} + $rhPosCache->{width} - 1,
#			$rhPosCache->{top} + $rhPosCache->{height} - 1,
#			) if($self->prop("Visible"));

#	$dcDev->DrawEdge(
#			$rhPosCache->{left} + 1,
#			$rhPosCache->{top} + 1,
#			$rhPosCache->{left} + $rhPosCache->{width} - 1,
#			$rhPosCache->{top} + $rhPosCache->{height} - 1,
#			0x0002 | 0x0008,			#BDR_SUNKENOUTER | BDR_SUNKENINNER 
#			);
	$dcDev->BkMode(1);
		
	$dcDev->SelectObject($rhBrush->{whiteBrush});	
	$dcDev->Rectangle(
			$rhPosCache->{left},
			$rhPosCache->{top},
			$rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top} + $rhPosCache->{height},
			);


	$self->paintName($dcDev, $rhBrush, $rhPosCache);

		
	return(1);
	}





1;





#EOF