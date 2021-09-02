ARG BUILD_FROM=alpine
FROM golang:1.15.2-alpine AS gobuilder

# Local build:
# docker build -t ruuvitag-mqtt . && docker run --rm -v $PWD/data/options.example.json:/data/options.json ruuvitag-mqtt

ARG SENSU_GO_VERSION
ARG SENSU_GO_HASH

WORKDIR /src/sensu-go

RUN wget -O sensu-go.tar.gz "https://github.com/sensu/sensu-go/archive/v$SENSU_GO_VERSION.tar.gz"; \
	tar -C . --strip-components=1  -xzf sensu-go.tar.gz; \
	rm sensu-go.tar.gz;

RUN go build -ldflags '-X "github.com/sensu/sensu-go/version.Version='`echo $SENSU_GO_VERSION`'" -X "github.com/sensu/sensu-go/version.BuildDate='`date +'%Y-%d-%m'`'" ' -o bin/sensu-agent ./cmd/sensu-agent

RUN bin/sensu-agent version |grep $SENSU_GO_VERSION


FROM sensu/sensu as orginal

RUN echo "Get me youre scripts ;)"


FROM $BUILD_FROM



RUN addgroup -S sensu && \
    adduser -DHS sensu -G sensu -h /var/lib/sensu && \
    mkdir -pv /etc/sensu /var/cache/sensu /var/lib/sensu /var/log/sensu /var/run/sensu && \
    chown -R sensu:sensu /etc/sensu /var/cache/sensu /var/lib/sensu /var/log/sensu /var/run/sensu /var/lib/sensu



RUN apk add --no-cache ca-certificates dumb-init && \
    ln -sf /opt/sensu/bin/entrypoint.sh /usr/local/bin/sensu-agent

USER sensu

VOLUME /var/lib/sensu


CMD ["/opt/sensu/bin/sensu-agent"]
#sensu-agent"]
EXPOSE 3030 3031 8126

COPY --from=gobuilder /src/sensu-go/bin/ /opt/sensu/bin/
# COPY --from=orginal /opt/sensu/bin/entrypoint.sh /opt/sensu/bin/

# # Move to /ruuvitag directory as the place for resulting binary folder
# WORKDIR /ruuvitag

# # Copy binary from build to main folder
# # COPY --from=builder /build/entrypoint.sh ./
# COPY --from=builder /build/main ./

# # Command to run when starting the container
# # CMD ["/ruuvitag/entrypoint.sh"]
# CMD ["/ruuvitag/main"]

# # Labels
# LABEL \
#   io.hass.name="RuuviTag into MQTT" \
#   io.hass.description="Broadcast RuuviTag sensors into MQTT" \
#   io.hass.arch="${BUILD_ARCH}" \
#   io.hass.type="addon" \
#   io.hass.version=${BUILD_VERSION} \
#   maintainer="Kimmo Saari <kirbo@kirbo-designs.com>" \
#   org.label-schema.description="Broadcast RuuviTag sensors into MQTT" \
#   org.label-schema.build-date=${BUILD_DATE} \
#   org.label-schema.name="RuuviTag into MQTT" \
#   org.label-schema.schema-version="1.0" \
#   org.label-schema.usage="https://gitlab.com/kirbo/addon-ruuvitag-mqtt/-/blob/master/README.md" \
#   org.label-schema.vcs-ref=${BUILD_REF} \
#   org.label-schema.vcs-url="https://gitlab.com/kirbo/addon-ruuvitag-mqtt/" \
#   org.label-schema.vendor="HomeAssistant add-ons by Kimmo Saari"



# # ARG BUILD_FROM
# # FROM $BUILD_FROM

# # ENV LANG C.UTF-8

# # # Install requirements for add-on
# # # RUN apk add --no-cache example_alpine_package

# # # Copy data for add-on
# # COPY run.sh /
# # RUN chmod a+x /run.sh

# # LABEL io.hass.version="VERSION" io.hass.type="addon" io.hass.arch="armhf|aarch64|i386|amd64"

# # CMD [ "/run.sh" ]
