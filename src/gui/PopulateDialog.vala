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
    public class PopulateDialog : Granite.MessageDialog {
        public Facefy.Window window { get; construct; }
        public string images_folder_path { get; construct set; }
        public TaskState state;
        private Gee.ArrayList<string> image_file_paths;
        private Gtk.ProgressBar progress_bar;
        private Gtk.Button start_button;
        private Gtk.Button suggested_button;

        public PopulateDialog (Gtk.Window parent, string images_folder_path) {
            Object (
                primary_text: _("Populate faces database"),
                secondary_text: _("Images in the folder will be preprocessed for extracting face encodings…"),
                buttons: Gtk.ButtonsType.CANCEL,
                transient_for: parent,
                window: (Facefy.Window) parent,
                images_folder_path: images_folder_path
            );
        }

        construct {
            this.list_all_image_files ();
            this.state = TaskState.WAITING;
            this.image_icon = GLib.Icon.new_for_string ("document-import");
            //this.window_position = Gtk.WindowPosition.CENTER_ON_PARENT;

            // Define objects
            this.start_button = new Gtk.Button.with_label (_("Start populating"));
            this.start_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            this.start_button.clicked.connect (prepare_db_population);

            this.suggested_button = new Gtk.Button.with_label (_("Accept"));
            this.suggested_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            this.suggested_button.sensitive = false;
            this.add_action_widget (suggested_button, Gtk.ResponseType.ACCEPT);

            this.progress_bar = new Gtk.ProgressBar ();
            this.progress_bar.show_text = true;
            this.progress_bar.ellipsize = Pango.EllipsizeMode.START;
            this.progress_bar.fraction = 0;

            // Pack grid elements together together
            var preprocessing_grid = new Gtk.Grid ();
            preprocessing_grid.column_spacing = preprocessing_grid.row_spacing = 12;
            preprocessing_grid.halign = preprocessing_grid.valign = Gtk.Align.CENTER;
            preprocessing_grid.attach (start_button, 0, 0, 3);
            preprocessing_grid.attach (progress_bar, 0, 1, 3);

            this.custom_bin.add (preprocessing_grid);
            this.show_error_details ("[*] Folder path:\n%s\n[*] Images found: %s".printf (
                this.images_folder_path,
                this.image_file_paths.size.to_string ()
            ));
            this.show_all ();
        }

        private void list_all_image_files () {
            this.image_file_paths = new Gee.ArrayList<string> ();
            try {
                Dir dir = Dir.open (this.images_folder_path, 0);
                string? name = null;
                while ((name = dir.read_name ()) != null) {
                    string path = Path.build_filename (this.images_folder_path, name);

                    if (FileUtils.test (path, FileTest.IS_REGULAR)) {
                        var extension = name.substring (-4, 4);
                        switch (extension) {
                           case ".bmp":
                           case ".gif":
                           case ".jpg":
                           case ".jpeg":
                           case ".tif":
                           case ".tiff":
                           case ".xpm":
                              this.image_file_paths.add (Path.build_filename (this.images_folder_path, name));
                              break;
                        }
                    }
                }
            } catch (FileError err) {
                stderr.printf (err.message);
            }
        }

        private async void prepare_db_population () {
            var counter = 0;
            this.start_button.visible = false;
            this.state = TaskState.RUNNING;

            // Used to let the UI refresh
            yield nap (1000);

            foreach (var file_path in this.image_file_paths) {
                counter++;
                print ("[com.felixbrezo.Facefy]\t%s | Image path: %s\n".printf (counter.to_string (), file_path));
                // Check if the dialog is still active

                if (this.state == TaskState.RUNNING) {
                    this.progress_bar.fraction = counter/(double) this.image_file_paths.size;

                    // Schedule the method to resume when idle, then
                    // yield control back to the caller
                    Idle.add (prepare_db_population.callback);
                    yield;

                    // Create the object
                    var source_image = window.pyfaces_client.extract_faces (file_path);
                    print ("[com.felixbrezo.Facefy]\tFaces found: %s\n".printf (source_image.faces.size.to_string ()));
                }
            }

            this.state = TaskState.ENDED;
            this.suggested_button.sensitive = true;
            this.get_widget_for_response (Gtk.ResponseType.CANCEL).visible = false;
        }
    }
}
