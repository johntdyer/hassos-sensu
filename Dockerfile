ARG BUILD_FROM=alpine
FROM golang:1.18.0-alpine AS gobuilder

ENV LANG C.UTF-8

ENV SENSU_GO_VERSION=6.8.0
ARG SENSU_GO_HASH
ARG SENSU_GO_ARCH

# https://s3-us-west-2.amazonaws.com/sensu.io/sensu-go/6.4.3/sensu-go_6.4.3_linux_amd64.tar.gz

WORKDIR /src/sensu-go

RUN wget -O sensu-go.tar.gz "https://github.com/sensu/sensu-go/archive/v$SENSU_GO_VERSION.tar.gz"
RUN tar -C . --strip-components=1 -xzf sensu-go.tar.gz
RUN rm sensu-go.tar.gz
RUN apk add build-base
RUN go build -ldflags '-linkmode external -extldflags -static -X "github.com/sensu/sensu-go/version.Version='$(echo $SENSU_GO_VERSION)'" -X "github.com/sensu/sensu-go/version.BuildDate='$(date +'%Y-%d-%m')'" ' -o bin/sensu-agent ./cmd/sensu-agent

RUN bin/sensu-agent version | grep $SENSU_GO_VERSION

###### add s6
FROM homeassistant/amd64-base:3.15

# Environment variables
ENV \
  HOME="/root" \
  LANG="C.UTF-8" \
  PS1="$(whoami)@$(hostname):$(pwd)$ " \
  S6_BEHAVIOUR_IF_STAGE2_FAILS=0 \
  S6_CMD_WAIT_FOR_SERVICES=1 \
  TERM="xterm-256color"

COPY --from=gobuilder /src/sensu-go/bin/ /opt/sensu/bin/

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

# Copy data
COPY rootfs /

# S6-Overlay
WORKDIR /
ENTRYPOINT ["/init"]

# Copy data for add-on
COPY run.sh /

RUN chmod a+x /run.sh /etc/cont-init.d/00-banner.sh \
  /etc/cont-init.d/01-log-level.sh \
  /etc/cont-init.d/02-config.sh \
  /etc/cont-finish.d/99-message.sh

EXPOSE 3030 3031 8125

COPY --from=gobuilder /src/sensu-go/bin/ /opt/sensu/bin/

CMD ["/usr/bin/with-contenv","bashio","/run.sh"]
