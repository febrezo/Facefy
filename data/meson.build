# Install the icon
install_data(
    meson.project_name() + '.svg',
    install_dir: join_paths(get_option('datadir'), 'icons')
)

# Translate and install our .desktop file
i18n.merge_file(
    'desktop',
    input: meson.project_name() + '.desktop.in',
    output: meson.project_name() + '.desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications'),
    po_dir: join_paths(meson.source_root(), 'po')
)

# Translate and install our .appdata file
i18n.merge_file(
    'appdata',
    input: meson.project_name() + '.appdata.xml.in',
    output: meson.project_name() + '.appdata.xml',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo'),
    po_dir: join_paths(meson.source_root(), 'po')
)
