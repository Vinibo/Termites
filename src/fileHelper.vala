/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * fileHelper.vala
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
using Gee;

namespace Termites {

  public class FileHelper : Object {
    private const string HASH_COMMENT = "#";
    private const string DOUBLEDASH_COMMENT = "//";

    private File loaded_file;
    public HashMap<string, string> file_content {get;set;}
    public ArrayList<string> linear_file_content {get;set;}

    public FileHelper (string file_path) {
        loaded_file = File.new_for_uri (file_path);
        file_content = new HashMap<string, string> ();
        linear_file_content = new ArrayList<string> ();

        load_file ();
    }

    private void load_file () {
        DataInputStream dis = new DataInputStream (loaded_file.read ());

        if (is_acceptable_file (dis)) {
            string line;
            while ((line = dis.read_line (null)) != null) {
                if (!is_comment (line)) {
                    string[] splitted_config_line = line.split ("=");

                    if (splitted_config_line.length > 1) {
                        file_content.set (splitted_config_line[0], splitted_config_line[1]);
                    } else {
                        linear_file_content.add (line);
                    }
                }
            }
        }
    }

    public void update_value (string key, string new_value) {
        file_content.unset (key, null);
        file_content.set (key, new_value);
    }

    public string get_value (string key) {
        return file_content.get(key);
    }

    //This should be moved to termiteStore
    public static void save_termites_tree (string file_path, TreeStore termites) {
      File file = File.new_for_uri (file_path);

      if (file.query_exists ()) {
            file.delete ();
      }

      FileOutputStream file_stream = file.create (FileCreateFlags.PRIVATE);
      DataOutputStream stream = new DataOutputStream (file_stream);

      stream.put_string (Application.generate_file_header ());
      termites.foreach (TermiteStore.generate_save_delegate (stream));
      stream.close ();
    }

    // When saving a file, we can assume that the content is already in its modified state/
    public void save () {
        if (linear_file_content.size > 0) {
            save_linear_file ();
        } else {
            save_map_file ();
            stdout.printf ("Map file \n");
        }
    }

    private void save_map_file () {
        FileOutputStream file_stream = loaded_file.replace (null, true, FileCreateFlags.REPLACE_DESTINATION);
        DataOutputStream stream = new DataOutputStream (file_stream);

        stream.put_string (Application.generate_file_header ());
        foreach (var entry in file_content.entries) {
            stdout.printf (entry.value + "\n");
            stream.put_string (entry.key + "=" + entry.value);
            stream.put_string ("\n");
        }
        stream.close ();
    }

    private void save_linear_file () {
        FileOutputStream file_stream = loaded_file.replace (null, true, FileCreateFlags.REPLACE_DESTINATION);
        DataOutputStream stream = new DataOutputStream (file_stream);

        stream.put_string (Application.generate_file_header ());
        foreach (string line in linear_file_content) {
            stream.put_string (line);
            stream.put_string ("\n");
        }
        stream.close ();
    }

    // This function read the first line of the given file to verify if the
    // file has a valid header
    public static bool is_acceptable_file (DataInputStream file_reader) {
        string line_in_file;
        line_in_file = file_reader.read_line (null);

        string[] application_line = line_in_file.split (":");

        bool application_okay = application_line[0] == Application.APPLICATION_NAME;
        bool version_okay = Application.is_compatible_version (application_line[1]);

        stdout.printf ("Application Okay? : %s \nVersion Okay? : %s \n", application_okay.to_string (), version_okay.to_string ());

        return version_okay && application_okay;
    }

    private static bool is_comment (string line) {
        return starts_with (line, DOUBLEDASH_COMMENT) || starts_with (line, HASH_COMMENT);
    }

    public static bool starts_with (string original_string, string pattern) {
        string start_of_string = original_string.substring (0, pattern.length);
        return start_of_string == pattern;
    }
  }
}
