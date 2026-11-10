FROM chainguard/wolfi-base:latest@sha256:b7787f1d3f29dcfb48730372d3515391ac3b218723201a765c94949922676099 AS certs
RUN apk update && apk upgrade && apk add --no-cache --upgrade \
    ca-certificates ca-certificates-bundle

FROM chainguard/wolfi-base:latest@sha256:b7787f1d3f29dcfb48730372d3515391ac3b218723201a765c94949922676099

RUN apk update && apk upgrade && apk add --no-cache --upgrade \
    libcap \
    libcap-utils zlib libcrypt1-2.44 ca-certificates-bundle

# Define username and working directory
ARG username="caddyingress"
ENV HOME="/home/$username"
ENV USER=$username

# Create a new user and home directory
RUN adduser -D -u 1000 -g 1000 -s /sbin/nologin $username && \
    mkdir -p $HOME /etc/caddy/certs && \
    chown -R $username:$username $HOME /etc/caddy/certs && \
    chmod -R 700 $HOME /etc/caddy/certs

# Copy files
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ARG TARGETPLATFORM
COPY $TARGETPLATFORM/ingress-controller $HOME

# Set the working directory inside the container
WORKDIR $HOME

# Allow the app to bind to ports below 1024
RUN setcap 'cap_net_bind_service=+ep' $HOME/ingress-controller

# Switch to local non-root user
USER $username

EXPOSE 443/tcp
EXPOSE 443/udp
EXPOSE 80 
ENTRYPOINT ["/home/caddyingress/ingress-controller"]