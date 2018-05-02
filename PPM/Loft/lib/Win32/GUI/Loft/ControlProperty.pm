=head1 NAME 

Win32::GUI::Loft::ControlProperty - A control property (e.g. 
Left).

=head1 SYNOPSIS



=cut





package Win32::GUI::Loft::ControlProperty;





use strict;
use Carp qw( cluck );

use Data::Dumper;





=head1 PROPERTIES

=head2 name

The property name.

=cut
sub name {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{name} = $val;
        }

    return($self->{name});
    }





=head2 nameProperty

The name of the sub/property that is used to get/set the 
value for this property when invoked on a Win32::GUI control.

This may be "" if no such sub exists.

Example: "Left"

=cut
sub nameProperty {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{nameProperty} = $val;
        }

    return($self->{nameProperty});
    }





=head2 nameOption

The name of the option that is used to set the value for 
this property when the Win32::GUI control is created. 

This may be "" if no such option exists.

Example: "-left"

=cut
sub nameOption {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{nameOption} = $val;
        }

    return($self->{nameOption});
    }





=head2 value

The current value of this property.

=cut
sub value {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val) && !$self->readonly()) {
        $self->{value} = $val;
        }

    return($self->{value});
    }





=head2 valueParameter

The current value of this property, transformed to what 
should be fed to the method indicated by nameProperty().

Readonly.

=cut
sub valueParameter {
    my $self = shift; my $pkg = ref($self);
    
    return($self->value()) if($self->isScalar());
    return($self->value()) if($self->isBoolean());

    #It's multi value
    
    #Is the first element in the list NOT a hash ref? 
    return($self->value()) if("HASH" ne ref($self->raValue()->[0]));
    
    #It's a multi value with indirection
    
    for my $rhItem (@{$self->raValue()}) {
        my ($key) = keys %$rhItem;
        return($rhItem->{ $key }) if($key eq $self->value());
        }

    cluck("ControlProperty::valueParameter(): Could not find parameter value for value (" . $self->value() . ")");

    return( undef );
    }





=head2 valueIncSnap

The current value of this property. When set, increase the 
current value. Snap to a multiple of $snap (if != 0).

=cut
sub valueIncSnap {
    my $self = shift; my $pkg = ref($self);
    my ($val, $snap) = @_;

    if(defined($val) && !$self->readonly()) {
        $self->{value} += $val;
        $self->{value} = int($self->{value} / $snap) * $snap if($snap != 0);
        }

    return($self->{value});
    }





=head2 raValue

Array ref with allowed values for this property. 

An empty array means that any values are allowed.

An array of scalars means that these values are allowed. The 
value will be set using a call to the nameProperty or using 
the nameOption.

Example: [ "0", "1" ]

An array with hash refs means: (key = the property 
value, value = the parameter value that will be passed to 
nameProperty or nameOption).

Example: [ { "current" => 0 }, { "left edge" => 1, } ]

=cut
sub raValue {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{raValue} = $val;
        }

    return($self->{raValue});
    }





=head2 raValuesString

Array ref with allowed values as plain strings. Empty if any 
values are allowed.

Readonly.

=cut
sub raValuesString {
    my $self = shift; my $pkg = ref($self);

    if(ref($self->raValue()->[0]) eq "HASH") {
        my @aVal;
        for my $rhItem (@{$self->raValue()}) {
            push(@aVal, keys %$rhItem);
            }
            
        return(\@aVal);
        }
        
    return($self->raValue());
    }





=head2 isBoolean

Return 1 if this property is a boolean value, else 0.

=cut
sub isBoolean {
    my $self = shift; my $pkg = ref($self);

    if(!defined($self->{isBoolean})) {
        $self->{isBoolean} = ( 
                @{$self->raValue()} == 2 && 
                $self->raValue()->[0] eq "0" && 
                $self->raValue()->[1] eq "1"
                ) ? 1 : 0;
        }

    return($self->{isBoolean});
    }





=head2 isMultiValue

Return 1 if this property is a multi-value, else 0.

=cut
sub isMultiValue {
    my $self = shift; my $pkg = ref($self);
     
    if(!defined($self->{isMultiValue})) {
        $self->{isMultiValue} = defined($self->raValue()->[0]) ? 1 : 0;
        }

    return($self->{isMultiValue});
    }





=head2 isScalar

Return 1 if this property is a scalar value, else 0.

=cut
sub isScalar {
    my $self = shift; my $pkg = ref($self);
     
    return(0) if($self->isMultiValue());
    return(0) if($self->isBoolean());

    return(1);
    }





=head2 readonly

Whether the property is currently readonly or not.

Default: 0

=cut
sub readonly {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{readonly} = $val;
        }

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
    defined($name) or die("ControlProperty->new(): $name must be passed");
    defined($nameProperty) or $nameProperty = $name;
    defined($nameOption) or $nameOption = lc("-$name");
    defined($value) or $value = undef;      #Maybe "" ?
    defined($raValue) or $raValue = [];

    my $self = {
        'name'                  => $name,
        'nameProperty'          => $nameProperty,
        'nameOption'            => $nameOption,
        'value'                 => $value,
        'raValue'               => $raValue,
        
        };
    bless $self, $pkg;
    
    $self->readonly(0);

    return($self);
    }





=head2 guiSet(Win32::GUI $objGuiControl)

Set/assign the property value to the $objGuiControl using 
the corresponding Win32::GUI method.

Return 1 on success, else 0.

=cut
sub guiSet {
    my $self = shift; my $pkg = ref($self);
    my ($objGuiControl) = @_;

    if(my $method = $self->nameProperty()) {
        eval {
            $objGuiControl->$method( $self->value() );
            };
        if($@) {
            warn(sprintf("ControlProperty::guiSet(%s) failed on object (%s->%s) %s",
                    $self->value(),
                    ref($objGuiControl),
                    $method, 
                    $@)
                    );
            return(0);
            }
        }
    ##todo: else, ChangeOption() ?

    return(1);
    }





=head2 transformSlim()

Transform the object to be a slimmed down representation of 
the important values.

Return 1 on success, else 0.

=cut
sub transformSlim {
    my $self = shift; my $pkg = ref($self);

    #value
    delete $self->{'name'};
    delete $self->{'nameProperty'};
    delete $self->{'nameOption'};
    delete $self->{'raValue'};

    return(1);
    }





=head2 imprint($objFresh, $name)

Imprint $objFresh (a Win32::GUI::Loft::ControlProperty) with the 
important values of this object. Set the name() to $name.

Return the altered $objFresh.

=cut
sub imprint {
    my $self = shift; my $pkg = ref($self);
    my ($objFresh, $name) = @_;

    $objFresh->{name} = $name;
    $objFresh->{value} = $self->{value};

    return($objFresh);
    }





1;





#EOF
