# How to use this repository for deploying your application

This repo is thought to be used as a template. It can be cloned easily and tested using the information in the [`README.md`](../README.md) file.
First of all, let's test it using `git clone`.

```
git clone https://github.com/febrezo/GraniteTemplate.git
cd GraniteTemplate
```

## Manual installation

### Towards building the application manually: the `build` folder

The `build` folder is not there by default but it is the place where things will be compiled. When testing our app we will be working many times from this path.

To create it, tell meson to do so:

```
meson build --prefix=/usr
```

However, it will not work if you follow the instracutions. Have a look at the error: is something wrong with the `en.po` file? That's related with translations. We will fix it now.

### Localize your application to different languages: the `po` folder

The `po` folder contains the information needed to localize the application:

- `LINGUAS`. A simple textfile which defines the languages to be used. In the template, `en`, `es` and `ca` are added one per line. Feel free to add new ones here.
- `meson.build`. It's a different file from the one in the base folder. It simply tells how to launch the `i18n` framework. Note that the `subdir('po')` clause in the main `meson.build` file redirects to the `meson.build` file inside the `po` directory.
- `POTFILES`. Contains the paths of the source files. They will be inspected to find any `_("Whatever")` string that will need to be localized.

Once understood, it's time to localize the application by building the templates for each language. Inside the `build` folder, run this command to build the empty internationalization template:

```
ninja com.felixbrezo.GraniteTemplate-pot
```

And this to update a new `.po` file within the previously created template for each language specified in the `LINGUAS` file:

```
ninja com.felixbrezo.GraniteTemplate-update-po
```

It's now yout turn to explore the contents and update the translations if you want it. For example, this is an example of two translated strings from the `es.po` file.

```
…
#: data/com.felixbrezo.GraniteTemplate.desktop.in:5
#: data/com.felixbrezo.GraniteTemplate.appdata.xml.in:7
msgid "Just another template"
msgstr "Simplemente otra plantilla"

#: data/com.felixbrezo.GraniteTemplate.desktop.in:6
msgid "A template for developing new Vala applications"
msgstr "Una plantilla para desarrollar nuevas aplicaciones en Vala"
…
```

There is an important note if you use non-ASCII characters. Edit this line:

```
"Content-Type: text/plain; charset=ASCII\n"
```

To look like this:

```
"Content-Type: text/plain; charset=UTF-8\n"
```

Otherwise, you may find errors when running the `ninja com.felixbrezo.GraniteTemplate-update-po` command.


### Provide additional metadata for the launcher: the `data` folder

The `.desktop.in` file is the template for the `.desktop` file which is used for the icon that is placed in the applications menu. The `.appdata.xml.in` file is the template for the description in the elementary OS application store. The text found in the file is also grabbed by the i18n package.

This folder contains a new `meson.build` which is in charge of generating the final files and install these elements in the system. Note that the `subdir('data')` clause in the main `meson.build` file redirects here.

### Testing the application

Once understood, it's time to build the application from the `build` folder and test it:

```
ninja
./com.felixbrezo.GraniteTemplate
```

If you want to install it, try:

```
sudo ninja install
```

The application will be ready to use in your system from your applications menu thanks to `desktop` file provided under the `data` folder or even using the terminal (note the absence of the `./` since the application is now installed):

```
com.felixbrezo.GraniteTemplate
```

### Automatic name customization: the `bin` folder

Once tested, you can customize the name of the application using the Python script found under `bin`.

```
cd bin
```

You will need Python in your system to use it. It will require a RDNN identifier for the application in the form of `com.github.febrezo.MyApp` or `com.felixbrezo.MyApp`. The script will automatically go through all the given files found inside and adapt them to that RDNN name.

It's strongly recommended to test it then and save the commit.


### Edit your code: the `src` folder

Code SHOULD be added under the `src` folder. Note that the compilation is made using the `meson.build` file under the project root so it is very important to add each new file added in that file. For example, if a new file is added as `src/gui/MyDialog.vala` it is required to add it as follows:

```
…
executable(
  meson.project_name(),
  'src/Application.vala',
  'src/Window.vala',
  'src/core/Clipboard.vala',
  'src/core/SomethingHelpful.vala',
  'src/gui/HeaderBar.vala',
  'src/gui/MainView.vala',
  'src/gui/MyDialog.vala',
  'src/gui/SampleDialog.vala',
  'src/gui/SettingsMenu.vala',
  'src/gui/WelcomeView.vala',
…
```

It is not required, but it is usually a good habit to add them in alphabetical order to find them easily. Note that you will also need to add them to the `po/POTFILES` file to localize any strings within it. In any case, pay attention at any errors that may appear at compilation time.

Note that if the new code has a dependency such `json-lib-1.0`, `gee-0.8` or `libsoup-2.4` you SHOULD also add the dependency too. In this template, this typical dependencies are commented, so removing the `#` would be enough.

```
…
  dependencies: [
    dependency('granite'),
#    dependency('json-glib-1.0'),
    dependency('gee-0.8'),
#    dependency('libsoup-2.4')
  ],
…
)
```

It is also important to keep track of the dependencies by updating the `README.md` file with it.

## Package your application with Flatpak

Flatpak provides a sandboxed environment in which applications can be packaged and shipped for many GNU/Linux operating systems. By packaging the application using Flatpak several benefits:

- The Sandboxed environment is, per se, a security and stability tool which makes sure that applications can only interact with parts of the system explicitly defined, while they mantain their own specific dependencies stable without crashing other parts of the system. Think about an application which needs an outdated and deprecated library to work. Installing it in the system may crash other applications which depend on newer versions of the app. This is prevented by installing dependencies together with each application at the cost of more (and cheap) hard disk space.
- The permission management system so that applications MUST specify certain permissions to interact with different parts of the OS such as networking, audio or filesystem.
- Flatplak is cross-platform making it easy to deploy applications in different GNU/Linux systems. Think about a random application which exists in different packgae managers but which is installed differently depending on the OS (`sudo apt install whatever` in Debian-based or  `sudo dnf install whatever` in systems like Fedora). Flatpak deals with the installation itself in the sandboxed environment.

To help us with so, we are packaging the application together with a third party which will be invoked from the application to _speak_ to the user: `espeak`. This is an example that lets us know how to add new packages and tools to our environment first and how to use them within the application.

### Dependencies

First of all you will need to fix the Flatpak dependencies:

```
sudo apt install flatpak flatpak-builder
```

This repository uses a BaseApp from elementary OS which needs to be downloaded. If this is your first time using Flatpak, you first need to add the Marketplace (Flathub in this case) and then install from there the appropiate base app.

```
TODO.
```

### Building the Flatpak

Note that the `.json` file in the repository points to a `git` repository which is online. For local development, you SHOULD change it to your local folder. So from:

```
…
{
    "name" : "com.felixbrezo.GraniteTemplate",
    "builddir" : true,
    "buildsystem" : "meson",
    "sources" : [
        {
            "type" : "git",
            "path" : "https://github.com/febrezo/GraniteTemplate"
        }
    ]
}
…
```

You may opt to something like this:

```
…
{
    "name" : "com.felixbrezo.GraniteTemplate",
    "builddir" : true,
    "buildsystem" : "meson",
    "sources" : [
        {
            "type" : "git",
            "path" : "/home/felix/Proyectos/GraniteTemplate"
        }
    ]
}
…
```

However, note that this approach uses the `git` manifest source. This is important because it will match against the last commit performed (or, if provided in an optional `commit` parameter, to that specific commit). As this is sometimes messy since you need to add and commit the changes (and I tipically forget that when testing), I prefer usin this:

```
…
{
    "name" : "com.felixbrezo.GraniteTemplate",
    "builddir" : true,
    "buildsystem" : "meson",
    "sources" : [
        {
            "type" : "git",
            "path" : "/home/felix/Proyectos/GraniteTemplate"
        }
    ]
}
…
```

Once defined, you can now build the Flatpak:

```
flatpak-builder build-dir com.felixbrezo.GraniteTemplate.json --force-clean
```

Or build and install for the current user (which does not require root permissions):

```
flatpak-builder build-dir com.felixbrezo.GraniteTemplate.json --force-clean --install --user
flatpak run com.felixbrezo.GraniteTemplate
```
