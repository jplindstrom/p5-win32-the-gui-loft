=head1 NAME Win32::GUI::Loft::Control::StatusBar - A StatusBar control

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::StatusBar;
use base qw( Win32::GUI::Loft::Control );





use strict;

#use Data::Denter;





=head1 PROPERTIES

=head2 nameDefault

The control's default name. This will affect, e.g. the
default control name when a new control is created.

E.g. "sbStatusBar".

Readonly.

=cut

sub nameDefault {
    my $self = shift; my $pkg = ref($self);
    return("sbStatusBar");
    }





=head2 type

The control's type name.

E.g. "StatusBar".

Readonly.

=cut

sub type {
    my $self = shift; my $pkg = ref($self);
    return("StatusBar");
    }





=head2 addMethod

The name of the AddXxxx() method to use when adding this
control to a container object.

Readonly

=cut

sub addMethod {
    my $self = shift; my $pkg = ref($self);
    return("AddStatusBar");
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





=head1 METHODS

=head2 new()

Create new Control object.

=cut

sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;

    my $self = $pkg->SUPER::new();

    #New defaults
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Width", 160));
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty::Readonly->new(
            "Height", 18));

    #New properties
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Text", ""));
#   $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
#           "Align", undef, [ "", "left", "center", "right" ], undef, ""));
#   $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
#           "Valign", undef, [ "", "top", "center", "bottom" ], undef, ""));
#   $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
#           "Default", 0, [ 0, 1 ], undef, ""));

    return($self);
    }





=head2 paint($dcDev, $rhBrush, $objDesign, $rhPosCache)

Paint the control in the $dcDev.

Return 1 on success, else 0.

=cut

sub paint {
    my $self = shift; my $pkg = ref($self);
    my ($dcDev, $rhBrush, $objDesign, $rhPosCache) = @_;

    return(1) if(!$self->designIsVisible());



    #The right corner
    Win32::GUI::AdHoc::DrawFrameControl($dcDev,
            $rhPosCache->{left},
            $rhPosCache->{top},
            $rhPosCache->{left} + $rhPosCache->{width},
            $rhPosCache->{top} + $rhPosCache->{height},
            3,                          #DFC_SCROLL
            0x0008                      #DFCS_SCROLLSIZEGRIP 
            );

    #Draw sunken box
    $dcDev->SelectObject($rhBrush->{whiteBrush});

    $dcDev->BkMode(1);

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
    
    $self->offsetTextLeft(2);
    $self->offsetTextTop(1);


    
    $self->paintText($dcDev, $rhBrush, $rhPosCache);

    return(1);
    }





1;





#EOF
