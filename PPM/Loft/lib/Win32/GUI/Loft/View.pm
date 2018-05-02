=head1 NAME

Win32::GUI::Loft::View - A View in the MCV model.

=cut





package Win32::GUI::Loft::View;





use strict;
use Data::Dumper;
use Carp qw( cluck );





=head1 PROPERTIES

=head1 METHODS

=head2 new()

Create new View.

=cut
sub new { my $pkg = shift; $pkg = ref($pkg) || $pkg;

	my $self = {

			};
	bless $self, $pkg;


	return($self);
	}





=head2 propPopulate($rhControl)

Populate the properties list view with the controls in
$rhControl.

Return 1 on success, else 0.

=cut
sub propPopulate { my $self = shift; my $pkg = ref($self);
	my ($rhControl) = @_;

	return(1);
	}





=head2 propNotifyChange($rhControl, $raPropName)

Update the properties in $raPropName for the controls in
$rhControl.

Return 1 on success, else 0.

=cut
sub propNotifyChange { my $self = shift; my $pkg = ref($self);
	my ($rhControl, $raPropName) = @_;

	return(1);
	}





=head2 propNotifySelected($rhControl)

The number of conrols that are selected has changed.

Return 1 on success, else 0.

=cut
sub propNotifySelected { my $self = shift; my $pkg = ref($self);
	my ($rhControl) = @_;

	return(1);
	}






=head2 propNotifySelectionBox($left, top, $width, $height)

If $left is not undef, the user is click-n-dragging a
selection box with the specified dimensions.

If $left is undef, the user is not anymore.

Return 1 on success, else 0.

=cut
sub propNotifySelectionBox { my $self = shift; my $pkg = ref($self);
	my ($left, $top, $width, $height) = @_;

	return(1);
	}





=head2 propNotifyFundamental()

The number of controls has changed.

Return 1 on success, else 0.

=cut
sub propNotifyFundamental { my $self = shift; my $pkg = ref($self);

	return(1);
	}





=head2 clusterNotifyFundamental()

The number of clustered controls has changed for one or more 
clusters.

Return 1 on success, else 0.

=cut
sub clusterNotifyFundamental { my $self = shift; my $pkg = ref($self);



	return(1);
	}





1;





#EOF