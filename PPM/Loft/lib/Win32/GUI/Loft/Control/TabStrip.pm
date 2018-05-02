=head1 NAME Win32::GUI::Loft::Control::TabStrip - A TabStrip control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::TabStrip;
use base qw( Win32::GUI::Loft::Control );





use strict;
use Carp qw( cluck );

use Win32::GUI;
use Win32::GUI::TabStripGroup;

use Data::Dumper;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "btnButton".

Readonly.

=cut
sub nameDefault { my $self = shift; my $pkg = ref($self);
	return("tsTabStrip");
	}





=head2 alignDefault

The default align option for control type.

Example: "left"

Readonly.

=cut
sub alignDefault { my $self = shift; my $pkg = ref($self);
	return("left");
	}





=head2 valignDefault

The default valign option for control type.

Example: "top"

Readonly.

=cut
sub valignDefault { my $self = shift; my $pkg = ref($self);
	return("top");
	}





=head2 offsetTextLeft

The offset from the left side of the control that texts
should be located for this type of control.

=cut
sub offsetTextLeft { my $self = shift; my $pkg = ref($self);
	return(0);
	}





=head2 offsetTextTop

The offset from the top side of the control that texts
should be located for this type of control.

=cut
sub offsetTextTop { my $self = shift; my $pkg = ref($self);
	return(0);
	}





=head2 type

The control's type name.

E.g. "TabStrip".

Readonly.

=cut
sub type { my $self = shift; my $pkg = ref($self);
	return("TabStrip");
	}





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut
sub addMethod { my $self = shift; my $pkg = ref($self);
	return("AddTabStrip");
	}





=head1 METHODS

=head2 new()

Create new Control object.

=cut
sub new { my $pkg = shift; $pkg = ref($pkg) || $pkg;

	my $self = $pkg->SUPER::new();

	#New defaults
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Width", 120));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Height", 100));

	#New properties
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Tabstop", 1, [ 0, 1 ], undef, ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Bottom", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Buttons", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Justify", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Multiline", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Right", 0, [ 0, 1 ], undef, ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"HotTrack", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ImageList", "", [], "", ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Tabs", "", undef, "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Clusters", "", undef, "", ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Select", "", [], "", undef));


	return($self);
	}





=head2 isUsingCluster($objCluster)

Is this control using or referencing $objCluster in the
property "Clusters"?

Default: 0

Redifine in derived classes.

=cut
sub isUsingCluster { my $self = shift; my $pkg = ref($self);
	my ($objCluster) = @_;

	my %hItem = map { $_ => 1 } split(/;\s*/, $self->prop("Clusters") || "");

	return( exists $hItem{ $objCluster->name() } ? 1 : 0);
	}





=head2 tabIndexFindByName($nameTab)

Return the index of the tab in the property "Clusters" 
that's named $nameTab, or undef if not found. The order of 
Tabs and Clusters are assumed to be the same, so the indexes 
should match.

Redefine in derived classes.

=cut
sub tabIndexFindByName { my $self = shift; my $pkg = ref($self);
	my ($nameTab) = @_;

	my @aItem = split(/;\s*/, $self->prop("Clusters"));

	my $i = 0;
	for my $item (@aItem) {
		return($i) if($item eq $nameTab);
		$i++;
		}

	return(undef);
	}





=head2 buildOptionsSpecial($objDesign)

Return array with special (particular to this control)
options for the creation of the control.

Return an empty array on errors.

=cut
sub buildOptionsSpecial { my $self = shift; my $pkg = ref($self);
	my ($objDesign) = @_;
	my @aOption;

	if($self->prop("ImageList") ne "") {
		my $ilImageList = $objDesign->rhImageList()->{ $self->prop("ImageList") };
		push(@aOption, ("-imagelist", $ilImageList)) if($ilImageList);
		}

	return(@aOption);
	}





=head2 buildMethodsSpecial($objNew, $objDesign)

Set all properties on the $objNew that wasn't set using an
option.

Return 1 on success, else 0.

=cut
sub buildMethodsSpecial { my $self = shift; my $pkg = ref($self);
	my ($objNew, $objDesign) = @_;

	if($self->prop("Tabs") || "" ne "") {
		#Parse preview text
		my @aItem = split(/;\s*/, $self->prop("Tabs"));

		for my $item (@aItem) {
			my ($textItem, $image) = ($item =~ m{^(.+?):?(\d+)?$});
			my @aImage = (($image || "") ne "") ? (-image => $image) : ();

			$objNew->InsertItem(-text =>  $textItem, @aImage );
			}
		}


	if($self->prop("Clusters") || "" ne "") {
		#Parse which clusters
		my @aItem = split(/;\s*/, $self->prop("Clusters"));

		if(@aItem) {
			#Add a Win32::GUI::TabStripGroup control to manage the tabstrip
			$objDesign->wingcTabStripGroupAdd($objNew);	#, \@aItem);

#			for my $item (@aItem) {
#
#				}
			}
		}

	return(1);
	}





=head2 buildEventHandlers($objNew, $objDesign)

Create event handler subs with appropriate behaviour for the
control.

If the sub already exists, fail.

Return 1 on success, else 0.

=cut
sub buildEventHandlers { my $self = shift; my $pkg = ref($self);
	my ($objNew, $objDesign) = @_;

	if($self->prop("Clusters") || "" ne "") {

		#Create a _Change events
		my $nameEvent = $objDesign->perlEventName($self, "Change");
		my $perlVarLoft = $objDesign->perlVarLoft() or return(0);
		my $perlVarTabStrip = $objDesign->perlVarControl($self) or return(0);
		my $perlVarTabStripGroup = $objDesign->perlVarTabStripGroup( $self ) or return(0);

		my $perl = <<EOP;
sub $nameEvent {

	$perlVarLoft

	${perlVarTabStripGroup}->showTab(
			${perlVarTabStrip}->SelectedItem()
			);

		
	return(1);
	}
EOP
		eval($perl);
		if($@) {
			warn($@);
			return(0);
			}
		}

	return(1);
	}





=head2 paint($dcDev, $rhBrush, $objDesign, $rhPosCache)

Paint the control in the $dcDev.

Return 1 on success, else 0.

=cut
sub paint { my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $objDesign, $rhPosCache) = @_;

	return(1) if(!$self->designIsVisible());


my $isScroll = 0;
my $widthScroll = 30;
my $widthTabTotal = 1;
my $widthTabTotalAdjusted = 1;
my $textOffsetLeft = 12;
my $textOffsetRight = 7;
my $textOffsetTop = 5;
my $widthButtonMin = 46;
my $heightButton = 20;


	##Draw TabStrip
	#Tabs
	my $firstInvisible = 0xFFFF;
	my @aWidth;
	if($self->prop("Tabs") || "" ne "") {
		#Parse preview text
		my @aItem = split(/;\s*/, $self->prop("Tabs"));

		my @aLeft;
		my $left = $rhPosCache->{left};
		my $widthTotal = 0;
		my $i = 0;
		for my $item (@aItem) {
			#Strip &
			$item =~ s/&//gm;
		
			my $width = $self->widthTab($item, $i, $rhBrush);
			$widthTotal += $width;
			if(0xFFFF == $firstInvisible && $widthTotal > $rhPosCache->{width}) {
				$firstInvisible = $i;
				}

			push(@aLeft, $left);
			push(@aWidth, $width);

			$left += $width;
			$i++;
			}

		$i = $#aItem;
		for my $item (reverse @aItem) {
			if($i < $firstInvisible) {
				my $offsetTop = ($i == 0) ? 0 : 2;
				Win32::GUI::AdHoc::DrawFrameControl($dcDev,
						$aLeft[$i],
						$rhPosCache->{top} + $offsetTop,
						$aLeft[$i] + $aWidth[$i],
						$rhPosCache->{top} + $heightButton + 2,
						4,							#DFC_BUTTON
						0x0010						#DFCS_BUTTONPUSH
						);

				#Paint text
				my $offsetTopText = ($i == 0) ? -2 : 0;
				my $offsetLeftText = ($i == 0) ? 0 : -4;
				$offsetLeftText += 2 if($i > 1);
				my $rhPos = {
						left	=> $aLeft[$i] + $textOffsetLeft - 4 + $offsetLeftText,
						top		=> $rhPosCache->{top} + $textOffsetTop + $offsetTopText,
						width	=> $aWidth[$i],
						height	=> $heightButton,
						};
				$self->paintTextGeneric($dcDev, $rhBrush, $rhPos, $aItem[$i]);
				}

			$i--;
			}
		}

	#Area
	Win32::GUI::AdHoc::DrawFrameControl($dcDev,
			$rhPosCache->{left},
			$rhPosCache->{top} + $heightButton,
			$rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top} + $rhPosCache->{height},
			4,							#DFC_BUTTON
			0x0010						#DFCS_BUTTONPUSH
			);

	#Touch up
	$dcDev->SelectObject($rhBrush->{buttonPen});
    $dcDev->MoveTo($rhPosCache->{left} + 1,
			$rhPosCache->{top} + $heightButton);
	$dcDev->LineTo($rhPosCache->{left} + ($aWidth[0] || 0),
			$rhPosCache->{top} + $heightButton);


	#"more arrows"
	if(0xFFFF != $firstInvisible) {
		my $widthArrow = 17;
		my $heightArrow = 18;
		Win32::GUI::AdHoc::DrawFrameControl($dcDev,
				$rhPosCache->{left} + $rhPosCache->{width} - $widthArrow,
				$rhPosCache->{top} + 1,
				$rhPosCache->{left} + $rhPosCache->{width},
				$rhPosCache->{top} + $heightArrow,
				3,							#DFC_SCROLL
				0x0003						#DFCS_SCROLLRIGHT
				);
		Win32::GUI::AdHoc::DrawFrameControl($dcDev,
				$rhPosCache->{left} + $rhPosCache->{width} - $widthArrow - $widthArrow,
				$rhPosCache->{top} + 1,
				$rhPosCache->{left} + $rhPosCache->{width} - $widthArrow,
				$rhPosCache->{top} + $heightArrow,
				3,							#DFC_SCROLL
				0x0002						#DFCS_SCROLLLEFT
				);
		}

##todo: make bottom (or rather "right", since it's broken) work

	$dcDev->BkMode(1);

	return(1);
	}





=head2 widthTab($text, $index, $rhBrush)

return the width of a Strip with the $text. $first indicates that it is the
first Tab.

=cut
sub widthTab { my $self = shift; my $pkg = ref($self);
	my ($text, $index, $rhBrush) = @_;
	my $textOffsetLeft = 9;
	my $textOffsetRight = 7;
	my $widthButtonMin = 46;

	my ($widthText, $heightText) = Win32::GUI::GetTextExtentPoint32(undef, $text, $rhBrush->{font});
	$widthText += ($textOffsetLeft + $textOffsetRight);
	$widthText = $widthText < $widthButtonMin ? $widthButtonMin : $widthText;
	$widthText -= 6 if($index > 0);
	$widthText += 2 if($index > 1);

	return($widthText);
	}





1;





#EOF