<%inherit file="pyck:templates/admin/admin_base.mako" />

<%def name="title()">
File Manager
</%def>

<%def name="meta()">
<style>
.btn-file {
    position: relative;
    overflow: hidden;
}
.btn-file input[type=file] {
    position: absolute;
    top: 0;
    right: 0;
    min-width: 100%;
    min-height: 100%;
    font-size: 100px;
    text-align: right;
    filter: alpha(opacity=0);
    opacity: 0;
    outline: none;
    background: white;
    cursor: inherit;
    display: block;
}
</style>
</%def>


<%def name="side_menu()">
<div class="panel panel-primary">
    <div class="panel-heading">
        Places
    </div>
    
    %if places:
    <ul class="list-group">
        %for place in places:
            
            %if current_place and current_place.name == place.name:
            <li class="list-group-item active">
            %else:
            <li class="list-group-item">
            %endif
            <a style="color: inherit;" href="${request.route_url(APP_NAME + '.place_view', place=place.name)}?cd=">${place.name}</a></li>
        %endfor
    </ul>
    %endif
    
</div>
</%def>

<%def name="header()">
<ul class="nav nav-pills">
  <li role="presentation"><a href="/"><span class="glyphicon glyphicon-home"></span></a></li>
  <li role="presentation" class="active"><a href="${request.route_url(APP_NAME + '.home')}"><span class="glyphicon glyphicon-folder-open"></span> File Manager</a></li>
</ul>
<br />
</%def>

${self.body()}