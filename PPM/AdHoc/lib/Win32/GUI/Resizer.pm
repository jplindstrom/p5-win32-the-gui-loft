=head1 NAME

Win32::GUI::Resizer -- Makes window Resize() events easy to manage


=head1 DESCRIPTION

The Win32::GUI::Resizer class can help you deal with a 
window's Resize() event. 

It lets you define how your controls should move and change 
size along with the window or some other gadget (e.g. a 
Splitter bar). It provides a consistent way of thinking 
about these things, and an easy way of defining them with 
little or no code.

It handles the minimize/restore of a window correctly.

It can handle you manually moving controls around or 
resizing them at run-time.

It is slightly slower than coding the Resize() event by 
hand.


=head1 VERSION

Like, pre-release. I'd appreciate feedback. Things may 
change, but probably nothing that would ruin your day.


=head1 INSTALLATION

Just copy the .pm file into the Win32/GUI directory. I'll 
write a proper module with a Makefile.PL and stuff some day.


=head1 SYNOPSIS

    use strict;
    use Win32::GUI;
    
    #Lots of code to build the window. Just note the names of the 
    #window and the controls as you scroll down.
    my $winMain = new Win32::GUI::Window(
            -left   => 13,
            -top    => 32,
            -width  => 439,
            -height => 260,
            -name   => "winMain",
            -text   => "Win32::GUI::Resizer Synopsis"
            );
    
    $winMain->AddTextfield(
            -text    => "",
            -name    => "tfName",
            -left    => 67,
            -top     => 6,
            -width   => 363,
            -height  => 20,
            );
    
    $winMain->AddLabel(
            -text    => "Your Name:",
            -name    => "lblName",
            -left    => 6,
            -top     => 9,
            -width   => 56,
            -height  => 13,
            );
    
    $winMain->AddLabel(
            -text    => "Your cool saying:",
            -name    => "lblSaying",
            -left    => 6,
            -top     => 32,
            -width   => 81,
            -height  => 14,
            );
    
    $winMain->AddRichEdit(
            -text    => "<<enter your cool saying here>>",
            -name    => "reSaying",
            -left    => 2,
            -top     => 49,
            -width   => 427,
            -height  => 150,
            );
    
    $winMain->AddButton(
            -text    => "&Ok",
            -name    => "btnOk",
            -left    => 358,
            -top     => 207,
            -width   => 70,
            -height  => 21,
            );
    
    $winMain->Show();
    
    sub winMain_Terminate {
        return -1;
        }
    
    #The usual window stuff is done here, now lets make it resizable
    
    
    use Win32::GUI::Resizer;
    
    #Create the Resizer object and connect it to the window
    my $objResizer = Win32::GUI::Resizer->new($winMain);
    
    #Define the relations between the window and the controls
    $objResizer->raRelations([
            'winWidth' => [
                    ['$winResize->reSaying->Width()'],
                    ['$winResize->tfName->Width()'],
                    ['$winResize->btnOk->Left()'],
                    ],
            'winHeight' => [
                    ['$winResize->reSaying->Height()'],
                    ['$winResize->btnOk->Top()'],
                    ],
            ]);
    
    #Remember the current control locations
    $objResizer->memorize();
    
    #Connect the Resizer object to the Resize() event
    sub winMain_Resize {
        defined($objResizer) and $objResizer->resize();
        }
    
    
    #Go modal
    Win32::GUI::Dialog();

=cut





package Win32::GUI::Resizer;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(    
        negResize
        );





use strict;





=head1 PROPERTIES

=head2 winResize

The Win32::GUI window object to resize.

=cut
sub winResize {
    my $self = shift;
    my ($val) = @_;

    if(defined($val)) {
        $self->{winResize} = $val;
        }

    return($self->{winResize});
    }





=head2 raRelations

The relations between the controls of the window. These 
settings define how each control will behave when the window 
or e.g. a Splitter changes size or position.

The syntax and structure of the array ref is described 
below.

=cut
sub raRelations {
    my $self = shift;
    my ($val) = @_;

    if(defined($val)) {
        $self->{raRelations} = $val;
        }

    return($self->{raRelations});
    }





=head2 isMinimized

Whether the window is minimized or not. Set by the resize() 
method when the window size is (0,0).

=cut
sub isMinimized {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{isMinimized} = $val;
        }

    return($self->{isMinimized});
    }





=head2 raPreMinimizedSize

Array ref with two items, the w/h of the window size prior 
to a minimize.

=cut
sub raPreMinimizedSize {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{raPreMinimizedSize} = $val;
        }

    return($self->{raPreMinimizedSize});
    }





=head1 METHODS

=head2 new(Win32::GUI::Window $winResize)

Create new Resizer object for $winResize.

=cut
sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;
    my ($winResize) = @_;

    my $self = {
        raRelations         => [],
        rhSpecialValue      => {},
        rhSpecialValueOld   => {},
        rhCache             => {},
        initDone            => 0,
        isMinimized         => 0,
        raPreMinimizedSize  => [0,0],
        
        };
    bless $self, $pkg;
    
    $self->winResize($winResize);
    
    return($self);
    }





=head2 memorize()

Init the Resizer by remembering the size of the winResize() 
window and the contained controls. 

Call this method when you have set up the entire window the 
way you want it.

Return 1 on success, else 0.

=cut
sub memorize {
    my $self = shift;
    
    $self->createCache() if(!$self->{initDone});

    my @aSize = ($self->winResize()->GetClientRect)[2..3];
    
    #If the window is minimized (has h/w == 0/0), use
    #the stored window size, otherwise remember the 
    #actual window size.
    if($aSize[0] == 0 && $aSize[1] == 0) {
        @aSize = @{$self->raPreMinimizedSize()};
        }
    else {
        $self->raPreMinimizedSize(\@aSize);
        }   

    $self->specialValue('winWidth', $aSize[0], 0);
    $self->specialValue('winHeight', $aSize[1], 0); 
    
    $self->{initDone} = 1;

    return(1);
    }





=head2 rememorize()

Re-init the Resizer by remembering the size of the 
winResize() window and the contained controls.

Call this method once you have changed the location or size 
of any control that you have under Resizer control.

Return 1 on success, else 0.

=cut
sub rememorize {
    my $self = shift;

    $self->{rhCache} = {};
    $self->createCache();

    $self->memorize();

    return(1);
    }





=head2 specialValue($key [,$val] [,$resize = 1])

Get or set the $val for $key. When set, the window is 
resized using the resize() method, unless $resize is false.

Use this to keep track of elements in the window that may 
change size or position, e.g. a Splitter bar (in the 
Release() event, update the position value by calling this 
method).

Return the value, or undef if $key has no value.

=cut
sub specialValue {
    my $self = shift;
    my ($key, $val, $resize) = @_;
    defined($resize) or $resize = 1;

    if(defined($val)) {
        $self->{rhSpecialValue}->{$key} = $val;     
        $self->specialValueOld($key, $val) if(! $self->{initDone});
        
        $self->resize() if($resize);
        }

    return($self->{rhSpecialValue}->{$key});
    }





=head2 resize()

Resize the controls of the window. It will handle a window's 
minimize/restore correctly.

Call this method from the window's Resize() event, like so:

    sub winMain_Resize {
        defined($objResizer) and $objResizer->resize();
        }

=cut
sub resize {
    my $self = shift;

    return(0) if(!$self->{initDone});

    #Is it being minimized?
    my @aSize = ($self->winResize()->GetClientRect)[2..3];
    if($aSize[0] == 0 && $aSize[1] == 0) {
        $self->isMinimized(1);
        return(1);
        }
        
    #Is it being restored?
    if($self->isMinimized()) {
        if(!($aSize[0] == 0 && $aSize[1] == 0)) {
            $self->raPreMinimizedSize(\@aSize);
            $self->isMinimized(0);
            }
            
        return(1);
        }

    $self->memorize();

    #Lexicalize the window so we have a scope for the symbol
    my $winResize = $self->winResize();     

    #Shorten access path
    my $rhCache = $self->{rhCache};


    ##Calculate delta values and modify
    my @aTemp = @{$self->raRelations()};
    while(@aTemp) {
        my ($srcVar, $raTrgVal) = (shift @aTemp, shift @aTemp);
        
        #It's a special, get it
        my $scrVarValOld = $self->specialValueOld($srcVar);
        my $scrVarVal = $self->specialValue($srcVar);

        my $delta = $scrVarVal - $scrVarValOld;
        
        if($delta != 0) {
            for my $raValOp (@{$raTrgVal}) {
                my $var = ${$raValOp}[0];
                my $rsModifier = ${$raValOp}[1];

                #Insert modifyer
                my $thisDelta = (defined($rsModifier)) ? $rsModifier->($delta) : $delta;
                my $valOld = $rhCache->{$var};
    
                #Compute new val
                $rhCache->{$var} = $valOld + $thisDelta;
    
    
                #Assign it
                if($var =~ /^(.+)\->(\w+?)\(\)$/) {
                    $rhCache->{$1}->$2($rhCache->{$var});
                    }
                else {
                    my $varEval = $var;
                    $varEval =~ s|\)$|$rhCache->{$var})|;
    
                    eval($varEval); die("eval($varEval) failed in Win32::GUI::Resizer->resize(): $@") if($@);
                    }
                }
            }
        }


    #Reset "old" values 
    $self->resetSpecialValues();
            
    return(1);
    }





=head1 SUBROUTINES

=head2 negResize($a)

Return 0 - $a.

May be used in the raRelations structure to indicate that 
e.g. a value should shrink as the window size grows.

Not exported by default.

=cut
sub negResize {
    $_[0] * -1;
    }





=head2 div2Resize($a)

Return $a / 2.

May be used in the raRelations structure to indicate that 
e.g. a value should grow, but only half the resize change.

Not exported by default.

=cut
sub div2Resize {
    $_[0] / 2;
    }





=head2 div3Resize($a)

Return $a / 3.

Not exported by default.

=cut
sub div3Resize {
    $_[0] / 3;
    }





=head2 div4Resize($a)

Return $a / 4.

Not exported by default.

=cut
sub div4Resize {
    $_[0] / 4;
    }





=head1 PRIVATE METHODS

This stuff is implementation, not interface.

=head2 specialValueOld($key [,$val])

Get or set the $val for $key. 

Return the value, or undef if $key has no value.

=cut
sub specialValueOld {
    my $self = shift;
    my ($key, $val) = @_;

    if(defined($val)) {
        $self->{rhSpecialValueOld}->{$key} = $val;
        }

    return($self->{rhSpecialValueOld}->{$key});
    }





=head2 resetSpecialValues()

Set the specialValuesOld to specialValues.

Return 1 on success, else 0.

=cut
sub resetSpecialValues {
    my $self = shift;
    my ($val) = @_;

    my %hTemp = %{$self->{rhSpecialValue}}; 
    $self->{rhSpecialValueOld} = \%hTemp;
    
    $self->memorize();
    
    return(1);
    }





=head2 createCache()

Cache values for control dimensions.

Return 1 on success, else 0. Die on fatal (config) errors.

=cut
#
#The calls to get e.g. Height() and Width() for controls take 
#some time, but not a lot. Calls to resolve contained objects 
#take a lot of time.
#
#These calls are cached. By doing that I also managed to cut 
#down on the evals, and this keeps the resize from being 4x 
#slower to maybe 15% slower than a manually coded resize.
#
#This is probably mostly due to the fact that some operations
#would be coded with Move() and Resize() rather than
#two calls to Left()/Top() and Height()/Width().
#
sub createCache {
    my $self = shift;

    #Lexicalize the window so we have a scope for the symbol
    my $winResize = $self->winResize();     

    #Shorten access path
    my $rhCache = $self->{rhCache};
    
    eval {
        my @aTemp = @{$self->raRelations()};
        while(@aTemp) {
            my ($srcVar, $raTrgVal) = (shift @aTemp, shift @aTemp);

            for my $raValOp (@{$raTrgVal}) {
                my $var = ${$raValOp}[0];
                
                #Cache the total value
                $rhCache->{$var} = eval($var); die($@) if($@);
                
                #Cache the object ref used to call the final method
                if($var =~ /^(.+)\->(\w+?)\(\)$/) {
                    $rhCache->{$1} = eval($1);
                    }
                }
            }
        };
    die("Win32::GUI::Resizer: There is an error in the rhRelations() property:\n$@") if($@);


    return(1);
    }





1;





__END__





=head1 THE raRelations ARRAY REF

This is the raRelations from the Synopsis example.

    [
        'winWidth' => [
            ['$winResize->reSaying->Width()'],
            ['$winResize->tfName->Width()'],
            ['$winResize->btnOk->Left()'],
            ],
        'winHeight' => [
            ['$winResize->reSaying->Height()'],
            ['$winResize->btnOk->Top()'],
    ],

As you can see, it contains a two-dimensional array ref. The 
first level contains values that may change, in this case 
the window's width and height. The second level contains 
properties that are dependent on the first level. 

Thus, when the height of the window changes, so should the 
height of reSaying and the top of btnOk.

There are a number of predefined values you have to keep in 
mind when you create your array.

B<$winResize> -- This is your window object, the one you 
specified in the new() method, and the one available in the 
winResize() property. This is the only way you should refer 
to that window in this array.

B<winWidth> -- The interior width (the ScaleWidth() 
property) of $winResize.

B<winHeight> -- The interior height.

=head2 The Resizer Mindset

Just to make sure you "think right" about this, consider 
this piece:

    'winWidth' => [
        ['$winResize->tfName->Width()'],
        ['$winResize->btnOk->Left()'],

Read it like this:

    'when-this-increases-its-value' => [
        ['so-should-this-width'],
        ['and-this-left-position'],



=head2 Negative Growth

Sometimes a value should shrink when e.g. the window width 
grows. This is handled with an optional second entry in the 
inner array, like this:

    'winWidth' => [
        ['$winResize->tfName->Width()'],
        ['$winResize->btnOk->Left()', \&Win32::GUI::Resizer::negResize],

The second entry is a subroutine ref which is used to 
perform a calculation on the delta value (how much the Left 
value should change). 

Having a control shrink as the window grows is fairly 
common, so there is a ready-made subroutine for it. It isn't 
exported by default though, so to avoid the lengthy symbol 
name you might want to do that when you use the Resizer 
class:

	use Win32::GUI::Resizer qw( negResize );

=head2 Things to Think About

In the example, it is possible to refer to e.g. the 
reSaying control both like this:

    $winResize->reSaying

and like this:

    $winResize->reSaying()

Either one is fine, but B<do not> mix them within the 
raRelations() array. THIS IS A BIG NO-NO:

    [
        'winWidth' => [
            ['$winResize->reSaying->Width()'],
            ['$winResize->reSaying()->Height()'],
    ],

=head1 TUTORIAL

use the window in uff

splitter, specialValue(), negative growth

move controls at runtime, rememorize()


=head1 COPYRIGHT

Copyright 2001.. Johan Lindström <johanl@bahnhof.se>

This program is free software; you can redistribute it and/or modify it
under the GPL-2.0

=cut
