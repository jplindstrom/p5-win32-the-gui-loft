=head1 NAME

Win32::GUI::DragDrop -- Drag-n-Drop functionality

=head1 DESCRIPTION

Win32::GUI::DragDrop enables you to drag-n-drop files on
Window and DialogBox windows.

This is the Perl-side code of the Drag-n-Drop implementation
(the other part is an XS patch).


=head1 SYNOPSIS

    ##Create the window
    # . . .

    #Make the window a drop target
    $winMain->DragAcceptFiles(1);
    my $isTarget = $winMain->DragAcceptFiles();

    #When files are dropped on the window, this event is triggered
    sub winMain_DropFiles {
        my ($handleDrop) = @_;

        my @aFilesDropped = Win32::GUI::DragDrop::GetDroppedFiles($handleDrop));

        return(1);
        }


=head1 THE XS PATCH

This code needs to be added to GUI.xs. After that, "nmake" 
and "nmake install" and you can use this module. 

If you use the module without this piece of code, people 
will be able to drop files on the window, but the 
DropFiles() event will never be triggered.

    GUI.xs, line 1839:
    ----------
        case WM_DROPFILES:
            if(GetObjectName(NOTXSCALL hwnd, Name)) {
                /*
                 * (@)EVENT:DropFiles(DROP_HANDLE)
                 * Sent when the window receives dropped files.
                 * (@)APPLIES_TO:Window, DialogBox
                 */
                strcat(Name, "_DropFiles");
                PerlResult = DoEvent_Long(NOTXSCALL Name, UINT(wParam));
            }
            break;
    ----------

=head1 EXAMPLE PROGRAM

    #!/usr/local/bin/perl -w

    use strict;

    use Win32::GUI;
    use Win32::GUI::DragDrop;



        #Also works for Window objects
    my $winMain = new Win32::GUI::DialogBox(
          -left   => 700,
          -top    => 50,
          -width  => 100,
          -height => 100,
          -name   => "winMain",
          -text   => "",
          );

        #Can drop on top of buttons
    $winMain->AddButton(
            -text    => "F",
            -name    => "btnTest",
            -left    => 0,
            -top     => 0,
            -width   => 20,
            -height  => 20,
            );

        #Can drop on top of RichEdit (will "land" on window)
    $winMain->AddRichEdit(
            -text    => "Drop files here",
            -name    => "reTest",
            -left    => 0,
            -top     => 23,
            -width   => 90,
            -height  => 50,
            );


    print "Initial state   : accepts drops: " . $winMain->DragAcceptFiles() . "\n";

    $winMain->DragAcceptFiles(1);
    print "After accept    : accepts drops: " . $winMain->DragAcceptFiles() . "\n";

    $winMain->DragAcceptFiles(0);
    print "After not accept: accepts drops: " . $winMain->DragAcceptFiles() . "\n";

    $winMain->DragAcceptFiles(1);
    print "After accept    : accepts drops: " . $winMain->DragAcceptFiles() . "\n";
    print "\n\n";


    $winMain->Show();
    Win32::GUI::Dialog();



    sub winMain_Terminate {
        return(-1);
        }


    sub winMain_DropFiles {
        my ($handleDrop) = @_;

        print join("\n", Win32::GUI::DragDrop::GetDroppedFiles($handleDrop)) . "\n\n";

        return(1);
        }



    #EOF

=cut





package Win32::GUI::DragDrop;





use strict;
use Win32::API;
use Win32::GUI;





=head1 ROUTINES

=head2 GetDroppedFiles($handleDrop)

Return the files associated with the $handleDrop (which you
should have received in a _DropFiles() event). Free the
memory allocated to the drag-drop operation.

Return array with files, or an empty array on errors.

=cut
sub GetDroppedFiles {
    my ($handleDrop) = @_;

    my @aFile = DragQueryFile($handleDrop);
    DragFinish($handleDrop);

    return(@aFile);
    }





=head2 DragQueryFile($handleDrop)

Return the files associated with the $handleDrop (which you
should have received in a DropFiles() event).

Return array with files, or an empty array on errors.

The GetDroppedFiles sub is preferred to this one.

=cut
my $rsDragQueryFile = new Win32::API ('shell32', 'DragQueryFileA', "NNPN", "N") || undef;
sub DragQueryFile {
    my ($handleDrop) = @_;
    my @aFile;

    return(@aFile) if($handleDrop == 0 || !defined($rsDragQueryFile));

    my $lenBuf = 1024;
    my $buffer = " " x $lenBuf;

    #Find number of files
    my $no = $rsDragQueryFile->Call($handleDrop, 0xFFFFFFFF, $buffer, $lenBuf);

    for my $i (1..$no) {
        my $lenFile = $rsDragQueryFile->Call($handleDrop, $i - 1, $buffer, $lenBuf);
        if($lenFile >= 0) {
            push(@aFile, substr($buffer, 0, $lenFile));
            }
        }

    return(@aFile);
    }





=head2 DragFinish($handleDrop)

Release memory that Windows allocated for use in
transferring filenames to the application.

Return 1 on success, else 0.

The GetDroppedFiles sub is preferred to this one.

=cut
my $rsDragFinish = new Win32::API ('shell32', 'DragFinish', "N", "") || undef;
sub DragFinish {
    my ($handleDrop) = @_;

    return(0) if(!defined($rsDragFinish));

    $rsDragFinish->Call($handleDrop) or return(0);

    return(1);
    }





=head1 Win32::GUI::Window/DialogBox methods

These are methods on Window or Dialog objects.

=cut

package Win32::GUI::Window;





=head2 DragAcceptFiles([$doAccept])

Get/set the DragAcceptFiles for the window to $doAccept
(1|0).

Return undef on errors.

=cut
my $rsDragAcceptFiles = new Win32::API ('shell32', 'DragAcceptFiles', "NI", "") || undef;
my %hHwindDragAccept;
sub DragAcceptFiles {
    my $self = shift;
    my ($doAccept) = @_;
    return(undef) if(!defined($rsDragAcceptFiles));

    return( $hHwindDragAccept{ $self->{-handle} } || 0) if(!defined($doAccept));

    return(undef) if(!defined($rsDragAcceptFiles));
    return(undef) if($doAccept < 0 || $doAccept > 1);

    $rsDragAcceptFiles->Call($self->{-handle}, $doAccept);

    return( $hHwindDragAccept{ $self->{-handle} } = $doAccept );
    }





package Win32::GUI::DialogBox;

sub DragAcceptFiles {
    Win32::GUI::Window::DragAcceptFiles(@_);
    }





1;





#EOF
