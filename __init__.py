from .. import PROJECT_NAME, project_package, has_app


APP_NAME = 'file_manager'
APP_BASE = '%s.apps.%s' % (PROJECT_NAME, APP_NAME)

from .routes import application_routes, global_routes

# app dependencies
app_requires = []
