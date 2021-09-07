#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

bashio::log.info "Creating Sensiu Configuration"

# CONFIG_PATH=/data/options.json

SENSU_BACKEND_URL="$(bashio::config 'sensu_backend_url')"
SENSU_SUBSCRIPTIONS="$(bashio::config 'sensu_subscriptions')"
SENSU_AGENT_SOCKET="$(bashio::config 'sensu_agent_socket')"
SENSU_AGENT_API="$(bashio::config 'sensu_agent_api')"
SENSU_AGENT_STATSD="$(bashio::config 'sensu_agent_statsd')"
SENSU_LOG_LEVEL="$(bashio::config 'sensu_log_level')"
SENSU_USER="$(bashio::config 'sensu_user')"
SENSU_PASSWORD="$(bashio::config 'sensu_password')"
SENSU_CACHE_DIR="$(bashio::config 'sensu_cache_dir')"
SENSU_NAME="$(bashio::config 'sensu_name')"

export SENSU_BACKEND_URL
export SENSU_SUBSCRIPTIONS
export SENSU_AGENT_SOCKET
export SENSU_AGENT_API
export SENSU_AGENT_STATSD
export SENSU_LOG_LEVEL
export SENSU_USER
export SENSU_PASSWORD
export SENSU_CACHE_DIR
export SENSU_NAME

/opt/sensu/bin/sensu-agent start --backend-url "${SENSU_BACKEND_URL}" --deregister --keepalive-interval=5 --keepalive-warning-timeout=10 --password "l+qjbQFq01iNeWoJLBFN6fzoOotS" --subscriptions hass --user "${SENSU_USER}"