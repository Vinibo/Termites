/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * environment.vala
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
using Gdk;

namespace Termites {
  public enum NodeEnvironment {
    NONE,
    DEVELOPMENT,
    TEST,
    STAGING,
    PRODUCTION;

    public static NodeEnvironment[] all() {
      return {NONE, DEVELOPMENT, TEST, STAGING, PRODUCTION};
    }

	public string to_string () {
		switch (this) {
            case NONE:
                return "Not specified";
			case DEVELOPMENT:
				return "Development";
			case TEST:
				return "Test";
			case STAGING:
				return "Staging";
			case PRODUCTION:
				return "Production";
			default:
				assert_not_reached();
		}
	}

    // Those colors are ugly and hide some details in labels
    public RGBA get_color () {
        RGBA color = Gdk.RGBA ();
        switch (this) {
            case NONE:
                color.parse ("white");
                break;
            case DEVELOPMENT:
                color.parse ("green");
                break;
            case TEST:
                color.parse ("blue");
                break;
            case STAGING:
                color.parse ("blue");
                break;
            case PRODUCTION:
                color.parse ("red");
                break;
            default:
                assert_not_reached();
                break;
        }
        return color;
    }

    public int get_id () {
        switch (this) {
            case NONE:
                return 1;
			case DEVELOPMENT:
				return 2;
			case TEST:
				return 3;
			case STAGING:
				return 4;
			case PRODUCTION:
				return 5;
			default:
				assert_not_reached();
		}
    }

	public static NodeEnvironment get (int p_proto) {
		switch (p_proto) {
            case 1:
                return NONE;
			case 2:
				return DEVELOPMENT;
			case 3:
				return TEST;
			case 4:
				return STAGING;
			case 5:
				return PRODUCTION;
			default:
				assert_not_reached();
		}
	}
  }
}
