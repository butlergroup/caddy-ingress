FROM redhat/ubi10-minimal AS certs
RUN microdnf update -y && \
    microdnf install -y \
        ca-certificates && \
    microdnf clean all

FROM redhat/ubi10-minimal

RUN microdnf update -y && \
    microdnf install -y \
        shadow-utils \
        libcap

# Define username and working directory
ARG username="caddyingress"
ENV HOME="/home/$username"
ENV USER=$username

# Create a new user and home directory
RUN useradd -m -s /bin/bash $username && \
    mkdir -p $HOME /etc/caddy/certs && \
    chown -R $username:$username $HOME /etc/caddy/certs && \
    chmod -R 700 $HOME /etc/caddy/certs && \
    microdnf clean all

# Copy files
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY ingress-controller $HOME

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