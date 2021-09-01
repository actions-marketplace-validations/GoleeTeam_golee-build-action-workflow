#!/bin/sh -l

app_name=$1
branch_name=$2
commit_hash=$3 

app_name=${app_name##*/}
branch_name=${branch_name##*/}

apt-get install kubectl

echo -n $GCLOUD_SERVICE_ACCOUNT_KEYFILE > ./gcloud-api-key.json
gcloud auth activate-service-account --key-file gcloud-api-key.json
gcloud config set project $GCLOUD_PROJECT   

VERSION_CODE="$branch_name-$commit_hash"
SERVICE_NAME="$app_name"
REMOTE_IMAGE_PATH="eu.gcr.io/$GCLOUD_PROJECT/$SERVICE_NAME:$VERSION_CODE"

gcloud auth configure-docker

docker build -t goleedev/$SERVICE_NAME:$VERSION_CODE .
docker tag goleedev/$SERVICE_NAME:$VERSION_CODE $REMOTE_IMAGE_PATH
docker push $REMOTE_IMAGE_PATH

echo "::set-output name=image_path::$REMOTE_IMAGE_PATH"