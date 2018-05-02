=head1 NAME Win32::GUI::Loft::Control::Combobox - A Combobox control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::Combobox;
use base qw( Win32::GUI::Loft::Control );





use strict;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "btnButton".

Readonly.

=cut
sub nameDefault {
    my $self = shift; my $pkg = ref($self);
	return("cbCombobox");
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

E.g. "Combobox".

Readonly.

=cut
sub type {
    my $self = shift; my $pkg = ref($self);
	return("Combobox");
	}





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut
sub addMethod {
    my $self = shift; my $pkg = ref($self);
	return("AddCombobox");
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
			"Height", 60));

	#New properties
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Tabstop", 1, [ 0, 1 ], undef, ""));
#	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
#			"Text", ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Type", "drop combo",
			[ "drop combo", "drop list", "simple combo" ],
			"", ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"AutoHScroll", 0, [ 0, 1 ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ScrollV", 0, [ 0, 1 ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ScrollH", 0, [ 0, 1 ], "", ""));
						
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"DisableNoScroll", 0, [ 0, 1 ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"OEMConvert", 0, [ 0, 1 ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Case", "", [ "", "upper", "lower" ], "", ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Sort", 0, [ 0, 1 ], "", ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"PreviewList", "", undef, "", ""));


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

	if($self->prop("Type") eq "drop combo") {
		push(@aOption, ("-addstyle", 0x0002));		#CBS_DROPDOWN	
		}
	if($self->prop("Type") eq "drop list") {
		push(@aOption, ("-addstyle", 0x0003));		#CBS_DROPDOWNLIST
		}
	if($self->prop("Type") eq "simple combo") {
		push(@aOption, ("-addstyle", 0x0001));		#CBS_SIMPLE
		}

	if($self->prop("Sort")) {
		push(@aOption, ("-addstyle", 0x0100));		#CBS_SORT
		}
	if($self->prop("AutoHScroll")) {
		push(@aOption, ("-addstyle", 0x0040));		#CBS_AUTOHSCROLL
		}
		
	if($self->prop("ScrollV")) {
		push(@aOption, ("-addstyle", 0x00200000));		#WS_VSCROLL
		}
	if($self->prop("ScrollH")) {
		push(@aOption, ("-addstyle", 0x00100000));		#WS_HSCROLL
		}

#	if($self->prop("ScrollAutoV")) {
#		push(@aOption, ("-addstyle", 0x0040));		#ES_ScrollAutoV
#		}
#	if($self->prop("ScrollAutoH")) {
#		push(@aOption, ("-addstyle", 0x0080));		#ES_ScrollAutoH
#		}

		
	if($self->prop("DisableNoScroll")) {
		push(@aOption, ("-addstyle", 0x0800));		#CBS_DISABLENOSCROLL
		}
	if($self->prop("OEMConvert")) {
		push(@aOption, ("-addstyle", 0x0080));		#CBS_OEMCONVERT
		}

	if($self->prop("Case") eq "upper") {
		push(@aOption, ("-addstyle", 0x2000));		#CBS_UPPERCASE
		}
	if($self->prop("Case") eq "lower") {
		push(@aOption, ("-addstyle", 0x4000));		#CBS_LOWERCASE
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

	if($objDesign->isPreview() && $self->prop("PreviewList") ne "") {
		#Parse preview text
		my @aItem = split(/;\s*/, $self->prop("PreviewList"));

		for my $item (@aItem) {
			$objNew->AddString($item);
			}
			
		#Select first item in list so we have something to look at
		$objNew->Select(0);
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


	#Draw Combobox
	$dcDev->SelectObject($rhBrush->{noPen});
	$dcDev->SelectObject($rhBrush->{whiteBrush});
	$dcDev->Rectangle(
			$rhPosCache->{left},
			$rhPosCache->{top},
			$rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top} + 21,
			) if($self->prop("Visible"));
	$dcDev->DrawEdge(
			$rhPosCache->{left},
			$rhPosCache->{top},
			$rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top} + 21,
			0x0002 | 0x0008,			#BDR_SUNKENOUTER | BDR_SUNKENINNER
			);

	if($self->prop("Type") eq "simple combo") {
		$dcDev->Rectangle(
				$rhPosCache->{left},
				$rhPosCache->{top} + 21,
				$rhPosCache->{left} + $rhPosCache->{width},
				$rhPosCache->{top} + $rhPosCache->{height},
				) if($self->prop("Visible"));
		$dcDev->DrawEdge(
				$rhPosCache->{left},
				$rhPosCache->{top} + 21,
				$rhPosCache->{left} + $rhPosCache->{width},
				$rhPosCache->{top} + $rhPosCache->{height},
				0x0002 | 0x0008,			#BDR_SUNKENOUTER | BDR_SUNKENINNER
				);
		}
	else {
		Win32::GUI::AdHoc::DrawFrameControl($dcDev,
				$rhPosCache->{left} + $rhPosCache->{width} - 21 + 3,
				$rhPosCache->{top} + 2,
				$rhPosCache->{left} + $rhPosCache->{width} - 2,
				$rhPosCache->{top} + 21 - 2,
				3,							#DFC_SCROLL
				0x0005						#DFCS_SCROLLCOMBOBOX       
				);
		}
	$dcDev->BkMode(1);

	$self->paintName($dcDev, $rhBrush, $rhPosCache);

	return(1);
	}





1;





#EOF
