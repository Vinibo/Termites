# Termites
Termites is a terminal manager and organizer build for Gnome 3/GTK desktops entirely written in Vala.

It's first purpose is to organize and preserve terminal sessions such as SSH. The whole software is built around the Terminal tree view, letting you add an inifite number of nodes at any level of depth.

## Why the name Termites
I'm not very creative when it comes to names but this time, it's a bit different. Termites are little insects that looks like white ants. They live in a structured colony, just like what I wanted to achieve for terminals when I started to wrote this application.

Plus, Termites contains the word "Term", I found it perfect for the job.

Hence the name, Termites!

## How to build Termites
The build process is quite ususual as I don't master Makefiles. This is something I want to fix in future versions.

### First of all, dependencies.

#### General dependencies notes
* This application aim is designed to run with GTK3.10 and more.
* Vala 0.28 is what I use to build and run

####  Ubuntu
To compile Termites for Ubuntu, you must make sure to have at least these applications/libraries installed :
* valac
* openssh
* libgnutls-dev
* libvte-2.91-dev
* libgee-0.8-dev

#### Fedora
* vala
* vte291-devel.[$ARCH]
* libgee-devel
* gcc

#### Arch linux
* base-devel (which include gcc)
* vala

### After the dependencies
If some Makefiles (configure.ac and others) files are present, just ignore them for the moment as it's not working.
Instead, just call ./build.sh in the src directory. It will compile Termites and put the executable binary into Termites/bin/Termites

## Windows and Mac OS X
I didn't test on Windows or Mac OS X but I'm pretty sure it's not working on Windows. I don't have any reason to make it functionnal for those platforms but if you want to, go for it!

## That's it!
Have fun (or do serious work) with Termites! I hope it helps you in your daily tasks!
