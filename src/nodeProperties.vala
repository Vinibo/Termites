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
		private Entry txtPassword = new Entry ();

		[GtkChild]
		private ComboBox cbProtocol;

		[GtkChild]
		private ComboBox cbEnvironment;

		private TermiteNode node = null;
		private TermiteStore m_tree_view = null;
		private TreeIter? node_emplacement = null;

		public NodeProperties.edit (ref TermiteStore termites, TreeSelection selected_node) {
			TreeModel model;
			Value node_from_tree;

			init_controls ();
			m_tree_view = termites;

			// Extract and load data from selected node
			selected_node.get_selected (out model, out node_emplacement);

			model.get_value (node_emplacement, 1, out node_from_tree);
			node = (TermiteNode) node_from_tree;

			set_form_from_node (node);
		}

		public NodeProperties.new (ref TermiteStore termites)
		{
			init_controls ();
			m_tree_view = termites;
		}

		public void show_window (Window p_parent_window)
		{
			this.set_transient_for (p_parent_window);
			this.show_all ();
		}

	    [GtkCallback]
	    public void cancel () {
	      this.destroy ();
	    }

		[GtkCallback]
		public void save_node () {
			if (validate_form ())
			{
				TreeIter wasteland;

				//if (node_emplacement == null) {
				//	node = new TermiteNode.empty();
				//}

				node = get_node_from_form ();

				// Save node
				if (node_emplacement == null) {
					m_tree_view.add_node (node, null, out wasteland);
				} else {
					m_tree_view.update_node (node, node_emplacement);
				}

				this.close ();
			}
		}

		private void init_controls () {
			init_environment ();
			init_protocols ();
		}

		private void init_protocols ()
		{
			Gtk.ListStore protoStore = new Gtk.ListStore(1, typeof (string));
			foreach (Protocol ptl in Protocol.all_supported ()) {
				TreeIter iter;
				protoStore.append (out iter);
				protoStore.set (iter, 0, ptl.to_string ());
			}

			cbProtocol.set_model (protoStore);
			CellRendererText cell = new CellRendererText ();
			cbProtocol.pack_start (cell, false);
			cbProtocol.set_attributes (cell, "text", 0);
			cbProtocol.set_active (Protocol.SSH);
		}

		private void init_environment ()
		{
			Gtk.ListStore envStore = new Gtk.ListStore(1, typeof (string));
			foreach (NodeEnvironment env in NodeEnvironment.all ()) {
				TreeIter iter;
				envStore.append (out iter);
				envStore.set (iter, 0, env.to_string ());
			}

			cbEnvironment.set_model (envStore);
			CellRendererText cell = new CellRendererText ();
			cbEnvironment.pack_start (cell, false);
			cbEnvironment.set_attributes (cell, "text", 0);
			cbEnvironment.set_active (NodeEnvironment.NONE);
		}

		[GtkCallback]
		private void changed_environment () {
			NodeEnvironment property = NodeEnvironment.get (cbEnvironment.get_active ()+1);
			if (property == NodeEnvironment.PRODUCTION) {
				// We don't allow Prod passwords to be stored yet!
				txtPassword.set_sensitive (false);
			} else {
				txtPassword.set_sensitive (true);
			}
		}

		[GtkCallback]
		private void changed_protocol () {
			Protocol property = Protocol.get (cbProtocol.get_active ()+1);
			txtPort.set_text (property.default_port ().to_string());
		}

		private void set_form_from_node (TermiteNode node) {
			assert (node != null);
			txtNodeName.set_text (node.name);
			txtHostname.set_text (node.host);
			txtPort.set_text (node.port);
			txtUsername.set_text (node.username);
			txtPassword.set_text (node.password);
			cbProtocol.set_active (node.protocol);
			cbEnvironment.set_active (node.environment);
		}

		private TermiteNode get_node_from_form () {
			TermiteNode node = new TermiteNode.empty ();
			node.name = txtNodeName.get_text ();
			node.host = txtHostname.get_text ();
			node.port = txtPort.get_text ();
			node.username = txtUsername.get_text ();
			node.password = txtPassword.get_text ();
			node.protocol = Protocol.get (cbProtocol.get_active ()+1);
			node.environment = NodeEnvironment.get (cbEnvironment.get_active ()+1);

			return node;
		}

		private bool validate_form ()
		{
			// Validate data (Not empty, valid IP)
			// To check if an ip is valid, we may ping the target and
			// display a validator icon beside ip control to indicate if
			// the host is replying. (Note that some host may not response to ping requests)

			if (txtNodeName.get_text() == null || txtHostname.get_text () == null || txtPort.get_text () == null)
			{
				return false;
			}
			else
			{
				// We must validate entered IP and port
				bool test = is_service_reachable ();
				stdout.printf ("recheable : %s\n", test.to_string ());

				return true;
			}
		}

	    private bool is_service_reachable () {
			bool is_reachable = false;
			NetworkMonitor monitor = NetworkMonitor.get_default ();
			NetworkAddress address = new NetworkAddress (txtHostname.get_text (), (uint16) txtPort.get_text ());

			try {
				is_reachable = monitor.can_reach (address);
			} catch (Error e) {

			}

		  	return is_reachable;
	    }
	}
}
