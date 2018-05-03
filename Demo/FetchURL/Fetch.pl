#!/usr/local/bin/perl -w

=head1 Name

Fetch URL and display HTTP and HTML response.

=cut





use strict;





use Win32::GUI;
use Win32;
use Win32::GUI::Loft;

use LWP::UserAgent;
use Data::Dumper;

#Modify the build process using this 
#Win32::GUI::Loft::ControlInspector subclass
use FetchInspector;





#Note the outmost eval catching fatal errors, reporting 
#them to the user. Try changing the filename and see it 
#fail to open the file.
eval {
	main();
	};
Win32::GUI::MessageBox(0, "Error: $@", "Fetch URL Demo") if($@);





sub main {
	my $fileWindow = "fetch.gld";
	my $objDesign = Win32::GUI::Loft::Design->newLoad($fileWindow) or 
			die("Could not open window file ($fileWindow)");			
	
	my $objInspector = FetchInspector->new() or die("Could not create Inspector}n");
	my $win = $objDesign->buildWindow(undef, $objInspector) 
			or die("Could not build window ($fileWindow)");
			
	$win->Show();
	$win->tfURL->SetFocus();

	Win32::GUI::Dialog();
	
	return(1);
	}





=head1 WIN32::GUI EVENT HANDLERS

=head2 winFetch_Terminate()

Terminate app.

=cut
#Note that we use :: to place the sub in package main,
#just in case you are in another package.

#Note how we verify that the window is actually there 
#while assigning the shortcut variable $win.
sub ::winFetch_Terminate { defined(my $win = $Win32::GUI::Loft::window{winFetch}) or return(1);

	#Just exit
	
	return(-1);
	}





#
#Note that we don't have to code the Resize event. It is 
#handled by the window that Loft::Design created for us.
#
#The same goes with the TabStrip.
#





=head2 btnFetch_Click()

Fetch url in tfURL.

=cut

sub ::btnFetch_Click { defined(my $win = $Win32::GUI::Loft::window{winFetch}) or return(1);
	
	my $url = $win->tfURL->Text();

	my $ua = new LWP::UserAgent;
	my $req = new HTTP::Request GET => $url;

	my $res = $ua->request($req);
	if ($res->is_success) {
		$win->reHttp->Text($res->headers_as_string());
		$win->reHtml->Text($res->content());
	} else {
		$win->reHttp->Text("Error getting url\n($url)");
		$win->reHtml->Text("Error getting url\n($url)");
		}

	return(1);
	}





#EOF
