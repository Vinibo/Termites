/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * termites.vala
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
using Vte;

namespace Termites {

	const string UI_ABOUT = "ui/aboutTermites.ui";
	const string SSH_BINARY_PATH = "/usr/bin/ssh";

	[GtkTemplate (ui = "/termites/ui/termites.ui")]
	public class Termites : Gtk.ApplicationWindow {

		[GtkChild]
		private TreeView terminalTreeview;

		[GtkChild]
		private Notebook terminalTabs;

		[GtkChild]
		private Label lblSession;

		private TermiteStore termite_tree_store;

		private Config m_configuration;

		static int main (string[] args) {
			Gtk.init (ref args);
			var win = new Termites ();
			win.present ();
			Gtk.main ();
			return 0;
		}

		public Termites () {

			// Instantiate configuration
			m_configuration = new Config ();

			termite_tree_store = new TermiteStore ();
			terminalTreeview.set_model(termite_tree_store.get_tree ());

			CellRendererText cell = new CellRendererText ();
			terminalTreeview.insert_column_with_attributes (-1, "Name", cell, "text", 0,null);
		}

	 	[GtkCallback]
		public void on_destroy (Widget window)
		{
			Gtk.main_quit();
		}

		[GtkCallback]
		public void quit_termites (Widget window)
		{
			Gtk.main_quit();
		}

		[GtkCallback]
		public void open_tree () {
			FileChooserDialog chooser = new FileChooserDialog ("Save nodes",
			 													this,
																FileChooserAction.OPEN,
																"Cancel", ResponseType.CANCEL,
																"Open", ResponseType.ACCEPT,
																null);

			chooser.show ();
			if (chooser.run () == ResponseType.ACCEPT) {
				string uri = chooser.get_uri ();
				FileHelper.load_termites_tree (uri, termite_tree_store);
				chooser.close ();
			} else {
				chooser.close ();
			}
		}

		[GtkCallback]
		public void save_tree () {
			// Use path of load to save nodes

			// TESTING PURPOSES
			FileHelper.save_termites_tree ("termitesTests.ter", termite_tree_store.get_tree ());
		}

		[GtkCallback]
		public void save_tree_as () {
			FileChooserDialog chooser = new FileChooserDialog ("Save nodes",
			 													this,
																FileChooserAction.SAVE,
																"Cancel", ResponseType.CANCEL,
																"Save", ResponseType.ACCEPT,
																null);

			chooser.show ();
			if (chooser.run () == ResponseType.ACCEPT) {
				string uri = chooser.get_uri ();
				FileHelper.save_termites_tree (uri, termite_tree_store.get_tree ());
				chooser.close ();
			} else {
				chooser.close ();
			}
		}

		[GtkCallback]
		public void about_termites () {
			try {
				var builder = new Builder ();
				builder.add_from_file (UI_ABOUT);
				builder.connect_signals (null);

				var window = builder.get_object ("aboutTermites") as AboutDialog;
				window.version = Application.get_version_string ();
				window.set_transient_for (this);
				window.show_all ();
			}
			catch (Error e)
			{
				stderr.printf ("Could not load UI: %s\n", e.message);
			}
		}

		[GtkCallback]
		public void create_node () {

			NodeProperties nodeProp = new NodeProperties.new (ref termite_tree_store);
			nodeProp.show_window (this);
		}

		[GtkCallback]
		public void modify_node () {
			// Get selected node TreeIter
			TreeSelection selected_node = terminalTreeview.get_selection ();

			// Send it to the form to read and modify it
			NodeProperties nodeProp = new NodeProperties.edit (ref termite_tree_store, selected_node);
			nodeProp.show_window (this);
		}

		[GtkCallback]
		public void remove_node () {
			TreeSelection selected_node = terminalTreeview.get_selection ();
			TreeIter node_emplacement;
			TreeModel model;

			selected_node.get_selected (out model, out node_emplacement);

			MessageDialog msg = new MessageDialog (this, DialogFlags.MODAL, MessageType.WARNING, ButtonsType.YES_NO, "Are you sure you want to delete this node?");
			msg.response.connect ((response_id) => {
				switch (response_id) {
					case Gtk.ResponseType.YES:
						termite_tree_store.delete_node (node_emplacement);
						break;
				}

				msg.destroy();
				});
			msg.show ();
		}

		[GtkCallback]
		public void open_connection(TreeView p_view, TreePath p_root, TreeViewColumn p_column) {

			TreeIter iter;
			TermiteNode node = null;
			if (p_view.model.get_iter (out iter,p_root)) {
				node = get_selection (p_view.model, iter);
				if (node.host == null) {
					return;
				}

				stdout.printf (node.serialize () + "\n");
			}

			string?[] env_var = {"PROMPT_COMMAND="+Environment.get_variable ("PROMPT_COMMAND")};
			string?[] interpreter = {SSH_BINARY_PATH,node.get_connection_string ()};

			string dir = GLib.Environment.get_current_dir ();
			Terminal testTerm = new Terminal();
			testTerm.set_visible (true);

			try {
				Pty termPty = new Pty.sync (PtyFlags.DEFAULT);
				testTerm.set_pty (termPty);

				// Close the tab if terminal exit
				// Could add an error if exits too quickly (oftenly means port is closed)
				testTerm.child_exited.connect ( (t)=> { terminalTabs.remove (testTerm);} );

				// Spawn a shell into the terminal
				testTerm.spawn_sync (Vte.PtyFlags.DEFAULT, dir, interpreter,env_var,
									SpawnFlags.DO_NOT_REAP_CHILD, null, null, null );

				// Get Node name as tab label
				int tab_number = terminalTabs.append_page (testTerm,create_notebook_child_label (node.name, testTerm));

				terminalTabs.set_tab_reorderable (testTerm, true);
				reorganise_tabs ();

				// Set focus on new tab
				terminalTabs.set_current_page (tab_number);
				testTerm.has_focus =  true;
			} catch (Error e) {
				stderr.printf ("Error happened: %s\n", e.message);
			}
		}

		[GtkCallback]
		public void reorganise_tabs () {

			// Display the "greeting" tab
			if (terminalTabs.get_n_pages () == 0) {
				terminalTabs.append_page (lblSession);
				terminalTabs.set_show_tabs (false);
			} else if (terminalTabs.page_num (lblSession) > -1) {
					terminalTabs.remove(lblSession);
					terminalTabs.set_show_tabs (true);
			}
		}

		[GtkCallback]
		public void open_settings () {
			m_configuration.set_transient_for (this);
			m_configuration.show_all ();
		}

		private static TermiteNode get_selection (TreeModel p_model, TreeIter p_iter) {
			Value node_from_tree;
			p_model.get_value (p_iter, 1, out node_from_tree);
			TermiteNode node = (TermiteNode) node_from_tree;
			return node;
		}

		private Widget create_notebook_child_label (string p_text, Widget p_term_tab)
		{

		    Label label = new Label(p_text);
		    var image = new Image.from_icon_name(Stock.CLOSE, IconSize.MENU);

		    var button = new Button();
		    button.relief = ReliefStyle.NONE;
		    button.name = "sample-close-tab-button";
		    // don't allow focus on this button
		    button.set_focus_on_click(false);
		    button.add(image);

				// Link action to signal
				button.clicked.connect ( (t)=> {terminalTabs.remove (p_term_tab); });

		    Box box = new Box(Orientation.HORIZONTAL, 2);
		    box.pack_start(label, false, false ,0);
		    box.pack_start(button, false, false ,0);
		    box.show_all();

		    return box;
		}
	}
}
