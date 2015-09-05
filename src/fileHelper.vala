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

namespace Termites {

  public class FileHelper : Object {

    // This object should only contains utility functions
    // like checking if file is loadable for the version
    // This method could take a hash and save it
    public static void save_termites_tree (string file_path, TreeStore termites) {
      File file = File.new_for_uri (file_path);

      if (file.query_exists ()) {
            file.delete ();
      }

      FileOutputStream file_stream = file.create (FileCreateFlags.REPLACE_DESTINATION);
      DataOutputStream stream = new DataOutputStream (file_stream);

      stream.put_string (Application.generate_file_header ());
      termites.foreach (TermiteStore.generate_save_delegate (stream));
      stream.close ();
    }

    // This method could produce a hash from file
    public static void load_termites_tree (string file_path, TermiteStore termites) {
      File file = File.new_for_uri (file_path);

      if (!file.query_exists ()) {
          //throw new
      }

      DataInputStream dis = new DataInputStream (file.read ());

      if (is_acceptable_file (dis)) {
        termites.clear_tree ();

        string line;
        while ((line = dis.read_line (null)) != null) {
            string[] node_line = line.split (",");

            // Creation of node from array of string
            TermiteNode node = new TermiteNode.empty ();
            node.name = node_line[1];
            node.host = node_line[2];
            node.port = node_line[3];
            node.username = node_line[4];

            TreeIter wasteland;
            TreeIter? new_position = termites.convert_string_to_new_iter (node_line[0]);
            termites.add_node (node, new_position, out wasteland);
        }
      } else {
          stderr.printf ("File not acceptable for this version");
          // Throw exception because file is not in a proper format
      }
    }

    public void load_mremoteng_connections (string p_Filepath) {
        // Not yet implemented - Not sure if it will....
    }

    public void load_putty_profile () {
        // What? No!
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
  }
}
