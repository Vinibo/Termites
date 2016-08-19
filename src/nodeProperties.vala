/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * nodeProperties.vala
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

	[GtkTemplate (ui = "/termites/ui/nodeProperties.ui")]
	public class NodeProperties : Dialog
	{

		[GtkChild]
		private Entry txtNodeName = new Entry ();

		[GtkChild]
		private Entry txtHostname = new Entry ();

		[GtkChild]
		private Entry txtPort = new Entry ();

		[GtkChild]
		private Entry txtUsername = new Entry ();

		[GtkChild]
		private ComboBox cbNodeType;

		private TermiteNode node = null;
		private TermiteStore m_tree_view = null;
		private TreeIter? node_emplacement = null;

		public NodeProperties.new (ref TermiteStore termites)
		{
			initialize_form_with_termite_store (ref termites);
		}

		public NodeProperties.edit (ref TermiteStore termites, TreeSelection selected_node)
		{
			TreeModel model;
			Value node_from_tree;

			initialize_form_with_termite_store (ref termites);

			// Extract and load data from selected node
			selected_node.get_selected (out model, out node_emplacement);

			model.get_value (node_emplacement, 1, out node_from_tree);
			node = (TermiteNode) node_from_tree;

			// Load filled form
			txtNodeName.set_text (node.name);
			txtHostname.set_text (node.host);
			txtPort.set_text (node.port);
			txtUsername.set_text (node.username);
			cbNodeType.set_active (node.nodetype);
		}

		public void initialize_form_with_termite_store (ref TermiteStore termites) {
			init_nodetypes ();
			m_tree_view = termites;
		}

		public void show_window (Window p_parent_window) {
			this.set_transient_for (p_parent_window);
			this.show_all ();
		}

		[GtkCallback]
		public void cancel_callback () {
		  this.destroy ();
		}

		[GtkCallback]
		public void save_node_callback () {
			save_node ();
		}

		[GtkCallback]
		public void nodetype_changed_callback ()
		{
			change_fields_sensitivity_from_nodetype ();
		}

		private void init_nodetypes ()
		{
			Gtk.ListStore protoStore = new Gtk.ListStore(1, typeof (string));
			foreach (NodeType ptl in NodeType.all()) {
				TreeIter iter;
				protoStore.append (out iter);
				protoStore.set (iter, 0, ptl.to_string());
			}

			// Initialize protocol Combobox
			cbNodeType.set_model (protoStore);
			CellRendererText cell = new CellRendererText ();
			cbNodeType.pack_start (cell, false);
			cbNodeType.set_attributes (cell, "text", 0);
			cbNodeType.set_active (NodeType.SSH);
		}

		// This method change sensitivity (active or greyed out) on fields
		// according to the node type selected.
		private void change_fields_sensitivity_from_nodetype ()
		{
			NodeType selected_type = NodeType.get (cbNodeType.get_active ()+1);

			if (selected_type == NodeType.FOLDER) {
				txtPort.set_text ("");
				txtUsername.sensitive = false;
				txtHostname.sensitive = false;
				txtPort.sensitive = false;
			} else {
				txtUsername.sensitive = true;
				txtHostname.sensitive = true;
				txtPort.sensitive = true;
				txtPort.set_text (selected_type.default_port().to_string());
			}
		}

		private bool validate_form ()
		{
			NodeType type = NodeType.get (cbNodeType.get_active ()+1);

			if (type == NodeType.FOLDER) {
				return is_valid_folder ();
			}

			return is_valid_node ();
		}

		// Validates if a folder respect all the criterias
		private bool is_valid_folder ()
		{
			string node_name = txtNodeName.get_text ();
			if (node_name == null || node_name.strip().length < 1) {
				return false;
			} else {
				return true;
			}
		}

		// Validate data (Not empty, valid IP)
		// To check if an ip is valid, we may ping the target and
		// display a validator icon beside ip control to indicate if
		// the host is replying. (Note that some host may not response to ping requests)
		private bool is_valid_node ()
		{
			if (txtNodeName.get_text() == null || txtHostname.get_text () == null || txtPort.get_text () == null)
			{
				return false;
			}

			// We must validate entered IP and port
			bool test = is_service_reachable ();
			stdout.printf ("recheable : %s\n", test.to_string ());

			return true;
		}

		// Incomplete method. Should try to ping the host or something else..
		private bool is_service_reachable ()
		{
			bool is_reachable = false;
			NetworkMonitor monitor = NetworkMonitor.get_default ();
			NetworkAddress address = new NetworkAddress (txtHostname.get_text (), (uint16) txtPort.get_text ());

			try {
				// It seems to return false only if an invalid IP is given
				is_reachable = monitor.can_reach (address);
			} catch (Error e) {

			}

		  	return is_reachable;
		}

		private void save_node ()
		{
			// Two cases here :
			// 1. It's a new Node
			// 2. It's an already saved node

			// Verify if all fields are complete
			if (validate_form ())
			{
				TreeIter wasteland;

				if (node_emplacement == null) {
					node = new TermiteNode.empty();
				}

				node.name = txtNodeName.get_text ();
				node.host = txtHostname.get_text ();
				node.port = txtPort.get_text ();
				node.username = txtUsername.get_text ();
				node.nodetype = NodeType.get (cbNodeType.get_active ()+1); // Enum index start at 0, Cbbox at 0


				// Save node
				if (node_emplacement == null) {
					m_tree_view.add_node (node, null, out wasteland);
				} else {
					m_tree_view.update_node (node, node_emplacement);
				}

				// Close the form
				this.close ();
			}
		}
	}
}
