=head1 NAME 

Win32::GUI::Loft::ControlProperty::Readonly - A control 
property (e.g. Left). Readonly; the value can only set using 
new(). value() and valueIncSnap() are redefiend to do only 
return the old value.

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::ControlProperty::Readonly;
use base qw( Win32::GUI::Loft::ControlProperty );





use strict;
use Carp qw( cluck );

use Data::Dumper;





=head1 PROPERTIES

=head2 value

The current value of this property.

Readonly. Can only be set during new().

=cut
sub value {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    return($self->{value});
    }





=head2 valueIncSnap

The current value of this property. When set, increase the 
current value. Snap to a multiple of $snap (if != 0).

Readonly. Can only be set during new().

=cut
sub valueIncSnap {
    my $self = shift; my $pkg = ref($self);
    my ($val, $snap) = @_;

    return($self->{value});
    }





=head2 readonly

Whether the property is currently readonly or not.

Default: 0

Readonly.

=cut
sub readonly {
    my $self = shift; my $pkg = ref($self);
    return($self->{readonly});
    }





=head1 METHODS

=head2 new($name, [ $value = "", $raValue = [], $nameOption, $nameProperty = $name ])

Create new ControlProperty object.

Die if $name isn't passed.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;
    my ($name, $value, $raValue, $nameOption, $nameProperty) = @_;  

    my $self = $pkg->SUPER::new($name, $value, $raValue, $nameOption, $nameProperty);
    $self->{value} = $value;

    return($self);
    }





1;





#EOF
