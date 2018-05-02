=head1 NAME Win32::GUI::Loft::Control::RichEdit - A RichEdit control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::RichEdit;
use base qw( Win32::GUI::Loft::Control );





use strict;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "reRichEdit".

Readonly.

=cut
sub nameDefault {
    my $self = shift; my $pkg = ref($self);
	return("reRichEdit");
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





=head2 offsetTextLeft

The offset from the left side of the control that texts
should be located for this type of control.

=cut
sub offsetTextLeft {
    my $self = shift; my $pkg = ref($self);
	return(3);
	}





=head2 type

The control's type name.

E.g. "RichEdit".

Readonly.

=cut
sub type {
    my $self = shift; my $pkg = ref($self);
	return("RichEdit");
	}





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut
sub addMethod {
    my $self = shift; my $pkg = ref($self);
	return("AddRichEdit");
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
			"Tabstop", 1, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Text", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Align", "left", [ "", "left", "center", "right" ], "", ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ScrollV", 0, [ 0, 1 ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ScrollH", 0, [ 0, 1 ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ScrollAutoV", 0, [ 0, 1 ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ScrollAutoH", 0, [ 0, 1 ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Keepselection", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Multiline", 1, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Password", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Readonly", 0, [ 0, 1 ], undef, ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"WantReturn", 1, [ 0, 1 ], "", ""));

##todo: Scroll things and other flags

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

	if($self->prop("Align") || "" ne "") {
		push(@aOption, ("-align", $self->prop("Align")));
		}

	if($self->prop("ScrollV")) {
		push(@aOption, ("-addstyle", 0x00200000));		#WS_VSCROLL
		}
	if($self->prop("ScrollH")) {
		push(@aOption, ("-addstyle", 0x00100000));		#WS_HSCROLL
		}

	if($self->prop("ScrollAutoV")) {
		push(@aOption, ("-addstyle", 0x0040));		#ES_ScrollAutoV
		}
	if($self->prop("ScrollAutoH")) {
		push(@aOption, ("-addstyle", 0x0080));		#ES_ScrollAutoH
		}

	if($self->prop("WantReturn")) {
		push(@aOption, ("-addstyle", 0x1000));		#ES_WANTRETURN
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

	#Draw RichEdit
	$dcDev->SelectObject($rhBrush->{noPen});

	#Enable
	if($self->prop("Enable")) {
		$dcDev->SelectObject($rhBrush->{whiteBrush});
		}
	else {
		$dcDev->SelectObject($rhBrush->{buttonBrush});
		}

	$dcDev->Rectangle(
			$rhPosCache->{left},
			$rhPosCache->{top},
			$rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top} + $rhPosCache->{height},
			) if($self->prop("Visible"));
	$dcDev->DrawEdge(
			$rhPosCache->{left},
			$rhPosCache->{top},
			$rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top} + $rhPosCache->{height},
			0x0002 | 0x0008,			#BDR_SUNKENOUTER | BDR_SUNKENINNER
			);
	$dcDev->BkMode(1);

	$self->paintText($dcDev, $rhBrush, $rhPosCache);
#	$self->paintSelected($dcDev, $rhBrush, $rhPosCache);

	return(1);
	}





1;





#EOF
