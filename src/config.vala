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

      const string LAST_TREE_FILE_PATH = "last-tree-file-path";
      const string SAVE_ON_CLOSE = "save-on-close";
      const string AUTOMATIC_SAVE = "automatic-save";

      private GLib.Settings termites_settings;

      public Config () {
          termites_settings = new GLib.Settings (Application.FQ_APPLICATION_NAME);
      }

      public string get_last_tree_file_path () {
          return termites_settings.get_string (LAST_TREE_FILE_PATH);
      }

      public void set_last_tree_file_path (string new_value) {
          termites_settings.set_string (LAST_TREE_FILE_PATH, new_value);
      }

      public bool get_save_on_close () {
          return termites_settings.get_boolean (SAVE_ON_CLOSE);
      }

      public void set_save_on_close (bool save_on_close) {
          termites_settings.set_boolean (SAVE_ON_CLOSE, save_on_close);
      }

      public bool get_automatic_save () {
          return termites_settings.get_boolean (AUTOMATIC_SAVE);
      }

      public void set_automatic_save (bool automatic_save) {
         termites_settings.set_boolean (AUTOMATIC_SAVE, automatic_save);
      }
  }
}
