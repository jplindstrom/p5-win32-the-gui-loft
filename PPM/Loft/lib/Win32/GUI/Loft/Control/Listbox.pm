=head1 NAME Win32::GUI::Loft::Control::Listbox - A Listbox control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::Listbox;
use base qw( Win32::GUI::Loft::Control::ForegroundBackground );





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
    return("lbListbox");
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

E.g. "Listbox".

Readonly.

=cut
sub type {
    my $self = shift; my $pkg = ref($self);
    return("Listbox");
    }





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut
sub addMethod {
    my $self = shift; my $pkg = ref($self);
    return("AddListbox");
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
#   $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
#           "Text", ""));
#   $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
#           "Align", "left", [ "", "left", "center", "right" ], undef, ""));

    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Multisel", 0, [ 0, 1, 2 ], undef, ""));
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Sort", 0, [ 0, 1 ], undef, ""));

    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "PreviewList", "", undef, "", ""));

    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "ScrollV", 1, [ 0, 1 ], "", ""));
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "ScrollH", 0, [ 0, 1 ], "", ""));


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

    if($self->prop("ScrollH") || "") {
        push(@aOption, ("-addstyle", 0x00100000));      #WS_HSCROLL
        }
    if($self->prop("ScrollV") || "") {
        push(@aOption, ("-addstyle", 0x00200000));      #WS_VSCROLL
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
        
        $objNew->Add(@aItem);
#       for my $item (@aItem) {
#           $objNew->treeviewInsertItem($objNew, $ndeTop, $sub) or next;
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
    
#   my $height = 4 + 2 + (int(($rhPosCache->{height} - 6) / 13) * 13);  #6
    my $height = (int(($rhPosCache->{height} - 4) / 13) * 13) + 4;

    #Draw Listbox
    $dcDev->SelectObject($rhBrush->{noPen});
    $dcDev->SelectObject($rhBrush->{whiteBrush});
    $dcDev->Rectangle(
            $rhPosCache->{left},
            $rhPosCache->{top},
            $rhPosCache->{left} + $rhPosCache->{width},
            $rhPosCache->{top} + $height,
            ) if($self->prop("Visible"));
    $dcDev->DrawEdge(
            $rhPosCache->{left},
            $rhPosCache->{top},
            $rhPosCache->{left} + $rhPosCache->{width},
            $rhPosCache->{top} + $height,
            0x0002 | 0x0008,            #BDR_SUNKENOUTER | BDR_SUNKENINNER
            );
    $dcDev->BkMode(1);

    $self->paintName($dcDev, $rhBrush, $rhPosCache);
#   $self->paintSelected($dcDev, $rhBrush, $rhPosCache);

    return(1);
    }





1;





#EOF
