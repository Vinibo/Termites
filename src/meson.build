project('Termites', ['vala', 'c'])

sources = [
	'application.vala',
	'nodeType.vala',
	'node.vala',
	'termiteStore.vala',
	'nodeProperties.vala',
	'config.vala',
	'configWindow.vala',
	'termites.vala',
	'fileHelper.vala'
	#,'resources.c'
	]

gnome = import('gnome')

vte = dependency('vte-2.91')
gee = dependency('gee-0.8')
gio = dependency('gio-2.0')
glib = dependency('glib-2.0', version: '>=2.38')
gobject = dependency('gobject-2.0')
gtk = dependency('gtk+-3.0')

gnome.compile_resources(
	'as-resources', 'uiRes.xml',
	source_dir : '.',
	c_name : 'resources')

#gnome.compile_schemas()

executable('Termites', sources,
	dependencies : [gtk, vte, gee, gio, glib, gobject],
	vala_args: ['--target-glib=2.38'])
