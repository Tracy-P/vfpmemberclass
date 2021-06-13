# vfpmemberclass
VFP Grid MemberClass example

This project is setup to discover what needs to be done when adding the MemberClass and MemberClassLibrary on the projects base Grid class to an old code base.

Examples should include 
* using the baseGrid directly on a form
* using the baseGrid in a visual class
* subclassing a class that has the baseGrid as a member
* using a class that has a baseGrid in it on a form
* using a class that has a baseGrid in it in a class

**IMPORTANT** 
This bit of code to process the files is more than is needed. I'll work on an adjustment later.
The only thing that needs to be changed is the properties of a grid columns prefixes.

```
ColumnCount = 3
Top = 12
Left = 12
Name = "Basegrid1"
Column1.Name = "Column1"
Column2.Name = "Column2"
Column3.Name = "Column3"
```

becomes

```
ColumnCount = 3
Top = 12
Left = 12
Name = "Basegrid1"
basecolumn1.Name = "Column1"
basecolumn2.Name = "Column2"
basecolumn3.Name = "Column3"
```

**NOTE** each of these should have some code in at least one method

The process*.prg files are the classes to update the classes and forms in the project.
Currently the processclassbase.prg is where the base* properties need to be set.
Then run the processtoupdatememberclassofgrid.prg program.
