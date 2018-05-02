=head1 NAME Win32::GUI::Loft::Control::TreeView - A TreeView control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::TreeView;
use base qw( Win32::GUI::Loft::Control::ForegroundBackground );





use strict;

use Data::Dumper;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "btnButton".

Readonly.

=cut
sub nameDefault {
    my $self = shift; my $pkg = ref($self);
	return("tvwTreeView");
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
	return(4);
	}





=head2 offsetTextTop

The offset from the top side of the control that texts
should be located for this type of control.

=cut
sub offsetTextTop {
    my $self = shift; my $pkg = ref($self);
	return(4);
	}





=head2 type

The control's type name.

E.g. "TreeView".

Readonly.

=cut
sub type {
    my $self = shift; my $pkg = ref($self);
	return("TreeView");
	}





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut
sub addMethod {
    my $self = shift; my $pkg = ref($self);
	return("AddTreeView");
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
			"Lines", 1, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"RootLines", 1, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Buttons", 1, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ImageList", "", [], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ShowSelAlways", 1, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"RootLines", 1, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Checkboxes", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"HotTrack", 0, [ 0, 1 ], undef, ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Indent", "", [], "", undef));
##todo: real colors			
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"TextColor", "", [], "", undef));
##todo: real colors
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"BackColor", "", [], "", undef));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"PreviewTree", "", undef, "", ""));


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
	my @aOption = $self->SUPER::buildOptionsSpecial($objDesign);

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
sub buildMethodsSpecial {
    my $self = shift; my $pkg = ref($self);
	my ($objNew, $objDesign) = @_;

	if($objDesign->isPreview() && $self->prop("PreviewTree") ne "") {
		#Parse preview text
		#Hej:0, Hopp:1, Hallå:1;Nisse, Manpower:2
		my @aBranch = split(/;\s*/, $self->prop("PreviewTree"));
		for my $branch (@aBranch) {
			my ($top, @aSub) = split(/,\s*/, $branch);
			
			if($top) {
				my $ndeTop = $self->treeviewInsertItem($objNew, undef, $top) or next;
				
				for my $sub (@aSub) {
					$self->treeviewInsertItem($objNew, $ndeTop, $sub) or next;
					}
				}
			}
		}

	return(1);
	}





=head2 treeviewInsertItem($tvwTree, $ndeTop, $itemText)

Create a new node from $text and insert it into $tvwTree, 
using $ndeTop as parent node (if not undef).

Return the new node, or undef on errors.

=cut
sub treeviewInsertItem {
    my $self = shift; my $pkg = ref($self);
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
sub paint {
    my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $objDesign, $rhPosCache) = @_;

	return(1) if(!$self->designIsVisible());

	#Draw TreeView
	$dcDev->SelectObject($rhBrush->{noPen});
	$dcDev->SelectObject($rhBrush->{whiteBrush});
	$dcDev->Rectangle(
			$rhPosCache->{left} + 1,
			$rhPosCache->{top} + 1,
			$rhPosCache->{left} + $rhPosCache->{width} - 1,
			$rhPosCache->{top} + $rhPosCache->{height} - 1,
			) if($self->prop("Visible"));
	$dcDev->DrawEdge(
			$rhPosCache->{left} + 1,
			$rhPosCache->{top} + 1,
			$rhPosCache->{left} + $rhPosCache->{width} - 1,
			$rhPosCache->{top} + $rhPosCache->{height} - 1,
			0x0002 | 0x0008,			#BDR_SUNKENOUTER | BDR_SUNKENINNER
			);
	$dcDev->BkMode(1);

	$self->paintName($dcDev, $rhBrush, $rhPosCache);
#	$self->paintSelected($dcDev, $rhBrush, $rhPosCache);

	return(1);
	}





1;





#EOF
