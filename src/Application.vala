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

namespace GraniteTemplate {
    public class GraniteTemplateApp : Gtk.Application {

        public GraniteTemplateApp () {
            Object (
                application_id: "com.felixbrezo.GraniteTemplate",
                flags: ApplicationFlags.FLAGS_NONE
            );
        }

        protected override void activate () {
            Window win = new Window(this);
            win.show_all();
        }

        public static int main (string[] args) {
            var app = new GraniteTemplateApp ();
            return app.run (args);
        }
    }
}
