#!/bin/bash

#  Build resources
glib-compile-resources uiRes.xml --target=resources.c --generate-source
valac -g --save-temps --pkg posix --pkg gtk+-3.0 --pkg vte-2.91 --pkg gee-0.8 --pkg gio-2.0 --target-glib=2.38 application.vala termitesTerminal.vala protocol.vala nodeEnvironment.vala node.vala termiteStore.vala nodeProperties.vala config.vala configWindow.vala termites.vala fileHelper.vala resources.c --gresources uiRes.xml -o Termites
#valac -g

# Cleanup C files
rm *.c
