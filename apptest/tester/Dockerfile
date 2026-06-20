FROM gcr.io/cloud-marketplace-tools/testrunner:0.1.8

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl dnsutils netcat-traditional jq ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    for v in 1.34 1.35 1.36; do \
      mkdir -p "/opt/kubectl/${v}"; \
      curl -L -o "/opt/kubectl/${v}/kubectl" \
        "https://dl.k8s.io/release/v${v}.0/bin/linux/amd64/kubectl"; \
      chmod 755 "/opt/kubectl/${v}/kubectl"; \
    done; \
    ln -sf /opt/kubectl/1.36/kubectl /usr/bin/kubectl

COPY tests/basic-suite.yaml /tests/basic-suite.yaml
COPY tester.sh /tester.sh
RUN chmod 755 /tester.sh

WORKDIR /
ENTRYPOINT ["/tester.sh"]