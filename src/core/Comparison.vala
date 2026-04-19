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
    public class Comparison : GLib.Object {
        public string face_path { get; construct set; }
        public double similarity { get; construct set; }
        
        public Comparison (Json.Object info) {
            Object (
                face_path: info.get_string_member ("known_face"),
                similarity: info.get_double_member ("similarity")
            );
        }
    }
}
