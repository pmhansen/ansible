#!/bin/bash

function _check_env {
  if [[ ! -v "$1" ]]; then
    echo "$1 is not set"
    exit 1
  fi
}

_check_env CARE1_API
_check_env CARE1_USERNAME
_check_env CARE1_PASSWORD
_check_env DB_NAME
_check_env DB_USERNAME
_check_env DB_PASSWORD
_check_env FREEPAY_API_KEY
_check_env FREEPAY_API_KEY_NOK
_check_env FREEPAY_API_KEY_SEK
_check_env FREEPAY_CALLBACK_URL
_check_env MODE
_check_env ORDER_PREFIX
_check_env POSTGRESQL_DATA
_check_env POSTGRESQL_INIT
_check_env R2_ACCOUNT_ID
_check_env R2_ACCESS_KEY_ID
_check_env R2_ACCESS_KEY_SECRET
_check_env REDEEM_IMAGE_TAG
_check_env REDIS_CONF
_check_env REDIS_DATA
_check_env RECEIPT_PREFIX
_check_env SESSION_DIR
_check_env SITE_URL
_check_env SMTP_SERVER
_check_env SMTP_PORT
_check_env SMTP_USERNAME
_check_env SMTP_PASSWORD

docker compose pull
docker compose down && docker compose up -d
