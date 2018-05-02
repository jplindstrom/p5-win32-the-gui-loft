use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Win32::GUI::AdHoc',
	($] ge '5.005' ? (
		    'AUTHOR'	=> 'Johan Lindstrom <johanl@bahnhof.se>',
		    'ABSTRACT'	=> 'Various Win32::GUI utility modules',
			) : ()),
    'VERSION_FROM'	=> 'lib/Win32/GUI/AdHoc.pm', # finds $VERSION
    'PREREQ_PM'		=> {
    		Win32 => 0.171,
    		Win32::GUI => "0.0.558",
    		}, # e.g., Module::Name => 1.1
);
