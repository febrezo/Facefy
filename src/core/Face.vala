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

namespace AppUtils {
    public class Face : GLib.Object {
        public string copied_image_path { get; construct set; }
        public string face_md5 { get; construct set; }
        public string face_path { get; construct set; }
        public string original_image_path { get; construct set; }

        public Face (string data) {
            var parser = new Json.Parser ();
            parser.load_from_data(data);
            var json_object = parser.get_root ().get_object ().get_object_member ("result");
            Object (
                copied_image_path: json_object.get_string_member ("copied_original_file"),
                face_md5: json_object.get_string_member ("copied_md5"),
                face_path: json_object.get_string_member ("copied_path"),
                original_image_path: json_object.get_string_member ("original_image_path")
            );
        }
    }
}
