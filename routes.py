from . import APP_NAME, PROJECT_NAME, APP_BASE


def application_routes(config):
    config.add_route(APP_NAME + '.home', '/')
    config.add_route(APP_NAME + '.delete_file', '/rm/{place}/*filepath')
    config.add_route(APP_NAME + '.delete_folder', '/rmdir/{place}/*folderpath')
    config.add_route(APP_NAME + '.create_folder', '/mkdir/{place}')
    config.add_route(APP_NAME + '.place_view', '/{place}')

    config.add_static_view('static', 'static', cache_max_age=3600)


def global_routes(config):
    config.add_route(APP_NAME + '.global_download', '/{place}/*filepath')
