#!/usr/local/bin/perl -w
=head1 Name

Password Demo.

=cut





use strict;





#
#Note the required modules: 
#- Win32 and Win32::GUI
#- PPM Win32::GUI::Loft 
#- PPM Win32::GUI::AdHoc
#
#The PPM modules are located in the PPM directory. 
#Run the install.bat script
#
use Win32::GUI;
use Win32;
use Win32::GUI::Loft::Design;





#Note the outmost eval catching fatal errors, reporting 
#them to the user. Try changing the filename and see it 
#fail to open the file.
eval {
	main();
	};
Win32::GUI::MessageBox(0, "Error: $@", "Password Demo") if($@);





sub main {
	my $fileWindow = "dialogs\\password.gld";
	my $objDesign = Win32::GUI::Loft::Design->newLoad($fileWindow) or 
			die("Could not open window file ($fileWindow)");			
	
	#Note that we don't have to store the returned window 
	#(though we could have). It is available in the global 
	#var %Win32::GUI::Loft::window. 
	$objDesign->buildWindow() or die("Could not build window ($fileWindow)");
			
	#Note that the Name property of the window we just loaded 
	#is "winPassword".
	$Win32::GUI::Loft::window{winPassword}->Show();
	$Win32::GUI::Loft::window{winPassword}->tfPassword->SetFocus();
	

	Win32::GUI::Dialog();
	
	return(1);
	}





=head1 WIN32::GUI EVENT HANDLERS

=head2 winPassword_Terminate()

Terminate app.

=cut
#Note that we use :: to place the sub in package main,
#just in case you are in another package.

#Note how we verify that the window is actually there 
#while assigning the shortcut variable $win.
sub ::winPassword_Terminate { defined(my $win = $Win32::GUI::Loft::window{winPassword}) or return(1);

	#Just exit
	print "[X] button\n";
	
	return(-1);
	}





=head2 btnPasswordSave_Click()

Save the password and confirm.

=cut
sub ::btnPasswordSave_Click { defined(my $win = $Win32::GUI::Loft::window{winPassword}) or return(1);
	
	my $pass = $win->tfPassword->Text();
	
	#Save it
	# ...
	
	Win32::MsgBox("Ok, I saved your password ($pass)... Oops!", 0, "Saved");
	
	return(1);
	}





=head2 btnPasswordOk_Click()

Close window and exit

=cut
sub ::btnPasswordOk_Click { defined(my $win = $Win32::GUI::Loft::window{winPassword}) or return(1);
	
	#Just exit
	print "Ok\n";
	
	return(-1);
	}





=head2 btnPasswordCancel_Click()

Close window and exit

=cut
sub ::btnPasswordCancel_Click { defined(my $win = $Win32::GUI::Loft::window{winPassword}) or return(1);
	
	#Just exit
	print "Cancel\n";
	
	return(-1);
	}





=head2 timPasswordBlink_Timer()

Blink the warning label

=cut
my $blink = 0;
sub ::timPasswordBlink_Timer { defined(my $win = $Win32::GUI::Loft::window{winPassword}) or return(1);

	$blink = !$blink ? $win->lblWarning()->Show() : $win->lblWarning()->Hide();
		
	return(1);
	}





#EOF