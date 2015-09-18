/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * termiteStore.vala
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

using Gtk;
using GLib;

namespace Termites {
    public class TermiteStore : Object {

        private TreeStore termiteNodes;
        private FileHelper file;

        public TermiteStore () {
            termiteNodes = new TreeStore (2, typeof(string), typeof(TermiteNode));
        }

        public void add_node (TermiteNode node, TreeIter? position, out TreeIter position_inserted) {
            TreeIter new_position_in_tree;
            termiteNodes.append (out new_position_in_tree, position);
            termiteNodes.set (new_position_in_tree, 0, node.name, 1, node, -1);
            position_inserted = new_position_in_tree;
        }

        public void update_node (TermiteNode node, TreeIter position) {
            termiteNodes.set_value (position, 1, node);
            termiteNodes.set_value (position, 0, node.name);
        }

        public void delete_node (TreeIter position) {
            bool has_child = termiteNodes.iter_has_child (position);
            stdout.printf ("Has children? : %s\n", has_child.to_string ());
            termiteNodes.remove (ref position);

            // Might use swap to avoid removing child nodes

        }

        public TreeStore get_tree () {
            return termiteNodes;
        }

        public TreeIter? convert_string_to_new_iter (string path_to_convert) {
            if (path_to_convert.index_of (":") < 1) {
                return null;
            }

            string latest_position = path_to_convert.slice (0, path_to_convert.length - 2);
            TreeIter iter_in_tree;
            termiteNodes.get_iter_from_string (out iter_in_tree, latest_position);

            return iter_in_tree;
        }

        public static TreeModelForeachFunc generate_save_delegate (DataOutputStream file) {
            return (model, path, iter) => {
                Value node_from_tree;
                model.get_value (iter, 1, out node_from_tree);

                TermiteNode node = (TermiteNode) node_from_tree;
                string iter_string = model.get_string_from_iter (iter);
                stdout.printf ("Position of node %s in tree : %s\n", iter_string, node.serialize ());

                file.put_string (iter_string + "," + node.serialize () + "\n");

                return false;
            };
        }

        public void load_termites_tree_from_file (string file_path) {
            file = new FileHelper (file_path);
            termiteNodes.clear ();

            foreach (string key in file.linear_file_content) {
                string[] node_line = key.split (",");

                // Creation of node from array of string
                TermiteNode node = new TermiteNode.empty ();
                node.name = node_line[1];
                node.host = node_line[2];
                node.port = node_line[3];
                node.username = node_line[4];

                TreeIter wasteland;
                TreeIter? new_position = convert_string_to_new_iter (node_line[0]);
                add_node (node, new_position, out wasteland);
            }
        }
    }
}
