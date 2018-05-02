=head1 NAME

Win32::GUI::Loft::Control::Toolbar - A Toolbar control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::Toolbar;
use base qw( Win32::GUI::Loft::Control );





use strict;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "lblToolbar".

Readonly.

=cut
sub nameDefault {
    my $self = shift; my $pkg = ref($self);
	return("tbToolbar");
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





=head2 alignDefault

The default align option for control type.

Example: "left"

Readonly.

=cut
sub alignDefault {
    my $self = shift; my $pkg = ref($self);
	return("left");
	}





=head2 offsetTextLeft

The offset from the left side of the control that texts
should be located for this type of control.

=cut
sub offsetTextLeft {
    my $self = shift; my $pkg = ref($self);
	return(0);
	}





=head2 offsetTextTop

The offset from the top side of the control that texts
should be located for this type of control.

=cut
sub offsetTextTop {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{offsetTextTop} = $val;
		}

	return($self->{offsetTextTop});
	}





=head2 type

The control's type name.

E.g. "Toolbar".

Readonly.

=cut
sub type {
    my $self = shift; my $pkg = ref($self);
	return("Toolbar");
	}





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut
sub addMethod {
    my $self = shift; my $pkg = ref($self);
	return("AddToolbar");
	}





=head2 noButtons

The number of buttons defined in the Buttons control
property.

Readonly;

=cut
sub noButtons {
    my $self = shift; my $pkg = ref($self);
	return(scalar($self->aButtonText()));
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
			"Width", 80));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Height", 16));

	#New properties
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Tabstop", 0, [ 0, 1 ], undef, ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"BitmapWidth", 16, [], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"BitmapHeight", 15, [], "", ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Bitmap", "", [], "", ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Buttons", "", [], "", ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Flat", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Nodivider", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Multiline", 0, [ 0, 1 ], undef, ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Valign", "top", [ "top", "bottom" ], undef, ""));


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

	if($self->prop("Valign") eq "bottom") {				#Top is default
		push(@aOption, ("-addstyle", 0x00000003));		#CCS_BOTTOM
		}

	return(@aOption);
	}





=head2 buildMethodsSpecial($objNew, $objDesign)

Set all properties on the $objNew that wasn't set using an
option.

Return 1 on success, else 0.

=cut
sub buildMethodsSpecial {
    my $self = shift; my $pkg = ref($self);
	my ($objNew, $objDesign) = @_;


	if($self->prop("BitmapWidth") > 0 && $self->prop("BitmapHeight") > 0) {
		$objNew->SetBitmapSize(
				$self->prop("BitmapWidth"),
				$self->prop("BitmapHeight")
				);
		}


	if($self->prop("Bitmap") ne "" && $self->prop("Buttons") ne "") {
		if((my $noButtons = $self->noButtons()) > 0) {
			my $bmBitmap = $objDesign->rhBitmap()->{ $self->prop("Bitmap") };
			$objNew->AddBitmap($bmBitmap, $noButtons);
			}
		}


	if($self->prop("Buttons") ne "") {
		my @aButton;

		my $i = 0;
		for my $buttonText ($self->aButtonText()) {
			my ($id, $state, $style, $string) = split(/,\s*/, $buttonText, 4);
			defined($id) or $id = $i;
			defined($state) or $state = 4;		#Some constant
			defined($style) or $state = 0;
			defined($string) or $string = "";

			push(@aButton, ($i, $id, $state, $style, $string));

			$i++;
			}

		$objNew->AddButtons($self->noButtons(), @aButton) if($i > 0);
		}

	return(1);
	}





=head2 paint($dcDev, $rhBrush, $objDesign, $rhPosCache)

Paint the control in the $dcDev.

Return 1 on success, else 0.

=cut
sub paint {
    my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $objDesign, $rhPosCache) = @_;

	return(1) if(!$self->designIsVisible());

	##Draw Toolbar
	$dcDev->BkMode(1);

	#Top line
	$dcDev->SelectObject($rhBrush->{whiteBrush});
	$dcDev->SelectObject($rhBrush->{grayPen});

    $dcDev->MoveTo(
    		$rhPosCache->{left},
    		$rhPosCache->{top});
    $dcDev->LineTo(
    		$rhPosCache->{left} + $rhPosCache->{width} - 1,
    		$rhPosCache->{top});
    $dcDev->SelectObject($rhBrush->{whitePen});
    $dcDev->MoveTo(
    		$rhPosCache->{left},
    		$rhPosCache->{top} + 1);
    $dcDev->LineTo(
    		$rhPosCache->{left} + $rhPosCache->{width} - 1,
    		$rhPosCache->{top} + 1);


	$self->offsetTextTop(0);
	$self->paintName($dcDev, $rhBrush, $rhPosCache);

	$self->offsetTextTop(7);
	if($self->prop("Bitmap")) {
		$self->paintBitmap($dcDev, $rhBrush, $rhPosCache, $objDesign);
		}


	return(1);
	}





=head2 aButtonText()

Return array with the text of the buttons defined in the
Buttons control property.

=cut
sub aButtonText {
    my $self = shift; my $pkg = ref($self);

	return(split( /;\s*/, $self->prop("Buttons") ));
	}





1;





#EOF
