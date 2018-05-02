=head1 NAME Win32::GUI::Loft::Control::Window - A Window control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::Window;
use base qw( Win32::GUI::Loft::Control );





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
	return("winWindow");
	}





=head2 type

The control's type name. 

E.g. "Button".

Readonly.

=cut
sub type {
    my $self = shift; my $pkg = ref($self);
	return("Window");
	}





=head1 METHODS

=head2 new()

Create new Window control object.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;

	my $self = $pkg->SUPER::new();

	#Remove properties
	delete $self->rhControlProperty()->{"Visible"};
	delete $self->rhControlProperty()->{"Enable"};

	delete $self->rhControlProperty()->{"ResizeH"};
	delete $self->rhControlProperty()->{"ResizeHMod"};
	delete $self->rhControlProperty()->{"ResizeHValue"};
	delete $self->rhControlProperty()->{"ResizeV"};
	delete $self->rhControlProperty()->{"ResizeModV"};
	delete $self->rhControlProperty()->{"ResizeVValue"};

	#New defaults
	##todo: get defaults from config
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Left", 250));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Top", 100));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Width", 350));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Height", 200));

	#New properties
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Text", $self->prop("Name")));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Topmost", 0, [ 0, 1 ], undef, ""));
			
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Maximizebox", 1, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Minimizebox", 1, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Helpbox", 0, [ 0, 1 ], undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Menubox", 1, [ 0, 1 ], undef, ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Controlparent", 0, [ 0, 1 ], undef, ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"Resizable", 1, [ 0, 1 ], undef, ""));

	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"MinWidth", undef, undef, undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"MaxWidth", undef, undef, undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"MinHeight", undef, undef, undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"MaxHeight", undef, undef, undef, ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"DialogBox", "window", [ "window", "dialog", "toolbar", "borderless", ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"DialogUI", 1, [ 0, 1 ], "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"PreviewMenu", "", undef, "", ""));
	$self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
			"WindowIcon", "", undef, "", ""));
	
	return($self);
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
				#Use the alternate name if possible
				push(@aOption, ($objProperty->nameOption(), 
						$objDesign->buildWindowName() || 
						$objProperty->value() . $objDesign->buildControlNameBase()));
				}
			else {
				push(@aOption, ($objProperty->nameOption(), $objProperty->value()));
				}
			
			}
		}

	warn("Harsh warning: $pkg control without a Name property") if(! $self->prop("Name") );

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

	if($self->prop("DialogUI") && $self->prop("DialogBox") ne "dialog") {
		$objNew->{-dialogui} = 1;
		}

	my $file = $self->prop("WindowIcon");
	if($file ne "") {
		$objNew->ChangeIcon( $objDesign->rhIcon()->{ $file } );
		$objNew->ChangeSmallIcon( $objDesign->rhIcon()->{ $file } );
		}
	
	return(1);
	}





=head2 runtimeName($objDesign)

Return the name the control has during runtime. This is 
probably equal to, or a variation on, the "Name" property.

=cut
sub runtimeName {
    my $self = shift; my $pkg = ref($self);
	my ($objDesign) = @_;

	return( $objDesign->buildWindowName() || 
			$self->prop("Name") . $objDesign->buildControlNameBase() );
	}





=head2 prop($propertyName, [$propertyValue, $winWindow])

Get or set the value of $propertyName.

Change the corresponding aspect of the Win32::GUI::Window 
$winWindow if passed.

Return undef if the property doesn't exist.

=cut
sub prop {
    my $self = shift; my $pkg = ref($self);
	my ($propertyName, $val, $winWindow) = @_;
	
	my $ret = $self->SUPER::prop($propertyName, $val);
	
	if(defined($ret) && defined($val) && defined($winWindow)) {
		$self->propGuiSet($propertyName, $winWindow);
		}
	

	return( $ret );
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
	if($propertyName eq "WindowIcon") {
		if(		$objProp->value() ne "" && 
				defined( $objDesign->rhIcon()->{ $objProp->value() } )) {
			$objGuiControl->ChangeIcon( $objDesign->rhIcon()->{ $objProp->value() } );
			$objGuiControl->ChangeSmallIcon( $objDesign->rhIcon()->{ $objProp->value() } );
			}
		}
	else {
		$objProp->guiSet($objGuiControl) or return(0);
		}

	return(1);
	}





1;





#EOF                                                                                                                                                                                                                                                                                                                                                                      
