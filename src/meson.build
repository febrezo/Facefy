# Create a new executable file, list the files we want to compile, list deps and install
executable(
  meson.project_name(),
  'src/Application.vala',
  'src/Window.vala',
  'src/core/Clipboard.vala',
  'src/core/SomethingHelpful.vala',
  'src/gui/AboutDialog.vala',
  'src/gui/HeaderBar.vala',
  'src/gui/MainView.vala',
  'src/gui/SampleDialog.vala',
  'src/gui/SettingsMenu.vala',
  'src/gui/WelcomeView.vala',
  dependencies: [
    dependency('granite'),
    meson.get_compiler('vala').find_library('posix'),
#    dependency('json-glib-1.0'),
#    dependency('gee-0.8'),
#    dependency('libsoup-2.4')
  ],
  install: true
)
