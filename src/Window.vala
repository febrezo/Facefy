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
* Authored by: Félix Brezo <felixbrezo@disroot.orgm>
*/

using AppUtils;
using AppWidgets;

namespace Facefy {
    public class Window : Gtk.ApplicationWindow {
        // Window elements
        // ===============
        public HeaderBar header_bar;
        private Granite.Widgets.Toast toast;
        private Gtk.Overlay overlay_panel;
        private Gtk.Grid main_grid;

        private MainView main_view;
        private WelcomeView welcome_view;

        public PyfacesClient pyfaces_client { get; construct set; }
		private Pid child_pid;

        // Elements
        // ========
        public int num_faces {
            get;
            set;
            default = 0;
        }
        
        // Methods
        // =======
        /// Tie to the Main Window to the Application
        public Window (Gtk.Application app) {
            Object (
                application: app,
                pyfaces_client: new PyfacesClient ("localhost", 12012)
            );
        }

        construct {       
            // Start pyfacesd daemon
	        try {
		        string[] spawn_args = {"pyfacesd"};
		        string[] spawn_env = Environ.get ();

		        Process.spawn_async ("/",
			        spawn_args,
			        spawn_env,
			        SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
			        null,
			        out this.child_pid);
                
                print(@"[com.felixbrezo.Facefy] A 'pyfacesd' daemon has been started with PID $(this.child_pid).\n");
		        ChildWatch.add (this.child_pid, (pid, status) => {
			        // Triggered when the child indicated by child_pid exits
			        Process.close_pid (pid);
		        });

	        } catch (SpawnError e) {
		        print (@"[com.felixbrezo.Facefy]  Error: $(e.message)\n");
	        }
	        
            // Set Windows defaults
            // --------------------
            this.default_height = 800;
            this.default_width = 1024;
            this.resizable = false;
            this.header_bar = new HeaderBar ();
            var color = Gdk.RGBA();
            color.parse("#04B68F");
            Granite.Widgets.Utils.set_color_primary (this, color);
            this.toast = new Granite.Widgets.Toast (_("Facefy"));

            // Define views
            // ------------
            this.welcome_view = new WelcomeView ();

            // Define window events
            // --------------------
            this.header_bar.search_image_btn.clicked.connect (on_search_image_clicked);
            this.header_bar.populate_db_btn.clicked.connect (on_populate_db_clicked);
            this.header_bar.menu.view_data_folder_item.clicked.connect ( () => {
                var data_folder = pyfaces_client.get_data_folder ();
                Posix.system ("xdg-open %s".printf (data_folder));
            });
            this.header_bar.settings_menu_btn.clicked.connect (on_menu_clicked);
            this.header_bar.menu.about_dialog = new AboutDialog (this);

            this.welcome_view.activated.connect ((index) => {
                switch (index) {
                    case 0:
                        this.on_search_image_clicked ();
                        break;
                    case 1:
                        this.on_populate_db_clicked ();
                        break;
                    case 2:
                        this.on_help_clicked ();
                        break;
                }
            });

            // Pack things
            // -----------
            this.overlay_panel = new Gtk.Overlay ();
            this.overlay_panel.add_overlay (this.welcome_view);
            this.overlay_panel.add_overlay (this.toast);

            this.set_titlebar(this.header_bar);
            this.add (overlay_panel);
            
            this.show_all ();
            this.destroy.connect ( () => {
                print(@"[com.felixbrezo.Facefy] Trying to kill 'pyfacesd' daemon…\n");
                try {
		            Process.close_pid (this.child_pid);
		            Pid closing_pid;
		            Process.spawn_async ("/",
			            {"killall", "pyfacesd"},
			            Environ.get (),
			            SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
			            null,
			            out closing_pid
			        );
                    print(@"[com.felixbrezo.Facefy] 'pyfacesd' killed.\n");
    	        } catch (SpawnError e) {
		            print (@"[com.felixbrezo.Facefy]  Error: $(e.message)\n");
	            }
            });
        }

        // Events
        // ======
        private void on_search_image_clicked () {
            var dialog = new Gtk.FileChooserDialog (
                _("Open image file"), // Title
                this, // Parent Window
                Gtk.FileChooserAction.OPEN, // Action: OPEN, SAVE, CREATE_FOLDER, SELECT_FOLDER
                _("Cancel"),
                Gtk.ResponseType.CANCEL,
                _("Open"),
                Gtk.ResponseType.ACCEPT
            );

            var filter = new Gtk.FileFilter ();
            filter.set_name (_("Images"));
            filter.add_mime_type ("image/gif");
            filter.add_mime_type ("image/jpeg");
            filter.add_mime_type ("image/png");
            filter.add_mime_type ("image/x-ms-bmp");
            filter.add_pattern ("*.bmp");
            filter.add_pattern ("*.gif");
            filter.add_pattern ("*.jpg");
            filter.add_pattern ("*.jepg");
            filter.add_pattern ("*.png");
            filter.add_pattern ("*.tif");
            filter.add_pattern ("*.xpm");
            dialog.add_filter (filter);

            var res = dialog.run ();

            if (res == Gtk.ResponseType.ACCEPT) {
                var path = dialog.get_filename ();
                dialog.close ();

                // Remove overlay panel and welcome view if present
                remove (this.overlay_panel);

                this.main_view = new MainView (
                    this,
                    path
                );

                // Create overlay
                this.overlay_panel = new Gtk.Overlay ();
                this.overlay_panel.add_overlay (this.main_view);
                this.overlay_panel.add_overlay (this.toast);

                this.show_toast (_("Image loaded: %s".printf (path)));
                this.add (this.overlay_panel);

                this.show_all ();
            } else {
                dialog.close ();
            }
        }

        private void on_populate_db_clicked () {
            var dialog = new Gtk.FileChooserDialog (
                _("Open images folder"), // Title
                this, // Parent Window
                Gtk.FileChooserAction.SELECT_FOLDER, // Action: OPEN, SAVE, CREATE_FOLDER, SELECT_FOLDER
                _("Cancel"),
                Gtk.ResponseType.CANCEL,
                _("Open"),
                Gtk.ResponseType.ACCEPT
            );

            string folder_path;
            if (dialog.run () == Gtk.ResponseType.ACCEPT) {
                folder_path = dialog.get_filename ();
                dialog.destroy ();
            } else {
                this.show_toast (_("No folder selected."));
                dialog.close ();
                return;
            }

            var populate_dialog = new PopulateDialog (
                this,
                folder_path
            );

            if (populate_dialog.run () == Gtk.ResponseType.ACCEPT) {
                this.show_toast (_("Database population ended successfully."));
            } else {
                populate_dialog.state = TaskState.STOPPING;
                this.show_toast (_("Database population manually stopped."));
            }
            populate_dialog.close ();
            this.header_bar.subtitle = @"$(this.pyfaces_client.get_number_faces ()) faces extracted";
        }

        private void on_help_clicked () {
            try {
                AppInfo.launch_default_for_uri (_("https://github.com/febrezo/Facefy/tree/master/doc/support/en/"), null);
            } catch (Error e) {
                warning (e.message);
            }
        }

        private void show_toast (string message) {
            this.toast.title = message;
            this.toast.send_notification ();
        }

        private void on_menu_clicked (Gtk.Button sender) {
            this.header_bar.menu.set_relative_to (sender);
            this.header_bar.menu.show_all ();
        }
    }
}
