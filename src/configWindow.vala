/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * configWindow.vala
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
  public class ConfigWindow : Dialog {

      private Config configuration;

      [GtkChild]
      private Switch automatic_save;

      [GtkChild]
      private Switch save_on_close;

      public ConfigWindow (Config loaded_configuration) {
          configuration = loaded_configuration;
          load_settings_status ();
      }

      [GtkCallback]
      private void save_and_close () {
          apply_modifications ();
          this.close ();
      }

      [GtkCallback]
      private void cancel_modifications () {
          this.close ();
      }

      private void load_settings_status () {
          automatic_save.set_state (configuration.get_automatic_save ());
          save_on_close.set_state (configuration.get_save_on_close ());
      }

      private void apply_modifications () {
          configuration.set_automatic_save (automatic_save.active);
          configuration.set_save_on_close (save_on_close.active);
      }
  }
}
