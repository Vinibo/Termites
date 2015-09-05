## Process this file with automake to produce Makefile.in

## Created by Anjuta


uidir = $(pkgdatadir)/ui
ui_DATA = termites.ui \
	nodeProperties.ui \
	aboutTermites.ui \
	termites.ui \
	settings.ui


AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir). \
	$(gee-0.8_CFLAGS). \
	$(gee-0.8_CFLAGS). \
	$(GEE_CFLAGS)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(TERMITES_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = termites

termites_SOURCES = \
	termites.vala config.vapi node.vala protocol.vala termiteStore fileHelper.vala nodeProperties.vala termites.vala

termites_VALAFLAGS =  \
	--pkg gtk+-3.0 --pkg gee-0.8 --target-glib=2.38 --gresources=uiRes.xml


termites_LDFLAGS = \
	-Wl,--export-dynamic

termites_LDADD = $(TERMITES_LIBS) \
	$(GEE_LIBS) \
	$(gee-0.8_LIBS)




EXTRA_DIST = $(ui_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)
