pyckapps.file_manager
=====================

Pluggable file manager app for PyCK framework. Allow uploading, downloading and deleting of files. Various locations are managed as places. Sub folders can be added and removed in places and files can also be stored in sub folders.

For example you can add this as a subtree to your PyCK project like::


    git remote add FM git@github.com:kashifpk/pyckapps.file_manager.git
    git subtree add --prefix myproject/apps/file_manager FM master

Later if you want to pull latest changes (any updates to the app) you can do::

    git subtree pull --prefix myproject/apps/file_manager FM master


Setup Instructions
-------------------

File manager needs a database table for storing various places it manages. You'll need to run the populate script of your project after including this app to create the necessary table(s) in your DB.

