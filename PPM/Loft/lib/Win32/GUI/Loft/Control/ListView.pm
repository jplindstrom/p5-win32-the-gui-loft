=head1 NAME Win32::GUI::Loft::Control::ListView - A ListView control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::ListView;
use base qw( Win32::GUI::Loft::Control );





use strict;

use Win32::GUI;

use Data::Dumper;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "btnButton".

Readonly.

=cut
sub nameDefault { my $self = shift; my $pkg = ref($self);
	return("lvwListView");
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
	return(6);
	}





=head2 offsetTextTop

The offset from the top side of the control that texts
should be located for this type of control.

=cut
sub offsetTextTop { my $self = shift; my $pkg = ref($self);
	return(6);
	}





=head2 type

The control's type name.

E.g. "ListView".

Readonly.

=cut
sub type { my $self = shift; my $pkg = ref($self);
	return("ListView");
	}





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut
sub addMethod { my $self = shift; my $pkg = ref($self);
	return("AddListView");
	}





=head1 METHODS

=head2 new()

Create new Control object.

=cut
sub new { my $pkg = shift; $pkg = ref($pkg) || $pkg;

	my $self = $pkg->SUPER::new();

	#New defaults
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Width", 100));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Height", 50));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Visible", 1, [ 0, 1 ], "", ""));
			

	#New properties
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Tabstop", 1, [ 0, 1 ], undef, ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Autoarrange", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"CheckBoxes", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"FullRowSelect", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"GridLines", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"NoColumnHeader", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"NoSortHeader", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ReorderColumns", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ShowSelAlways", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"SingleSel", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"SortAscending", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"SortDescending", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"HotTrack", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ImageList", "", [], "", ""));

##todo: real colors
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"TextColor", "", [], "", undef));
##todo: real colors
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"TextBkColor", "", [], "", undef));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Columns", "", undef, "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"PreviewList", "", undef, "", ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"View", "details", [
					{ "big icons" => 0 },
					{ "details" => 1 },
					{ "small icons" => 2 },
					{ "list" => 3 },
					], "", undef));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Arrange", "current", [
					{ "current" => 0 },
					{ "left edge" => 1 },
					{ "top edge" => 2 },
					{ "to grid" => 3 },
					], "", undef));


	return($self);
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
		
	#This one seems to HAVE to be there! Weirdness!
	push(@aOption, (-style => WS_CHILD | 1));

	if($self->prop("Visible") ne "0") {
		#If preview and the cluster is hidden, go for hidden
		if(		$objDesign->isPreview() && 
				!$self->designIsVisible() ) {
			#Nothing, let it be invisible
			}
		else {
			my $ilImageList = $objDesign->rhImageList()->{ $self->prop("ImageList") };
			push(@aOption, ("-addstyle", WS_VISIBLE));
			}
		}

	###

	return(@aOption);
	}





=head2 buildMethodsSpecial($objNew, $objDesign)

Set all properties on the $objNew that wasn't set using an
option.

Return 1 on success, else 0.

=cut
sub buildMethodsSpecial { my $self = shift; my $pkg = ref($self);
	my ($objNew, $objDesign) = @_;

	if($self->prop("Columns") || "" ne "") {
		#Parse column text
		my @aItem = split(/;\s*/, $self->prop("Columns"));
		for my $item (@aItem) {

			my ($text, $width) = ($item =~ m{^(.+?):?(-?\d+)?$});

			$objNew->InsertColumn(-text => $text, -width => $width);
			}
		}

	if($objDesign->isPreview() && $self->prop("PreviewList") || "" ne "") {
		#Parse preview text
		my @aItem = split(/;\s*/, $self->prop("PreviewList"));

		for my $item (@aItem) {
			my ($textItem, $image) = ($item =~ m{^(.+?):?(\d+)?$});

			my @aText = split(/,\s*/, $textItem);

			my @aImage = (($image || "") ne "") ? (-image => $image) : ();

			$objNew->InsertItem(-text => [ @aText ], @aImage );
			}

		}

	return(1);
	}





=head2 ListViewInsertItem($tvwTree, $ndeTop, $itemText)

Create a new node from $text and insert it into $tvwTree,
using $ndeTop as parent node (if not undef).

Return the new node, or undef on errors.

=cut
sub ListViewInsertItem { my $self = shift; my $pkg = ref($self);
	my ($tvwTree, $ndeTop, $itemText) = @_;

	#Hej:0, Hopp:1, Hallå:1;Nisse, Manpower:2
	my ($text, $image) = ($itemText =~ m{^(.+?):?(\d+)?$});

	my @aImage = defined($image) ? (
			-image => $image,
			-selectedimage => $image ) :
			();

	#Don't use the image if there is no imagelist
#	@aImage = () if(! $objDesign->rhImageList()->{ $self->prop("ImageList") } );
	my @aParent = (defined($ndeTop)) ? (-parent => $ndeTop) : ();
	my $ndeNew = $tvwTree->InsertItem(
			-text          => $text,
			@aImage,
			@aParent,
			);
	$tvwTree->EnsureVisible($ndeNew);


	return($ndeNew);
	}





=head2 paint($dcDev, $rhBrush, $objDesign, $rhPosCache)

Paint the control in the $dcDev.

Return 1 on success, else 0.

=cut
sub paint { my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $objDesign, $rhPosCache) = @_;

	return(1) if(!$self->designIsVisible());

	#Draw ListView
	$dcDev->SelectObject($rhBrush->{noPen});
	$dcDev->SelectObject($rhBrush->{whiteBrush});
	$dcDev->Rectangle(
			$rhPosCache->{left},
			$rhPosCache->{top},
			$rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top} + $rhPosCache->{height},
			) if($self->prop("Visible"));

	if(!$self->prop("GridLines")) {
		$dcDev->DrawEdge(
				$rhPosCache->{left},
				$rhPosCache->{top},
				$rhPosCache->{left} + $rhPosCache->{width},
				$rhPosCache->{top} + $rhPosCache->{height},
				0x0002 | 0x0008,			#BDR_SUNKENOUTER | BDR_SUNKENINNER
				);

		}
	else {
		$dcDev->DrawEdge(
				$rhPosCache->{left},
				$rhPosCache->{top},
				$rhPosCache->{left} + $rhPosCache->{width},
				$rhPosCache->{top} + $rhPosCache->{height},
				0x0004 | 0x0001,			#BDR_RAISEDINNER  | BDR_RAISEDOUTER
				);

		$dcDev->DrawEdge(
				$rhPosCache->{left} + 3,
				$rhPosCache->{top} + 3,
				$rhPosCache->{left} + $rhPosCache->{width} - 3,
				$rhPosCache->{top} + $rhPosCache->{height} - 3,
				0x0002 | 0x0008,			#BDR_SUNKENOUTER | BDR_SUNKENINNER
				);
		}
	$dcDev->BkMode(1);

	$self->paintName($dcDev, $rhBrush, $rhPosCache);
#	$self->paintSelected($dcDev, $rhBrush, $rhPosCache);

	return(1);
	}





1;





#EOF