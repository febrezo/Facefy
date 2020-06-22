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

namespace AppWidgets {
    public class SampleDialog : Granite.MessageDialog {
        private Gtk.Label body_label;

        public SampleDialog (Gtk.Window parent) {
            Object (
                primary_text: _("Sample dialog"),
                secondary_text: _("Just showing some text"),
                buttons: Gtk.ButtonsType.CANCEL,
                transient_for: parent
            );
        }

        construct {
            this.image_icon = GLib.Icon.new_for_string ("application-vnd.openxmlformats-officedocument.presentationml.presentation");

            // Define objects
            var suggested_button = new Gtk.Button.with_label (_("Copy to clipboard"));
            suggested_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            suggested_button.set_sensitive (false);
            this.add_action_widget (suggested_button, Gtk.ResponseType.ACCEPT);

            var title_label = new Gtk.Label (_("A sample Loremp ipsum text"));
            title_label.halign = Gtk.Align.START;
            title_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

            body_label = new Gtk.Label (_("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas in ligula sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis quis metus magna. Curabitur id metus volutpat risus sodales pretium. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Morbi rutrum dictum egestas. Mauris semper suscipit massa vitae facilisis. "));

            // Pack grid elements together together
            var ask_for_asset_widget = new Gtk.Grid ();
            ask_for_asset_widget.column_spacing = ask_for_asset_widget.row_spacing = 12;
            ask_for_asset_widget.halign = ask_for_asset_widget.valign = Gtk.Align.CENTER;
            ask_for_asset_widget.attach (title_label, 0, 0);
            ask_for_asset_widget.attach (body_label, 0, 1);

            //message_dialog.show_error_details ("The details of a possible error.");
            this.custom_bin.add (ask_for_asset_widget);
            this.show_all ();
        }

        public string? launch_dialog () {
            if (this.run () == Gtk.ResponseType.ACCEPT) {
                var clipboard = Gtk.Clipboard.get_for_display (
                    Gdk.Display.get_default (),
                    Gdk.SELECTION_CLIPBOARD
                );
                clipboard.set_text (this.body_label.get_text (), this.body_label.get_text ().length);
                return this.body_label.get_text ();
            }
            return null;
        }
    }
}
