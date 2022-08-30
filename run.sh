#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

# bashio::log.info "Creating Sensu Configuration"

# # CONFIG_PATH=/config/sensu/options.json

# SENSU_BACKEND_URL="$(bashio::config 'sensu_backend_url')"
# SENSU_SUBSCRIPTIONS="$(bashio::config 'sensu_subscriptions')"
# SENSU_SOCKET_PORT="$(bashio::config 'sensu_agent_socket_port')"
# SENSU_API_PORT="$(bashio::config 'sensu_agent_api_port')"
# SENSU_STATSD_METRICS_PORT="$(bashio::config 'sensu_agent_statsd_port')"
# SENSU_LOG_LEVEL="$(bashio::config 'sensu_log_level')"
# SENSU_USER="$(bashio::config 'sensu_user')"
# SENSU_PASSWORD="$(bashio::config 'sensu_password')"
# SENSU_CACHE_DIR="$(bashio::config 'sensu_cache_dir')"
# SENSU_NAME="$(bashio::config 'sensu_name')"

# export SENSU_BACKEND_URL
# export SENSU_SUBSCRIPTIONS
# export SENSU_SOCKET_PORT
# export SENSU_API_PORT
# export SENSU_STATSD_METRICS_PORT
# export SENSU_LOG_LEVEL
# export SENSU_USER
# export SENSU_PASSWORD
# export SENSU_CACHE_DIR
# export SENSU_NAME

/opt/sensu/bin/sensu-agent start --config-file /config/sensu/agent.conf
