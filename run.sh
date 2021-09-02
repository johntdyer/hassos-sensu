#!/usr/bin/with-contenv bashio

bashio::log.info "Creating DHCP configuration..."

CONFIG_PATH=/data/options.json

TARGET="$(bashio::config 'target')"

SENSU_BACKEND="$(bashio::config 'sensu_backend')"
SUBSCRIPTION_GROUP="$(bashio::config 'subscription_group')"
SENSU_AGENT_SOCKET="$(bashio::config 'sensu_agent_socket')"
SENSU_AGENT_API="$(bashio::config 'sensu_agent_api')"
SENSU_AGENT_STATSD="$(bashio::config 'sensu_agent_statsd')"

echo "Hello world! $TARGET"
echo "SENSU_BACKEND ->$SENSU_BACKEND"
echo "SUBSCRIPTION_GROUP - >$SUBSCRIPTION_GROUP"
echo "SENSU_AGENT_SOCKET - >$SENSU_AGENT_SOCKET"
echo "SENSU_AGENT_API - >$SENSU_AGENT_API"
echo "SENSU_AGENT_STATSD - >$SENSU_AGENT_STATSD"
