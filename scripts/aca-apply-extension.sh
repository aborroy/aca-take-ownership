#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Default options
ACA="false"
INSTALL="false"
UNINSTALL="false"

# Required programs
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
# Alternatively, npm module name can be used
PACKAGE_INSTALLATION_RESOURCE=/Users/aborroy/Downloads/aca-take-ownership/dist/take-ownership/take-ownership-0.0.1.tgz
MODULE_NAME=take-ownership
EXTENSION_FILE=take-ownership.json
EXTENSION_MODULE=TakeOwnershipModule

# Clone and prepare Alfresco Content App
function installAca {
  git clone $ACA_GIT_REPO
  cd alfresco-content-app
  npm install
}

# Install module
function installModule {

  npm install $PACKAGE_INSTALLATION_RESOURCE

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

}

function uninstallModule {

  npm uninstall $MODULE_NAME

  # angular.json
  cat angular.json | jq 'del(.projects."content-ce".architect.build.options.assets[] | try select(.input | contains("take-ownership")))' \
  > angular.tmp && mv angular.tmp angular.json

  # extensions.module.ts
  gsed -i "/import { ""$EXTENSION_MODULE"" } from '"$MODULE_NAME"'/d" app/src/app/extensions.module.ts
  gsed -i 's/'"$EXTENSION_MODULE"', //' app/src/app/extensions.module.ts

  # app.extension.json
  cat app/src/assets/app.extensions.json | jq 'del(."$references"[] | select(contains("'$EXTENSION_FILE'")))' > app.extensions.json && \
  mv app.extensions.json app/src/assets/app.extensions.json

}

# EXECUTION
# Parse params from command line
while test $# -gt 0
do
    case "$1" in
        -aca)
            ACA="true"
            shift
        ;;
        -install)
            INSTALL="true"
            shift
        ;;
        -uninstall)
            UNINSTALL="true"
            shift
        ;;
        *)
            echo "An invalid parameter was received: $1"
            echo "Allowed parameters:"
            echo "  -repo"
            echo "  -share"
            echo "  -search"
            exit 1
        ;;
    esac
done

if [ "$ACA" == "true" ]; then
    echo "--"
    echo "Installing Alfresco Content Application..."
    installAca
    echo "--"
fi

if [ "$(basename $PWD)" != "alfresco-content-app" ]; then
  cd alfresco-content-app
fi

if [ "$INSTALL" == "true" ]; then
  echo "--"
  echo "Installing $MODULE_NAME module..."
  installModule
  echo "--"
fi

if [ "$UNINSTALL" == "true" ]; then
  echo "--"
  echo "Uninstalling $MODULE_NAME module..."
  uninstallModule
  echo "--"
fi
