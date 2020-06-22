/*
* Copyright (c) 2020 Félix Brezo (https://felixbrezo.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Félix Breo <felixbrezo@disroot.orgm>
*/

using AppUtils;
using AppWidgets;

namespace AppWidgets {
    public class AboutDialog : Gtk.AboutDialog {
        public AboutDialog (Gtk.Window parent) {
            Object (
                transient_for: parent
            );
        }

        construct {
            this.set_destroy_with_parent (true);
          	this.set_modal (true);
            this.logo_icon_name = "computer-laptop";

          	this.artists = null;
          	this.authors = {"Félix Brezo (felixbrezo@disroot.org)"};
          	this.documenters = {"Félix Brezo (felixbrezo@disroot.org)"};
          	this.translator_credits = _("Félix Brezo (felixbrezo@disroot.org)");

          	this.program_name = _("GraniteTemplate");
          	this.comments = _("Just another template");
          	this.copyright = _("Copyright © 2020 Félix Brezo");
          	this.version = _("1.0");

          	this.license = "GPLv3.0+ (https://www.gnu.org/licenses/gpl-3.0.txt)";
          	this.wrap_license = true;

          	this.website = _("https://github.com/febrezo/GraniteTemplate");
          	this.website_label = _("Website");

            this.response.connect ((response_id) => {
          		if (response_id == Gtk.ResponseType.CANCEL || response_id == Gtk.ResponseType.DELETE_EVENT) {
          			   this.hide_on_delete ();
          		}
          	});
        }
    }
}
