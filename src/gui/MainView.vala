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

namespace AppWidgets {
    public class MainView : Gtk.Frame {
        construct {
            var label = new Gtk.Label (_("Some sample text"));
            this.update_view (label);
        }

        public void update_view (Gtk.Widget content) {
            var stack_grid = new Gtk.Grid ();
            stack_grid.margin_top = 12;
            stack_grid.margin_bottom = 12;
            stack_grid.column_spacing = 12;
            stack_grid.row_spacing = 12;
            stack_grid.halign = Gtk.Align.CENTER;
            stack_grid.attach (content, 0, 0);

            this.add (stack_grid);
            this.show_all ();
        }
    }
}
