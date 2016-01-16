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
			m_configuration = new Config ();

			termite_tree_store = new TermiteStore ();
			termite_tree_store.load_termites_tree_from_file (m_configuration.get_last_tree_file_path ());
			terminalTreeview.set_model(termite_tree_store.get_tree ());

			CellRendererText cell = new CellRendererText ();
			//cell.background_rgba = NodeEnvironment.TEST.get_color ();
			terminalTreeview.insert_column_with_attributes (-1, "Name", cell, "text", 0,null);
		}

		[GtkCallback]
		public void quit_termites (Widget window) {
			if (m_configuration.get_save_on_close ()) {
				save_tree ();
			}
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
				termite_tree_store.load_termites_tree_from_file (uri);

				// Update last opened
				m_configuration.set_last_tree_file_path (uri);
				chooser.close ();
			} else {
				chooser.close ();
			}
		}

		[GtkCallback]
		public void new_tree () {
			m_configuration.set_last_tree_file_path ("");
			termite_tree_store.clear_tree ();
		}

		[GtkCallback]
		public void save_tree () {
			FileHelper.save_termites_tree (m_configuration.get_last_tree_file_path (),
			 								termite_tree_store.get_tree ());
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
				m_configuration.set_last_tree_file_path (uri);
			}
			chooser.close ();
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
			catch (Error e) {
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
			TreeSelection selected_node = terminalTreeview.get_selection ();
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
			}

		    TermitesTerminal test_term = new TermitesTerminal (node);
		    Terminal terminal = new Terminal ();
            test_term.connect (terminal);

            terminal.child_exited.connect ( (t)=> { stdout.printf ("Tab closed by signal \n");
                                                    terminalTabs.remove (terminal);} );


            int tab_number = terminalTabs.append_page (terminal,create_notebook_child_label (node.name, terminal));
			terminalTabs.set_tab_reorderable (terminal, true);
			reorganise_tabs ();
		}

		[GtkCallback]
		public void reorganise_tabs () {
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
			ConfigWindow cw = new ConfigWindow (m_configuration);
			cw.set_transient_for (this);
			cw.show_all ();
		}

		private static TermiteNode get_selection (TreeModel p_model, TreeIter p_iter) {
			Value node_from_tree;
			p_model.get_value (p_iter, 1, out node_from_tree);
			TermiteNode node = (TermiteNode) node_from_tree;
			return node;
		}

		private Widget create_notebook_child_label (string p_text, Widget p_term_tab) {
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
