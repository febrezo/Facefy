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
    public class ComparisonView : Gtk.Overlay {
        public MainView parent { get; construct; }
        
        // UI Elements
        public Gtk.Label result_label;
        public Gtk.Label face_label;
        public Gtk.Label comparisons_label;
        public Gtk.Image target_image;
        public Gtk.Label target_image_label;
        public Granite.Widgets.Avatar face_avatar;
        public Granite.Widgets.Avatar comparison_avatar;
        public Gtk.Button prev_face_btn;
        public Gtk.Button next_face_btn;
        public Gtk.Button view_original_btn;
        private Gtk.Grid stack_grid;
        public Granite.Widgets.OverlayBar overlay_bar;
        
        public FaceInfoPane target_face_pane { get; set; }
        public FaceInfoPane comparison_face_pane { get; set; }
        
        private int current_face_index { get; set; }
        private Gee.ArrayList<Comparison> faces { get; set; }

        public ComparisonView (MainView parent) {
            Object (
                parent: parent
            );
        }

        construct {
            // Show calculation overlay_bar
            this.overlay_bar = new Granite.Widgets.OverlayBar (this);
            this.overlay_bar.label = _("Performing calculations…");
            this.overlay_bar.active = true;
            
            this.result_label = new Gtk.Label (_("Similarity: N/A"));
            this.result_label.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);
            this.face_label = new Gtk.Label (_("Target face"));
            this.face_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
            this.comparisons_label = new Gtk.Label (_("Candidates"));
            this.comparisons_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);

            this.face_avatar = new Granite.Widgets.Avatar.with_default_icon (400);
            this.comparison_avatar = new Granite.Widgets.Avatar.with_default_icon (400);

            // Building buttons for face
            // -------------------------
            this.prev_face_btn = new Gtk.Button.from_icon_name ("up");
            this.prev_face_btn.sensitive = false;
            this.prev_face_btn.clicked.connect ( get_previous_face_clicked );
            
            this.next_face_btn = new Gtk.Button.from_icon_name ("down");
            this.next_face_btn.sensitive = false;
            this.next_face_btn.clicked.connect (get_next_face_clicked);
            
            this.view_original_btn = new Gtk.Button.from_icon_name ("multimedia-photo-viewer");
            this.view_original_btn.sensitive = false;
            this.view_original_btn.clicked.connect  ( () => {
                var face = parent.window.pyfaces_client.get_info_from_face (this.faces.get (current_face_index).face_path);
                Posix.system ("xdg-open %s".printf (face.original_image_path));
            });
            
            // Packing face buttons
            var grid_face_actions = new Gtk.Grid();            
            grid_face_actions.column_homogeneous = true;
            grid_face_actions.expand = false;
            grid_face_actions.valign = Gtk.Align.CENTER;
            grid_face_actions.attach (new Gtk.Label(""), 0, 0);
            grid_face_actions.attach (this.next_face_btn, 1, 0, 1);
            grid_face_actions.attach (this.prev_face_btn, 2, 0, 1);
            grid_face_actions.attach (new Gtk.Label(""), 3, 0);
            grid_face_actions.attach (this.view_original_btn, 4, 0);
            grid_face_actions.attach (new Gtk.Label(""), 5, 0);

            // Packings all elements 
            // ---------------------
            this.stack_grid = new Gtk.Grid ();
            this.stack_grid.margin_top = 24;
            this.stack_grid.margin_left = this.stack_grid.margin_right = 24;
            this.stack_grid.margin_bottom = 12;
            this.stack_grid.column_spacing = 12;
            this.stack_grid.column_homogeneous = true;
            this.stack_grid.row_spacing = 12;
            this.stack_grid.halign = Gtk.Align.CENTER;
            this.stack_grid.valign = Gtk.Align.CENTER;
            this.stack_grid.attach (this.result_label, 0, 2, 2);
            this.stack_grid.attach (this.face_label, 0, 3);
            this.stack_grid.attach (comparisons_label, 1, 3);
            this.stack_grid.attach (this.face_avatar, 0, 4);
            this.stack_grid.attach (this.comparison_avatar, 1, 4);
            this.stack_grid.attach (grid_face_actions, 1, 5);

            this.add (this.stack_grid);
            this.show_all ();
        }
        
        private void get_previous_face_clicked () {
            // Set buttons
            this.current_face_index -= 1;
            if (this.current_face_index <= 0)  {
                this.prev_face_btn.sensitive = false;
            }
            this.next_face_btn.sensitive = true;

            this.update_comparison_face ();
        }
        
        private void get_next_face_clicked () { 
            // Set buttons
            this.current_face_index += 1;
            if (this.current_face_index >= (this.faces.size-1))  {  // -1 extra because of the same image
                this.next_face_btn.sensitive = false;
            }
            this.prev_face_btn.sensitive = true;

            this.update_comparison_face ();
        }
        
        public void set_target_face (string target_face_path) {
            this.overlay_bar.active = true;
            this.overlay_bar.visible = true;
            
            // Set original faces
            this.face_avatar.pixbuf = new Gdk.Pixbuf.from_file_at_scale (
                target_face_path, 400, 400, true
            );
            var face = parent.window.pyfaces_client.get_info_from_face (
                target_face_path
            );

            this.target_face_pane = new FaceInfoPane (face);
            this.stack_grid.attach (target_face_pane, 0, 6);
        }
        
        public void populate_faces (Gee.ArrayList<Comparison> faces ) {
            this.overlay_bar.active = false;
            this.overlay_bar.visible = false;
            this.faces = faces;
            this.current_face_index = 0;
            
            if (this.faces.size > 0) { 
                this.update_comparison_face ();
                this.view_original_btn.sensitive = true;
                this.next_face_btn.sensitive = true;
            }
        }
        
        private void update_comparison_face () {
            // Update comparison face
            this.comparison_avatar.pixbuf = new Gdk.Pixbuf.from_file_at_scale (
                this.faces.get (current_face_index).face_path, 400, 400, true
            );
;
            var comparison_face = parent.window.pyfaces_client.get_info_from_face (
                this.faces.get (current_face_index).face_path
            );

            var similarity = this.faces.get (current_face_index).similarity;
            this.result_label.set_text (_("Similarity: %f").printf (similarity));

            if (similarity <= 0.6) {
                this.result_label.get_style_context ().add_class (Granite.STYLE_CLASS_ACCENT);
            } else {
                this.result_label.get_style_context ().remove_class (Granite.STYLE_CLASS_ACCENT);
            }
            this.comparison_face_pane = new FaceInfoPane (comparison_face);
            this.stack_grid.attach (comparison_face_pane, 1, 6);
            this.comparisons_label.set_text (
                _("Candidato: %i/%i").printf(
                    current_face_index+1,
                    this.faces.size
                )
            );
        }
    }
}
