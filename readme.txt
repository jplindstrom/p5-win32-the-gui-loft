*** The GUI Loft - Readme


** Directory structure
[some dirs only present in the source distribution]

lib -- The source tree for the Application.

PPM -- The PPM files (and source tree) for the Runtime. 
Install these first.

Modules -- Some modules required to run the Application
(unless you run the binary). Install these first.

Demo -- Demo programs. Look here for code examples.

Images -- Image originals, psd and bmp mostly.

Notes -- Some dev notes.

Release -- Release script (and the distros).



** Basic Code Structure

There is the Application (The GUI Loft), and the Runtime 
module Win32::GUI::Loft. The Application uses the Runtime.


* Running the Application

- From the binary distro. Run the tgl.exe file. No modules 
needed, just launch it.

- From the source distro. Run tgl.pl in the "lib" dir. You 
need to install required modules and PPMs.


* Using the windows in your program

You need to install required PPMs. See the Demo programs and 
the Programmer's Reference for info on how to do this.



/J
