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
    public class SourceImage : GLib.Object {
        public string copied_md5 { get; construct set; }
        public string copied_path { get; construct set; }
        public string extraction_date { get; construct set; }
        public string original_path { get; construct set; }
        public Gee.ArrayList<string> faces { get; construct set; }
        public int current_face_index { get; construct set; }
        
        public SourceImage (string data) {
            var parser = new Json.Parser ();
            parser.load_from_data(data);

            var json_object = parser.get_root ().get_object ().get_object_member ("result");

            var faces = new Gee.ArrayList<string> ();

            foreach (var node in json_object.get_array_member ("faces").get_elements ()) {
                faces.add (node.get_string ());
            }

            Object (
                copied_md5: json_object.get_string_member ("copied_md5"),
                copied_path: json_object.get_string_member ("copied_path"),
                extraction_date: json_object.get_string_member ("extraction_date"),
                original_path: json_object.get_string_member ("original_path"),
                faces: faces,
                current_face_index: 0
            );
        }
    }
}
