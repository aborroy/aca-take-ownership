# Alfresco ACA TakeOwnership Extension

An extension module for the Alfresco Content Application that enables "Take Ownership" feature.

Integrates with:

* Context Menus
* Toolbars
* Viewer

## Building

The module is available in [projects/take-ownership](projects/take-ownership) folder.

Local build can be achived by using following commands:

```
$ npm install
$ npm run build:take-ownership
$ cd dist/take-ownership
$ npm pack
```

This will produce `take-ownership-0.0.1.tgz` file that can be installed in ACA.

>> Currently this module is not published, but `npm publish` can be used in `dist/take-ownership` folder to upload the module to npm[https://www.npmjs.com].

## Installation

Simple installation script can be found in [scripts/aca-apply-extension.sh](scripts/aca-apply-extension.sh) file, that includes following operations:

* Clone ACA Git Repository
* Install Node dependencies
* Install `take-ownership` dependency (from `take-ownership-0.0.1.tgz`)
* Apply configuration to ACA source code

>> You may run this script in different location, to it doesn't requires resources from this project

## Running

Once ACA application is ready, remember to create your `.env` file with Repository URL and start the application.

```
$ npm start
```
