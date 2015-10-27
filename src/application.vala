/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * application.vala
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

  public class Application : Object {

    public const string APPLICATION_NAME = "termites";
    private const int APPLICATION_MAJOR = 0;
    private const int APPLICATION_MINOR = 1;
    private const int APPLICATION_BUILD = 0;

    public Application () {

    }

    public static string get_version_string () {
        return APPLICATION_MAJOR.to_string () + "." +
               APPLICATION_MINOR.to_string () + "." +
               APPLICATION_BUILD.to_string ();
    }

    public static string generate_file_header () {
      return APPLICATION_NAME + ":" + get_version_string () + "\n";
    }

    public static bool is_compatible_version (string version) {
        string[] decomposed_version = version.split(".");

        int major = int.parse (decomposed_version[0]);
        int minor = int.parse (decomposed_version[1]);
        int build = int.parse (decomposed_version[2]);
        
        return !is_uncompatible_version (major, minor, build);
    }

    private static bool is_uncompatible_version (int major, int minor, int build) {
        if (major == 0 && minor < 1) {
            return true;
        } else {
            return false;
        }
    }
  }
}
