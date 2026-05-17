FROM cgr.dev/chainguard/wolfi-base@sha256:353c31c9d3d5023a7bf0d1f316edf83bb99fbfdb6aa67f4e2e86222e88cb632c AS certs
RUN apk add --no-cache \
    ca-certificates

FROM cgr.dev/chainguard/wolfi-base@sha256:353c31c9d3d5023a7bf0d1f316edf83bb99fbfdb6aa67f4e2e86222e88cb632c

RUN apk add --no-cache \
    libcap \
    libcap-utils

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