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

using GLib;
using Gtk;

namespace Termites {

  [GtkTemplate (ui = "/termites/ui/config.ui")]
  public class Config : Dialog {

      const string DEFAULT_SETTINGS_PATH = "file://%s/.config/Termites/%s";
      const string DEFAULT_SETTINGS_FILE = "default.conf";

      private string last_tree_file_path;
      private FileHelper configuration_file;

      [GtkChild]
      private Switch automatic_save;

      [GtkChild]
      private Frame automatic_saving_frame;

      [GtkChild]
      private Switch save_on_close;

      [GtkChild]
      private RadioButton save_on_modification;

      [GtkChild]
      private RadioButton save_on_timer;

      [GtkChild]
      private SpinButton save_interval;

      public Config () {
          configuration_file = new FileHelper (DEFAULT_SETTINGS_PATH.printf (Environment.get_home_dir (), DEFAULT_SETTINGS_FILE));
          load_settings_status ();
      }

      public string get_last_tree_file_path () {
          return last_tree_file_path;
      }

      public bool is_save_on_close () {
          return save_on_close.active;
      }

      public void set_last_tree_file_path (string new_value) {
          last_tree_file_path = new_value;
          configuration_file.update_value ("last_tree_file_path", last_tree_file_path);
          configuration_file.save ();
      }

      private void load_settings_status () {
          automatic_save.set_state (bool.parse (configuration_file.get_value ("automatic_save")));
          last_tree_file_path = configuration_file.get_value ("last_tree_file_path");
          save_interval.set_value (int.parse (configuration_file.get_value ("save_interval")));
          save_on_close.set_state (bool.parse (configuration_file.get_value ("save_on_close")));
      }

      [GtkCallback]
      private void save_and_close () {
          apply_modifications ();
          configuration_file.save ();
          this.close ();
      }

      [GtkCallback]
      private void cancel_modifications () {
          this.close ();
      }

      private void apply_modifications () {
          configuration_file.update_value ("automatic_save", automatic_save.active.to_string ());
          configuration_file.update_value ("save_interval", save_interval.get_value().to_string ());
          configuration_file.update_value ("save_on_close", save_on_close.active.to_string ());
          configuration_file.update_value ("last_tree_file_path", last_tree_file_path);
      }
  }
}
