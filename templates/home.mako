<%!
import os.path
%>
<%inherit file="app_base.mako" />

<!--<img src="${request.static_url(APP_BASE + ':static/webapp.png')}" />-->

%if request.session.get('confirm_folder_delete', False):

  <div class="alert alert-warning">
    Folder <strong>${request.session['confirm_folder_delete']}</strong> not empty, really remove folder including all sub-folders and files?
    <span class="pull-right">
      <a href="${request.route_url(APP_NAME + '.delete_folder',
                                   place=current_place.name,
                                   folderpath=request.session['confirm_folder_delete'])}?confirmed=yes" class="btn btn-danger">Yes</a>
      <a href="${request.route_url(APP_NAME + '.place_view', place=current_place.name)}" class="btn btn-default">Cancel</a>
      
    </span>
    <br /><br />
  </div>
  <% del request.session['confirm_folder_delete'] %>
%endif
%if not places:
  <h1 class="h1 text-danger">No place to go</h1>
  <p class="text-danger">
    It seems there are no places configured for managing via the file manager yet. 
  </p>
%elif not current_place:
  <h1 class="h1">Select Place:</h1>
  %for place in places:
    <div class="well well-lg">
      <h2 class="h2">${place.name}</h2>
      <p>${place.description}
      <a href="${request.route_url(APP_NAME + '.place_view', place=place.name)}" class="btn btn-success pull-right">Manage</a>
      </p>
    </div>
  %endfor
%else:

  <ol class="breadcrumb">
    <li><a href="${request.route_url(APP_NAME + '.home')}">File Manager</a></li>
    %if current_place:
      <li>
        <a href="${request.route_url(APP_NAME + '.place_view', place=current_place.name)}?cd=">${current_place.name}</a>
      </li>
      %if current_folder:
        <% prev_folders = '' %>
        %for folder in current_folder.split('/'):
          <li>
            <a href="${request.route_url(APP_NAME + '.place_view', place=current_place.name)}?cd=${os.path.join(prev_folders, folder)}&abs=y">
              ${folder}
            </a>
          </li>
          <% prev_folders = os.path.join(prev_folders, folder) %>
        %endfor
      %endif
    %endif
  </ol>
  <br />
  
  <div class="row">
    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
      <form class="form-inline" action="${request.route_url(APP_NAME + '.create_folder', place=current_place.name)}"
            method="POST">
        <div class="form-group">
          <div class="input-group">
            <input type="text" class="form-control" name="folder_name" placeholder="folder name">
            <span class="input-group-btn">
              <button class="btn btn-default" type="submit">Create Folder</button>
            </span>
          </div><!-- /input-group -->
        </div>
        
      </form>
    </div>
    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12" style="text-align: right">
      <form class="form-inline" action="${request.route_url(APP_NAME + '.place_view', place=current_place.name)}"
            method="POST" enctype="multipart/form-data">
        <div class="form-group">
          <label class="control-label" for="uploaded_file">Upload file to current folder</label>
          <span class="btn btn-default btn-file">
              Browse <input type="file" name="uploaded_file">
          </span>
          <!--<input type="file" class="file" id="uploaded_file" name="uploaded_file" placeholder="Upload file">-->
          <button type="submit" class='btn btn-primary'>Upload</button>
          
        </div>
        
      </form>    
    </div>
  </div>
  
  <br />
  <table class="table table-striped table-hover">
    %if current_folder:
      <tr>
        <td>
        <a href="${request.route_url(APP_NAME + '.place_view', place=current_place.name)}?cd=.."
           style="text-decoration: none; color: inherit;">
          <span class="glyphicon glyphicon-open"></span>
           ..
        </a>
        </td>
        <td style="text-align: right; font-size: larger;">
          <a href=""><span class="glyphicon glyphicon-remove-circle text-danger"></span></a>
        </td>
      </tr>
    %endif
    
    %for folder in folders:
      <tr>
        <td><span class="glyphicon glyphicon-folder-close"></span>
        <a href="${request.route_url(APP_NAME + '.place_view', place=current_place.name)}?cd=${folder}"
           style="text-decoration: none; color: inherit;">
        ${folder}
        </a>
        </td>
        <td style="text-align: right; font-size: larger;">
          <a href="${request.route_url(APP_NAME + '.delete_folder',
                                       place=current_place.name,
                                       folderpath=os.path.join(current_folder, folder))}"><span class="glyphicon glyphicon-remove-circle text-danger"></span></a>
        </td>
      </tr>
    %endfor
    %for file in files:
      <tr>
        <td><span class="glyphicon glyphicon-file"></span>
        <a href="${request.route_url(APP_NAME + '.global_download',
                                     place=current_place.name,
                                     filepath=os.path.join(current_folder, file))}"
           style="text-decoration: none; color: inherit;">
        ${file}
        </a>
        </td>
        <td style="text-align: right; font-size: larger;">
          <a href="${request.route_url(APP_NAME + '.global_download',
                                       place=current_place.name,
                                       filepath=os.path.join(current_folder, file))}"><span class="glyphicon glyphicon-download text-success"></span></a>
          &nbsp;&nbsp;
          <a href="${request.route_url(APP_NAME + '.delete_file',
                                       place=current_place.name,
                                       filepath=os.path.join(current_folder, file))}"><span class="glyphicon glyphicon-remove-circle text-danger"></span></a>
        </td>
      </tr>
    %endfor
  </table>
%endif

