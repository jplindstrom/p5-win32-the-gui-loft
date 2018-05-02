=head1 NAME

Win32::GUI::TabStripGroup -- Manager for the tabs and 
controls in a TabStrip.

=head1 SYNOPSIS



=cut





package Win32::GUI::TabStripGroup;





use strict;
use Data::Dumper;

use Win32::GUI;





=head1 PROPERTIES

=head2 tsStrip

The TabStrip to manage.

=cut
sub tsStrip {
    my $self = shift;
    my ($val) = @_;

    if(defined($val)) {
        $self->{tsStrip} = $val;
        }

    return($self->{tsStrip});
    }





=head2 rhTab

Ref to a hash representing the tabs in the TabStrip. Like so:

    {
    0   =>  #The first tab
        $objAControl =>     #This is the text value of the object, i.e. the address
            {
            visibility => 1,
            objControl => $objAControl,
            },
        $objAnotherControl =>
            {
            visibility => 0,
            objControl => $objAnotherControl,
            },
        },
    1   =>  #The second tab
        {
        $objAControlOnTheSecondTab => 
            {
            visibility => 1,
            objControl => $objAControlOnTheSecondTab,
            },
        },  
    }

You will not need to manupulate this structure manually 
under normal circumstances.

=cut
sub rhTab {
    my $self = shift;
    my ($val) = @_;

    if(defined($val)) {
        $self->{rhTab} = $val;
        }

    return($self->{rhTab});
    }





=head1 METHODS

=head2 new(Win32::GUI::TabStrip $tsStrip)

Create new manager object for $tsStrip.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;
    my ($tsStrip) = @_;

    my $self = {
        rhTab               => {},
        
        };
    bless $self, $pkg;
    
    $self->tsStrip($tsStrip);
    
    return($self);
    }





=head2 registerControl($tab, $objControl)

Add $objControl to the tab $tab and remember it's visibility 
state.

This will bring the visibility state of $objControl under 
the control of TabStripGroup. Controls on unselected tabs 
will be invisible, while controls on the selected tab will 
have the visibility state remembered here.

If you need to manually change the visibility of a control, 
simply re-register it with this method after calling it's 
Show() or Hide() method.

NOTE: The visibility feature isn't implemented yet.

Return 1 on success, else 0.

=cut
sub registerControl {
    my $self = shift;
    my ($tab, $objControl) = @_;

    $self->rhTab()->{$tab}->{$objControl}->{objControl} = $objControl;
#   $self->rhTab()->{$tab}->{$objControl}->{visible} = $objControl->isVisible();
    $self->rhTab()->{$tab}->{$objControl}->{visible} = 1;
    
    return(1);
    }





=head2 showTab($tab, [$changeTab = 0])

Show the controls on $tab and hide the controls on all other 
tabs. The controls affected are those registered with 
registerControl(). If $changeTab is true, select the correct 
tab in the TabStrip control.

Call this from the Click() event of your TabStrip. So if $W 
is your window object and $objTSManager is your 
TabStripGroup object:

    sub TS_Click {
        $objTSManager->showTab( $W->TS->SelectedItem() );
        }

Return 1 on success, else 0.

=cut
sub showTab {
    my $self = shift; my $pkg = ref($self);
    my ($showTab, $changeTab) = @_;
    defined($changeTab) or $changeTab = 0;
    
    #Loop the tabs
    for my $tab (keys %{$self->rhTab()}) {
        if($tab == $showTab) {
            #Show, maybe...
            for my $rhControl (values %{$self->rhTab()->{$tab}}) {
                if($rhControl->{visible}) {                 
                    $rhControl->{objControl}->Show();
                    }
                else {
                    $rhControl->{objControl}->Hide();
                    }
                }
            }
        else {
            #Hide
            for my $rhControl (values %{$self->rhTab()->{$tab}}) {
                $rhControl->{objControl}->Hide();
                }
            }
        }
        
    $self->tsStrip()->Select($showTab) if($changeTab);

    return(1);
    }





1;





#EOF
