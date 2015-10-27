/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * termitesTerminal.vala
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
     public class TermitesTerminal : Object {

         // Basic path to SSH on most common Linux platforms
         const string SSH_BINARY_PATH = "/usr/bin/ssh";
         TermiteNode nodeConnection;

         public TermitesTerminal (TermiteNode node) {
             // Opens a connection from a node
             nodeConnection = node;
         }

         public Terminal connect () {

            string?[] env_var = {"PROMPT_COMMAND="+Environment.get_variable ("PROMPT_COMMAND")};
			string?[] interpreter = {SSH_BINARY_PATH,nodeConnection.get_connection_string ()};

			string dir = GLib.Environment.get_current_dir ();
			Terminal terminal = new Terminal();
			terminal.set_visible (true);

             try {
                 Pty termPty = new Pty.sync (PtyFlags.DEFAULT);
                 terminal.set_pty (termPty);

                 // Could add an error if exits too quickly (oftenly means port is closed)
                //terminal.child_exited.connect ( (t)=> { stdout.printf ("Tab closed by signal \n");
                //                                         terminalTabs.remove (terminal);} );

                 // Spawn a shell into the terminal
                 terminal.spawn_sync (Vte.PtyFlags.DEFAULT, dir, interpreter,env_var,
                                     SpawnFlags.DO_NOT_REAP_CHILD, null, null, null );

                // Put in place a error/message detection system to reconize SSH messages as they appear
                // Or simply wait for next line?

                 if (nodeConnection.password != null) {
                    Posix.sleep (1);
                    string password_command = nodeConnection.password + "\n";
                    terminal.feed_child (password_command, password_command.char_count ());
                 }
                 terminal.has_focus =  true;
             } catch (Error e) {
                 stderr.printf ("Error happened: %s\n", e.message);
             }

             return terminal;
         }
     }
 }
