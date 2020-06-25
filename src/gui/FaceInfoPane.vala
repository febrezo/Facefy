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
    public class FaceInfoPane : Gtk.Grid {
        public Face face { get; construct set; }

        public FaceInfoPane (Face face) {
            Object (
                face: face
            );
        }

        construct {
            this.margin_top = 24;
            this.margin_left = this.margin_right = 24;
            this.margin_bottom = 12;
            this.column_spacing = 12;
            this.column_homogeneous = true;
            this.row_spacing = 12;
            this.halign = Gtk.Align.CENTER;
            this.valign = Gtk.Align.CENTER;

            // Define objects
            var title_label = new Gtk.Label (_("Details"));
            title_label.halign = Gtk.Align.CENTER;
            title_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

            var original_image_label = new Gtk.Label (_("Original path: "));
            original_image_label.halign = Gtk.Align.END;
            var original_image_entry = new Gtk.Entry ();
            original_image_entry.set_text (face.original_image_path);
            original_image_entry.editable = false;

            var face_md5_label = new Gtk.Label (_("MD5: "));
            face_md5_label.halign = Gtk.Align.END;
            var face_md5_entry = new Gtk.Entry ();
            face_md5_entry.set_text (face.face_md5);
            face_md5_entry.editable = false;

            this.attach (title_label, 0, 0, 2);
            this.attach (original_image_label, 0, 1);
            this.attach (original_image_entry, 1, 1);
            this.attach (face_md5_label, 0, 2);
            this.attach (face_md5_entry, 1, 2);

            this.show_all ();
        }
    }
}
