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
    public class ExtractionView : Gtk.Overlay {
        public MainView parent { get; construct; }
        public string target_image_path { get; construct set; }
        
        public Gtk.Label face_label;
        public Gtk.Image target_image;
        public Gtk.Label target_image_label;
        public Granite.Widgets.Avatar face_avatar;

        // Add UI Buttons
        public Gtk.Button prev_face_btn;
        public Gtk.Button next_face_btn;
        public Gtk.Button start_comparison_btn;

        public ExtractionView (MainView parent, string target_image_path) {
            Object (
                parent: parent,
                target_image_path: target_image_path 
            );
        }

        construct {
            var target_title_label = new Gtk.Label (_("Original image"));
            target_title_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
            this.face_label = new Gtk.Label (_("Extracted faces"));
            this.face_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);

            var target_pixbuf = new Gdk.Pixbuf.from_file_at_scale (
                this.target_image_path, 400, 400, true
            );
            this.target_image = new Gtk.Image.from_pixbuf (target_pixbuf);
            this.target_image_label = new Gtk.Label (this.target_image_path);
            this.target_image_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
            this.target_image_label.get_style_context ().add_class (Granite.STYLE_CLASS_ACCENT);
 
            this.face_avatar = new Granite.Widgets.Avatar.with_default_icon (256);

            // Building buttons for face
            // -------------------------

            // Start comparison            
            this.start_comparison_btn = new Gtk.Button.from_icon_name ("search", Gtk.IconSize.LARGE_TOOLBAR);
            this.start_comparison_btn.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            this.start_comparison_btn.clicked.connect (parent.start_comparison_clicked);
            this.start_comparison_btn.sensitive = false;
            this.start_comparison_btn.tooltip_text = _("Search face against the known DB");

            this.prev_face_btn = new Gtk.Button.from_icon_name ("up");
            this.prev_face_btn.sensitive = false;
            this.prev_face_btn.clicked.connect ( get_previous_face_clicked );
            
            this.next_face_btn = new Gtk.Button.from_icon_name ("down");
            this.next_face_btn.sensitive = false;
            this.next_face_btn.clicked.connect ( get_next_face_clicked );
            
            // Packing face buttons
            var grid_face_actions = new Gtk.Grid();            
            grid_face_actions.column_homogeneous = true;
            grid_face_actions.expand = false;
            grid_face_actions.valign = Gtk.Align.CENTER;
            grid_face_actions.attach (new Gtk.Label(""), 0, 0);
            grid_face_actions.attach (this.next_face_btn, 1, 0, 1);
            grid_face_actions.attach (this.prev_face_btn, 2, 0, 1);
            grid_face_actions.attach (new Gtk.Label(""), 3, 0);
            grid_face_actions.attach (this.start_comparison_btn, 4, 0, 1);
            grid_face_actions.attach (new Gtk.Label(""), 5, 0);

            // Packings all elements 
            // ---------------------
            var stack_grid = new Gtk.Grid ();
            stack_grid.margin_top = 24;
            stack_grid.margin_left = stack_grid.margin_right = 24;
            stack_grid.margin_bottom = 12;
            stack_grid.column_spacing = 12;
            stack_grid.column_homogeneous = true;
            stack_grid.row_spacing = 12;
            stack_grid.halign = stack_grid.valign = Gtk.Align.CENTER;
            stack_grid.attach (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), 0, 0, 2);
            stack_grid.attach (target_title_label, 0, 1);
            stack_grid.attach (this.face_label, 1, 1);
            stack_grid.attach (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), 0, 2, 2);
            stack_grid.attach (this.target_image, 0, 4);
            stack_grid.attach (this.face_avatar, 1, 4);
            stack_grid.attach (this.target_image_label, 0, 7);
            stack_grid.attach (grid_face_actions, 1, 7);

            this.add (stack_grid);
            this.show_all ();
        }
        
        private void get_previous_face_clicked () {
            parent.source_image.current_face_index -= 1; 
            if (parent.source_image.current_face_index == 0) {
                this.prev_face_btn.sensitive = false;
            }
            this.next_face_btn.sensitive = true;
            
            this.face_avatar.pixbuf = new Gdk.Pixbuf.from_file_at_scale (
                parent.source_image.faces.get (parent.source_image.current_face_index), 256, 256, true
            ); 
        }
        
        private void get_next_face_clicked () {
            parent.source_image.current_face_index += 1; 
            if (parent.source_image.current_face_index >= (parent.source_image.faces.size-1))  {
                this.next_face_btn.sensitive = false;
            }
            this.prev_face_btn.sensitive = true;
            
            this.face_avatar.pixbuf = new Gdk.Pixbuf.from_file_at_scale (
                parent.source_image.faces.get (parent.source_image.current_face_index), 256, 256, true
            ); 
        }
    }
}
