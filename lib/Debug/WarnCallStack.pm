=head1 NAME 

Debug::WarnCallStack -- Module to make warnings produce a 
call stack.

=head1 SYNOPSIS

	#!/usr/local/bin/perl -w
	use Debug::WarnCallStack;
	
	sub a  {
		$i = $_[0] * 4.2;
		}
	
	print a(10);
	
=cut
package Debug::WarnCallStack;





#use strict;
use Carp;





=head2 $::SIG{__WARN__}

The warning handler is replaced with a sub printing a call 
stack as well as the warning.

=cut
BEGIN { 
	$::SIG{__WARN__} = 
	sub { 
		# Fatal stack trace made non-fatal.	
		eval q{confess("WARNING: @_\nCALL STACK: ")}; 
		print STDERR "$@\n"; # $@ is set by eval().
		};
	}





=head1 AUTHORS

Johan Lindström <johanl@bahnhof.se>

=cut





1;





#EOF