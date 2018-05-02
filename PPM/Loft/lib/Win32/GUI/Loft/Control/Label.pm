=head1 NAME Win32::GUI::Loft::Control::Label - A Label control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::Label;
use base qw( Win32::GUI::Loft::Control::ForegroundBackground );





use strict;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "lblLabel".

Readonly.

=cut
sub nameDefault {
    my $self = shift; my $pkg = ref($self);
    return("lblLabel");
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
    my ($val) = @_;

    if(defined($val)) {
        $self->{offsetTextLeft} = $val;
        }

    return($self->{offsetTextLeft});
    }





=head2 offsetTextRight

The offset from the right side of the control that texts
should be located for this type of control.

=cut
sub offsetTextRight {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{offsetTextRight} = $val;
        }

    return($self->{offsetTextRight});
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

E.g. "Label".

Readonly.

=cut
sub type {
    my $self = shift; my $pkg = ref($self);
    return("Label");
    }





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut
sub addMethod {
    my $self = shift; my $pkg = ref($self);
    return("AddLabel");
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
            "Height", 20));

    #New properties
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Tabstop", 0, [ 0, 1 ], undef, ""));

    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Text", ""));
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Align", "left", [ "", "left", "center", "right" ], "", ""));
#   $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
#           "Valign", "top", [ "", "top", "center", "bottom" ], undef, ""));

##todo: fill, doesn't seem to work; produces weird results
#   $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
#           "Fill", "none", [ "none", "black", "gray", "white" ], undef, ""));

##todo: "black", "gray", "white", but these seem totally weird
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Frame", "none", [ "none", "etched" ], undef, ""));

    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Noprefix", 0, [ 0, 1 ], undef, ""));
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Notify", 1, [ 0, 1 ], undef, ""));
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Sunken", 0, [ 0, 1 ], undef, ""));
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Truncate", 0, [ 0, 1, "word", "path" ], undef, ""));
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Wrap", 1, [ 0, 1 ], undef, ""));
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Bitmap", "", [], "", ""));

##todo: icon

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

    if($self->prop("Bitmap") ne "") {
        my $bmBitmap = $objDesign->rhBitmap()->{ $self->prop("Bitmap") };
        push(@aOption, ("-bitmap", 1)) if($bmBitmap);   #Just make the label aware of the bitmap
        }

    my $align = $self->prop("Align") || "";
    if($align ne "" && $align ne "left") {
        push(@aOption, ("-align", $self->prop("Align")));
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

    if($self->prop("Bitmap") ne "") {
        my $bmBitmap = $objDesign->rhBitmap()->{ $self->prop("Bitmap") };
        $objNew->SetImage($bmBitmap);
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

    #Draw Label
    $dcDev->SelectObject($rhBrush->{noPen});
    $dcDev->SelectObject($rhBrush->{whiteBrush});
#   $dcDev->Rectangle(
#           $rhPosCache->{left} + 1,
#           $rhPosCache->{top} + 1,
#           $rhPosCache->{left} + $rhPosCache->{width} - 1,
#           $rhPosCache->{top} + $rhPosCache->{height} - 1,
#           ) if($self->prop("Visible"));

#   $dcDev->DrawEdge(
#           $rhPosCache->{left} + 1,
#           $rhPosCache->{top} + 1,
#           $rhPosCache->{left} + $rhPosCache->{width} - 1,
#           $rhPosCache->{top} + $rhPosCache->{height} - 1,
#           0x0002 | 0x0008,            #BDR_SUNKENOUTER | BDR_SUNKENINNER
#           );
    $dcDev->BkMode(1);


    if($self->prop("Frame") eq "none") {

        if($self->prop("Sunken")) {
            $dcDev->SelectObject($rhBrush->{grayPen});
            $dcDev->MoveTo($rhPosCache->{left},
                    $rhPosCache->{top} + $rhPosCache->{height});
            $dcDev->LineTo(
                    $rhPosCache->{left},
                    $rhPosCache->{top});
            $dcDev->LineTo(
                    $rhPosCache->{left} + $rhPosCache->{width} - 1,
                    $rhPosCache->{top});

            $dcDev->SelectObject($rhBrush->{whitePen});
            $dcDev->LineTo(
                    $rhPosCache->{left} + $rhPosCache->{width} - 1,
                    $rhPosCache->{top} + $rhPosCache->{height} - 1);
            $dcDev->LineTo(
                    $rhPosCache->{left},
                    $rhPosCache->{top} + $rhPosCache->{height} - 1);

#                   $rhPosCache->{left} + $rhPosCache->{width},
#                   $rhPosCache->{top} + $rhPosCache->{height},

            $self->offsetTextLeft(1);
            $self->offsetTextRight(1);
            $self->offsetTextTop(1);
            }
        else {
            $self->offsetTextLeft(0);
            $self->offsetTextRight(0);
            $self->offsetTextTop(0);
            }

        if($self->prop("Bitmap")) {
            $self->paintBitmap($dcDev, $rhBrush, $rhPosCache, $objDesign);
            }
        else {
            $self->paintText($dcDev, $rhBrush, $rhPosCache);
            }
        }
    else {
        $dcDev->DrawEdge(
                $rhPosCache->{left},
                $rhPosCache->{top},
                $rhPosCache->{left} + $rhPosCache->{width},
                $rhPosCache->{top},
                0x0002 | 0x0004,        #BDR_SUNKENOUTER | BDR_RAISEDINNER
                0x0002                  #BF_TOP
                );
        }
#   $self->paintSelected($dcDev, $rhBrush, $rhPosCache);

    return(1);
    }





1;





#EOF
