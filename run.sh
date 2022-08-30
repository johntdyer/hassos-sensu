#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

/opt/sensu/bin/sensu-agent start --config-file /config/sensu/agent.conf
