=head1 NAME

Win32::GUI::Loft::Canvas - A "canvas", the working state of a Design.

=head1 DESCRIPTION

The Canvas is the working state of the Design. This includes which
controls that are selected.

The Canvas is the center of all dynamic activity in the
design; the Canvas is the Control in a Control-Model-View
relationship where the Design is the Model and the GUI
windows are the Views.

The Design doesn't know anything about this dynamic
behavuour, which means that a lot of interactivity coming
from the GUI must pass the Canvas on it's way to the Design
so the Canvas can notify the Views.

=cut





package Win32::GUI::Loft::Canvas;





use strict;
use Data::Dumper;
use Carp qw( cluck );

use Win32::GUI;

use Win32::GUI::Loft::Control;
use Win32::GUI::Loft::ControlProperty;





=head1 PROPERTIES

=head2 objDesign

The Win32::GUI::Loft::Design object that is the current design, or undef
if no such thing exists.

Set to 0 to undef

=cut
sub objDesign {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objDesign} = $val;
        $self->{objDesign} = undef if($val == 0);
        }

    return($self->{objDesign});
    }





=head2 objCanvas

The Win32::GUI::Loft::Canvas that is the current state of the objDesign()

Set to 0 to undef

=cut
sub objCanvas {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objCanvas} = $val;
        $self->{objCanvas} = undef if($val == 0);
        }

    return($self->{objCanvas});
    }





=head2 rhControlSelected

Hash ref with (key = Win32::GUI::Loft::Control string, value =
Win32::GUI::Loft::Control object). These are the controls that are
currently selected but does not include the window control
itself if no other control is selected.

=cut
sub rhControlSelected {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{rhControlSelected} = $val;
        }

    return($self->{rhControlSelected});
    }





=head2 rhControlActuallySelected

Hash ref with (key = Win32::GUI::Loft::Control string, value =
Win32::GUI::Loft::Control object). These are the controls that are
currently selected and DOES include the window control
itself if no other control is selected.

Readonly.

=cut
sub rhControlActuallySelected {
    my $self = shift; my $pkg = ref($self);

    if(!keys %{$self->rhControlSelected()}) {
        return( {
                $self->objDesign()->objControlWindow() =>
                $self->objDesign()->objControlWindow()
                } );
        }

    return($self->rhControlSelected());
    }





=head2 raView

Array ref with objects of type Win32::GUI::Loft::View that should be
notified when something happens to the model.

=cut
sub raView {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{raView} = $val;
        }

    return($self->{raView});
    }





=head1 METHODS

=head2 new()

Create new Canvas.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;

    my $self = {
            rhControlSelected       => {},
            raView                  => [],

            };
    bless $self, $pkg;


    return($self);
    }





=head2 propNotifyChange($raPropName, [$objBlocked])

Notify Views that the properties in $raPropName changed to a
new value for the selected controls. If $objBlocked
(Win32::GUI::Loft::View) is passed, don't notify that view.

Return 1 on success, else 0.

=cut
sub propNotifyChange {
    my $self = shift; my $pkg = ref($self);
    my ($raPropName, $objBlocked) = @_;
    defined($objBlocked) or $objBlocked = 0;

    my $rhControl = $self->rhControlSelected();

    #If no selected, view the window
    if(! (keys %$rhControl)) {
        $rhControl = { 1 => $self->objDesign()->objControlWindow() };
        }

    for my $objView (@{$self->raView()}) {
        $objView->propNotifyChange( $rhControl, $raPropName ) if($objBlocked != $objView);
        }

    return(1);
    }





=head2 propNotifySelected([$objBlocked])

The number of conrols that are selected has changed. If 
$objBlocked (Win32::GUI::Loft::View) is passed, don't notify 
that view.

Return 1 on success, else 0.

=cut
sub propNotifySelected {
    my $self = shift; my $pkg = ref($self);
    my ($objBlocked) = @_;
    defined($objBlocked) or $objBlocked = 0;

    my $rhControl = $self->rhControlSelected();

    #If no selected, view the window
    if(! (keys %$rhControl)) {
        $rhControl = { 1 => $self->objDesign()->objControlWindow() };
        }

    for my $objView (@{$self->raView()}) {
        $objView->propNotifySelected( $rhControl, [] ) if($objBlocked != $objView);
        }

    return(1);
    }





=head2 propNotifySelectionBox($left, top, $width, $height, [$objBlocked])

If $left is not undef, the user is click-n-dragging a
selection box with the specified dimensions.

If $left is undef, the user is not anymore.

Return 1 on success, else 0.

=cut
sub propNotifySelectionBox {
    my $self = shift; my $pkg = ref($self);
    my ($left, $top, $width, $height, $objBlocked) = @_;
    defined($objBlocked) or $objBlocked = 0;

    for my $objView (@{$self->raView()}) {
        $objView->propNotifySelectionBox($left, $top, $width, $height) if($objBlocked != $objView);
        }

    return(1);
    }





=head2 propNotifyFundamental([$objBlocked])

The number of controls has changed.

Return 1 on success, else 0.

=cut
sub propNotifyFundamental {
    my $self = shift; my $pkg = ref($self);
    my ($objBlocked) = @_;
    defined($objBlocked) or $objBlocked = 0;

    for my $objView (@{$self->raView()}) {
        $objView->propNotifyFundamental() if($objBlocked != $objView);
        }

    return(1);
    }





=head2 clusterNotifyFundamental([$objBlocked])

The number of clustered controls has changed for one or more
clusters.

Return 1 on success, else 0.

=cut
sub clusterNotifyFundamental {
    my $self = shift; my $pkg = ref($self);
    my ($objBlocked) = @_;
    defined($objBlocked) or $objBlocked = 0;

    for my $objView (@{$self->raView()}) {
        $objView->clusterNotifyFundamental() if($objBlocked != $objView);
        }

    return(1);
    }





=head2 setAppState()

Set the total state of controls in all windows so that they
match the state of the application.

Return 1 on success, else 0.

=cut
sub setAppState {
    my $self = shift; my $pkg = ref($self);

    #View the selected control's properties in the
    #properties window
##todo


    return(1);
    }






=head2 controlAlignSelected($how)

Align the selected controls to each other according to $how:

    right

Return 1 on success, else 0.

=cut
sub controlAlignSelected {
    my $self = shift; my $pkg = ref($self);
    my ($how) = @_; 
    my $raControl = [ values %{$self->rhControlSelected()} ];
    
    $self->objDesign()->controlAlignMultiple($raControl, $how);
    
    $self->propNotifyChange(["Left", "Top", "Width", "Height"]);

    return(1);
    }





=head2 controlSelected($objControl, $isSelected)

Mark the $objControl as $isSelected (0|1).

Return 1 on success, else 0.

=cut
sub controlSelected {
    my $self = shift; my $pkg = ref($self);
    my ($objControl, $isSelected) = @_;

    if($isSelected) {
###     if(!$objControl->designIsVisible()) {
            $self->rhControlSelected()->{$objControl} = $objControl;
###         }
        }
    else {
        delete $self->rhControlSelected()->{$objControl};
        }

    $objControl->designIsSelected($isSelected);

    return(1);
    }





=head2 controlMultipleSelect($rhControl, $isSelected)

Deselect the controls in $rhControl.

Return 1 on success, else 0.

=cut
sub controlMultipleSelect {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl, $isSelected) = @_;

    for my $objControl (values %{$rhControl}) {
        $self->controlSelected($objControl, $isSelected);
        }

    return(1);
    }





=head2 controlAllDeselect()

Deselect all selected controls.

Return 1 on success, else 0.

=cut
sub controlAllDeselect {
    my $self = shift; my $pkg = ref($self);

    #Deselect all
    for my $objControl (@{$self->objDesign()->raControl()}) {
        $objControl->designIsSelected(0);
        }

    #Clear hash ref with selected
    $self->rhControlSelected({});
    
    $self->propNotifySelected();

    return(1);
    }





=head2 controlAllSelect()

Select all controls (except the window).

Return 1 on success, else 0.

=cut
sub controlAllSelect {
    my $self = shift; my $pkg = ref($self);

#   $self->objDesign()->objControlWindow()->isSelected(0);

    #Select all
    for my $objControl (@{$self->objDesign()->raControl()}) {
        $self->controlSelected($objControl, 1);
        }

    $self->propNotifySelected();

    return(1);
    }





=head2 controlNew($type)

Create new control of $type and put it in the middle of the
window.

Return the newly created Win32::GUI::Loft::Control::$type, or undef on
failure.

=cut
sub controlNew {
    my $self = shift; my $pkg = ref($self);
    my ($type) = @_;

    my $objNew = $self->objDesign()->controlNew($type);

    $self->propNotifyFundamental();

    return($objNew);
    }





=head2 controlCut()

Cut the selected controls

Return the resulting string (to be put in the clipboard) on
success, else "".

=cut
sub controlCut {
    my $self = shift; my $pkg = ref($self);

    my $clipboard = $self->objDesign()->controlCopy( $self->rhControlSelected() );
    $self->controlDelete();

    return($clipboard);
    }





=head2 controlCopy()

Copy the selected controls.

Return the resulting string (to be put in the clipboard) on
success, else  "".

=cut
sub controlCopy {
    my $self = shift; my $pkg = ref($self);
    return( $self->objDesign()->controlCopy( $self->rhControlSelected() ) );
    }





=head2 controlCopyName()

Copy the name of selected controls.

Return the resulting string (to be put in the clipboard) on
success, else  "".

=cut
sub controlCopyName {
    my $self = shift; my $pkg = ref($self);
    return( $self->objDesign()->controlCopyName( $self->rhControlActuallySelected() ) );
    }





=head2 controlPaste($clipboard)

Paste the contents of the $clipboard.

Return 1 on success, else 0.

=cut
sub controlPaste {
    my $self = shift; my $pkg = ref($self);
    my ($clipboard) = @_;

    $self->controlAllDeselect();
    my $rhControl = $self->objDesign()->clipboardParseControl($clipboard);
    $self->objDesign()->controlPaste($rhControl);

    #Select the new controls
    for my $objControl (values %{$rhControl}) {
        $self->controlSelected($objControl, 1);
        }

    #Notify
    $self->propNotifyFundamental();

    return(1);
    }





=head2 controlDelete()

Delete the selected controls

Return 1 on success, else 0.

=cut
sub controlDelete {
    my $self = shift; my $pkg = ref($self);

    my $raControl = $self->rhControlSelected();     #Store selected
    $self->controlAllDeselect();                    #Deselect from canvas
    $self->objDesign()->controlDelete($raControl);  #Remove from design
    $self->propNotifyFundamental();                 #Nofify

    return(1);
    }





=head2 clusterNew($name)

Create a new cluster with $name, and the currently selected
controls.

Return 1 on success, else 0.

=cut
sub clusterNew {
    my $self = shift; my $pkg = ref($self);
    my ($name) = @_;

    $self->objDesign()->clusterNew($self->rhControlSelected(), $name) or return(0);

    $self->clusterNotifyFundamental();

    return(1);
    }





=head2 clusterDelete($objCluster)

Delete $objCluster from the Design.

Return 1 on success, else 0.

=cut
sub clusterDelete {
    my $self = shift; my $pkg = ref($self);
    my ($objCluster) = @_;

    $self->objDesign()->clusterDelete($objCluster) or return(0);

    $self->clusterNotifyFundamental();

    return(1);
    }





=head2 clusterVisibleToggle($objCluster)

Toggle the isVisible for $objCluster and update clustered
controls. Deselect if the new visible state is "invisible".

Return 1 on success, else 0.

=cut
sub clusterVisibleToggle {
    my $self = shift; my $pkg = ref($self);
    my ($objCluster) = @_;

    #Toggle and (de)select
    $objCluster->visibleToggle();

    #If "show", deselect all other controls before we select clustered controls
    $self->controlAllDeselect() if($objCluster->isVisible());

    #Select custered controls
    $self->controlMultipleSelect($objCluster->rhControl(), $objCluster->isVisible());


    $self->clusterNotifyFundamental();
    $self->propNotifySelected();

    return(1);
    }




=head2 clusterMemorize($objCluster)

Replace the clustered controls in $objCluster with the
currently selected ones.

Return 1 on success, else 0.

=cut
sub clusterMemorize {
    my $self = shift; my $pkg = ref($self);
    my ($objCluster) = @_;

    $self->objDesign()->clusterMemorize($objCluster, $self->rhControlSelected()) or return(0);

    return(1);
    }





=head2 helpFileSelected()

Return "type", e.g. "Button" for the currently selected
control, or "" if no or many controls are selected.

=cut
sub helpFileSelected {
    my $self = shift; my $pkg = ref($self);

    my @aControl = values %{$self->rhControlActuallySelected()};

    return($aControl[0]->type()) if(@aControl == 1);

    return("");
    }





1;





#EOF
