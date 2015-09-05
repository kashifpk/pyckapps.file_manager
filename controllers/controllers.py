from pyramid.view import view_config
from pyramid.response import FileResponse
from pyramid.httpexceptions import HTTPFound
import glob
import os.path
import os
import shutil

from ..models import db, Place
from .. import APP_NAME, PROJECT_NAME, APP_BASE

import logging
log = logging.getLogger(__name__)


def folder_listing(folder):
    files = []
    folders = []
    items = glob.glob(folder.rstrip('/') + '/*')

    for item in items:
        if os.path.isdir(item):
            folders.append(os.path.basename(item))
        else:
            files.append(os.path.basename(item))

    return sorted(folders), sorted(files)


def _get_current_place(request):

    cp = request.matchdict.get('place', None)
    current_place = None
    
    if cp:
        current_place = db.query(Place).filter_by(name=cp).first()

    return current_place


@view_config(route_name=APP_NAME + ".global_download")
def global_file_download(request):
    "Global file download"

    current_place = _get_current_place(request)
    filepath = request.matchdict['filepath']
    filepath = '/'.join(filepath)

    full_path = os.path.join(current_place.path, filepath)
    log.debug("Download path: {}".format(full_path))
    return FileResponse(full_path, request=request)


@view_config(route_name=APP_NAME + '.delete_file')
def delete_file_view(request):
    current_place = _get_current_place(request)
    filepath = request.matchdict['filepath']
    filepath = '/'.join(filepath)

    full_path = os.path.join(current_place.path, filepath)
    try:
        os.unlink(full_path)
    except Exception as exp:
        log.error(exp)
        request.session.flash("Error: {}".format(exp))
    else:
        request.session.flash("Success: File deleted successfully!")

    return HTTPFound(location=request.route_url(APP_NAME + '.place_view', place=current_place.name))


@view_config(route_name=APP_NAME + '.delete_folder')
def delete_folder_view(request):
    current_place = _get_current_place(request)
    folderpath = request.matchdict['folderpath']
    folderpath = '/'.join(folderpath)
    

    full_path = os.path.join(current_place.path, folderpath)
    folders, files = folder_listing(full_path)
    if folders or files:
        # not empty
        if 'yes' == request.GET.get('confirmed', 'no'):
            try:
                shutil.rmtree(full_path)
            except Exception as exp:
                log.error(exp)
                request.session.flash("Error: {}".format(exp))
            else:
                request.session.flash("Success: folder and it's contents deleted successfully!")
        else:
            request.session['confirm_folder_delete'] = folderpath        
    else:
        try:
            os.rmdir(full_path)
        except Exception as exp:
            log.error(exp)
            request.session.flash("Error: {}".format(exp))
        else:
            request.session.flash("Success: folder deleted successfully!")

    return HTTPFound(location=request.route_url(APP_NAME + '.place_view', place=current_place.name))


@view_config(route_name=APP_NAME + '.create_folder', request_method='POST')
def mkdir(request):
    "Create folder"

    current_place = _get_current_place(request)
    current_folder = request.session.get('current_folder', '')

    folder_name = request.POST.get('folder_name')
    if not folder_name:
        request.session.flash("Error: No folder name given")
        return HTTPFound(location=request.route_url(APP_NAME + '.place_view', place=current_place.name))

    full_path = os.path.join(current_place.path, current_folder, folder_name)
    os.mkdir(full_path)

    request.session.flash("Success: Folder created")
    return HTTPFound(location=request.route_url(APP_NAME + '.place_view', place=current_place.name))
    


@view_config(route_name=APP_NAME + '.home', renderer='%s:templates/home.mako' % APP_BASE)
@view_config(route_name=APP_NAME + '.place_view', renderer='%s:templates/home.mako' % APP_BASE)
def app_home(request):
    
    current_place = _get_current_place(request)
    folders = []
    files = []

    current_folder = request.session.get('current_folder', '')
    if 'cd' in request.GET:
        
        if '..' == request.GET['cd']:
            current_folder = os.path.dirname(current_folder)
        elif '' == request.GET['cd']:
            current_folder = ''
        else:
            if 'y' == request.GET.get('abs', 'n'):
                current_folder = request.GET['cd']
            else:
                current_folder = os.path.join(current_folder, request.GET['cd'])

        request.session['current_folder'] = current_folder

    places = db.query(Place).all()

    if not current_place and 1 == len(places):
        current_place = places[0]
    
    if current_place:
        if "POST" == request.method:
            if 'uploaded_file' in request.POST:
                filename = request.POST['uploaded_file'].filename
                full_path = os.path.join(current_place.path, current_folder, filename)
                log.debug("Upload path: {}".format(full_path))

                with open(full_path, 'wb') as output_file:
                    shutil.copyfileobj(request.POST['uploaded_file'].file, output_file)
                
                request.session.flash("success: File uploaded!")

        folders, files = folder_listing(os.path.normpath(os.path.join(current_place.path, current_folder)))

    
    return {'APP_BASE': APP_BASE, 'APP_NAME': APP_NAME,
            'places': places,'folders': folders, 'files': files,
            'current_place': current_place, 'current_folder': current_folder
            }
