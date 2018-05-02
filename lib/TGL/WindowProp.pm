=head1 NAME

TGL::WindowProp -- The Design window

=head1 SYNOPSIS

Oh, man...

=cut





package TGL::WindowProp;
@ISA = qw( Win32::GUI::AppWindow Win32::GUI::Loft::View );
use Win32::GUI::AppWindow;
use Win32::GUI::Loft::View;





use strict;
use Carp qw(cluck);
use Data::Dumper;
#use Data::Denter;

use Win32::GUI;
use Win32;
use Win32::GUI::AdHoc;
use Win32::GUI::Resizer qw( negResize );
use Win32::GUI::DragDrop;

use Win32::GUI::Loft::Control;
use Win32::GUI::Loft::Control::Window;
use Win32::GUI::Loft::Control::Button;





#This class is a singleton. This is that object.
my $gObjSingleton = undef;

#Some things like bitmaps and stuff _needs_ to be persistent
#outside of their scope.
my %ghPerm;





=head1 PROPERTIES

=head2 winProp

The Properties window object

=cut
sub winProp {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{winProp} = $val;
        }

    return($self->{winProp});
    }





=head2 objResizerDesign

The Win32::GUI::Resizer object used to resize the controls
in the winProp window.

=cut
sub objResizerDesign {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objResizerDesign} = $val;
        }

    return($self->{objResizerDesign});
    }





=head2 objWindowApp

The main window object

=cut
sub objWindowApp {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objWindowApp} = $val;
        }

    return($self->{objWindowApp});
    }





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





=head2 objWindowDesign

The design window object

=cut
sub objWindowDesign {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objWindowDesign} = $val;
        }

    return($self->{objWindowDesign});
    }





=head2 propLastIndex

The index of the property that was last edited.

=cut
sub propLastIndex {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{propLastIndex} = $val;
        }

    return($self->{propLastIndex});
    }





=head2 propLastKey

The key of the property that was last edited.

=cut
sub propLastKey {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{propLastKey} = $val;
        }

    return($self->{propLastKey});
    }





=head2 propLastValue

The initial value of the property that was last displayed.

=cut
sub propLastValue {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{propLastValue} = $val;
        }

    return($self->{propLastValue});
    }





=head2 propIsDirty

Whether the currently edited property was actually changed.

=cut
sub propIsDirty {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{propIsDirty} = $val;
        }

    return($self->{propIsDirty});
    }





=head2 winInitiatedProperty

The Win32::GUI::Window from where the last property edit was 
initiated, or undef if no window initiated it.

Used to reset focus to that window after an edit.

Set to 0 to undef

=cut
sub winInitiatedProperty {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{winInitiatedProperty} = $val;
        $self->{winInitiatedProperty} = undef if($val eq "0");
        }

    return($self->{winInitiatedProperty});
    }





=head1 METHODS

=head2 new()

Create new UI for Windows.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;
    defined($gObjSingleton) and return($gObjSingleton);

    my $self = $gObjSingleton = $pkg->SUPER::new();

    $self->objWindowDesign(undef);
    $self->objWindowApp(undef);
    $self->objCanvas(undef);
    $self->propLastKey("");
    $self->propLastValue("");
    $self->propLastIndex(-1);
    $self->propIsDirty(0);
    $self->winInitiatedProperty(undef);

    $self->winProp(undef);


    $self->{timOpen_Timer} = 0;     #Internal

    return($self);
    }





=head2 init($winMain)

Init application, info, windows etc.

Return 1 on succes, else 0.

=cut
sub init {
    my $self = shift; my $pkg = ref($self);
    my ($winMain) = @_;


    ###Build GUI

    #The main window

    my $w = 200;
    my $h = 450;
    my $winProp = new Win32::GUI::Window(
          -parent => $winMain,
          -left   => 200,
          -top    => 50,
          -width  => $w,
          -height => $h,
          -name   => "winProp",
          -text   => "Properties",
          );
    $winProp->{-dialogui} = 1;
    my ($width, $height) = ($winProp->GetClientRect)[2..3];
    $self->winProp($winProp);


    $winProp->AddButton(
           -text    => "Ok",
           -name    => "btnOk",
           -left    => 10000,
           -top     => 10000,
           -width   => 0,
           -height  => 0,
           -ok => 1,
          );
    #To prevent the Esc button to close the dialog window
    $winProp->AddButton(
           -text    => "Cancel",
           -name    => "btnFakeCancel",
           -left    => 10000,
           -top     => 10000,
           -width   => 0,
           -height  => 0,
           -cancel => 1,
          );

    my $top = 2;
    $winProp->AddLabel(
           -text    => "",
           -name    => "lblLocation",
           -left    => 4,
           -top     => $top,
           -width   => ($width / 2 ),
           -height  => 16,
          );
    $winProp->AddLabel(
           -text    => "",
           -name    => "lblSelection",
           -align   => "right",
           -left    => $width / 2,
           -top     => $top,
           -width   => ($width / 2) - 8,
           -height  => 16,
          );

    $top += 16;
    $winProp->AddLabel(
           -text    => "- ? -",
           -name    => "lblControl",
           -left    => 4,
           -top     => $top,
           -width   => $width - 8,
           -height  => 16,
          );

    $top += 16;
    $winProp->AddLabel(
           -text    => "",
           -name    => "lblProperty",
           -left    => 9,
           -top     => $top + 3,
           -width   => ($width / 2) - 9,
           -height  => 16,
          );
    $winProp->AddTextfield(
           -text    => "",
           -name    => "tfValue",
           -left    => $width / 2,
           -top     => $top,
           -width   => $width / 2,
           -height  => 20,
           -tabstop => 1,
           -visible => 0,
          );
    $winProp->AddCheckbox(
           -text    => "",
           -name    => "chbValue",
           -left    => ($width / 2) + 1,
           -top     => $top + 2,
           -width   => 20,
           -height  => 20,
           -tabstop => 1,
           -visible => 0,
          );
    $winProp->AddCombobox(
           -text    => "",
           -name    => "cbValue",
           -left    => $width / 2,
           -top     => $top,
           -width   => $width / 2,
           -height  => 200,
           -tabstop => 1,
           -visible => 0,
           -style   => WS_VISIBLE | 2 | Win32::GUI::AdHoc::CBS_DROPDOWNLIST,            # | WS_NOTIFY,  # Dropdown Style
          );

    $top += 22;
    my $lvwProp = $winProp->AddListView(
            -name      => "lvwProp",
            -text      => "",
            -left      => 0,
            -top       => $top,
            -width     => $width,
            -height    => $height - $top,
            -style     =>
                    WS_CHILD |
                    WS_VISIBLE |
#                   0x0200 |            #LVS_EDITLABELS
                    1,
            -fullrowselect => 1,
            -gridlines => 1,
            );

    $lvwProp->InsertColumn(
            -index => 0,
            -width => $width / 2,
            -text  => "Property",
            );
    $lvwProp->InsertColumn(
            -index => 1,
            -width => $width / 2,
            -text  => "Value",
            );


    #Watch for times to show Open dialog
    $winProp->AddTimer("timOpen", 1000/5);


    my $objResizer = Win32::GUI::Resizer->new($winProp);
    $self->objResizerDesign($objResizer);
    $objResizer->raRelations([
            'winWidth' => [
                    ['$winResize->lvwProp->Width()'],
                    ['$winResize->tfValue->Width()'],
                    ['$winResize->lblSelection->Left()', \&Win32::GUI::Resizer::div2Resize],
                    ['$winResize->lblSelection->Width()', \&Win32::GUI::Resizer::div2Resize],
                    ['$winResize->lblLocation->Width()', \&Win32::GUI::Resizer::div2Resize],
                    ],
            'winHeight' => [
                    ['$winResize->lvwProp->Height()'],
                    ],
            ]);
    $objResizer->memorize();
    
    $winProp->DragAcceptFiles(1);

    return(1);
    }





=head2 setWindowState()

Set the state of controls so that they match the state of
the application.

Return 1.

=cut
sub setWindowState {
    my $self = shift; my $pkg = ref($self);


    return(1);
    }





=head2 setFocus($property)

Click the $property and set focus to the input field with
highlight. If it's the "Name" property, don't highlight the
prefix.

Return 1 on success, else 0.

=cut
sub setFocus {
    my $self = shift; my $pkg = ref($self);
    my ($property) = @_;

    my $lvwProp = $self->winProp()->lvwProp();

    #First, get rid of any triggered events by setting focus to this window
    $self->winProp()->SetFocus();
    

    #Find the correct item
    my $found = -1;
    for my $index (0 .. $lvwProp->Count() - 1) {
        my %hItem = $lvwProp->ItemInfo($index, 0);
        if($hItem{-text} eq $property) {
            $found = $index;
            last;
            }
        }

    if($found != -1) {
        $self->propDisplay($found);
        }
    else {
        #Not found? Set focus to the Design window
        $self->objWindowDesign()->winDesign()->SetFocus();
        return(0);
        }
    

    $self->winProp()->tfValue()->SetFocus();

    if($property eq "Name") {
        #Highlight the first uppercase char and the rest
        $self->winProp()->tfValue()->Text() =~ /^([a-z]*)/;
        $self->winProp()->tfValue()->Select(length($1), 10000) if(defined($1));
        }
    else {
        $self->winProp()->tfValue()->SelectAll();
        }

    return(1);
    }





=head2 infoDisplay($rhControl)

Display info in labels.

Return 1 on success, else 0.

=cut
sub infoDisplay {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl) = @_;
    

    my @aControls = keys %$rhControl;
    return(0) if(!@aControls);

    #Control name and type, location
    my $nameControl = "";
    my $typeControl = "";
    my $location = "";
    if(scalar(@aControls) == 1) {
        my $objControl = $rhControl->{ $aControls[0] };
        
        if($objControl->designIsTangible()) {
            my $objControlProperty = $objControl->rhControlProperty();
            
            $nameControl = $objControlProperty->{"Name"}->value();
            $typeControl = " (" . $objControl->type() . ")";
            $location = sprintf("%d\@%d %dx%d", 
                $objControlProperty->{"Left"}->value(), 
                $objControlProperty->{"Top"}->value(), 
                $objControlProperty->{"Width"}->value(), 
                $objControlProperty->{"Height"}->value(), 
                );
            }
        }
    else {
        my $minLeft = 10000;
        my $minTop = 10000;
        for my $control (@aControls) {
            next if(!$rhControl->{ $control }->designIsTangible());
            
            my $objControlProperty = $rhControl->{ $control }->rhControlProperty();
            if($objControlProperty->{"Left"}->value() < $minLeft) {
                $minLeft = $objControlProperty->{"Left"}->value();
                }
            if($objControlProperty->{"Top"}->value() < $minTop) {
                $minTop = $objControlProperty->{"Top"}->value();
                }
            }
        $location = sprintf("%d\@%d", 
            $minLeft, 
            $minTop, 
            )
        }
    $self->winProp()->lblControl()->Text("$nameControl$typeControl");
    $self->winProp()->lblLocation()->Text($location);


    return(1);
    }





=head2 propPopulate($rhControl)

Populate the properties list view with the controls in
$rhControl. Update the info label

Return 1 on success, else 0.

=cut
sub propPopulate {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl) = @_;

    my @aControls = keys %$rhControl;
    return(0) if(!@aControls);

    #Find out which properties to display. Only display
    #properties that are valid for all selected controls.

    #Init with anyone
    my %hProp = map
            { $_ => 1; }
            keys %{$rhControl->{ $aControls[0] }->rhControlProperty()};

    #Remove all properties that doesn't exist in other controls
    for my $objControl (values %{$rhControl}) {
        for my $nameProp (keys %hProp) {
            if(! exists $objControl->rhControlProperty()->{$nameProp} ) {
                delete $hProp{$nameProp};
                }
            }
        }

    $self->winProp()->lvwProp()->Clear();


    #Display prop value, or "- ? -" if it's not shared by all selected controls
    for my $keyProp (sort keys %hProp) {
        #Find out which value to display
        my $valueProp = $rhControl->{ $aControls[0] }->rhControlProperty()->{$keyProp}->value();
        for my $objControl (values %{$rhControl}) {
            if(defined($objControl->rhControlProperty()->{$keyProp}->value()) &&
                    defined($valueProp)) {
                if($valueProp ne $objControl->rhControlProperty()->{$keyProp}->value()) {
                    $valueProp = "- ? -";
                    last;
                    }
                }
            }

        defined($valueProp) or $valueProp = "";
        $self->winProp()->lvwProp()->InsertItem(
                -text => [ $keyProp, $valueProp ] );
        }


    #Hide the "current" property, since we haven't selected one yet
    $self->winProp()->lblProperty()->Hide();
    $self->winProp()->tfValue()->Hide();
    $self->winProp()->chbValue()->Hide();
    $self->winProp()->cbValue()->Hide();

    return(1);
    }





=head2 propUpdate($rhControl, $raPropName)

Update the properties in $raPropName for the controls in
$rhControl.

Return 1 on success, else 0.

=cut
sub propUpdate {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl, $raPropName) = @_;
    
#   my $lvwProp = $self->winProp()->lvwProp();
#   for(my $i = 0; $i < $lvwProp->Count(); $i++) {
#       my $prop = $lvwProp->ItemInfo()->{-text};
#       }

    #Display info
    $self->infoDisplay($rhControl);

    ##todo: optimize!!! 
    $self->propPopulate( $rhControl );  

    return(1);
    }





=head2 propDisplay($itmClicked)

Display edit control above ListView and populate it.

Return 1 on success, else 0.

=cut
sub propDisplay {
    my $self = shift; my $pkg = ref($self);
    my ($itmClicked) = @_;


    my $lvwProp = $self->winProp()->lvwProp();

    #Remember which property
    my %hItem = $lvwProp->ItemInfo($itmClicked, 0);
    $self->propLastKey( $hItem{-text} );
    $self->propLastIndex($itmClicked);

    #Prepare label and value controls
    %hItem = $lvwProp->ItemInfo($itmClicked, 0);
    my $propName = $hItem{-text};
    $self->winProp()->lblProperty()->Text( $propName );


    #Find the property for some control
    my @aControl = values %{$self->objCanvas()->rhControlActuallySelected()};
    my $objProp = $aControl[0]->rhControlProperty()->{$propName};


    #Fill value controls
    %hItem = $lvwProp->ItemInfo($itmClicked, 1);
    my $text = $hItem{-text};
    $self->winProp()->tfValue()->Text( $text );

    $self->winProp()->chbValue()->Checked( ($text eq "1") ? 1 : 0 );
#   $self->winProp()->chbValue()->SetCheck(2) if($text eq "- ? -"); ##todo: Why doesn't this work damnit???

    $self->winProp()->cbValue()->Clear();
    for my $item (@{$objProp->raValuesString()}) {
        $self->winProp()->cbValue()->InsertItem($item);
        }
    $self->winProp()->cbValue()->Select( $self->winProp()->cbValue()->FindString($text) );


    #Remember which value
    $self->propLastValue($text);


    #Show the "current" property
    $self->winProp()->lblProperty()->Show();

    if($objProp->isBoolean()) {
        $self->winProp()->chbValue()->Hide();
        $self->winProp()->tfValue()->Hide();
        $self->winProp()->chbValue()->Show();
        }
    elsif($objProp->isMultiValue()) {
        $self->winProp()->chbValue()->Hide();
        $self->winProp()->tfValue()->Hide();
        $self->winProp()->cbValue()->Show();
        }
    else {
        $self->winProp()->chbValue()->Hide();
        $self->winProp()->cbValue()->Hide();
        $self->winProp()->tfValue()->Show();
        }

    $self->propIsDirty(0);

    return(1);
    }





=head2 propNotifyChange($rhControl, $raPropName)

Update the properties in $raPropName for the controls in
$rhControl.

Return 1 on success, else 0.

=cut
sub propNotifyChange {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl, $raPropName) = @_;

    $self->propUpdate( $rhControl, $raPropName );

    return(1);
    }





=head2 propNotifySelected($rhControl)

The number of conrols that are selected has changed.

Return 1 on success, else 0.

=cut
sub propNotifySelected {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl, $raPropName) = @_;

    $self->infoDisplay($rhControl);
    $self->propPopulate( $rhControl );

    return(1);
    }





=head2 propNotifySelectionBox($left, top, $width, $height)

If $left is not undef, the user is click-n-dragging a 
selection box with the specified dimensions.

If $left is undef, the user is not anymore.

Return 1 on success, else 0.

=cut
sub propNotifySelectionBox {
    my $self = shift; my $pkg = ref($self);
    my ($left, $top, $width, $height) = @_;

    if(defined($left)) {
        $self->winProp()->lblSelection()->Text("[$left\@$top, ${height}x$width]");
        }
    else {
        $self->winProp()->lblSelection()->Text("");
        }
        
    return(1);
    }





=head2 textfieldPropEvaluate()

Check the state of the tfProp control. If it is visible,
apply the value and hide the textfield.

Call this method when another control gets the focus, or if
the window loses focus.

Set focus to the Design window when all is done.

Return 1 on success, else 0.

=cut
sub textfieldPropEvaluate {
    my $self = shift; my $pkg = ref($self);

    if($self->propIsDirty()) {
        $self->propIsDirty(0);

        my $lvwProp = $self->winProp()->lvwProp();

        my $prop = $self->propLastKey();
        my $value;

        if($self->winProp()->tfValue()->IsVisible()) {
            $value = $self->winProp()->tfValue()->Text();
            }
        elsif($self->winProp()->chbValue()->IsVisible()) {
            $value = $self->winProp()->chbValue()->Checked();
            }
        elsif($self->winProp()->cbValue()->IsVisible()) {
            $value = $self->winProp()->cbValue()->GetString(
                    $self->winProp()->cbValue()->SelectedItem() );
            }
        else {
            warn("Semi fatal error: No xxxValue control visible.");
            }


        #Update the property
        my @aControl = values %{$self->objCanvas()->rhControlSelected()};
        if(0 == @aControl) {
            #No selected, do the window
            @aControl = ( $self->objDesign()->objControlWindow() );
            }

        for my $objControl (@aControl) {
            $objControl->prop($prop, $value);
            }

        #Update everything
        $self->objCanvas()->propNotifyChange([ $prop ]);

        #Reselect that item in the ListView and give focus to the input
        #but only if the edit was initiated by the Properties window
        if(     defined($self->winInitiatedProperty()) && 
                $self->winInitiatedProperty() == $self->winProp()) {
            $self->winProp()->lvwProp()->Select($self->propLastIndex());
            if($self->winProp()->tfValue()->IsVisible()) {
                $self->winProp()->tfValue()->SetFocus();
                $self->winProp()->tfValue()->SelectAll();
                }
            }

#       $self->winProp()->chbValue()->SetFocus() if($self->winProp()->chbValue()->IsVisible());
#       $self->winProp()->cbValue()->SetFocus() if($self->winProp()->chbValue()->IsVisible());
        }

    if(defined($self->winInitiatedProperty())) {
        $self->winInitiatedProperty()->SetFocus();
        }
    

    return(1);
    }





=head1 Win32::GUI EVENTS

=head2 winProp_Terminate()

Block the close operation.

=cut
sub ::winProp_Terminate {
    my $self = TGL::WindowProp->new();
print "winProp_Terminate()\n";
    $self->winProp()->Hide();

    return(0);
    }





=head2 winProp_Resize()

Resize the main window. Store the size into the Design.

=cut
sub ::winProp_Resize {
    my $self = TGL::WindowProp->new();
    defined($self->objResizerDesign()) and $self->objResizerDesign()->resize();
    }





=head2 winProp_Activate()

Activate the window and perform Modalizer stuff.

=cut
sub ::winProp_Activate {
    my $self = TGL::WindowProp->new();
    defined($self->objWindowApp()->objModalizer()) and $self->objWindowApp()->objModalizer()->activate($self->winProp());
    }





sub ::winProp_DropFiles {
    my $self = TGL::WindowApp->new();   #Note! The App window!
    my ($handleDrop) = @_;

    $self->dropFiles($handleDrop);

    return(1);
    }





=head2 lvwProp_ItemClick()

Display edit box on top of item.

=cut
sub ::lvwProp_ItemClick {
    my $self = TGL::WindowProp->new();
    my ($itmClicked) = @_;

    $self->propDisplay($itmClicked);

    $self->winInitiatedProperty( $self->winProp() );

    return(1);
    }





=head2 tfValue_LostFocus()

Make the new value take effect

=cut
sub ::tfValue_LostFocus {
    my $self = TGL::WindowProp->new();

#   if($self->propLastValue() ne $self->winProp()->tfValue()->Text()) {
#       ::btnOk_Click();
#       }

    return(1);
    }





=head2 tfValue_Change()

Note that the value changed.

=cut
sub ::tfValue_Change {
    my $self = TGL::WindowProp->new();
    $self->propIsDirty(1);
    }





=head2 chbValue_LostFocus()

Make the new value take effect

=cut
sub ::chbValue_LostFocus {
    my $self = TGL::WindowProp->new();
    ::btnOk_Click();
    }





=head2 chbValue_Click()

Note that the value changed.

=cut
sub ::chbValue_Click {
    my $self = TGL::WindowProp->new();
    $self->propIsDirty(1);
    ::btnOk_Click();
    }





=head2 cbValue_Change()

Note that the value changed.

=cut
sub ::cbValue_Change {
    my $self = TGL::WindowProp->new();
    $self->propIsDirty(1);
    ::btnOk_Click();
    }





=head2 btnOk_Click()

Make the new value take effect

=cut
sub ::btnOk_Click {
    my $self = TGL::WindowProp->new();

    $self->textfieldPropEvaluate();

    return(1);
    }





=head2 btnFakeCancel_Click()

Trap the event and "do nothing" to prevent the Esc key from 
closing the window.

=cut
sub ::btnFakeCancel_Click {
    my $self = TGL::WindowProp->new();

    return(0);
    }





=head2 timOpen_Timer()

Keep track of values in the tfValue and popup the Open
dialog when appropriate.

=cut
sub ::timOpen_Timer {
    my $self = TGL::WindowProp->new();

    return(1) if($self->{timOpen_Timer});
    $self->{timOpen_Timer} = 1;

    #Special case: if it's a Bitmap and the value is " ",
    #let the user open a file
    if($self->propLastKey() eq "Bitmap" && $self->winProp()->tfValue()->Text() eq " ") {
        my $value = GUI::GetOpenFileName(
                -owner => $self->winProp(),
                -title  => "Open Bitmap",
                -directory => "",
                -filter => [
                        "Bitmaps (*.bmp)" => "*.bmp",
                        "All files (*.*)", "*.*",
                        ],
                ) || "";
#print "ret: $value\n";
#print "rel: " . $self->objDesign()->fileMakeRelative($value) . "\n";
        $self->winProp()->tfValue()->Text(
                $self->objDesign()->fileMakeRelative($value)
                );
#print "tf : " . $self->winProp()->tfValue()->Text() . "\n";
#print "tfvis: " . $self->winProp()->tfValue()->IsVisible() . "\n";
        ::btnOk_Click();        #Submit the value
        }

    #Special case: if it's an WindowIcon and the value is " ",
    #let the user open a file
    if($self->propLastKey() eq "WindowIcon" && $self->winProp()->tfValue()->Text() eq " ") {
        my $value = GUI::GetOpenFileName(
                -owner => $self->winProp(),
                -title  => "Open Icon",
                -directory => "",
                -filter => [
                        "Icons (*.ico)" => "*.ico",
                        "All files (*.*)", "*.*",
                        ],
                ) || "";

        $self->winProp()->tfValue()->Text(
                $self->objDesign()->fileMakeRelative($value)
                );

        ::btnOk_Click();        #Submit the value
        }


    $self->{timOpen_Timer} = 0;
    
    return(1);
    }





1;





#EOF
