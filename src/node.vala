/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * node.vala
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

	public class TermiteNode : Object {
		public string name {get; set;}
		public string host {get; set;}
		public string port {get; set;}
		public string username {get; set;}
		public Protocol protocol {get; set;}
		public string password {get; set;}
		public NodeEnvironment environment {get; set;}

		public TermiteNode (string p_name, string p_host, string p_port, string p_username, Protocol p_protocol) {
			this.name = p_name;
			this.host = p_host;
			this.port = p_port;
			this.username = p_username;
			this.protocol = p_protocol;
		}

		public TermiteNode.empty () {}

		public TermiteNode.copy (TermiteNode p_original_instance) {
			this.name = p_original_instance.name;
			this.host = p_original_instance.host;
			this.port = p_original_instance.port;
			this.username = p_original_instance.username;
		}

		public TermiteNode.as_logical_node (string name) {
			this.name = name;
		}

		public string get_connection_string () {
			return username + "@" + host;
		}

		public string serialize () {
		    int protocol_index = protocol;
		    int environment_index = environment;
			return name + "," + host + "," + port + "," + username + "," + protocol_index.to_string () + "," + environment_index.to_string();
		}
	}
}
