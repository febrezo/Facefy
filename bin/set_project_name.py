import os
from os import listdir
from os.path import isfile, join
import sys


def main (rdnn):
    """Updates the template with the given name

    Args:
        rdnn (str): The Reverse Domain Name Notation.
    """
    app_name = rdnn.split(".")[-1]

    base_path = join(os.path.abspath(os.path.dirname(__file__)), "..")
    result = [os.path.join(dp, f) for dp, dn, filenames in os.walk(base_path) for f in filenames if os.path.splitext(f)[1] in ['.build', '.vala', '.in', '.json', '.md', '.vala', '.pot', '.po', 'POTFILES', ".svg"] ]

    for file_path in result:
        if ".py" not in file_path and "build-dir" not in file_path and ".flatpak-builder" not in file_path:
            with open (file_path) as file:
                contents = file.read ()

            contents = contents.replace ("com.felixbrezo.GraniteTemplate", rdnn)
            contents = contents.replace ("GraniteTemplate", app_name)
            new_path = rdnn.replace (".", "/")
            contents = contents.replace ("com/felixbrezo/GraniteTemplate", new_path)

            if "com.felixbrezo.GraniteTemplate" not in file_path:
                with open (file_path, "w") as file:
                    file.write (contents)
            else:
                new_path = file_path.replace ("com.felixbrezo.GraniteTemplate", rdnn)
                with open (new_path, "w") as file:
                    file.write (contents)
                os.remove (file_path)


if __name__ == "__main__":
    if len (sys.argv) == 2:
        if len(sys.argv[1].split (".")) >= 3:
            main (sys.argv[1])
        else:
            print ("The new project name SHOULD be in RDNN (Reverse Domain Name Notation) and SHOULD have at least 3 components, i. e.: com.felixbrezo.MyApp")
            sys.exit (1)
    else:
        print ("The new project name is required. Usage: set_project_name.py com.felixbrezo.MyApp");
        sys.exit (1)
