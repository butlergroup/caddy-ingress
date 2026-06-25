FROM chainguard/wolfi-base@sha256:2f7a5c164eafbdbe46fe1d91bd1ab4c8cb5c2bdbd10641c3d61bd39962384cdb AS certs
RUN apk add --no-cache \
    ca-certificates

FROM chainguard/wolfi-base@sha256:2f7a5c164eafbdbe46fe1d91bd1ab4c8cb5c2bdbd10641c3d61bd39962384cdb

RUN apk update && apk upgrade && apk add --no-cache \
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