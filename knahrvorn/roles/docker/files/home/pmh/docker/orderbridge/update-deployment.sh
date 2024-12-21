#!/bin/bash

function _check_env {
  if [[ ! -v "$1" ]]; then
    echo "$1 is not set"
    exit 1
  fi
}

_check_env API_ADDR
_check_env WEB_PORT
_check_env MAILBOX
_check_env MS_APP_ID
_check_env MS_SECRET_TEXT
_check_env MS_TENANT_ID
_check_env IDP_URL
_check_env IDP_CLIENT_ID
_check_env PROD

docker compose pull
docker compose down && docker compose up -d
