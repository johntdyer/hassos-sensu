---
# Automatically generated do not edit


##
# agent configuration
##
name: "{{ env "HOSTNAME" }}"
namespace: "{{ .namespace }}"
{# subscriptions: ["ubuntu","proxy"] #}
subscriptions: [{% for sub in .subscriptions %}"{{ sub }}"{{ "," if not loop.last else "" }} {% endfor %}]

password: {{.sensu_password}}

##
# api configuration
##
api-host: "127.0.0.1"
api-port: {{.sensu_agent_api_port}}
disable-api:    {{ .sensu_api_disable }}

##
# socket configuration
##
disable-sockets: false
socket-host: "127.0.0.1"
socket-port: {{.sensu_agent_socket_port}}

##
# statsd configuration
##
statsd-disable:  {{ .sensu_local_statsd_listener_disable }}
statsd-event-handlers: ""
statsd-flush-interval: 10
statsd-metrics-host: "127.0.0.1"
statsd-metrics-port: {{.sensu_agent_statsd_port}}
##
# other
##
#cache-dir: "/var/cache/sensu/sensu-agent"
#config-file: ""
deregister: true
#deregistration-handler: ""
#keepalive-timeout: 120
#keepalive-interval: 20
#extended-attributes: ""
log-level: "{{.sensu_log_level}}"
#redact: ""

