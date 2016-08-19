#!/bin/bash

# Build schema
sudo cp ../data/gsettings/net.vinibo.Termites.gschema.xml /usr/share/glib-2.0/schemas
sudo glib-compile-schemas /usr/share/glib-2.0/schemas

#  Build resources
glib-compile-resources uiRes.xml --target=resources.c --generate-source
valac -g --save-temps --pkg gtk+-3.0 --pkg vte-2.91 --pkg gee-0.8 --pkg gio-2.0 --target-glib=2.38 application.vala nodeType.vala node.vala termiteStore.vala nodeProperties.vala config.vala configWindow.vala termites.vala fileHelper.vala resources.c --gresources uiRes.xml -o Termites
#valac -g

# Cleanup useless files
rm *.c
