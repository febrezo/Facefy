# Project name and programming language
project('com.felixbrezo.Facefy', 'vala', 'c')

# Include the translations module
i18n = import('i18n')

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Translations
# ------------
subdir('po')

# Data files
# -----------
#subdir('data')

# Install the icon
# TODO: remove in favour of subdir for easier maintenance
install_data(
    join_paths('data', meson.project_name() + '.png'),
    install_dir: join_paths(get_option('datadir'), 'icons')
)

install_data(
    join_paths('data', 'bachfugue.wav'),
    install_dir: join_paths(get_option('datadir'), 'icons')
)

# Translate and install our .desktop file
i18n.merge_file(
    type: 'desktop',
    input: join_paths('data', meson.project_name() + '.desktop.in'),
    output: meson.project_name() + '.desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications'),
    po_dir: join_paths(meson.source_root(), 'po')
)

# Translate and install our .appdata file
i18n.merge_file(
    type: 'xml',
    input: join_paths('data', meson.project_name() + '.appdata.xml.in'),
    output: meson.project_name() + '.appdata.xml',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo'),
    po_dir: join_paths(meson.source_root(), 'po')
)

# Compilation
# -----------
#subdir('src')

# Create a new executable file, list the files we want to compile, list deps and install
# TODO: remove in favour of subdir for  easier maintenance
executable(
  meson.project_name(),
  'src/Application.vala',
  'src/Window.vala',
  'src/core/Clipboard.vala',
  'src/core/Comparison.vala',
  'src/core/Face.vala',
  'src/core/PyfacesClient.vala',
  'src/core/SourceImage.vala',
  'src/core/TaskState.vala',
  'src/core/Utils.vala',
  'src/gui/AboutDialog.vala',
  'src/gui/ComparisonView.vala',
  'src/gui/ExtractionView.vala',
  'src/gui/FaceInfoPane.vala',
  'src/gui/HeaderBar.vala',
  'src/gui/MainView.vala',
  'src/gui/PopulateDialog.vala',
  'src/gui/SettingsMenu.vala',
  'src/gui/WelcomeView.vala',
  dependencies: [
    dependency('granite'),
    meson.get_compiler('vala').find_library('posix'),
    dependency('json-glib-1.0'),
    dependency('vte-2.91'),
    dependency('gee-0.8'),
    dependency('libsoup-2.4')
  ],
  install: true
)
