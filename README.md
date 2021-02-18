# vfpmemberclass
VFP Grid MemberClass example

This project is setup to discover what needs to be done when adding the MemberClass and MemberClassLibrary on the projects base Grid class to an old code base.

Examples should include 
* using the baseGrid directly on a form
* using the baseGrid in a visual class
* subclassing a class that has the baseGrid as a member
* using a class that has a baseGrid in it on a form
* using a class that has a baseGrid in it in a class

**NOTE** each of these should have some code in at least one method

The process*.prg files are the classes to update the classes and forms in the project.
Currently the processclassbase.prg is where the base* properties need to be set.
Then run the processtoupdatememberclassofgrid.prg program.
