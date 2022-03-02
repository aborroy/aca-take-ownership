#!/bin/bash

# Declare requirements in bash scripts

set -e

function requires() {
    if ! command -v $1 &>/dev/null; then
        echo "Requires $1"
        exit 1
    fi
}

requires "jq"
requires "gsed"

# Environment variables

ACA_GIT_REPO=git@github.com:Alfresco/alfresco-content-app.git
PACKAGE_TGZ_PATH=/Users/aborroy/Downloads/aca-take-ownership/dist/take-ownership/take-ownership-0.0.1.tgz
MODULE_NAME=take-ownership
EXTENSION_FILE=take-ownership.json
EXTENSION_MODULE=TakeOwnershipModule

# Clone and prepare Alfresco Content App

git clone $ACA_GIT_REPO

cd alfresco-content-app

npm install

# Install module

npm install $PACKAGE_TGZ_PATH

# Apply configuration

# angular.json
cat angular.json | jq '.projects."content-ce".architect.build.options.assets += [ {
  "glob": "'$EXTENSION_FILE'",
  "input": "node_modules/'$MODULE_NAME'/assets",
  "output": "./assets/plugins"
},
{
  "glob": "**/*",
  "input": "node_modules/'$MODULE_NAME'/assets",
  "output": "./assets/'$MODULE_NAME'"
} ]' > angular.tmp && mv angular.tmp angular.json

# extensions.module.ts
gsed -i 's/imports: \[/& '"$EXTENSION_MODULE"', /' app/src/app/extensions.module.ts
gsed -i "/^\@NgModule/i import { ""$EXTENSION_MODULE"" } from '"$MODULE_NAME"';\n" app/src/app/extensions.module.ts

# app.extension.json
cat app/src/assets/app.extensions.json | jq '."$references" += ["'$EXTENSION_FILE'"]' > app.extensions.json && \
mv app.extensions.json app/src/assets/app.extensions.json
