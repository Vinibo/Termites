/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * protocol.vala
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
  public enum Protocol {
    NONE,
    SSH,
    TELNET,
    SERIAL,
    VNC,
    RDP;

    public static Protocol[] all() {
      return {NONE, SSH, TELNET, SERIAL, VNC, RDP };
    }

	public string to_string () {
		switch (this) {
            case NONE:
                return "Other";
			case SSH:
				return "SSH";
			case TELNET:
				return "Telnet";
			case SERIAL:
				return "Serial";
			case VNC:
				return "VNC";
			case RDP:
				return "RDP";
			default:
				assert_not_reached();
		}
	}

	public static Protocol get( int p_proto) {
		switch (p_proto) {
            case 1:
                return NONE;
			case 2:
				return SSH;
			case 3:
				return TELNET;
			case 4:
				return SERIAL;
			case 5:
				return VNC;
			case 6:
				return RDP;
			default:
				assert_not_reached();
		}
	}
  }
}
