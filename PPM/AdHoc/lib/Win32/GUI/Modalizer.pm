=head1 NAME

Win32::GUI::Modalizer -- Almost "correct" Windows modal 
dialog boxes


=head1 DESCRIPTION

=head2 What are modal/modeless windows?

A modal window is a window that has the user's entire
attention. Other windows in the application are "frozen" and
cannot be selected when the modal window is displayed. If
the window is "system modal", no oher window in the entire
OS can be selected. The opposite of a modal window is a
modeless window.


=head2 Win32::GUI::Modalizer

Win32::GUI::Modalizer is a class to help you display modal
dialog boxes using Win32::GUI. These aren't implemented in a
native way (yet, I hope) in Win32::GUI.

Modalizer differs from "real" modal windows in the following ways:

=over 4

=item *

The user may double click the title bar to maximize/restore
a modeless window.

=item *

Modeless windows aren't really disabled, they just give
focus to the modal window as soon as they get the focus.

=item *

The modal window is visible in the task bar.

=item *

When multiple modeless windows are visible when the modal
window is displayed, they can still change Z- order when
clicked.

=back


=head1 VERSION

Beta still.

=head1 USAGE

The SYNOPSIS example program demonstrates two modeless
windows and one dialog box.

You have to do quite a lot of manual work to get it to work,
mainly calling the Modalizer object from every window's
Activate() event.

Basicaly, what you have to do is:

=over 4

=item *

Create your window objects. 


=item *

Create the Modalizer and specify the modeless windows.


=item *

Create event routines for the Activate() events for all
your modal windows and all your modeless windows. Call the
activate() method from these.

=item *

That is the basic setup. Now we are ready to display the
modal window.

In e.g. a Click() event, call the beginDialog() method. The
first argument is the modal Window object to display.

The second argument is optional, and you only have to use it 
if you have many modeless windows visible (this is not the 
case in most situations). The second argument is the Window 
object that is currently active. It will have it's focus 
restored when the modal window is hidden.

The modal window is displayed.

=item *

When you want to close the modal window, call the
endDialog() method.


=item *

You're done. Cool!


=back


=head1 SYNOPSIS

	#!/usr/local/bin/perl -w
	
	use strict;
	
	use Win32::GUI;
	
	my $winModeless = new Win32::GUI::Window(
	        -left   => 13,
	        -top    => 32,
	        -width  => 439,
	        -height => 260,
	        -name   => "winModeless",
	        -text   => "Win32::GUI::Modalizer Synopsis [1]"
	        );
	
	$winModeless->AddButton(
	        -text    => "&Open",
	        -name    => "btnModelessOpen",
	        -left    => 358,
	        -top     => 207,
	        -width   => 70,
	        -height  => 21,
	        );
	
	$winModeless->AddButton(
	        -text    => "&Test",
	        -name    => "btnModelessTest",
	        -left    => 358,
	        -top     => 20,
	        -width   => 70,
	        -height  => 21,
	        );
	
	
	my $winModeless2 = new Win32::GUI::Window(
	        -left   => 100,
	        -top    => 100,
	        -width  => 439,
	        -height => 260,
	        -name   => "winModeless2",
	        -text   => "Win32::GUI::Modalizer Synopsis [2]"
	
	        );
	
	$winModeless2->AddButton(
	        -text    => "&Open",
	        -name    => "btnModeless2Open",
	        -left    => 358,
	        -top     => 207,
	        -width   => 70,
	        -height  => 21,
	        );
	
	
	my $winDialog = new Win32::GUI::DialogBox(
	        -left   => 50,
	        -top    => 50,
	        -width  => 439,
	        -height => 260,
	        -name   => "winDialog",
	        -text   => "Dialog Box",
	        );
	
	$winDialog->AddButton(
	        -text    => "&Ok",
	        -name    => "btnDialogOk",
	        -left    => 358,
	        -top     => 207,
	        -width   => 70,
	        -height  => 21,
	        );
	
	
	$winModeless->Show();
	$winModeless2->Show();
	
	
	#Do the Modalizer stuff
	use Win32::GUI::Modalizer;
	
	my $objModalizer = Win32::GUI::Modalizer->new($winModeless, $winModeless2);
	
	#Go modal
	Win32::GUI::Dialog();
	
	
	#Modeless window
	sub winModeless_Terminate {
	    return(-1);
	    }
	
	sub winModeless_Activate {
		defined($objModalizer) and $objModalizer->activate($winModeless);
	    return(1);
	    }
	
	sub btnModelessOpen_Click {
	    $objModalizer->beginDialog($winDialog, $winModeless);
	    return(1);
	    }
	
	sub btnModelessTest_Click {
	    Win32::GUI::MessageBox(0, "Clicked the Test button", "Test Button");
	    return(1);
	    }
	
	#Modeless2 window
	sub winModeless2_Terminate {
	    return(-1);
	    }
	
	sub winModeless2_Activate {
		defined($objModalizer) and $objModalizer->activate($winModeless2);
	    return(1);
	    }
	
	sub btnModeless2Open_Click {
	    $objModalizer->beginDialog($winDialog, $winModeless2);
	    return(1);
	    }
	
	#Dialog window
	sub winDialog_Terminate {
		$objModalizer->endDialog();
	    return 0;
	    }
	
	sub winDialog_Activate {
		$objModalizer->activate($winDialog);
	    return(1);
	    }
	
	sub btnDialogOk_Click {
	    winDialog_Terminate();
	    return(1);
	    }
	
	#EOF

=cut





package Win32::GUI::Modalizer;





use strict;

use Win32::GUI;





=head1 PROPERTIES

=head2 raWinModeless

Hash ref to Win32::GUI Windows to keep in the background 
while some window is modal. 

These are the windows you specify in the new() call, but you 
may change this at will unless you have a modal window 
visible.

=cut
sub raWinModeless { my $self = shift;
    my ($val) = @_;

    if(defined($val)) {
        $self->{raWinModeless} = $val;
        }

    return($self->{raWinModeless});
    }





=head2 rhBlocked

Hash ref with (key = Window object, value = block level).

=cut
sub rhBlocked { my $self = shift; my $pkg = ref($self);
	my ($val) = @_;

	if(defined($val)) {
		$self->{rhBlocked} = $val;
		}

	return($self->{rhBlocked});
	}





=head2 winModal

The Window object that is modal, or undef if no window is
modal.

Set to 0 to undef.

=cut
sub winModal { my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{winModal} = $val;
        $self->{winModal} = undef if($val == 0);
        }

    return($self->{winModal});
    }





=head2 winModeless

Maybe the Window object that opened the modal window, or
undef if no such window was defined.

Set to 0 to undef.

=cut
sub winModeless { my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{winModeless} = $val;
        $self->{winModeless} = undef if($val == 0);
        }

    return($self->{winModeless});
    }





=head1 METHODS

=head2 new(@aWinModeless)

Create new Modalizer object for the windows in @aWinModeless
(Win32::GUI::Window objects).

These Windows objects are the modeless ones that should be 
"frozen" when a modal window is displayed.

=cut
sub new { my $pkg = shift; $pkg = ref($pkg) || $pkg;
    my (@aWinModeless) = @_;

    my $self = {
        raWinModeless			=> \@aWinModeless,
        rhBlocked				=> {},
        winModal				=> undef,
        winModeless				=> undef,
        };
    bless $self, $pkg;

    return($self);
    }





=head2 beginDialog($winModal, [$winModeless])

Set the application in a modal state with $winModal as the
modal window. Show $winModal.

If $winModeless is passed, this is the main modeless window
that was active when the modal window was displayed. This
window will get the focus back when endDialog() is called.

The sub will return immediately. Call endDialog() to exit the
modal state.

Return 1 on success, else 0.

=cut
sub beginDialog { my $self = shift; my $pkg = ref($self);
	my ($winModal, $winModeless) = @_;
	defined($winModeless) and $self->winModeless($winModeless);

	#Already modal?
	return(0) if($self->winModal());

	$self->winModal($winModal);

	for my $winCur (@{$self->raWinModeless()}) {
		$self->rhBlocked()->{ $winCur } = 0;
		}

	$self->rhBlocked()->{ $winModal } = 1;
#print "Modal: Block" . $self->winModal() . "\n";
	$winModal->Show();
	$winModal->BringWindowToTop();

	return(1);
	}





=head2 endDialog()

End the modal state, hide the modal window and restore the
state of all other affected windows.

Return 1 on success, else 0.

=cut
sub endDialog { my $self = shift; my $pkg = ref($self);

	#Not modal?
	return(0) if(!$self->winModal());

	#Do the modal window
	my $winModal = $self->winModal();
	$self->winModal(0);
	$winModal->Hide();		#Will not enter the activate() method, winModal() == 0

	#Do windows other than the main modeless window
	my $winModeless = defined($self->winModeless()) ? $self->winModeless() : 0;
	for my $winCur (@{$self->raWinModeless()}) {
		next if($winCur == $winModeless);
		$winCur->Enable() if($winCur->IsVisible());
		$winCur->SetFocus();
		}

	#Do the main modeless window
	if($self->winModeless()) {
		$self->winModeless()->Enable();
		$self->winModeless()->SetFocus();
		$self->winModeless(0);
		}

	return(1);
	}





=head2 activate($winActivated)

Call this from the Activate() event for all windows that are 
controlled by Modalizer, both the modeless windows and the 
modal windows.

$winActivated is the Window that just got activated.

Return 1 on success, else 0.

=cut
sub activate { my $self = shift; my $pkg = ref($self);
	my ($winActivated) = @_;

	#Not modal?
	return(0) if(!$self->winModal());

	#Selectively block re-entry
#print "Modal: " if($self->winModal() == $winActivated);
	$self->rhBlocked()->{$winActivated}--;
	if($self->rhBlocked()->{$winActivated} >= 0) {
#print "Blocked: $winActivated: " . $self->rhBlocked()->{$winActivated} . "\n\n";
		return(0);
		}
#print "Passed: $winActivated\n";

	if($winActivated == $self->winModal()) {

		#Bring to front all visible main windows
		for my $winCur (@{$self->raWinModeless()}) {
			if($winCur->IsVisible()) {
				$self->rhBlocked()->{$winCur} = 1;
#print "Modeless: Block: $winCur\n";
				$winCur->BringWindowToTop();
				}
			}

		#Bring to front the modal window
		$self->rhBlocked()->{ $self->winModal() } = 1;
#print "Modal: Block: " . $self->winModal() . "\n";
		$self->winModal()->BringWindowToTop();
		}
	else {
		#Bring to front the modal window
		$self->rhBlocked()->{ $self->winModal() } = 1;
#print "Modal: Block: " . $self->winModal() . "\n";

		$self->winModal()->BringWindowToTop();
		}

#print "\n";

	return(1);
	}





=head1 AUTHOR

Copyright 2001.. Johan Lindström <johanl@bahnhof.se>

Same license as Perl.

=cut





1;





#EOF