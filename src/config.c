/* config.c generated by valac 0.28.1, the Vala compiler
 * generated from config.vala, do not modify */

/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * config.vala
 The MIT License (MIT)

 Copyright (c) 2015 Vinibo

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#include <glib.h>
#include <glib-object.h>
#include <gtk/gtk.h>
#include <stdlib.h>
#include <string.h>
#include <gio/gio.h>
#include <stdio.h>


#define TERMITES_TYPE_CONFIG (termites_config_get_type ())
#define TERMITES_CONFIG(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TERMITES_TYPE_CONFIG, TermitesConfig))
#define TERMITES_CONFIG_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TERMITES_TYPE_CONFIG, TermitesConfigClass))
#define TERMITES_IS_CONFIG(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TERMITES_TYPE_CONFIG))
#define TERMITES_IS_CONFIG_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TERMITES_TYPE_CONFIG))
#define TERMITES_CONFIG_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TERMITES_TYPE_CONFIG, TermitesConfigClass))

typedef struct _TermitesConfig TermitesConfig;
typedef struct _TermitesConfigClass TermitesConfigClass;
typedef struct _TermitesConfigPrivate TermitesConfigPrivate;
#define _g_free0(var) (var = (g_free (var), NULL))
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))

struct _TermitesConfig {
	GtkDialog parent_instance;
	TermitesConfigPrivate * priv;
};

struct _TermitesConfigClass {
	GtkDialogClass parent_class;
};

struct _TermitesConfigPrivate {
	gchar* _last_tree_file_path;
	GtkSwitch* automatic_save;
	GtkFrame* automatic_saving_frame;
	GtkRadioButton* save_on_modification;
	GtkRadioButton* save_on_timer;
	GtkSpinButton* save_interval;
};


static gpointer termites_config_parent_class = NULL;

GType termites_config_get_type (void) G_GNUC_CONST;
#define TERMITES_CONFIG_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), TERMITES_TYPE_CONFIG, TermitesConfigPrivate))
enum  {
	TERMITES_CONFIG_DUMMY_PROPERTY
};
#define TERMITES_CONFIG_DEFAULT_SETTINGS_PATH "~/.config/Termites/"
TermitesConfig* termites_config_new (void);
TermitesConfig* termites_config_construct (GType object_type);
void termites_config_load_settings (TermitesConfig* self);
gboolean termites_file_helper_is_acceptable_file (GDataInputStream* file_reader);
void termites_config_save_settings (TermitesConfig* self);
static const gchar* termites_config_get_last_tree_file_path (TermitesConfig* self);
static void termites_config_set_last_tree_file_path (TermitesConfig* self, const gchar* value);
static void termites_config_finalize (GObject* obj);
static void _vala_termites_config_get_property (GObject * object, guint property_id, GValue * value, GParamSpec * pspec);
static void _vala_termites_config_set_property (GObject * object, guint property_id, const GValue * value, GParamSpec * pspec);


TermitesConfig* termites_config_construct (GType object_type) {
	TermitesConfig * self = NULL;
#line 54 "/home/vincent/Source/Vala/Termites/src/config.vala"
	self = (TermitesConfig*) g_object_new (object_type, NULL);
#line 55 "/home/vincent/Source/Vala/Termites/src/config.vala"
	termites_config_load_settings (self);
#line 54 "/home/vincent/Source/Vala/Termites/src/config.vala"
	return self;
#line 100 "config.c"
}


TermitesConfig* termites_config_new (void) {
#line 54 "/home/vincent/Source/Vala/Termites/src/config.vala"
	return termites_config_construct (TERMITES_TYPE_CONFIG);
#line 107 "config.c"
}


void termites_config_load_settings (TermitesConfig* self) {
	GFile* file = NULL;
	GFile* _tmp0_ = NULL;
	GFile* _tmp1_ = NULL;
	gboolean _tmp2_ = FALSE;
	GError * _inner_error_ = NULL;
#line 60 "/home/vincent/Source/Vala/Termites/src/config.vala"
	g_return_if_fail (self != NULL);
#line 63 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_tmp0_ = g_file_new_for_path (TERMITES_CONFIG_DEFAULT_SETTINGS_PATH "default.conf");
#line 63 "/home/vincent/Source/Vala/Termites/src/config.vala"
	file = _tmp0_;
#line 65 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_tmp1_ = file;
#line 65 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_tmp2_ = g_file_query_exists (_tmp1_, NULL);
#line 65 "/home/vincent/Source/Vala/Termites/src/config.vala"
	if (_tmp2_) {
#line 129 "config.c"
		GFileInputStream* _tmp3_ = NULL;
		GFile* _tmp4_ = NULL;
		GFileInputStream* _tmp5_ = NULL;
		GDataInputStream* dis = NULL;
		GDataInputStream* _tmp6_ = NULL;
		GDataInputStream* _tmp7_ = NULL;
		gboolean _tmp8_ = FALSE;
#line 66 "/home/vincent/Source/Vala/Termites/src/config.vala"
		_tmp4_ = file;
#line 66 "/home/vincent/Source/Vala/Termites/src/config.vala"
		_tmp5_ = g_file_read (_tmp4_, NULL, &_inner_error_);
#line 66 "/home/vincent/Source/Vala/Termites/src/config.vala"
		_tmp3_ = _tmp5_;
#line 66 "/home/vincent/Source/Vala/Termites/src/config.vala"
		if (G_UNLIKELY (_inner_error_ != NULL)) {
#line 66 "/home/vincent/Source/Vala/Termites/src/config.vala"
			_g_object_unref0 (file);
#line 66 "/home/vincent/Source/Vala/Termites/src/config.vala"
			g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
#line 66 "/home/vincent/Source/Vala/Termites/src/config.vala"
			g_clear_error (&_inner_error_);
#line 66 "/home/vincent/Source/Vala/Termites/src/config.vala"
			return;
#line 153 "config.c"
		}
#line 66 "/home/vincent/Source/Vala/Termites/src/config.vala"
		_tmp6_ = g_data_input_stream_new ((GInputStream*) _tmp3_);
#line 66 "/home/vincent/Source/Vala/Termites/src/config.vala"
		dis = _tmp6_;
#line 68 "/home/vincent/Source/Vala/Termites/src/config.vala"
		_tmp7_ = dis;
#line 68 "/home/vincent/Source/Vala/Termites/src/config.vala"
		_tmp8_ = termites_file_helper_is_acceptable_file (_tmp7_);
#line 68 "/home/vincent/Source/Vala/Termites/src/config.vala"
		if (_tmp8_) {
#line 165 "config.c"
			FILE* _tmp9_ = NULL;
#line 69 "/home/vincent/Source/Vala/Termites/src/config.vala"
			_tmp9_ = stdout;
#line 69 "/home/vincent/Source/Vala/Termites/src/config.vala"
			fprintf (_tmp9_, "File is loaded\n");
#line 171 "config.c"
		}
#line 65 "/home/vincent/Source/Vala/Termites/src/config.vala"
		_g_object_unref0 (dis);
#line 65 "/home/vincent/Source/Vala/Termites/src/config.vala"
		_g_object_unref0 (_tmp3_);
#line 177 "config.c"
	} else {
	}
#line 60 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_g_object_unref0 (file);
#line 182 "config.c"
}


void termites_config_save_settings (TermitesConfig* self) {
#line 77 "/home/vincent/Source/Vala/Termites/src/config.vala"
	g_return_if_fail (self != NULL);
#line 189 "config.c"
}


static const gchar* termites_config_get_last_tree_file_path (TermitesConfig* self) {
	const gchar* result;
	const gchar* _tmp0_ = NULL;
#line 37 "/home/vincent/Source/Vala/Termites/src/config.vala"
	g_return_val_if_fail (self != NULL, NULL);
#line 37 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_tmp0_ = self->priv->_last_tree_file_path;
#line 37 "/home/vincent/Source/Vala/Termites/src/config.vala"
	result = _tmp0_;
#line 37 "/home/vincent/Source/Vala/Termites/src/config.vala"
	return result;
#line 204 "config.c"
}


static void termites_config_set_last_tree_file_path (TermitesConfig* self, const gchar* value) {
	const gchar* _tmp0_ = NULL;
	gchar* _tmp1_ = NULL;
#line 37 "/home/vincent/Source/Vala/Termites/src/config.vala"
	g_return_if_fail (self != NULL);
#line 37 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_tmp0_ = value;
#line 37 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_tmp1_ = g_strdup (_tmp0_);
#line 37 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_g_free0 (self->priv->_last_tree_file_path);
#line 37 "/home/vincent/Source/Vala/Termites/src/config.vala"
	self->priv->_last_tree_file_path = _tmp1_;
#line 221 "config.c"
}


static void termites_config_class_init (TermitesConfigClass * klass) {
	gint TermitesConfig_private_offset;
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	termites_config_parent_class = g_type_class_peek_parent (klass);
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	g_type_class_add_private (klass, sizeof (TermitesConfigPrivate));
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	G_OBJECT_CLASS (klass)->get_property = _vala_termites_config_get_property;
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	G_OBJECT_CLASS (klass)->set_property = _vala_termites_config_set_property;
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	G_OBJECT_CLASS (klass)->finalize = termites_config_finalize;
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	TermitesConfig_private_offset = g_type_class_get_instance_private_offset (klass);
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	gtk_widget_class_set_template_from_resource (GTK_WIDGET_CLASS (klass), "/termites/ui/config.ui");
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	gtk_widget_class_bind_template_child_full (GTK_WIDGET_CLASS (klass), "automatic_save", FALSE, TermitesConfig_private_offset + G_STRUCT_OFFSET (TermitesConfigPrivate, automatic_save));
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	gtk_widget_class_bind_template_child_full (GTK_WIDGET_CLASS (klass), "automatic_saving_frame", FALSE, TermitesConfig_private_offset + G_STRUCT_OFFSET (TermitesConfigPrivate, automatic_saving_frame));
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	gtk_widget_class_bind_template_child_full (GTK_WIDGET_CLASS (klass), "save_on_modification", FALSE, TermitesConfig_private_offset + G_STRUCT_OFFSET (TermitesConfigPrivate, save_on_modification));
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	gtk_widget_class_bind_template_child_full (GTK_WIDGET_CLASS (klass), "save_on_timer", FALSE, TermitesConfig_private_offset + G_STRUCT_OFFSET (TermitesConfigPrivate, save_on_timer));
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	gtk_widget_class_bind_template_child_full (GTK_WIDGET_CLASS (klass), "save_interval", FALSE, TermitesConfig_private_offset + G_STRUCT_OFFSET (TermitesConfigPrivate, save_interval));
#line 251 "config.c"
}


static void termites_config_instance_init (TermitesConfig * self) {
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	self->priv = TERMITES_CONFIG_GET_PRIVATE (self);
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	gtk_widget_init_template (GTK_WIDGET (self));
#line 260 "config.c"
}


static void termites_config_finalize (GObject* obj) {
	TermitesConfig * self;
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, TERMITES_TYPE_CONFIG, TermitesConfig);
#line 37 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_g_free0 (self->priv->_last_tree_file_path);
#line 40 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_g_object_unref0 (self->priv->automatic_save);
#line 43 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_g_object_unref0 (self->priv->automatic_saving_frame);
#line 46 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_g_object_unref0 (self->priv->save_on_modification);
#line 49 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_g_object_unref0 (self->priv->save_on_timer);
#line 52 "/home/vincent/Source/Vala/Termites/src/config.vala"
	_g_object_unref0 (self->priv->save_interval);
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	G_OBJECT_CLASS (termites_config_parent_class)->finalize (obj);
#line 282 "config.c"
}


GType termites_config_get_type (void) {
	static volatile gsize termites_config_type_id__volatile = 0;
	if (g_once_init_enter (&termites_config_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (TermitesConfigClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) termites_config_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (TermitesConfig), 0, (GInstanceInitFunc) termites_config_instance_init, NULL };
		GType termites_config_type_id;
		termites_config_type_id = g_type_register_static (gtk_dialog_get_type (), "TermitesConfig", &g_define_type_info, 0);
		g_once_init_leave (&termites_config_type_id__volatile, termites_config_type_id);
	}
	return termites_config_type_id__volatile;
}


static void _vala_termites_config_get_property (GObject * object, guint property_id, GValue * value, GParamSpec * pspec) {
	TermitesConfig * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (object, TERMITES_TYPE_CONFIG, TermitesConfig);
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	switch (property_id) {
#line 303 "config.c"
		default:
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
		G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
		break;
#line 309 "config.c"
	}
}


static void _vala_termites_config_set_property (GObject * object, guint property_id, const GValue * value, GParamSpec * pspec) {
	TermitesConfig * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (object, TERMITES_TYPE_CONFIG, TermitesConfig);
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
	switch (property_id) {
#line 319 "config.c"
		default:
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
		G_OBJECT_WARN_INVALID_PROPERTY_ID (object, property_id, pspec);
#line 33 "/home/vincent/Source/Vala/Termites/src/config.vala"
		break;
#line 325 "config.c"
	}
}



