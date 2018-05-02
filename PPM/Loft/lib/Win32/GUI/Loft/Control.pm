=head1 NAME Win32::GUI::Loft::Control - A window control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control;





use strict;
use Data::Dumper;
use Carp qw( cluck );

use Win32::GUI::Loft::ControlProperty;





=head1 PROPERTIES

=head2 designIsVisible

Whether the control is currently visible in the Design
Window.

Default: 1

=cut
sub designIsVisible {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{designIsVisible} = $val;
		}

	return($self->{designIsVisible});
	}





=head2 designIsSelected

Whether the control is currently selected in the Design
Window.

Default: 1

=cut
sub designIsSelected {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{designIsSelected} = $val;
		}

	return($self->{designIsSelected});
	}





=head2 designIsTangible

Whether the control has the ability to be drawn in the
Design window.

Positional operations should not be performed on the control
if designIsTangible == 0, and it indicates that the control
has no Left, Top, Height, Width.

Default: 1

Readonly.

=cut
sub designIsTangible {
    my $self = shift; my $pkg = ref($self);
	return(1);
	}





=head2 buildPreControlPhase

Whether the control should be built before the "control"
phase.

Default: 0

Readonly.

=cut
sub buildPreControlPhase {
    my $self = shift; my $pkg = ref($self);
	return(0);
	}





=head2 buildControlPhase

Whether the control should be built during the "control"
phase.

Default: 1

Readonly.

=cut
sub buildControlPhase {
    my $self = shift; my $pkg = ref($self);
	return(1);
	}





=head2 buildPostControlPhase

Whether the control should be built after the "control"
phase.

Default: 0

Readonly.

=cut
sub buildPostControlPhase {
    my $self = shift; my $pkg = ref($self);
	return(0);
	}





=head2 isResizable

Whether the control has the ability to be resized depending
on it's properties.

Readonly.

=cut
sub isResizable {
    my $self = shift; my $pkg = ref($self);

	return(1) if(($self->prop("ResizeH") || "" ne "") ||
			($self->prop("ResizeV") || "" ne "") );

	return(0);
	}





=head2 rhControlProperty

key = property name, value = Win32::GUI::Loft::ControlProperty.

These are the properties this control supports. The objects
are created with the control.

=cut
sub rhControlProperty {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{rhControlProperty} = $val;
		}

	return($self->{rhControlProperty});
	}





=head2 objContainer

The Win32::GUI::Loft::Control object that is this control's parent, or
undef if it doesn't have one.

Set to 0 to undef.

=cut
sub objContainer {
    my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{objContainer} = $val;
		$self->{objContainer} = undef if($val eq "0");
		}

	return($self->{objContainer});
	}





=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "btnButton".

Readonly.

=cut
sub nameDefault {
    my $self = shift; my $pkg = ref($self);
	return("-- Abstract --");
	}





=head2 alignDefault

The default align option for control type.

Example: "left"

Readonly.

=cut
sub alignDefault {
    my $self = shift; my $pkg = ref($self);
	return("center");
	}





=head2 valignDefault

The default valign option for control type.

Example: "top"

Readonly.

=cut
sub valignDefault {
    my $self = shift; my $pkg = ref($self);
	return("middle");
	}





=head2 bkModeDefault

The default value for the BkMode when it isn't obvious it
should be transparent. 1|2.

Readonly.

=cut
sub bkModeDefault {
    my $self = shift; my $pkg = ref($self);
	return(1);
	}





=head2 type

The control's type name.

E.g. "Button".

Readonly.

=cut
sub type {
    my $self = shift; my $pkg = ref($self);
	return("-- Abstract --");
	}





=head2 selDotSize

The size in pixels of selection dots.

Readonly.

=cut
sub selDotSize {
    my $self = shift; my $pkg = ref($self);
	return(6);
	}





=head2 offsetTextLeft

The offset from the left side of the control that texts
should be located for this type of control.

=cut
sub offsetTextLeft {
    my $self = shift; my $pkg = ref($self);
	return(4);
	}





=head2 offsetTextRight

The offset from the right side of the control that texts
should be located for this type of control.

=cut
sub offsetTextRight {
    my $self = shift; my $pkg = ref($self);
	return(5);
	}





=head2 offsetTextTop

The offset from the top side of the control that texts
should be located for this type of control.

=cut
sub offsetTextTop {
    my $self = shift; my $pkg = ref($self);
	return(3);
	}





=head2 offsetTextBottom

The offset from the bottom side of the control that texts
should be located for this type of control.

=cut
sub offsetTextBottom {
    my $self = shift; my $pkg = ref($self);
	return(4);
	}





=head2 addMethod

If it starts with "Add", the name of the AddXxxx() method to
use when adding this control to a container object.

If it doesn't, the class name to invoke new() on, with the
container object as the first param.

Readonly

=cut
sub addMethod {
    my $self = shift; my $pkg = ref($self);
	return("-- Abstract --");
	}





=head2 noObject

The number of created objects of this class.

Readonly, updated by the new() method.

=cut
my %hNoObject;
sub noObject {
    my $self = shift; my $pkg = ref($self);
	return($hNoObject{$pkg});
	}





=head1 METHODS

=head2 new()

Create new Control object. The basic Control has these
properties:

	Left
	Top
	Height
	Width
	ResizeH
	ResizeHMod
	ResizeHValue
	ResizeV
	ResizeModV
	ResizeVValue

Controls that doesn't support this can remove these properties.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;

	$pkg->incInstanceCount();

	my $self = {
		'designIsVisible'					=> 1,
		'designIsSelected'					=> 0,
		'rhControlProperty'					=> {},
		'objContainer'						=> undef,

		};
	bless $self, $pkg;


	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Name", "", undef, undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Left", 0));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Top", 0));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Width", 0));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Height", 0));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Visible", 1, [ 0, 1 ], undef, "IsVisible"));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Enable", 1, [ 0, 1 ], "", "Enable"));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ResizeH", "", [ "", "left", "width" ], "", ""));
#	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
#			"ResizeHValue", "", [ ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ResizeHMod", "", [ ],
#			[ "", "div2", "div3", "div4", "div5", "neg", "neg2", "neg3", "neg4", "neg5" ],
			"", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ResizeV", "", [ "", "top", "height" ], "", ""));
#	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
#			"ResizeVValue", "", [ ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"ResizeVMod", "", [ ],
#			[ "", "div2", "div3", "div4", "div5", "neg", "neg2", "neg3", "neg4", "neg5" ],
			"", ""));


	#Set the control base name
	$self->nameDefault( (split(/::/, $pkg))[-1] );

	#Set default name
	$self->prop("Name", $self->nameDefault() . $self->noObject());

	return($self);
	}





=head2 resetInstanceCount()

Reset the counter that is used to keep track of how many
instances of this object that are created.

Note: This is a class method. Call it like so:

	Win32::GUI::Loft::TheControlClass->resetInstanceCounter()

Return 1 on success, else 0.

=cut
sub resetInstanceCount {
    my $pkg = shift;
	$hNoObject{$pkg} = 0;
	return(1);
	}





=head2 incInstanceCount()

Increase the counter that is used to keep track of how many
instances of this object that are created.

Note: This is a class method. Call it like so:

	Win32::GUI::Loft::TheControlClass->incInstanceCounter()

Return 1 on success, else 0.

=cut
sub incInstanceCount {
    my $pkg = shift;
	$hNoObject{$pkg}++;
	return(1);
	}





=head2 isSelectedToggle()

Toggle the designIsSelected property. Return the new value.

=cut
sub isSelectedToggle {
    my $self = shift; my $pkg = ref($self);

	my $val = !$self->designIsSelected();
	$self->designIsSelected($val);

	return($val);
	}





=head2 isClicked($left, $top)

Return 1 if the coords are within the control, else 0.

=cut
sub isClicked {
    my $self = shift; my $pkg = ref($self);
	my ($left, $top) = @_;

	#Non-design-visible controls are not clickable
	return(0) if(!$self->designIsVisible());


	my $leftControl = $self->prop("Left");
	return(0) if($left < $leftControl);

	my $topControl = $self->prop("Top");
	return(0) if($top < $topControl);

	my $rightControl = $leftControl + $self->prop("Width");
	return(0) if($left > $rightControl);

	my $bottomControl = $topControl + $self->prop("Height");
	return(0) if($top > $bottomControl);

	return(1);
	}





=head2 isClickedSelected($left, $top, $leftSel, $topSel)

Return 1 if the coords are within a selected box located at
$leftSel, $topSel, else return 0.

=cut
sub isClickedSelected {
    my $self = shift; my $pkg = ref($self);
	my ($left, $top, $leftSel, $topSel) = @_;

	my $dist = ($self->selDotSize() / 2) + 1;

	if(		$left < $leftSel - $dist ||
			$top < $topSel - $dist ||
			$left > $leftSel + $dist ||
			$top > $topSel + $dist) {
		return(0)
		}

	return(1);
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
sub clickedSelectCorner {
    my $self = shift; my $pkg = ref($self);
	my ($left, $top) = @_;

	return(0) if(!$self->designIsTangible());
	return(0) if(!$self->designIsVisible());

	my $rhPosCache = $self->rhPosCache();

	#Bottom right
	return(0) if($self->isClickedSelected($left, $top,
			$rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top} + $rhPosCache->{height}));
	#Bottom left
	return(1) if($self->isClickedSelected($left, $top,
			$rhPosCache->{left},
			$rhPosCache->{top} + $rhPosCache->{height}));
	#Top left
	return(2) if($self->isClickedSelected($left, $top,
			$rhPosCache->{left},
			$rhPosCache->{top}));
	#Top right
	return(3) if($self->isClickedSelected($left, $top,
			$rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top}));

	return(-1);
	}





=head2 isTouchedByRect($left, $top, $right, $bottom)

Return 1 if the control is within or touched by the
rectangle, else 0.

=cut
sub isTouchedByRect {
    my $self = shift; my $pkg = ref($self);
	my ($left, $top, $right, $bottom) = @_;

	return(0) if(!$self->designIsVisible());


	my $topC = $self->prop("Top");
	return(0) if($topC > $bottom);

	my $leftC = $self->prop("Left");
	return(0) if($leftC > $right);

	my $bottomC = $topC + $self->prop("Height");
	return(0) if($bottomC < $top);

	my $rightC = $leftC + $self->prop("Width");
	return(0) if($rightC < $left);

	return(1);
	}





=head2 hasProperty($propName)

Return 1 if $propName is a property of this object, else 0.

=cut
sub hasProperty {
    my $self = shift; my $pkg = ref($self);
	my ($propName) = @_;

	return((exists $self->rhControlProperty()->{$propName}) ? 1 : 0);
	}





=head2 isUsingCluster($objCluster)

Is this control using or referencing $objCluster in the
property "Clusters"?

Default: 0

Redifine in derived classes.

=cut
sub isUsingCluster {
    my $self = shift; my $pkg = ref($self);
	my ($objCluster) = @_;

	return(0);
	}





=head2 tabIndexFindByName($nameTab)

Return the index of the tab in the property "Tabs" that's
named $nameTab, or undef if not found.

Default: undef

Redefine in derived classes.

=cut
sub tabIndexFindByName {
    my $self = shift; my $pkg = ref($self);
	my ($nameTab) = @_;


	return(undef);
	}





=head2 prop($propertyName, [$propertyValue])

Get or set the value of $propertyName.

Return undef if the property doesn't exist.

=cut
sub prop {
    my $self = shift; my $pkg = ref($self);
	my ($propertyName, $val) = @_;

	if(! exists $self->rhControlProperty()->{$propertyName} ) {
#		cluck(sprintf("Non-existant property ($propertyName) in Control (%s--%s)",
#				$pkg, $self->rhControlProperty()->{"Name"}->value()));
		return(undef);
		}

	if(defined($val)) {
		$self->rhControlProperty()->{$propertyName}->value($val);
		}

	return( $self->rhControlProperty()->{$propertyName}->value() );
	}





=head2 propIncSnap($propertyName, $propertyValue, $snap)

Increase the value of $propertyName, snapping to a multiple
of $snap (if $snap != 0).

Return undef if the property doesn't exist.

=cut
sub propIncSnap {
    my $self = shift; my $pkg = ref($self);
	my ($propertyName, $val, $snap) = @_;

	return(undef) if(!$self->designIsVisible());

#eval {
	return($self->rhControlProperty()->{$propertyName}->valueIncSnap($val, $snap));
#	}; cluck($@) if($@);
	}





=head2 propGuiSet($propertyName, $objGuiControl, $objDesign)

Set the current value of $propertyName in the Win32::GUI
control $objGuiControl.

Retur 1 on success, else 0.

=cut
sub propGuiSet {
    my $self = shift; my $pkg = ref($self);
	my ($propertyName, $objGuiControl, $objDesign) = @_;

	my $objProp = $self->rhControlProperty()->{$propertyName} or return(0);

	$objProp->guiSet($objGuiControl) or return(0);

	return(1);
	}





=head2 propertyAdd(Win32::GUI::Loft::ControlProperty $objProperty)

Add (or replace) the $objProperty to the rhControlProperty()
array.

Return 1 on success, else 0.

=cut
sub propertyAdd {
    my $self = shift; my $pkg = ref($self);
	my ($objProperty) = @_;

	$self->rhControlProperty()->{ $objProperty->name() } = $objProperty;

	return(1);
	}





=head2 propertyDelete($propertyName)

Delete the $propertyName from the rhControlProperty() array.

Return 1 on success, else 0.

=cut
sub propertyDelete {
    my $self = shift; my $pkg = ref($self);
	my ($propertyName) = @_;

	return(defined(delete $self->rhControlProperty()->{ $propertyName }) ? 1 : 0);
	}





=head2 buildAdd($objDesign, $objControlContainerDefault, $objInspector)

Create Win32::GUI control and add it to it's container
object, or to $objControlContainerDefault if it doesn't have
one.

If the container object doesn't exist, create it first.

[implementation note: currently, only the
$objControlContainerDefault is used as container]

Return the new control object, or undef on errors.

=cut
sub buildAdd {
    my $self = shift; my $pkg = ref($self);
	my ($objDesign, $objControlContainerDefault, $objInspector) = @_;

##todo: Implement the container object stuff
##Meanwhile, always use the...
	my $objContainer = $objControlContainerDefault;

	my $method = $self->addMethod();

	my $objNew;
	if($method) {
		#Only add it if it has a creation method
		my @aOption = $objInspector->buildOptions(
				$self, [
					$self->buildOptions($objDesign),
					$self->buildOptionsSpecial($objDesign)
					],
				) or return(undef);

		if($method =~ /^Add/) {
			$objNew = $objContainer->$method(@aOption);
			}
		else {
			$objNew = $method->new($objContainer, @aOption);
			}

		$self->buildMethods($objNew);
		$self->buildMethodsSpecial($objNew, $objDesign);
		}
	else {
		#Let the app programmer provide it
		$objNew = $objInspector->buildAdd($objContainer, $self);
		}

	##TabStripGroups; if the control is part of a Cluster,
	# register the Win32::GUI control with a TabStripGroup/
	# TabStrip if there is one.
	if(defined($objNew)) {
		$objDesign->wingcTabStripRegister($self, $objNew);
		}


	#Add event handlers
	$self->buildEventHandlers($objNew, $objDesign);


	return($objNew);
	}





=head2 buildOptions($objDesign)

Return array with options for the creation of the control.

Return an empty array on errors.

Warn if the "Name" property is missing.

=cut
sub buildOptions {
    my $self = shift; my $pkg = ref($self);
	my ($objDesign) = @_;
	my @aOption;

	for my $objProperty (values %{$self->rhControlProperty()}) {
		if($objProperty->nameOption() && defined($objProperty->value())) {
			if($objProperty->name() eq "Name") {
				#Append the base name if possible
				push(@aOption, ($objProperty->nameOption(),
						$objProperty->value() . $objDesign->buildControlNameBase()));
				}
			else {
				#If preview and the cluster is hidden, go for hidden
				if(		#$objDesign->isPreview() &&
						$objProperty->name() eq "Visible" &&
						!$self->designIsVisible() ) {
					push(@aOption, ($objProperty->nameOption(), 0));
					}
				else {
					push(@aOption, ($objProperty->nameOption(), $objProperty->valueParameter()));
					}
				}
			}
		}

	warn("Harsh warning: $pkg control without a Name property") if(! $self->prop("Name") );

	return(@aOption);
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

	return(@aOption);
	}





=head2 buildMethods($objNew)

Set all properties on the $objNew that wasn't set using an
option.

Return 1 on success, else 0.

=cut
sub buildMethods {
    my $self = shift; my $pkg = ref($self);
	my ($objNew) = @_;

	for my $objProperty (values %{$self->rhControlProperty()}) {
		if(		!$objProperty->nameOption() &&
				$objProperty->nameProperty() &&
				defined($objProperty->value()) &&
				$objProperty->value() ne "") {

			my $method = $objProperty->nameProperty();
			$objNew->$method( $objProperty->valueParameter() );
			}
		}

	return(1);
	}





=head2 buildMethodsSpecial($objNew, $objDesign)

Set all properties on the $objNew that wasn't set using an
option.

Return 1 on success, else 0.

=cut
sub buildMethodsSpecial {
    my $self = shift; my $pkg = ref($self);
	my ($objNew, $objDesign) = @_;


	return(1);
	}





=head2 buildEventHandlers($objNew, $objDesign)

Create event handler subs with appropriate behaviour for the
control.

If the sub already exists, fail.

Return 1 on success, else 0.

=cut
sub buildEventHandlers {
    my $self = shift; my $pkg = ref($self);
	my ($objNew, $objDesign) = @_;


	return(1);
	}






=head2 runtimeName($objDesign)

Return the name the control has during runtime. This is
probably equal to, or a variation on, the "Name" property.

=cut
sub runtimeName {
    my $self = shift; my $pkg = ref($self);
	my ($objDesign) = @_;

	return($self->prop("Name") . $objDesign->buildControlNameBase());
	}





=head2 transformSlim()

Transform the object to be a slimmed down representation of
the important property values.

Return 1 on success, else 0.

=cut
sub transformSlim {
    my $self = shift; my $pkg = ref($self);

	for my $objProperty (values %{$self->rhControlProperty()}) {
		$objProperty->transformSlim();
		}

	return(1);
	}





=head2 transformFatten()

Transform the object to be fully functional in terms of
property values.

Return 1 on success, else 0.

=cut
sub transformFatten {
    my $self = shift; my $pkg = ref($self);

	#Create new object of same type so we get all default values for the
	#properties
	my $objControlNew = $pkg->new();

	#For each property in the new object, lookup the corresponding existing
	#property and imprint that value in the new object.
	while(	my ($nameProperty, $objProperty) = each
			%{$objControlNew->rhControlProperty()}) {
		my $objPropertySlim = $self->rhControlProperty()->{$nameProperty};

		if(defined($objPropertySlim)) {
			$objPropertySlim->imprint($objProperty, $nameProperty);
			}
		}

	#For this object, replace the existing properties with
	#the new properties.
	$self->rhControlProperty( $objControlNew->rhControlProperty() );

	return(1);
	}





=head2 rhPosCache()

Return hash ref with a snapshot of the positional
properties, used for cashing the expensive lookups.

=cut
sub rhPosCache {
    my $self = shift; my $pkg = ref($self);
	return({
			width => $self->prop("Width"),
			height => $self->prop("Height"),
			left => $self->prop("Left"),
			top => $self->prop("Top"),
			});
	}





=head2 paint($dcDev, $rhBrush, $objDesign, $rhPosCache)

Paint the control in the $dcDev.

Return 1 on success, else 0.

=cut
sub paint {
    my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $objDesign, $rhPosCache) = @_;


	return(1);
	}





=head2 paintText($dcDev, $rhBrush, $rhPosCache)

Paint the Text property on the control if there is one.

Return 1 on success, else 0.

=cut
sub paintText {
    my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $rhPosCache) = @_;

	#Remove any & chars
	##todo: make it write underlined & in the text
	my $text = $self->prop("Text") or return(1);
	$text =~ s/&//gm;


	#Upper or lower case
	my $case = $self->prop("Case") || "";
	$text = uc($text) if($case eq "upper");
	$text = lc($text) if($case eq "lower");

	$self->paintTextGeneric($dcDev, $rhBrush, $rhPosCache, $text);

	return(1);
	}





=head2 paintName($dcDev, $rhBrush, $rhPosCache)

Paint the Name property on the control if there is one.

Return 1 on success, else 0.

=cut
sub paintName {
    my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $rhPosCache) = @_;

	my $text = $self->prop("Name") or return(1);

	$self->paintTextGeneric($dcDev, $rhBrush, $rhPosCache, $text);

	return(1);
	}





=head2 paintTextGeneric($dcDev, $rhBrush, $rhPosCache, $text)

Paint the $text property on the control.

Return 1 on success, else 0.

=cut
sub paintTextGeneric {
    my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $rhPosCache, $text) = @_;

	#Alignment
	my $align = $self->prop("Align") || $self->alignDefault();
	my $valign = $self->prop("Valign") || $self->valignDefault();

	my ($widthText, $heightText) = Win32::GUI::GetTextExtentPoint32(undef, $text, $rhBrush->{font});
	my $leftText = ($rhPosCache->{width}  - $widthText - 1) / 2;
	my $topText = ($rhPosCache->{height} - $heightText - 1) / 2;

	if($align eq "left") {
		$leftText = $self->offsetTextLeft();
		}
	if($align eq "right") {
		$leftText = $rhPosCache->{width} - $widthText - $self->offsetTextRight();
		}
	if($valign eq "top") {
		$topText = $self->offsetTextTop();
		}
	if($valign eq "bottom") {
		$topText = $rhPosCache->{height} - $heightText - $self->offsetTextBottom();
		}


	$dcDev->SelectObject($rhBrush->{font});
	if($self->prop("Visible")) {
		if($self->prop("Enable")) {
			$dcDev->TextColor(0);		##todo: real color, and predefined
			}
		else {
			##todo: Real greyed color using GrayString
			$dcDev->TextColor([128,128,128]);		#Gray. "disabled"
			}
		}
	else {
		$dcDev->TextColor([255, 255, 255]);		#White. "invisible"
		}

	$dcDev->BkMode($self->bkModeDefault());
	$dcDev->BackColor($rhBrush->{colorWindow});

	$dcDev->TextOut(
			$rhPosCache->{left} + $leftText,
			$rhPosCache->{top} + $topText,
			$text);

	return(1);
	}





=head2 paintBitmap($dcDev, $rhBrush, $rhPosCache, $objDesign)

Paint the $bmBitmap on the control.

Return 1 on success, else 0.

=cut
sub paintBitmap {
    my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $rhPosCache, $objDesign) = @_;

	my $bmBitmap = $objDesign->rhBitmap()->{ $self->prop("Bitmap") } or return(0);

	##todo: Alignment
	my $align = $self->prop("Align") || $self->alignDefault();
	my $valign = $self->prop("Valign") || $self->valignDefault();

	my ($widthBitmap, $heightBitmap) = ($bmBitmap->Info())[0..1];

	my $leftBitmap = ($rhPosCache->{width}  - $widthBitmap - 1) / 2;
	my $topBitmap = ($rhPosCache->{height} - $heightBitmap - 1) / 2;

	if($align eq "left") {
		$leftBitmap = $self->offsetTextLeft();
		}
	if($align eq "right") {
		$leftBitmap = $rhPosCache->{width} - $widthBitmap;
		}
	if($valign eq "top") {
		$topBitmap = $self->offsetTextTop();
		}
	if($valign eq "bottom") {
		$topBitmap = $rhPosCache->{height} - $heightBitmap - $self->offsetTextBottom();
		}

	#Draw rectangle with the image as brush
	my $brsBitmap = Win32::GUI::Brush->new(
			-style => 3, 				#BS_PATTERN
			-pattern => $bmBitmap,
			);

	if($self->prop("Visible")) {
		$dcDev->SelectObject($rhBrush->{noPen});
		Win32::GUI::AdHoc::SetBrushOrgEx($dcDev,		#Move the brush origin
				$rhPosCache->{left} + $leftBitmap,
				$rhPosCache->{top} + $topBitmap);
		$dcDev->SelectObject($brsBitmap);
		$dcDev->Rectangle(
				$rhPosCache->{left} + $leftBitmap,
				$rhPosCache->{top} + $topBitmap,
				$rhPosCache->{left} + $leftBitmap + $widthBitmap + 1,
				$rhPosCache->{top} + $topBitmap + $heightBitmap + 1,
				);
		}
	else {
		#Indicate invisible state with a white cross
		$dcDev->SelectObject($rhBrush->{whitePen});
        $dcDev->MoveTo($rhPosCache->{left} + $leftBitmap,
				$rhPosCache->{top} + $topBitmap);
		$dcDev->LineTo($rhPosCache->{left} + $leftBitmap + $widthBitmap,
				$rhPosCache->{top} + $topBitmap + $heightBitmap);
        $dcDev->MoveTo($rhPosCache->{left} + $leftBitmap + $widthBitmap,
				$rhPosCache->{top} + $topBitmap);
		$dcDev->LineTo($rhPosCache->{left} + $leftBitmap,
				$rhPosCache->{top} + $topBitmap + $heightBitmap);
		}


	if(!$self->prop("Enable")) {
		#Indicate disabled state with a black cross
		##todo: draw an actually greyed bitmap
		$dcDev->SelectObject($rhBrush->{blackPen});
        $dcDev->MoveTo($rhPosCache->{left} + $leftBitmap - 1,
				$rhPosCache->{top} + $topBitmap - 1);
		$dcDev->LineTo($rhPosCache->{left} + $leftBitmap + $widthBitmap - 1,
				$rhPosCache->{top} + $topBitmap + $heightBitmap - 1);
        $dcDev->MoveTo($rhPosCache->{left} + $leftBitmap + $widthBitmap - 1,
				$rhPosCache->{top} + $topBitmap - 1);
		$dcDev->LineTo($rhPosCache->{left} + $leftBitmap - 1,
				$rhPosCache->{top} + $topBitmap + $heightBitmap - 1);
		}

	return(1);
	}





=head2 paintSelected($dcDev, $rhBrush, $rhPosCache)

Paint selection-markers on the control if
designIsSelected().

Return 1 on success, else 0.

=cut
sub paintSelected {
    my $self = shift; my $pkg = ref($self);
	my ($dcDev, $rhBrush, $rhPosCache) = @_;

	return(1) if(!$self->designIsSelected());
	return(0) if(!$self->designIsVisible());

    $dcDev->SelectObject($rhBrush->{whitePen});
    $dcDev->SelectObject($rhBrush->{blackBrush});

	#Top left
	$self->paintSelectedDot($dcDev,
			$rhPosCache->{left}, $rhPosCache->{top});
	#Top right
	$self->paintSelectedDot($dcDev,
			$rhPosCache->{left} + $rhPosCache->{width}, $rhPosCache->{top});

	#Bottom right
	$self->paintSelectedDot($dcDev,
			$rhPosCache->{left} + $rhPosCache->{width},
			$rhPosCache->{top} + $rhPosCache->{height});
	#Bottom left
	$self->paintSelectedDot($dcDev,
			$rhPosCache->{left},
			$rhPosCache->{top} + $rhPosCache->{height});

	return(1);
	}





=head2 paintSelectedDot($dcDev, $left, $top)

Paint a selection dot at $left, $top.

Return 1 on success, else 0.

=cut
sub paintSelectedDot {
    my $self = shift; my $pkg = ref($self);
	my ($dcDev, $left, $top) = @_;

	my $dist = $self->selDotSize() / 2;

	$dcDev->Rectangle($left - $dist, $top - $dist, $left + $dist, $top + $dist);

	return(1);
	}





1;





#EOF
