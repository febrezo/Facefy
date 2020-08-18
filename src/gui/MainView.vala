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
    public class MainView : Gtk.Frame {
        public Facefy.Window window { get; construct; }
        public string source_image_path { get; construct set; }
        public SourceImage source_image { get; construct set; }
        public Gee.ArrayList<Comparison> comparisons { get; set; }

        private ExtractionView extraction_view;
        private ComparisonView comparison_view;
        public Gtk.Stack stack;

        public MainView (Facefy.Window parent, string source_image_path) {
            Object (
                window: parent,
                source_image_path: source_image_path
            );
        }

        construct {
            // Create the operation table
            extraction_view = new ExtractionView (
                this,
                source_image_path
            );
            comparison_view =  new ComparisonView (
                this
            );

            // Organizing the stack
            // --------------------
            this.stack = new Gtk.Stack ();
            stack.expand = true;
            stack.homogeneous = true;
            stack.halign = Gtk.Align.CENTER;
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            stack.set_transition_duration (300);

            // Pack stack tabs
            stack.add_titled (
                extraction_view,
                "extraction_view",
                _("Face Extraction")
            );
            stack.add_titled (
                comparison_view,
                "comparison_view",
                _("Comparisons")
            );

            // Link menus and stack
            var stack_switcher = new Gtk.StackSwitcher ();
            stack_switcher.stack = stack;
            stack_switcher.halign = Gtk.Align.CENTER;

            var stack_grid = new Gtk.Grid ();
            stack_grid.margin_top = 12;
            stack_grid.margin_bottom = 12;
            stack_grid.column_spacing = 12;
            stack_grid.row_spacing = 12;
            stack_grid.halign = Gtk.Align.CENTER;
            stack_grid.attach (stack_switcher, 0, 0);
            stack_grid.attach (stack, 0, 1);

            this.add (stack_grid);

            this.start_extraction (source_image_path);
        }

        public void start_extraction (string? file_path) {
            if (file_path == null) {
                // Called in creation, the image is already loaded
                file_path = this.source_image_path;
            }
            else {
                // Make sure that the provided image is loaded
                this.extraction_view.target_image_path = file_path;
                this.extraction_view.target_image.pixbuf = new Gdk.Pixbuf.from_file_at_scale (file_path, 400, 400, true);
            }

            // Create the object
            this.source_image = window.pyfaces_client.extract_faces (file_path);

            // Activate buttons
            if (this.source_image.faces.size > 0) {
                this.extraction_view.face_avatar.pixbuf = new Gdk.Pixbuf.from_file_at_scale (
                    this.source_image.faces.get (this.source_image.current_face_index), 256, 256, true
                );

                this.extraction_view.start_comparison_btn.sensitive = true;
                if (this.source_image.faces.size > 1) {
                    this.extraction_view.prev_face_btn.sensitive = false;
                    this.extraction_view.next_face_btn.sensitive = true;
                }
            }
            var total_faces = this.source_image.faces.size;
            this.extraction_view.face_label.set_text (_("Extracted faces: %i").printf (total_faces));
            //this.extraction_view.show_all ();
            this.stack.set_visible_child_name ("extraction_view");

            window.header_bar.subtitle = _("%i faces extracted").printf (window.pyfaces_client.get_number_faces ());
        }

        public async void start_comparison_clicked () {
            this.stack.set_visible_child_name ("comparison_view");
            var unknown_face = this.source_image.faces.get (this.source_image.current_face_index);
            this.comparison_view.set_target_face (unknown_face);
            yield nap (1000);
            this.comparisons = window.pyfaces_client.guess_face (unknown_face);
            this.comparison_view.populate_faces (this.comparisons);
        }
    }
}
