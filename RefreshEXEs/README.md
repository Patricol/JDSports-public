# RefreshEXEs

## RefreshEXEs
* A Python program that I built to handle all the overhead surrounding compiling Python code into portable executable files.
* Drag and drop functionality that also allows you to drag a *.py file onto RefreshEXEs.exe or a shortcut pointing to it, which will then create a *.exe file in the same directory that the *.py file came from.
  * Can be done with an arbitrary number of python files at once.
* Handles copying custom modules into the system folder for compilation, and removing them after compilation.
* Removes temporary files and folders created during compilation.
* Includes helpful status and error messages.

## RefreshRefreshEXEs
* Stripped down version of RefreshEXEs, meant to be used to compile RefreshEXEs.
* Exists so that it can handle removing temp folders etc.; speeding up the process of recreating RefreshEXEs.exe

## Update RefreshRefreshEXEs
* Short batch script used to compile RefreshRefreshEXEs; when/if that is ever necessary.
