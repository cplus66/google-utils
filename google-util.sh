#!/bin/bash -xe

case "$1" in
  install)
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y
  ;;

  config-account)
  echo "Usage: $0 user@gmail.com"
  gcloud config set account $2
  ;;

  *)
  echo "Usage: $0 { install | config-account }";
  ;;
esac
