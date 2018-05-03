=head1 NAME

TGL::WindowApp -- The main application

=head1 SYNOPSIS

Oh, man...

=cut





package TGL::WindowApp;
@ISA = qw( Win32::GUI::AppWindow Win32::GUI::Loft::View );
use Win32::GUI::AppWindow;
use Win32::GUI::DragDrop;
use Win32::GUI::Loft::View;





use strict;
use Carp qw(cluck);
use Data::Dumper;
#use Data::Denter;
use Pod::Text;
use File::Basename;
use Cwd;

use Win32::GUI;
use Win32;
use Win32::GUI::AdHoc;
use Win32::GUI::Resizer qw( negResize );
use Win32::GUI::Modalizer;

use Win32::Clipboard;

use TGL::WindowDesign;
use TGL::WindowProp;
use TGL::WindowTool;

use Win32::GUI::Loft::Design;
use Win32::GUI::Loft::Canvas;
use Win32::GUI::Loft::Control;
use Win32::GUI::Loft::Control::Window;
use Win32::GUI::Loft::Control::Button;





#This class is a singleton. This is that object.
my $gObjSingleton = undef;

#Some things like bitmaps and stuff _needs_ to be persistent
#outside of their scope.
my %ghPerm;





#The program dir
my $pathBase = dirname($0);
$pathBase = cwd() if($pathBase eq ".");
$pathBase =~ s{/}{\\}g;





#Block GUI warnings
Win32::GUI::AdHoc::blockGUIWarnings();





=head1 PROPERTIES

=head2 winMain

The main window object

=cut

sub winMain {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{winMain} = $val;
        }

    return($self->{winMain});
    }





=head2 winClusterProp

The Export Perl window object.

=cut

sub winClusterProp {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{winClusterProp} = $val;
        }

    return($self->{winClusterProp});
    }





=head2 mnuMain

The menu for the main window

=cut

sub mnuMain {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{mnuMain} = $val;
        }

    return($self->{mnuMain});
    }





=head2 objResizerMain

The Win32::GUI::Resizer object used to resize the controls
in the winMain window.

=cut

sub objResizerMain {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objResizerMain} = $val;
        }

    return($self->{objResizerMain});
    }





=head2 objModalizer

The Win32::GUI::Modalizer object used to make dialogs modal.

=cut

sub objModalizer {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objModalizer} = $val;
        }

    return($self->{objModalizer});
    }





=head2 objWindowProp

The Properties window object (not the design
Win32::GUI::Window object).

=cut

sub objWindowProp {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objWindowProp} = $val;
        }

    return($self->{objWindowProp});
    }





=head2 objWindowDesign

The Design window object (not the design Win32::GUI::Window
object).

=cut

sub objWindowDesign {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objWindowDesign} = $val;
        }

    return($self->{objWindowDesign});
    }





=head2 objWindowTool

The Toolbox window object (not the design Win32::GUI::Window
object).

=cut

sub objWindowTool {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objWindowTool} = $val;
        }

    return($self->{objWindowTool});
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





=head2 objClusterLastEdited

The Cluster object that is being edited in winClusterProp,
or undef.

Set to 0 to undef.

=cut

sub objClusterLastEdited {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{objClusterLastEdited} = $val;
        $self->{objClusterLastEdited} = undef if($val == 0);
        }

    return($self->{objClusterLastEdited});
    }





=head2 raWinTest

Array ref with window objects that have been opened and not
yet been hidden/closed.

=cut

sub raWinTest {
    my $self = shift; my $pkg = ref($self);
    my ($val) = @_;

    if(defined($val)) {
        $self->{raWinTest} = $val;
        }

    return($self->{raWinTest});
    }





=head1 METHODS

=head2 new()

Create new UI for Windows.

=cut

sub new {
    my $pkg = shift; $pkg = ref($pkg) || $pkg;
    defined($gObjSingleton) and return($gObjSingleton);

    my $self = $gObjSingleton = $pkg->SUPER::new();

    $self->winMain(undef);
    $self->winClusterProp(undef);
    $self->mnuMain(undef);

    $self->objWindowDesign( TGL::WindowDesign->new() );
    $self->objWindowProp( TGL::WindowProp->new() );
    $self->objWindowTool( TGL::WindowTool->new() );

    $self->raWinTest([]);

    $self->objClusterLastEdited(0);


    return($self);
    }





=head2 init()

Init application, info, windows etc.

Return 1 on succes, else 0.

=cut

sub init {
    my $self = shift; my $pkg = ref($self);


    ###Build GUI

    #The main window
    my $mnuMain = Win32::GUI::MakeMenu(
            "&File"                     => "mnuFile",
            " > &New\tCtrl+N"           => "mnuFileNew",
            " > &Open...\tCtrl+O"       => "mnuFileOpen",
            " > &Save\tCtrl+S"          => "mnuFileSave",
            " > Save &as..."            => "mnuFileSaveAs",
            " > -"                      =>  0,
#           " > &Export Perl code..."   => "mnuFileExportPerl",
#           " > -"                      =>  0,
            " > E&xit"                  => "mnuFileExit",

            "&Edit"                     => "mnuEdit",
            " > &Cut\tCtrl+X"           => "mnuEditCut",
            " > &Copy\tCtrl+C"          => "mnuEditCopy",
            " > &Paste\tCtrl+V"         => "mnuEditPaste",
            " > Copy &Perl"             => "mnuEditCopyPerl",
            " > > Control &name"        => "mnuEditCopyPerlName",
            " > > &Resizer Code"        => "mnuEditCopyPerlResizer",
            " > -"                      =>  0,
            " > &Delete\tDel"           => "mnuEditDelete",
            " > &Duplicate"             => "mnuEditDuplicate",
            " > -"                      =>  0,

            " > &Select"                => "mnuEditSelect",
            " > > &All\tCtrl+A"         => "mnuEditSelectAll",
            " > > &Window"              => "mnuEditSelectWindow",

            " > &Align"                 => "mnuEditAlign",
            " > > &Left"                => "mnuEditAlignLeft",
            " > > &Center"              => "mnuEditAlignCenter",
            " > > &Right"               => "mnuEditAlignRight",
            " > > &Width"               => "mnuEditAlignMaxWidth",
            " > > -"                    =>  0,
            " > > &Top"                 => "mnuEditAlignTop",
            " > > &Middle"              => "mnuEditAlignMiddle",
            " > > &Bottom"              => "mnuEditAlignBottom",
            " > > &Height"              => "mnuEditAlignMaxHeight",

            " > &Bring"                 => "mnuEditBring",
            " > > To &top"              => "mnuEditBringToTop",
            " > > &Up"                  => "mnuEditBringUp",
            " > > &Down"                => "mnuEditBringDown",
            " > > To &bottom"           => "mnuEditBringToBottom",

            " > -"                  =>  0,
            " > &Events\tCtrl-E"        => "mnuEditEvents",

            "&Design"                   => "mnuDesign",
            " > &Test window\tCtrl+T"   => "mnuDesignTest",
            " > &Close all test windows"=> "mnuDesignCloseTest",

            "&Help"                     => "mnuHelp",
            " > &User manual"           => "mnuHelpUserManual",
            " > &Programmer's Reference"=> "mnuHelpProgrammersReference",
            " > &FAQ"                   => "mnuHelpFAQ",
            " > -"                      =>  0,
            " > Win32::GUI Docs"        => "mnuHelpWin32GUI",
            " > Win32::GUI Selected Control" => "mnuHelpWin32GUISelectedControl",
            " > -"                      =>  0,
            " > Win32 &SDK web page"    => "mnuHelpWin32SDK",
            " > -"                      =>  0,
            " > &Changes"               => "mnuHelpChanges",
            " > &About..."              => "mnuHelpAbout",
            );

    $self->mnuMain($mnuMain);

    #The window
#=pod
    my $fileWindow = "resource\\main.gld";      ##todo: Move to config
    my $objDesign = Win32::GUI::Loft::Design->newLoad($fileWindow) or
            $self->errorReport("Could not open window file ($fileWindow)");
    $objDesign->mnuMenu($mnuMain);
    my $winMain = $objDesign->buildWindow() or
            $self->errorReport("Could not build window ($fileWindow)");
    $winMain->DragAcceptFiles(1);

#print Dumper($winMain);
#print "$winMain->{-name}\n";
#=cut

=pod

    my $winMain = new Win32::GUI::Window(
          -left   => 0,
          -top    => 100,
          -width  => 200,
          -height => 500,
          -name   => "winMain",
          -text   => "The GUI Loft",
          -menu   => $mnuMain,
          );
    $winMain->{-dialogui} = 1;

    my ($width, $height) = ($winMain->GetClientRect)[2..3];


#   $self->objWindowDesign()->objModalizer( $self->objModalizer() );


#   my $hw = 16;
#   my $pathIcon = $self->rhConfig()->{dirIcon};
#   my $ilIcon = new Win32::GUI::ImageList($hw, $hw, 0, @gaBitmap + 1, @gaBitmap + 1);
#   for my $icon (@gaBitmap) {
#       my $fileIcon =  "$pathIcon\\$icon";
#       $ilIcon->Add(new Win32::GUI::Bitmap($fileIcon), 0);
#       }


    my $wb = 20;
    my $hb = 20;
    my $x = 0;
    my $y = 0;

    $winMain->AddButton(
           -text    => "&Nw",
           -name    => "btnNew",
           -left    => $x,
           -top     => $y,
           -width   => $wb,
           -height  => $hb,
          );
    $x += $wb;
    $winMain->AddButton(
           -text    => "&Op",
           -name    => "btnOpen",
           -left    => $x,
           -top     => $y,
           -width   => $wb,
           -height  => $hb,
          );
    $x += $wb;
    $winMain->AddButton(
           -text    => "&Sv",
           -name    => "btnSave",
           -left    => $x,
           -top     => $y,
           -width   => $wb,
           -height  => $hb,
          );
    $x += $wb;

    $x += 2;

    $winMain->AddButton(
           -text    => "&Ct",
           -name    => "btnCut",
           -left    => $x,
           -top     => $y,
           -width   => $wb,
           -height  => $hb,
          );
    $x += $wb;
    $winMain->AddButton(
           -text    => "&Cp",
           -name    => "btnCopy",
           -left    => $x,
           -top     => $y,
           -width   => $wb,
           -height  => $hb,
          );
    $x += $wb;
    $winMain->AddButton(
           -text    => "&Ps",
           -name    => "btnPaste",
           -left    => $x,
           -top     => $y,
           -width   => $wb,
           -height  => $hb,
          );
    $x += $wb;
    $winMain->AddButton(
           -text    => "&Dl",
           -name    => "btnDelete",
           -left    => $x,
           -top     => $y,
           -width   => $wb,
           -height  => $hb,
          );
    $x += $wb;

    $x += 2;

    $winMain->AddButton(
           -text    => "&Up",
           -name    => "btnUp",
           -left    => $x,
           -top     => $y,
           -width   => $wb,
           -height  => $hb,
          );
    $x += $wb;
    $winMain->AddButton(
           -text    => "&Dn",
           -name    => "btnDown",
           -left    => $x,
           -top     => $y,
           -width   => $wb,
           -height  => $hb,
          );
    $x += $wb;
    $y += $hb;

    my $lbControl = $winMain->AddListbox(
            -name      => "lbControl",
            -text      => "",
            -left      => 0,
            -top       => $y,
            -width     => $width,
            -height    => $height,
#           -style     =>
#                   WS_CHILD |
#                   WS_VISIBLE |
#                   1,
            -multisel  => 2,
            );

#   my $lvwControl = $winMain->AddListView(
#           -name      => "lvwControl",
#           -text      => "",
#           -left      => 0,
#           -top       => $y,
#           -width     => $width,
#           -height    => $height - $y,
#           -style     =>
#                   WS_CHILD |
#                   WS_VISIBLE |
#                   1,
#           -fullrowselect => 1,
#           -gridlines => 1,
#           );
#
#   $lvwControl->InsertColumn(
#           -index => 0,
#           -width => $width / 2,
#           -text  => "Control",
#           );
#   $lvwControl->InsertColumn(
#           -index => 1,
#           -width => $width / 2,
#           -text  => "Type",
#           );

=cut

    $self->winMain($winMain);


    ##The dialog is done, now arrange it.
    my $objResizer = Win32::GUI::Resizer->new($winMain);
    $self->objResizerMain($objResizer);
    $objResizer->raRelations([
            'winWidth' => [
                    ['$winResize->lbControl->Width()'],
                    ['$winResize->tsClusterGrid->Width()'],

                    ['$winResize->lvwCluster->Width()'],
                    ['$winResize->btnClusterMemorize->Width()'],

                    ['$winResize->gbGrid->Width()'],
                    ['$winResize->lblGridSize->Left()'],
                    ['$winResize->lblGridX->Left()'],
                    ['$winResize->tfGridHeight->Left()'],
                    ['$winResize->tfGridWidth->Left()'],
                    ['$winResize->btnGridApply->Left()'],
                    ['$winResize->btnGridReset->Left()'],
                    ],
            'winHeight' => [
                    ['$winResize->lbControl->Height()'],
                    ['$winResize->tsClusterGrid->Top()'],

                    ['$winResize->lvwCluster->Top()'],
                    ['$winResize->btnClusterNew->Top()'],
                    ['$winResize->btnClusterDelete->Top()'],
                    ['$winResize->btnClusterRename->Top()'],
                    ['$winResize->btnClusterMemorize->Top()'],

                    ['$winResize->gbGrid->Top()'],
                    ['$winResize->lblGridSize->Top()'],
                    ['$winResize->chbGridSnap->Top()'],
                    ['$winResize->chbGridShow->Top()'],
                    ['$winResize->lblGridX->Top()'],
                    ['$winResize->tfGridHeight->Top()'],
                    ['$winResize->tfGridWidth->Top()'],
                    ['$winResize->btnGridApply->Top()'],
                    ['$winResize->btnGridReset->Top()'],

                    ],
            ]);
    $objResizer->memorize();


    ##Resize to the saved position
    my $rhWindowConfig = $self->rhWindowConfig();
    $winMain->Left( $self->default($rhWindowConfig->{posMainLeft}, 100) );
    $winMain->Top( $self->default($rhWindowConfig->{posMainTop}, 100) );
    $winMain->Width( $self->default($rhWindowConfig->{posMainWidth} ,620) );
    $winMain->Height( $self->default($rhWindowConfig->{posMainHeight} ,400) );



    ##The Cluster properties window
    $fileWindow = "resource\\cluster.gld";      ##todo: Move to config
    my $objClusterProp = Win32::GUI::Loft::Design->newLoad($fileWindow) or
            $self->errorReport("Could not open window file ($fileWindow)");
    my $winClusterProp = $objClusterProp->buildWindow($winMain) or
            $self->errorReport("Could not build window ($fileWindow)");
    $self->winClusterProp($winClusterProp);



    ##Tadaaa!
    $self->setWindowState();
    $winMain->Show();


    ##The Design window
    $self->objWindowDesign()->rhConfig( $self->rhConfig() );
    $self->objWindowDesign()->objWindowProp($self->objWindowProp());
    $self->objWindowDesign()->objWindowApp($self);
    $self->objWindowDesign->init($winMain);


    ##The Properties window
    $self->objWindowProp()->rhConfig( $self->rhConfig() );
    $self->objWindowProp()->objWindowDesign($self->objWindowDesign());
    $self->objWindowProp()->objWindowApp($self);
    $self->objWindowProp->init($winMain);

    $self->objWindowProp()->winProp()->Left( $self->default($rhWindowConfig->{posPropLeft}, 600) );
    $self->objWindowProp()->winProp()->Top( $self->default($rhWindowConfig->{posPropTop}, 50) );
    $self->objWindowProp()->winProp()->Width( $self->default($rhWindowConfig->{posPropWidth} ,250) );
    $self->objWindowProp()->winProp()->Height( $self->default($rhWindowConfig->{posPropHeight} ,400) );

    ##The Toolbox window
    $self->objWindowTool()->rhConfig( $self->rhConfig() );
    $self->objWindowTool()->objWindowDesign($self->objWindowDesign());
    $self->objWindowTool()->objWindowProp($self->objWindowProp());
    $self->objWindowTool()->objWindowApp($self);
    $self->objWindowTool->init($winMain);


    #All windows are done, prepare them for Modalizer
    $self->objModalizer(Win32::GUI::Modalizer->new(
            $winMain,
            $self->objWindowProp()->winProp(),
            $self->objWindowDesign()->winDesign(),
            $self->objWindowTool()->winTool(),
            ));


    $self->canvasClose();

    $winMain->SetForegroundWindow();

    $self->objWindowProp()->winProp()->Show();
    $self->objWindowTool()->winTool()->Show();

    return(1);
    }





=head2 run()

Run the UI.

Return 1 on success, else 0.

=cut

sub run {
    my $self = shift; my $pkg = ref($self);

    Win32::GUI::Dialog();

    return(1);
    }





=head2 shutdown()

Shutdown application, close stuff, save etc.

Return 1 on succes, else 0.

=cut

sub shutdown {
    my $self = shift; my $pkg = ref($self);

    $self->configWindowSave(
            $self->winMain->Left(),
            $self->winMain->Top(),
            $self->winMain->Width(),
            $self->winMain->Height(),
            $self->objWindowProp()->winProp->Left(),
            $self->objWindowProp()->winProp->Top(),
            $self->objWindowProp()->winProp->Width(),
            $self->objWindowProp()->winProp->Height(),
            );

    $self->configSave();

    $self->isClosed(1);

    return(1);
    }





=head2 configLoad($fileConfig)

Load the config from file $fileConfig, and from the files
defined in that config file.

Return 1 on success, else die().

=cut

sub configLoad {
    my $self = shift; my $pkg = ref($self);
    my ($fileConfig) = @_;

    $self->fileConfig($fileConfig);

    $self->rhConfig($self->loadXMLFile($fileConfig));

    $self->rhWindowConfig($self->loadXMLFile( $self->rhConfig()->{fileWindow} ) ) if(-r $self->rhConfig()->{fileWindow});

    return(1);
    }





=head2 configSave()

Save the rhConfig.

Return 1 on success, else 0.

=cut

sub configSave {
    my $self = shift; my $pkg = ref($self);
    return($self->saveXMLFile($self->fileConfig(), $self->rhConfig()));
    }





=head2 configWindowSave($mainLeft, $mainTop, $mainWidth, $mainHeight, $propLeft, $propTop, $propWidth, $propHeight)

Save the window state config file

Return 1 on success, else 0.

=cut

sub configWindowSave {
    my $self = shift; my $pkg = ref($self);
    my ($mainLeft, $mainTop, $mainWidth, $mainHeight, $propLeft,
            $propTop, $propWidth, $propHeight) = @_;

    $self->rhWindowConfig()->{posMainLeft} = $mainLeft;
    $self->rhWindowConfig()->{posMainTop} = $mainTop;
    $self->rhWindowConfig()->{posMainWidth} = $mainWidth;
    $self->rhWindowConfig()->{posMainHeight} = $mainHeight;
    $self->rhWindowConfig()->{posPropLeft} = $propLeft;
    $self->rhWindowConfig()->{posPropTop} = $propTop;
    $self->rhWindowConfig()->{posPropWidth} = $propWidth;
    $self->rhWindowConfig()->{posPropHeight} = $propHeight;

    $self->saveXMLFile($self->rhConfig()->{fileWindow}, $self->rhWindowConfig());

    return(1);
    }





=head2 setWindowState()

Set the state of controls so that they match the state of
the application.

Return 1.

=cut

sub setWindowState {
    my $self = shift; my $pkg = ref($self);

#   my $winMain = $self->winMain() or return(0);
#   my $mnuMain = $self->mnuMain() or return(0);
    my $objDesign = $self->objDesign() or return(0);
    my $objCanvas = $self->objCanvas() or return(0);
    my $win = $self->winMain() or return(0);

    if(keys %{$objCanvas->rhControlSelected()}) {
        $win->btnCut()->Enable(1);
        $win->btnCopy()->Enable(1);
        $win->btnDelete()->Enable(1);
        $win->btnUp()->Enable(1);
        $win->btnDown()->Enable(1);
        }
    else {
        $win->btnCut()->Enable(0);
        $win->btnCopy()->Enable(0);
        $win->btnDelete()->Enable(0);
        $win->btnUp()->Enable(0);
        $win->btnDown()->Enable(0);
        }

    my $clustEnable = defined($self->clusterGetSelected()) ? 1 : 0;
    $win->btnClusterRename()->Enable($clustEnable);
    $win->btnClusterDelete()->Enable($clustEnable);
    $win->btnClusterMemorize()->Enable($clustEnable);


    return(1);
    }





=head2 openFile($fileName)

Close the current canvas and open the one in $fileName.

A user cancellation is a success.

Return 1 on success, else 0.

=cut

sub openFile {
    my $self = shift; my $pkg = ref($self);
    my ($fileName) = @_;

    $self->canvasClose() or return(1);
    
    my $objNew = Win32::GUI::Loft::Design->newLoad($fileName);
    my $ret = 1;
    if(!$objNew) {
        $ret = 0;
        }

    $self->canvasNew($objNew);

    #Sync the Grid settings
    ::btnGridReset_Click();

    return($ret);
    }





=head2 dropFiles($handleDrop)

Close the current canvas and open the first one indicated by 
$handleDrop.

Return 1 on success, else 0.

=cut

sub dropFiles {
    my $self = shift; my $pkg = ref($self);
    my ($handleDrop) = @_;

    #Show and focus the app window
    $self->winMain()->SetForegroundWindow();
    
    my @aFile = Win32::GUI::DragDrop::GetDroppedFiles($handleDrop);
    my $fileOpen = $aFile[0] or return(0);
    
    $self->openFile($fileOpen) or $self->errorReport("Could not open Design ($fileOpen)");  

    return(1);
    }





=head2 canvasNew([Win32::GUI::Loft::Design $objNew])

Reset current design and create a new one. If $objNew is
passed, use that one as the new design.

Return 1 on success, else 0.

=cut

sub canvasNew {
    my $self = shift; my $pkg = ref($self);
    my ($objNew) = @_;
    Win32::GUI::Loft::Design->resetInstanceCount();     #Hide the fact that we have created a few windows
    defined($objNew) or ($objNew = Win32::GUI::Loft::Design->new()) or return(0);

    #Create new canvas, maybe using the existing design
    $self->objDesign($objNew);
    $self->objCanvas( Win32::GUI::Loft::Canvas->new() );
    $self->objCanvas()->objDesign($objNew);


    #The Model-Control-View views
    $self->objCanvas()->raView( [
            $objNew,                        #The Win32::GUI::Loft::Design object
            $self->objWindowDesign(),       #Design window
            $self->objWindowProp(),         #Properties window
            $self,                          #Main window
            ] );

    $self->objWindowDesign()->objDesign($objNew);
    $self->objWindowDesign()->objCanvas( $self->objCanvas() );
    $self->objWindowDesign()->hwindMain( $self->winMain()->{-handle} );

    $self->objWindowProp()->objCanvas( $self->objCanvas() );
    $self->objWindowProp()->objDesign( $self->objDesign() );

    $self->objWindowTool()->objCanvas( $self->objCanvas() );
    $self->objWindowTool()->objDesign( $self->objDesign() );


    $self->objWindowDesign()->canvasNew();


    #Display design window
    $self->objWindowDesign()->winDesign()->Show();

    $self->objCanvas()->clusterNotifyFundamental();

    return(1);
    }





=head2 canvasClose()

Close the current design and reset the state of the app.
Make sure the user gets the opportunity to save if need be.

Return 1 on success, else 0.

=cut

sub canvasClose {
    my $self = shift; my $pkg = ref($self);
#$DB::single = 1;
    if($self->objDesign() && $self->objDesign()->isDirty()) {
        my $fileName = basename($self->objDesign()->fileName()) || "current design";
        my $ret = Win32::MsgBox(
                "Save changes to $fileName?",
                MB_YESNOCANCEL | MB_ICONQUESTION | MB_DEFBUTTON1 | MB_APPLMODAL,
                "The GUI Loft");
        return(0) if($ret == 2);                #IDCANCEL
        ::mnuFileSave_Click() if($ret == 6);    #IDYES
        }

    $self->objWindowDesign()->winDesign()->Hide();
    $self->objDesign(0);

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

    for my $prop (@{$raPropName}) {
        $self->controlPopulate() if($prop eq "Name");
        }

    return(1);
    }





=head2 propNotifyFundamental()

The number of controls has changed.

Return 1 on success, else 0.

=cut

sub propNotifyFundamental {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl, $raPropName) = @_;

    $self->controlPopulate();

    $self->setWindowState();

    return(1);
    }





=head2 propNotifySelected($rhControl)

The number of conrols that are selected has changed.

Return 1 on success, else 0.

=cut

sub propNotifySelected {
    my $self = shift; my $pkg = ref($self);
    my ($rhControl) = @_;

    $self->controlSelect( $rhControl );

    $self->setWindowState();

    return(1);
    }





=head2 clusterNotifyFundamental()

The number of clustered controls has changed for one or more
clusters.

Return 1 on success, else 0.

=cut

sub clusterNotifyFundamental {
    my $self = shift; my $pkg = ref($self);

    $self->clusterPopulate();

    $self->setWindowState();

    return(1);
    }





=head2 controlPopulate()

Fill the list with the available controls.

Return 1 on success, else 0.

=cut

sub controlPopulate {
    my $self = shift; my $pkg = ref($self);

    $self->winMain()->lbControl()->Clear();

    $self->winMain()->lbControl()->AddString( $self->objDesign()->objControlWindow()->prop("Name") );   #. " (Window)" );

    for my $objControl (@{$self->objDesign()->raControl()}) {
        $self->winMain()->lbControl()->AddString(
                $objControl->prop("Name") );        #. " (" . $objControl->type() . ")" );
        }

    $self->controlSelect();

    return(1);
    }





=head2 controlSelect()

Sync the ListBox with the selected controls.

Return 1 on success, else 0.

=cut

sub controlSelect {
    my $self = shift; my $pkg = ref($self);

    my $check = ( keys %{$self->objCanvas()->rhControlSelected()}  ) ? 0 : 1;
    $self->winMain()->lbControl()->SendMessage(0x0185, $check, 0);              #LB_SETSEL

    my $i = 1;
    for my $objControl (@{$self->objDesign()->raControl()}) {
        $self->winMain()->lbControl()->SendMessage(0x0185,
                $objControl->designIsSelected(), $i);               #LB_SETSEL
        $i++;
        }

    return(1);
    }





=head2 controlSetSelection()

Impose the state of the List Box on the model by selecting
the correct controls.

Return 1 on success, else 0.

=cut

sub controlSetSelection {
    my $self = shift; my $pkg = ref($self);

    #First, deselect the window if any other controls are selected
    my @aSelected = $self->winMain()->lbControl()->SelectedItems();
#   if(@aSelected && 0 != $aSelected[0]) {
#       $self->winMain()->lbControl()->SendMessage(0x0185, 0, 0);       #LB_SETSEL
#       $self->objCanvas()->controlAllDeselect();
#       }

    my %hSelected = map { $_ => 1 } @aSelected;
    my $i = 1;
    for my $objControl (@{$self->objDesign()->raControl()}) {
        my $check = exists $hSelected{$i} ? 1 : 0;
        $self->objCanvas()->controlSelected($objControl, $check);

        $i++;
        }

    $self->controlSelect();
    $self->objCanvas()->propNotifySelected($self);

    return(1);
    }





=head2 controlMove($dir)

Move the selected controls in the $dir (0: down, 1: up, 2: 
bottom, 3: top).

Don't do anything with the window control, and don't move
above the window control since it is the main container.

Return 1 on success, else 0.

=cut

sub controlMove {
    my $self = shift; my $pkg = ref($self);
    my ($dir) = @_;

    my @aSelected = map { $_ - 1 } $self->winMain()->lbControl()->SelectedItems();
    return(0) if(@aSelected && -1 == $aSelected[0]);

    $self->objDesign()->controlRearrange($dir, \@aSelected);

    $self->objCanvas()->propNotifyFundamental();

    return(1);
    }





=head2 clusterGetSelected()

Return 2 element array with (the index, the
Win32::GUI::Loft::Cluster object) that is selected, or ()
if none. If many are selected, return only the first.

Return 1 on success, else 0.

=cut

sub clusterGetSelected {
    my $self = shift; my $pkg = ref($self);

    my @aSelected = $self->winMain()->lvwCluster()->SelectedItems();

    my $index = $aSelected[0]; return(0) if(!defined($index));
    my $objCluster = $self->objDesign()->raCluster()->[$index] or return();

    return($index, $objCluster);
    }





=head2 clusterPopulate()

Re-fill lvwCluster with the current clusters.

Return 1 on success, else 0.

=cut

sub clusterPopulate {
    my $self = shift; my $pkg = ref($self);

    #Reset the lvwCluster and refill it
    $self->winMain()->lvwCluster()->Clear();

    for my $objCluster (@{$self->objDesign()->raCluster()}) {
        $self->winMain()->lvwCluster()->InsertItem(
                -text => [ $objCluster->name() ],
                -image => $objCluster->isVisible()
                );
        }

    return(1);
    }





=head2 clusterSetVisible($index, $visible)

Change the image in the listview to $visible for item $index.

Return 1 on success, else 0.

=cut

sub clusterSetVisible {
    my $self = shift; my $pkg = ref($self);
    my ($index, $visible) = @_;
    return(0) if($visible < 0 || $visible > 1);

    $self->winMain()->lvwCluster()->ChangeItem(
            -item       => $index,
            -image      => $visible
            );

    return(1);
    }





=head2 windowTest()

Test the current window.

Return 1 on success, else 0.

=cut

sub windowTest {
    my $self = shift; my $pkg = ref($self);

    ##Use a temp name so it's not colliding with the application's name space
    #Store old values
    my $buildWindowName = $self->objDesign()->buildWindowName();
    my $buildControlNameBase = $self->objDesign()->buildControlNameBase();

    my $id = time() . int(rand(10000));
    $self->objDesign()->buildWindowName( "winTest$id" );
    $self->objDesign()->buildControlNameBase( $id );


    ##If we have a preview menu, build one and provide it.
    my $menuPreview = $self->objDesign()->objControlWindow()->prop("PreviewMenu");
    if($menuPreview) {
        my $mnuPreview = Win32::GUI::MakeMenu(
                map { $_ => "mnu$_$id" } split(/,\s*/, $menuPreview)
                );

        $self->objDesign()->mnuMenu($mnuPreview);
        }
    else {
        $self->objDesign()->mnuMenu(0);
        }


    ##Build the window
    $self->objDesign()->isPreview(1);
    my $winTest = $self->objDesign()->buildWindow($self->winMain());

    ##Restore old values
    $self->objDesign()->buildWindowName( $buildWindowName );
    $self->objDesign()->buildControlNameBase( $buildControlNameBase );

    $winTest or return(0);

    $winTest->Show();

    #Add it to the array
    $self->raWinTest([ $winTest, @{$self->raWinTest()} ]);

    return(1);
    }





=head2 perlExport($fileName, $subName)

Export the current design to $fileName.

$subName -- If ne "", it's the sub in which to put the code.

Return 1 on success, else 0.

=cut

sub perlExport {
    my $self = shift; my $pkg = ref($self);
    my ($fileName, $subName) = @_;



    return(1);
    }





=head1 Win32::GUI EVENTS

=head2 winMain_Terminate()

Terminate the main window

=cut

sub ::winMain_Terminate {

    $gObjSingleton->shutdown();

    return(-1);
    }





=head2 winMain_Resize()

Resize the main window.

=cut
#sub ::winMain_Resize {
my $self = TGL::WindowApp->new();
#   defined($self->objResizerMain()) and $self->objResizerMain()->resize();
#   }





=head2 winMain_Activate()

Activate the window and perform Modalizer stuff.

=cut

sub ::winMain_Activate {
    my $self = TGL::WindowApp->new();
    defined($self->objModalizer()) and $self->objModalizer()->activate($self->winMain());
    }





sub ::winMain_DropFiles {
    my $self = TGL::WindowApp->new();
    my ($handleDrop) = @_;

    $self->dropFiles($handleDrop);

    return(1);
    }





=head2 lbControl_Click()

The selected state change, so reflect that.

=cut

sub ::lbControl_Click {
    my $self = TGL::WindowApp->new();

    $self->controlSetSelection();

    $self->setWindowState();

    return(1);
    }





=head2 btnNew_Click()

New design.

=cut

sub ::btnNew_Click {
    my $self = TGL::WindowApp->new();

    ::mnuFileNew_Click();

    return(1);
    }





=head2 btnOpen_Click()

Open design.

=cut

sub ::btnOpen_Click {
    my $self = TGL::WindowApp->new();

    ::mnuFileOpen_Click();

    $self->setWindowState();

    return(1);
    }





=head2 btnSave_Click()

Save design.

=cut

sub ::btnSave_Click {
    my $self = TGL::WindowApp->new();

    ::mnuFileSave_Click();

    $self->setWindowState();

    return(1);
    }





=head2 btnCut_Click()

Cut selected controls.

=cut

sub ::btnCut_Click {
    my $self = TGL::WindowApp->new();

    my $clipboard = $self->objCanvas()->controlCut();
    Win32::Clipboard::Set( $clipboard );

    return(1);
    }





=head2 btnCopy_Click()

Copy selected controls.

=cut

sub ::btnCopy_Click {
    my $self = TGL::WindowApp->new();

    my $clipboard = $self->objCanvas()->controlCopy() or return(1);
    Win32::Clipboard::Set( $clipboard );

    return(1);
    }





=head2 btnPaste_Click()

Paste selected controls.

=cut

sub ::btnPaste_Click {
    my $self = TGL::WindowApp->new();

    my $clipboard = Win32::Clipboard::GetText();
    $self->objCanvas()->controlPaste($clipboard);

    return(1);
    }





=head2 btnDelete_Click()

Delete selected controls.

=cut

sub ::btnDelete_Click {
    my $self = TGL::WindowApp->new();

    $self->objCanvas()->controlDelete();

    return(1);
    }





=head2 btnUp_Click()

Move selected controls up one step

=cut

sub ::btnUp_Click {
    my $self = TGL::WindowApp->new();

    $self->controlMove(1);

    return(1);
    }





=head2 btnDown_Click()

Move selected controls down one step

=cut

sub ::btnDown_Click {
    my $self = TGL::WindowApp->new();

    $self->controlMove(0);

    return(1);
    }





=head2 btnClusterNew_Click()

New cluster

=cut

sub ::btnClusterNew_Click {
    my $self = TGL::WindowApp->new();

    my $name = "New cluster";
    $self->objCanvas()->clusterNew($name) or return(1);

#   my $index = $self->winMain()->lvwCluster()->Count() - 1;
#   $self->clusterSetVisible($index, 1);

    return(1);
    }





=head2 btnClusterRename_Click()

Rename cluster

=cut

sub ::btnClusterRename_Click {
    my $self = TGL::WindowApp->new();

    my ($index, $objCluster) = $self->clusterGetSelected() or return(1);

    $self->objClusterLastEdited($objCluster);

    #Fill out the form
    $self->winClusterProp()->tfClusterName()->Text( $objCluster->name() );

    ##todo: make it modal
#   $self->winClusterProp()->Show();
    $self->objModalizer()->beginDialog($self->winClusterProp(), $self->winMain());
    $self->winClusterProp()->tfClusterName()->SelectAll();
    $self->winClusterProp()->tfClusterName()->SetFocus();

    return(1);
    }





=head2 btnClusterDelete_Click()

Delete cluster

=cut

sub ::btnClusterDelete_Click {
    my $self = TGL::WindowApp->new();

    my ($index, $objCluster) = $self->clusterGetSelected() or return(1);
    $self->objCanvas()->clusterDelete($objCluster);

    return(1);
    }





=head2 btnClusterMemorize_Click()

Delete cluster

=cut

sub ::btnClusterMemorize_Click {
    my $self = TGL::WindowApp->new();

    my ($index, $objCluster) = $self->clusterGetSelected() or return(1);
    $self->objCanvas()->clusterMemorize($objCluster);

    return(1);
    }





=head2 btnGridApply_Click()

Grid Apply button. Sync the Design with the form contents.

=cut

sub ::btnGridApply_Click {
    my $self = TGL::WindowApp->new();

    $self->objDesign->gridSnap( $self->winMain()->chbGridSnap()->Checked() );
    $self->objDesign->gridShow( $self->winMain()->chbGridShow()->Checked() );

    $self->objDesign->snapX( $self->winMain()->tfGridWidth()->Text() );
    $self->objDesign->snapY( $self->winMain()->tfGridHeight()->Text() );

    #We have set the properties. They were validated when set.
    #Now, "reload" them from their actual vaues.
    ::btnGridReset_Click();

    #Update the views
    ##todo: this should be a message specific for
    #       "the view properties has changed" or something
    $self->objCanvas()->propNotifyFundamental($self);

    return(1);
    }





=head2 btnGridReset_Click()

Grid Reset button. Sync the form contents with the Design.

=cut

sub ::btnGridReset_Click {
    my $self = TGL::WindowApp->new();

    $self->winMain()->chbGridSnap()->Checked( $self->objDesign->gridSnap() );
    $self->winMain()->chbGridShow()->Checked( $self->objDesign->gridShow() );

    $self->winMain()->tfGridWidth()->Text( $self->objDesign->snapX() );
    $self->winMain()->tfGridHeight()->Text( $self->objDesign->snapY() );

    return(1);
    }





=head2 lvwCluster_DblClick()

Change visible state

=cut

sub ::lvwCluster_DblClick {
    my $self = TGL::WindowApp->new();

    my ($index, $objCluster) = $self->clusterGetSelected() or return(undef);

    #Toggle it's visible state
    $self->objCanvas()->clusterVisibleToggle($objCluster);
    $self->clusterSetVisible( $index, $objCluster->isVisible() );

    return(1);
    }





=head2 mnuFileNew_Click()

Exit the app.

=cut

sub ::mnuFileNew_Click {
    my $self = TGL::WindowApp->new();

    $self->canvasClose() or return(1);
    $self->canvasNew();

    return(1);
    }





=head2 mnuFileOpen_Click()

Open new design and replace the existing one.

=cut

sub ::mnuFileOpen_Click {
    my $self = TGL::WindowApp->new();

    my $dir = ($self->objDesign() and dirname($self->objDesign()->fileName())
            or "");
    my $fileRet = GUI::GetOpenFileName(
            -owner => $self->winMain(),
            -title  => "Open",
            -directory => $dir,
            -filter => [
                    "GUI Loft Design files (*.gld)" => "*.gld",
                    "All files (*.*)", "*.*",
                    ],
            );

    return(1) if(!$fileRet);

    $self->openFile($fileRet) or $self->errorReport("Could not open Design ($fileRet)");

    return(1);
    }





=head2 mnuFileSave_Click()

Save the current design.

=cut

sub ::mnuFileSave_Click {
    my $self = TGL::WindowApp->new();
    return(1) if(!$self->objDesign());

    my $fileName = $self->objDesign()->fileName() || "";

    if(!$fileName) {
        return(::mnuFileSaveAs_Click());
        }

    $self->objDesign()->fileSave($fileName) or $self->errorReport("Could not save Design");

    return(1);
    }





=head2 mnuFileSaveAs_Click()

Save the current design.

=cut

sub ::mnuFileSaveAs_Click {
    my $self = TGL::WindowApp->new();
    return(1) if(!$self->objDesign());

    my $fileRet = GUI::GetSaveFileName(
            -title  => "Save As...",
#           -file   => "\0" . " " x 256,
            -filter => [
                    "GUI Loft Design files (*.gld)" => "*.gld",
                    "All files (*.*)", "*.*",
                    ],
            );

    return(1) if(!$fileRet);
    $fileRet .= ".gld" if($fileRet !~ /\.\w+$/);

    $self->objDesign()->fileName($fileRet);

    ::mnuFileSave_Click();

    return(1);
    }





=head2 mnuFileExit_Click()

Exit the app.

=cut

sub ::mnuFileExit_Click {

    $gObjSingleton->shutdown();

    return(-1);
    }





=head2 mnuEditCopyPerlName_Click()

Copy the names of selected controls to the Clipboard.

=cut

sub ::mnuEditCopyPerlName_Click {
    my $self = TGL::WindowApp->new();

    my $clipboard = $self->objCanvas()->controlCopyName() or return(1);
    $clipboard =~ s{\n}{\r\n}gs;

    Win32::Clipboard::Set( $clipboard );

    return(1);
    }





=head2 mnuEditCopyPerlResizer_Click()

Generate Perl code for the resizer stuff and put it in the
Clipboard.

=cut

sub ::mnuEditCopyPerlResizer_Click {
    my $self = TGL::WindowApp->new();

    my $perlRes = $self->objDesign()->perlResizer();
    $perlRes =~ s{\n}{\r\n}gs;

    Win32::Clipboard::Set( $perlRes );

    return(1);
    }





=head2 mnuEditSelectAll_Click()

Select all controls (except the window).

=cut

sub ::mnuEditSelectAll_Click {
    my $self = TGL::WindowApp->new();

    $self->objCanvas()->controlAllSelect() or $self->errorReport("Could not select all");

    return(1);
    }





=head2 mnuEditSelectWindow_Click()

Deselect all controls (select the window).

=cut

sub ::mnuEditSelectWindow_Click {
    my $self = TGL::WindowApp->new();

    $self->objCanvas()->controlAllDeselect() or $self->errorReport("Could not deselect all");

    return(1);
    }





=head2 mnuEditBringToTop_Click()

Bring the selected controls to the top of the Tab Order.

=cut

sub ::mnuEditBringToTop_Click {
    my $self = TGL::WindowApp->new();

    return( $self->controlMove(3) );
    }





=head2 mnuEditBringUp_Click()

Bring the selected controls up one step in the Tab Order.

=cut

sub ::mnuEditBringUp_Click {
    my $self = TGL::WindowApp->new();

    return( $self->controlMove(1) );
    }





=head2 mnuEditBringDown_Click()

Bring the selected controls up one step in the Tab Order.

=cut

sub ::mnuEditBringDown_Click {
    my $self = TGL::WindowApp->new();

    return( $self->controlMove(0) );
    }





=head2 mnuEditBringToBottom_Click()

Bring the selected controls to the top of the Tab Order.

=cut

sub ::mnuEditBringToBottom_Click {
    my $self = TGL::WindowApp->new();

    return( $self->controlMove(2) );
    }





=head2 mnuEditAlignRight_Click()

Align selected controls right

=cut

sub ::mnuEditAlignRight_Click {
    my $self = TGL::WindowApp->new();

    return( $self->objCanvas()->controlAlignSelected("right") );
    }





=head2 mnuEditAlignLeft_Click()

Align selected controls left

=cut

sub ::mnuEditAlignLeft_Click {
    my $self = TGL::WindowApp->new();

    return( $self->objCanvas()->controlAlignSelected("left") );
    }





=head2 mnuEditAlignTop_Click()

Align selected controls top

=cut

sub ::mnuEditAlignTop_Click {
    my $self = TGL::WindowApp->new();

    return( $self->objCanvas()->controlAlignSelected("top") );
    }





=head2 mnuEditAlignBottom_Click()

Align selected controls bottom

=cut

sub ::mnuEditAlignBottom_Click {
    my $self = TGL::WindowApp->new();

    return( $self->objCanvas()->controlAlignSelected("bottom") );
    }





=head2 mnuEditAlignCenter_Click()

Align selected controls center

=cut

sub ::mnuEditAlignCenter_Click {
    my $self = TGL::WindowApp->new();

    return( $self->objCanvas()->controlAlignSelected("center") );
    }





=head2 mnuEditAlignMiddle_Click()

Align selected controls middle

=cut

sub ::mnuEditAlignMiddle_Click {
    my $self = TGL::WindowApp->new();

    return( $self->objCanvas()->controlAlignSelected("middle") );
    }





=head2 mnuEditAlignMaxHeight_Click()

Align selected controls to the max height

=cut

sub ::mnuEditAlignMaxHeight_Click {
    my $self = TGL::WindowApp->new();

    return( $self->objCanvas()->controlAlignSelected("maxheight") );
    }





=head2 mnuEditAlignMaxWidth_Click()

Align selected controls to the max width

=cut

sub ::mnuEditAlignMaxWidth_Click {
    my $self = TGL::WindowApp->new();

    return( $self->objCanvas()->controlAlignSelected("maxwidth") );
    }





=head2 mnuDesignTest_Click()

Test the window

=cut

sub ::mnuDesignTest_Click {
    my $self = TGL::WindowApp->new();

    $self->windowTest() or $self->errorReport("Could not create Test window");

    return(1);
    }





=head2 mnuDesignCloseTest_Click()

Test the window

=cut

sub ::mnuDesignCloseTest_Click {
    my $self = TGL::WindowApp->new();

    #Hide all test windows
    for my $winTest (@{$self->raWinTest()}) {
        $winTest->Hide();
        }

    #Clear, they are hidden now
    $self->raWinTest([]);

    return(1);
    }





=head2 mnuHelpUserManual_Click()

User manual HTML page

=cut

sub ::mnuHelpUserManual_Click {
    my $self = TGL::WindowApp->new();

    system("explorer " . $self->rhConfig()->{fileHelpManual});

    return(1);
    }




=head2 mnuHelpWin32GUI_Click()

Win32::GUI docs HTML page

=cut

sub ::mnuHelpWin32GUI_Click {
    my $self = TGL::WindowApp->new();

    system("explorer " . $self->rhConfig()->{fileHelpWin32GUI});

    return(1);
    }




=head2 mnuHelpWin32GUISelectedControl_Click()

Win32::GUI docs HTML page for the currently selected
control.

=cut

sub ::mnuHelpWin32GUISelectedControl_Click {
    my $self = TGL::WindowApp->new();

    my $name = $self->objCanvas()->helpFileSelected() or return(1);
    my $file = sprintf($self->rhConfig()->{dirTemplateHelpWin32GUISelectedControl}, $name);
    return(1) if(! -e $file);

    system('explorer "' . $file . '"');

    return(1);
    }




=head2 mnuHelpProgrammersReference_Click()

Programmer's Reference HTML page

=cut

sub ::mnuHelpProgrammersReference_Click {
    my $self = TGL::WindowApp->new();

    system("explorer " . $self->rhConfig()->{fileHelpReference});

    return(1);
    }




=head2 mnuHelpFAQ_Click()

FAQ HTML page

=cut

sub ::mnuHelpFAQ_Click {
    my $self = TGL::WindowApp->new();

    system("explorer " . $self->rhConfig()->{fileHelpFAQ});

    return(1);
    }




=head2 mnuHelpWin32SDK_Click()

Win32 API

=cut

sub ::mnuHelpWin32SDK_Click {
    my $self = TGL::WindowApp->new();

    system('explorer "' . $self->rhConfig()->{urlWin32API} . '"');

    return(1);
    }





=head2 mnuHelpChanges_Click()

Win32 API

=cut

sub ::mnuHelpChanges_Click {
    my $self = TGL::WindowApp->new();

    system("explorer " . $self->rhConfig()->{fileHelpChanges});

    return(1);
    }





=head1 WIN32::GUI CLUSTER PROP EVENTS

=head2 winClusterProp_Terminate()

Hide the window.

=cut

sub ::winClusterProp_Terminate {
    my $self = TGL::WindowApp->new();

    #$self->winClusterProp()->Hide();
    $self->objModalizer()->endDialog();

    return(0);
    }





=head2 btnClusterOk_Click()

Hide the window and do stuff

=cut

sub ::btnClusterOk_Click {
    my $self = TGL::WindowApp->new();

    #$self->winClusterProp()->Hide();
    $self->objModalizer()->endDialog();

    my $name = $self->winClusterProp()->tfClusterName()->Text();
    $self->objClusterLastEdited()->name($name);
    ##todo: set dirty flag?

    $self->clusterNotifyFundamental();

    return(1);
    }





=head2 btnClusterCancel_Click()

Hide the window and don't do stuff

=cut

sub ::btnClusterCancel_Click {
    my $self = TGL::WindowApp->new();

    #$self->winClusterProp()->Hide();
    $self->objModalizer()->endDialog();

    return(1);
    }





1;






#EOF
