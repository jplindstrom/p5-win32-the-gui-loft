=head1 NAME Win32::GUI::Loft::Control::ImageList - A ImageList control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::ImageList;
use base qw( Win32::GUI::Loft::Control::Intangible );





use strict;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "ilImageList".

Readonly.

=cut
sub nameDefault {
    my $self = shift; my $pkg = ref($self);
    return("ilImageList");
    }





=head2 type

The control's type name.

E.g. "ImageList".

Readonly.

=cut
sub type {
    my $self = shift; my $pkg = ref($self);
    return("ImageList");
    }





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut
sub addMethod {
    my $self = shift; my $pkg = ref($self);
    return("");
    }





=head2 buildPreControlPhase

Whether the control should be built before the "control" 
phase.

Default: 1

Readonly.

=cut
sub buildPreControlPhase {
    my $self = shift; my $pkg = ref($self);
    return(1);
    }





=head2 buildControlPhase

Whether the control should be built during the "control" 
phase.

Default: 0

Readonly.

=cut
sub buildControlPhase {
    my $self = shift; my $pkg = ref($self);
    return(0);
    }





=head1 METHODS

=head2 new()

Create new Control object.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;

    my $self = $pkg->SUPER::new();

    #Remove properties

    #New properties
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "ImageWidth", "16", [], "", ""));
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "ImageHeight", "16", [], "", ""));
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Images", "", undef, "", ""));
##todo: add using AddMasked,
#       using imagename.bmp| or imagename.bmp|192
#       to specify the mask
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Flags", "color",
            [ "color", "color4", "color8", "color16", "color24", "color32", "colorddb" ],
            "", ""));
##todo: mask, specify the mask image as imagename.bmp|maskimagename.bmp, ...
#   $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
#           "Mask", 0, [ 0, 1 ], "", ""));
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Grow", "", [], undef, ""));


    return($self);
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
my %hFlags = (
        "color" => 0x0000,
        "color4" => 0x0004,
        "color8" => 0x0008,
        "color16" => 0x0010,
        "color24" => 0x0018,
        "color32" => 0x0020,
        "colorddb" => 0x00FE,
        );
sub buildAdd {
    my $self = shift; my $pkg = ref($self);
    my ($objDesign, $objControlContainerDefault, $objInspector) = @_;


    #Parse the Images prop
    my @aImage = split(/,\s*/, $self->prop("Images"));

    my $flags = $hFlags{$self->prop("Flags")};  ##todo: mask stuff
    my $initial = scalar(@aImage);
    my $grow = int($self->prop("Grow") || 0);
    $grow = $initial if($grow < $initial);

    ##todo: pass this to the inspector somehow,
    #       probably in a new (generic?) method
    my $objNew = new Win32::GUI::ImageList(
            $self->prop("ImageWidth"),
            $self->prop("ImageHeight"),
            $flags, $initial, $grow);

    for my $fileImage (@aImage) {
        $objDesign->bitmapLoad($fileImage) or next;
        $objNew->Add($objDesign->rhBitmap()->{$fileImage});     ##todo: mask stuff
        }

    #Stick the ImageList in the Design object
    $objDesign->rhImageList()->{$self->prop("Name")} = $objNew;


    return($objNew);
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





1;





#EOF
