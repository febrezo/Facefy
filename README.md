# Facefy

This is a template repository to ease the process of creating GUI with Vala based on GTK and Granite.

## Manually install the Facefy

You'll need the following dependencies:

* granite >= 0.5
* meson >= 0.43.0
* valac

Then, you SHOULD clone the repository:

```
git clone https://github.com/febrezo/Facefy.git
cd Facefy
```

Run `meson build` to configure the build environment. Change to the build directory and run `ninja test` to build and run automated tests.

```
meson build --prefix=/usr
cd build
ninja test
```

The application found under the build folder can now be launched:

```
./com.felixbrezo.Facefy
```

To optionally install, use `ninja install`, then execute with `com.felixbrezo.Facefy`.

```
ninja install
com.felixbrezo.Facefy
```

Tou SHOULD be able to explore the capabilities of the default application.

## Other dependencies

This tool requires Python's `face_recognition` library to be installed in the system. You can find more information [here](https://github.com/ageitgey/face_recognition).
