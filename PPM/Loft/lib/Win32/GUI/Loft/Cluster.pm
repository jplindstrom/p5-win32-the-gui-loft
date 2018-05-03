=head1 NAME 

Win32::GUI::Loft::Cluster - A "Cluster", a group of controls.

=cut





package Win32::GUI::Loft::Cluster;





use strict;
use Data::Dumper;
use Carp qw( cluck );

use Win32::GUI;

use Win32::GUI::Loft::Control;
use Win32::GUI::Loft::ControlProperty;





=head1 PROPERTIES

=head2 name

The name of the cluster. Not unique.

=cut

sub name {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{name} = $val;
        }

    return($self->{name});
    }





=head2 isVisible

Whether the cluster is currently visible. When set, update 
clustered controls using setDesignIsVisible().

Default: 1

=cut

sub isVisible {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{isVisible} = $val;
        
        $self->setDesignIsVisible();
        }

    return($self->{isVisible});
    }





=head2 rhControl

Hash ref with (key = Win32::GUI::Loft::Control string, value = 
Win32::GUI::Loft::Control object). These are the controls that are 
currently in this cluster.

=cut

sub rhControl {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{rhControl} = $val;
        }

    return($self->{rhControl});
    }





=head1 METHODS

=head2 new()

Create new Cluster.

=cut

sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;

    my $self = {
            name                    => "",
            isVisible               => 1,
            rhControl       => {},
            
            };
    bless $self, $pkg;


    return($self);
    }





=head2 controlAdd($rhControl)

Add the controls in $rhControl to the clustered controls.

Return 1 on success, else 0.

=cut

sub controlAdd {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl) = @_;

    for my $nameControl (keys %{$rhControl}) {
        $self->rhControl()->{ $nameControl } = $rhControl->{ $nameControl };
        }

    return(1);
    }





=head2 controlDelete($rhControl)

Remove the controls in $rhControl from the clustered 
controls.

Return 1 on success, else 0.

=cut

sub controlDelete {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl) = @_;

    for my $nameControl (keys %{$self->rhControl()}) {
        delete $self->rhControl()->{$nameControl}
                if(exists $rhControl->{$nameControl});
        }

    return(1);
    }





=head2 controlIsClustered($objControl)

Return 1 if $objControl is part of this cluster, else 0.

=cut

sub controlIsClustered {
    my $self = shift; my $pkg = ref($self);
    my ($objControl) = @_;

    return( exists $self->rhControl()->{$objControl} ? 1 : 0 );
    }





=head2 visibleToggle()()

Toggle the isVisible state.

Return the new visible state.

=cut

sub visibleToggle() {
    my $self = shift; my $pkg = ref($self);
    return( $self->isVisible( $self->isVisible() ? 0 : 1 ) );
    }





=head2 setDesignIsVisible()

Set the designIsVisible for all clustered controls to the 
current isVisible value.

Return 1 on success, else 0.

=cut

sub setDesignIsVisible {
    my $self = shift; my $pkg = ref($self);

    my $visible = $self->isVisible();
    for my $objControl (values %{$self->rhControl()}) {
        $objControl->designIsVisible( $visible );
        }

    return(1);
    }





1;





#EOF
