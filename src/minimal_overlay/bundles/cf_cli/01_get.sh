#!/bin/sh

set -e

# Grab everything after the '=' character.
DOWNLOAD_URL=`grep -i ^CLOUD_FOUNDRY_CLI_URL= $CONFIG | cut -f2- -d'=' | xargs`

# Read the 'USE_LOCAL_SOURCE' property from '.config'
USE_LOCAL_SOURCE="$(grep -i USE_LOCAL_SOURCE $MAIN_SRC_DIR/.config | cut -f2 -d'=')"

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/cf-cli.tgz ] ; then
  echo "Shell script $MAIN_SRC_DIR/source/overlay/cf-cli.tgz is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd $MAIN_SRC_DIR/source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" ] ; then
  # Downloading cloud foundry compressed binary archive. The '-c' option allows the download to resume.
  echo "Downloading cloud foundry compressed binary archive from $DOWNLOAD_URL"
  wget -O cf-cli.tgz -c $DOWNLOAD_URL
else
  echo "Using local cloud foundry compressed binary archive $MAIN_SRC_DIR/source/overlay/cf-cli.tgz"
fi

# Delete folder with previously prepared cloud foundry cli.
echo "Removing cloud foundry cli work area. This may take a while."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir $WORK_DIR/overlay/$BUNDLE_NAME

# Copy cf-cli.tgz to folder 'work/overlay/cf_cli'.
cp cf-cli.tgz $WORK_DIR/overlay/$BUNDLE_NAME

cd $SRC_DIR
