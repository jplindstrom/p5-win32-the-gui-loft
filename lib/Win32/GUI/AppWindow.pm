=head1 NAME

Win32::GUI::AppWindow -- Base for Win32::GUI application
windows.

=head1 SYNOPSIS



=cut





package Win32::GUI::AppWindow;





use strict;
use Data::Dumper;

use Win32;
use XML::Simple;





=head1 PROPERTIES

=head2 fileConfig

The file that the rhConfig() was loaded from.

=cut

sub fileConfig {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{fileConfig} = $val;
        }

    return($self->{fileConfig});
    }





=head2 rhConfig

Configuration variables.

=cut

sub rhConfig {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{rhConfig} = $val;
        }

    return($self->{rhConfig});
    }





=head2 rhWindowConfig

The config for the application window.

=cut

sub rhWindowConfig {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{rhWindowConfig} = $val;
        }

    return($self->{rhWindowConfig});
    }





=head2 isClosed

Whether the window is closed or not. May be used if you roll 
your own main event loop instead of the Win32::GUI::Dialog() 
call.

Default: 0

=cut

sub isClosed {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{isClosed} = $val;
        }

    return($self->{isClosed});
    }





=head2 raError

Array ref with accumulated errors.

Default: []

=cut

sub raError {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{raError} = $val;
        }

    return($self->{raError});
    }





=head1 METHODS

=head2 new()



=cut

sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;
    my ($tsStrip) = @_;

    my $self = {
        rhConfig        => {},
        rhWindowConfig  => {},
        isClosed        => 0,
        raError         => [],
        };
    bless $self, $pkg;

    return($self);
    }





=head2 loadXMLFile($file, [$mustBeArray = 0])

Load $file and return a hash ref with all values. 

If $mustBeArray is true, always return an array ref, and if 
the file is parsed to be a hash ref, return [].

Die on errors.

=cut

sub loadXMLFile {
    my $self = shift; my $pkg = ref($self);
    my ($file, $mustBeArray) = @_;
    defined($mustBeArray) or $mustBeArray = 0;

    my $objXML = XML::Simple->new();
    my $rhVal;
    eval { $rhVal = $objXML->XMLin($file, forcearray => 1); };
    die("Could not load/parse file ($file)\n($@)") if($@);
    
    if($mustBeArray) {
        return([]) unless(ref($rhVal) eq "ARRAY");
        }

    return($rhVal);
    }





=head2 saveXMLFile($file, $rhData)

Save $rhData into $file.

Return 1 on success, else 0.

=cut

sub saveXMLFile {
    my $self = shift; my $pkg = ref($self);
    my ($file, $rhData) = @_;

    eval {
        my $objXML = XML::Simple->new();
        $objXML->XMLout($rhData, outputfile => $file);
        };
    return(0) if($@);
    
    return(1);
    }





=head2 errorClear()

Clear errors. This should be called by all methods that 
might call errorMessage().

Return 1 on success, else 0.

=cut

sub errorClear {
    my $self = shift; my $pkg = ref($self);
    
    $self->raError([]);

    return(1);
    }





=head2 errorMessage($message, [$ret = 1])

Unshift $message to the raError array. 

Return $ret.

=cut

sub errorMessage {
    my $self = shift; my $pkg = ref($self);
    my ($message, $ret) = @_;
    defined($ret) or $ret = 1;

    $self->raError( [ $message, @{$self->raError()} ] );

    return($ret);
    }





=head2 errorReport([$messError])

Report the $messageError by displaying a dialog box. 

If $messError isn't passed, the contents of the raError 
array is joined and displayed. If raError is empty, return 
0.

Return 1 on success, else 0.

=cut

sub errorReport {
    my $self = shift; my $pkg = ref($self);
    my ($messError) = @_;
    
    if(!defined($messError)) {
        $messError = join("\n\n", @{$self->raError()});
        return(0) if($messError eq "");
        }

    Win32::MsgBox($messError, 0, "Error");

    return(1);
    }





=head2 default($val, $default)

Return $val, or $default if $val is undef.

=cut

sub default {
    my $self = shift; my $pkg = ref($self);
    my ($val, $default) = @_;

    defined($val) and return($val);

    return($default);
    }





1;





#EOF
