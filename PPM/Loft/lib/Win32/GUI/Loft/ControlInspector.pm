=head1 NAME

Win32::GUI::Loft::ControlInspector - Used to inspect 
controls when they get built

=head1 DESCRIPTION

If you need to change something about about a control during
build, you need to subclass this class and provide the
needed behaviour.

The ControlInspector object is also used to create actual
Win32::GUI controls when there are Custom controls in the
Design.

You pass this object to the buildWindow() method of the
Design object you want to build.

=cut





package Win32::GUI::Loft::ControlInspector;





use strict;





=head1 PROPERTIES

=head1 METHODS

=head2 new()

Create new ControlInspector object.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;

    my $self = {
        };
    bless $self, $pkg;


    return($self);
    }





=head2 buildOptions($objControl, $raOption)

This method gets called during the build process before the 
creation of each control.

Return array of build options which in the unmodified case
is equivalent to returning @$aOption.

$raOption contains key, value pairs that will be passed on
to the AddXXXX method to create the object. Option names may
be present many times, so you may NOT treat it as a hash.

An example of a $raOption:

    [ "-name", "winMain", "-text", "Main window" ]

You may change the contents of $raOption. You may NOT change
$objControl!

You may want to subclass this method if you want to change
some option for a certain control. Use the "Name" property
to identify the control.

Return the array on success, else an empty array () in which
case the control will not be created.

=cut
sub buildOptions {
    my $self = shift; my $pkg = ref($self);
    my ($objControl, $raOption) = @_;

    #Use this to determine if you need to fiddle with
    #the $raOption
#   my $name = $objControl->prop("Name");

    return(@$raOption);
    }





=head2 buildAdd($objContainer, $objControl)

This method gets called during the build process once for 
each Custom control in the window.

Insert a new Win32::GUI object into $objContainer (which is
probably, but not certainly, a Win32::GUI::Window or
DialogBox). Not that you'll have to actually B<insert> the
control, so use AddXXXX or somesuch.

You may NOT change $objControl!

You may want to subclass this method if you want to use the
Custom control and add controls of your own. Use the "Name"
property to identify the control.

Return the newly created Win32::GUI object, or undef on
errors (in which case the the rest of the dialog will be
created as usual).

=cut
sub buildAdd {
    my $self = shift; my $pkg = ref($self);
    my ($objContainer, $objControl) = @_;

    #Use this to determine what kind of control you want
    #to add
#   my $name = $objControl->prop("Name");

    #Other properties of the Custom control are:
    #Left, Top, Height, Width, Visible, Enable
    #That's all you get to play with.

#   my $objNew = $objContainer->AddXXX();   #Then you return $objNew

    return(undef);
    }





1;





#EOF
