=head1 NAME Win32::GUI::Loft::Control::ForegroundBackground - A generic
parent for control that have the Foreground and Background
properties.

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::Control::ForegroundBackground;
use base qw( Win32::GUI::Loft::Control );





use strict;





=head1 PROPERTIES

=head1 METHODS

=head2 new()

Create new Control object.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;

    my $self = $pkg->SUPER::new();

    #New properties
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Foreground", "", undef, "", ""));
    $self->propertyAdd(Win32::GUI::Loft::ControlProperty->new(
            "Background", "", undef, "", ""));

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

    if((my $fg = $self->prop("Foreground") || "") ne "") {
        my ($r, $g, $b) = ($fg =~ m{(\d+)[^\d]+(\d+)[^\d]+(\d+)} );
        if(defined($b) && $b ne "") {
            push(@aOption, ("-foreground", [$r, $g, $b]));
            }
        }

    if((my $bg = $self->prop("Background") || "") ne "") {
        my ($r, $g, $b) = ($bg =~ m{(\d+)[^\d]+(\d+)[^\d]+(\d+)});
        if(defined($b) && $b ne "") {
            push(@aOption, ("-background", [$r, $g, $b]));
            }
        }

    return(@aOption);
    }





1;





#EOF
