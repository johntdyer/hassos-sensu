#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

# ==============================================================================
# Sensu config
# ==============================================================================


# Read hostname from API or setting default "hassio"
HOSTNAME=$(bashio::info.hostname)
if bashio::var.is_empty "${HOSTNAME}"; then
    bashio::log.warning "Can't read hostname, using default."
    HOSTNAME="hassio"
fi

# Get default interface
# interface=$(bashio::network.name)

bashio::log.info "Using hostname=${HOSTNAME}" #// interface=${interface}"

mkdir -p /etc/sensu/
mkdir -p /var/cache/sensu/sensu-agent

CONFIG="/etc/sensu/sensu-agent.conf"
bashio::log.info "Configuring Sensu..."
tempio \
    -conf /data/options.json \
    -template /usr/share/tempio/sensu.jinja2 \
    -out "${CONFIG}"

