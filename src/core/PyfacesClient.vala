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
    public class PyfacesClient : GLib.Object{
        public string rpc_host { get; construct set; }
        public int rpc_port { get; construct set; }
        
        public PyfacesClient (string host, int port) {
            Object (
                rpc_host: host,
                rpc_port: port
            );
        }
        
        public SourceImage extract_faces (string picture_path) {
            var path = @"http://$(this.rpc_host):$(this.rpc_port)";
            
            // Build Json data
            var msg = new Soup.Message ("POST", path);
            var json = """{"jsonrpc": 2.0, "id": 1, "method": "%s", "params": ["%s"]}""".printf (
                "extract_faces",
                picture_path
            );
            msg.request_body.append_take (json.data);
            print (@"[com.felixbrezo.Facefy] POST $path: $json\n");
            
            // Perform request
            var session = new Soup.Session();
            session.send_message(msg);


            // Parse response
            var parser = new Json.Parser ();
            
            try  {
                return new SourceImage ((string) msg.response_body.flatten().data);
            }
            catch (Error e) {
                print ("Error found: %s".printf (e.message));
            }
        }
        
        public string get_data_folder () {
            var path = @"http://$(this.rpc_host):$(this.rpc_port)";
            
            // Build Json data
            var msg = new Soup.Message ("POST", path);
            var json = """{"jsonrpc": 2.0, "id": 1, "method": "%s", "params": []}""".printf (
                "config"
            );
            msg.request_body.append_take (json.data);
            print (@"[com.felixbrezo.Facefy] POST $path: $json\n");

            // Perform request
            var session = new Soup.Session();
            session.send_message(msg);

            var parser = new Json.Parser ();
            parser.load_from_data ((string) msg.response_body.flatten ().data);
            try  {
                return parser.get_root ().get_object ().get_object_member ("result").get_object_member ("config").get_object_member ("Main Options").get_string_member ("data_folder");
            }
            catch (Error e) {
                print ("Error found: %s".printf (e.message));
            }
        }
        
        public Face? get_info_from_face (string face_path) {
            var path = @"http://$(this.rpc_host):$(this.rpc_port)";
            
            // Build Json data
            var msg = new Soup.Message ("POST", path);
            var json = """{"jsonrpc": 2.0, "id": 1, "method": "%s", "params": ["%s"]}""".printf (
                "get_face",
                face_path
            );
            msg.request_body.append_take (json.data);
            print (@"[com.felixbrezo.Facefy] POST $path: $json\n");

            // Perform request
            var session = new Soup.Session();
            session.send_message(msg);

            var parser = new Json.Parser ();
            
            try  {
                return new Face ((string) msg.response_body.flatten().data);
            }
            catch (Error e) {
                print ("Error found: %s".printf (e.message));
            }
        }
        
        public int get_number_faces () {
            var path = @"http://$(this.rpc_host):$(this.rpc_port)";
            
            // Build Json data
            var msg = new Soup.Message ("POST", path);
            var json = """{"jsonrpc": 2.0, "id": 1, "method": "%s", "params": []}""".printf (
                "info"
            );
            msg.request_body.append_take (json.data);
            print (@"[com.felixbrezo.Facefy] POST $path: $json\n");

            // Perform request
            var session = new Soup.Session();
            session.send_message(msg);

            var parser = new Json.Parser ();
            parser.load_from_data ((string) msg.response_body.flatten ().data);
            try  {
                return (int) parser.get_root ().get_object ().get_object_member ("result").get_int_member ("faces");
            }
            catch (Error e) {
                print ("Error found: %s".printf (e.message));
            }
        }
        
        public Gee.ArrayList<Comparison> guess_face (string face_path) {
            var path = @"http://$(this.rpc_host):$(this.rpc_port)";
            
            // Build Json data
            var msg = new Soup.Message ("POST", path);
            var json = """{"jsonrpc": 2.0, "id": 1, "method": "%s", "params": ["%s"]}""".printf (
                "guess_face",
                face_path
            );
            msg.request_body.append_take (json.data);
            print (@"[com.felixbrezo.Facefy] POST $path: $json\n");

            // Perform request
            var session = new Soup.Session();
            session.send_message(msg);

            var parser = new Json.Parser ();
            parser.load_from_data((string) msg.response_body.flatten().data);

            var comparisons = new Gee.ArrayList<Comparison> ();

            foreach (var node in parser.get_root ().get_object ().get_object_member ("result").get_array_member ("comparisons").get_elements ()) {
                var obj = node.get_object ();
                comparisons.add (new Comparison (obj));
            }

            return comparisons;
        }
    }
}
