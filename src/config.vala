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

  public class Config : Object {

      const string DEFAULT_SETTINGS_PATH = "file://%s/.config/Termites/%s";
      const string DEFAULT_SETTINGS_FILE = "default.conf";

      private FileHelper configuration_file;

      public Config () {
          configuration_file = new FileHelper (DEFAULT_SETTINGS_PATH.printf (Environment.get_home_dir (), DEFAULT_SETTINGS_FILE));
      }

      public void save () {
          configuration_file.save (); // Yuk!
      }

      public string get_last_tree_file_path () {
          return configuration_file.get_value ("last_tree_file_path");
      }

      public void set_last_tree_file_path (string new_value) {
          configuration_file.update_value ("last_tree_file_path", new_value);
          configuration_file.save ();
      }

      public bool get_save_on_close () {
          return bool.parse (configuration_file.get_value ("save_on_close"));
      }

      public void set_save_on_close (bool save_on_close) {
          configuration_file.update_value ("save_on_close", save_on_close.to_string ());
      }

      public bool get_automatic_save () {
          return bool.parse (configuration_file.get_value ("automatic_save"));
      }

      public void set_automatic_save (bool automatic_save) {
          configuration_file.update_value ("automatic_save", automatic_save.to_string ());
      }

      public double get_save_interval () {
          return double.parse (configuration_file.get_value ("save_interval"));
      }

      public void set_save_interval (double save_interval) {
          configuration_file.update_value ("save_interval", save_interval.to_string ());
      }
  }
}
