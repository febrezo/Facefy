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
    public class HeaderBar : Gtk.HeaderBar {
        public Facefy.Window window { get; construct; }
        public Gtk.Button search_image_btn;
        public Gtk.Button populate_db_btn;
        public Gtk.Button settings_menu_btn;
        public SettingsMenu menu;

        public HeaderBar (Facefy.Window window) {
            Object (
                window: window
            );
        }
        
        construct {
            this.show_close_button = true;
            this.title = _("Facefy");
            this.subtitle = _("A GUI for playing with face recognition");

            // Set Menu
            // --------
            this.menu = new SettingsMenu (this.window);

            // Gtk Settings
            /*var granite_settings = Granite.Settings.get_default ();
            var gtk_settings = Gtk.Settings.get_default ();

            gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
            granite_settings.notify["prefers-color-scheme"].connect (() => {
                gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
            });*/

            // Add menu buttons
            // ----------------
            // Search image button
            search_image_btn = new Gtk.Button.from_icon_name ("multimedia-photo-manager", Gtk.IconSize.LARGE_TOOLBAR);
            search_image_btn.tooltip_text = _("Search face");
            this.pack_start (search_image_btn);
            
            // Populate DB button
            populate_db_btn = new Gtk.Button.from_icon_name ("document-import", Gtk.IconSize.LARGE_TOOLBAR);
            populate_db_btn.tooltip_text = _("Populate faces database");
            this.pack_start (populate_db_btn);

            // Menu button
            settings_menu_btn = new Gtk.Button.from_icon_name ("open-menu-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            settings_menu_btn.tooltip_text = _("Open menu");
            this.pack_end (settings_menu_btn);

            this.pack_end (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
        }
    }
}
