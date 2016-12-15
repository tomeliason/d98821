#!/bin/bash
# Description: script to build a Docker image for client 

usage() {
cat << EOF

Usage: buildDockerImage.sh -v [version] [-d | -g | -i] [-s] [-c]
Builds a Docker Image.
  
Parameters:
   -v: version 

EOF
exit 0
}

IMAGE_NAME=oracle/d98821

# ################## #
# BUILDING THE IMAGE #
# ################## #
echo "Building image '$IMAGE_NAME' ..."

# BUILD THE IMAGE (replace all environment variables)
BUILD_START=$(date '+%s')
docker build --force-rm=true --no-cache=true $PROXY_SETTINGS -t $IMAGE_NAME -f Dockerfile . || {
  echo "There was an error building the image."
  exit 1
}
BUILD_END=$(date '+%s')
BUILD_ELAPSED=`expr $BUILD_END - $BUILD_START`

echo ""

if [ $? -eq 0 ]; then
cat << EOF
  Docker Image is ready: 
    
    --> $IMAGE_NAME

  Build completed in $BUILD_ELAPSED seconds.

EOF
else
  echo "WebLogic Docker Image was NOT successfully created. Check the output and correct any reported problems with the docker build operation."
fi

