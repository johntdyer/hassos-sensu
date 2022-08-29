ARG BUILD_FROM=alpine
FROM golang:1.18.0-alpine AS gobuilder

ENV LANG C.UTF-8

ENV SENSU_GO_VERSION=6.7.5
ARG SENSU_GO_HASH
ARG SENSU_GO_ARCH

# https://s3-us-west-2.amazonaws.com/sensu.io/sensu-go/6.4.3/sensu-go_6.4.3_linux_amd64.tar.gz

WORKDIR /src/sensu-go

RUN wget -O sensu-go.tar.gz "https://github.com/sensu/sensu-go/archive/v$SENSU_GO_VERSION.tar.gz"
RUN tar -C . --strip-components=1 -xzf sensu-go.tar.gz
RUN rm sensu-go.tar.gz

RUN go build -ldflags '-X "github.com/sensu/sensu-go/version.Version='$(echo $SENSU_GO_VERSION)'" -X "github.com/sensu/sensu-go/version.BuildDate='$(date +'%Y-%d-%m')'" ' -o bin/sensu-agent ./cmd/sensu-agent

RUN bin/sensu-agent version | grep $SENSU_GO_VERSION

# FROM sensu/sensu as orginal
# RUN echo "Get me youre scripts ;)"

# ARG BUILD_FROM
# amd64: alpine:${VERSION}
# i386: i386/alpine:${VERSION}
# aarch64: arm64v8/alpine:${VERSION}
# armv7: arm32v7/alpine:${VERSION}
# armhf: arm32v6/alpine:${VERSION}

# FROM homeassistant/aarch64-base:3.11
#ghcr.io/home-assistant/base:3.13
FROM homeassistant/amd64-base:3.15

# Environment variables
ENV \
  HOME="/root" \
  LANG="C.UTF-8" \
  PS1="$(whoami)@$(hostname):$(pwd)$ " \
  S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
  S6_CMD_WAIT_FOR_SERVICES=1 \
  TERM="xterm-256color"

# COPY --from=gobuilder /src/sensu-go/bin/ /opt/sensu/bin/

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

# Copy data
COPY rootfs /
# # Copy data for add-on
# COPY run.sh /
# RUN chmod a+x /run.sh

# S6-Overlay
WORKDIR /
ENTRYPOINT ["/init"]

# ARG BUILD_FROM=homeassistant/amd64-base:latest
# FROM $BUILD_FROM

# ARG BUI\
# # Entrypoint & CMD
# ENTRYPOINT ["/init"]

# ENV LANG C.UTF-8

# WORKDIR /

# # FROM $BUILD_FROM
# # FROM ghcr.io/hassio-addons/base/aarch64@sha256:5086c238bdf93a67ca83803960516f160af6323251902d71eef5deb59ea82f7b
# # ENV LANG C.UTF-8

# RUN addgroup -S sensu && \
#     adduser -DHS sensu -G sensu -h /var/lib/sensu && \
#     mkdir -pv /etc/sensu /var/cache/sensu /var/lib/sensu /var/log/sensu /var/run/sensu && \
#     chown -R sensu:sensu /etc/sensu /var/cache/sensu /var/lib/sensu /var/log/sensu /var/run/sensu /var/lib/sensu

# # Copy data for add-on
# COPY run.sh /
# RUN chmod a+x /run.sh

# # RUN mkdir /data
# # USER sensu
# # Entrypoint & CMD

# VOLUME /var/lib/sensu

# LABEL \
#   io.hass.name="Sensu Agent" \
#   io.hass.description="Sensu agent for Home Assistant" \
#   io.hass.arch="${BUILD_ARCH}" \
#   io.hass.type="addon" \
#   io.hass.version=${BUILD_VERSION} \
#   maintainer="John Dyer <johntdyer@gmail.com>"\
#   org.label-schema.description="Sensu Agent for HassOS" \
#   org.label-schema.build-date=${BUILD_DATE} \
#   org.label-schema.name="Sensu Agent" \
#   org.label-schema.schema-version="1.0" \
#   org.label-schema.usage="https://gitlab.com/johntdyer/addon-sensu-agent/-/blob/master/README.md" \
#   org.label-schema.vcs-ref=${BUILD_REF} \
#   org.label-schema.vcs-url="https://gitlab.com/johntdyer/addon-sensu-agent/" \
#   org.label-schema.vendor="HomeAssistant add-ons by John Dyer"

EXPOSE 3030 3031 8126

COPY --from=gobuilder /src/sensu-go/bin/ /opt/sensu/bin/

CMD ["/usr/bin/with-contenv","bashio","/run.sh"]

# Copy data
