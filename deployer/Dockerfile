FROM debian:13-slim@sha256:62bd423aeee912639ca8ee681c2b762cb3e25137e0a92b20be455898a9f034ad AS build

ARG CHART_NAME

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

COPY charts/$CHART_NAME /tmp/chart
RUN cd /tmp && tar -czvf /tmp/$CHART_NAME.tar.gz chart

COPY apptest/deployer/$CHART_NAME /tmp/test/chart
RUN cd /tmp/test \
    && tar -czvf /tmp/test/$CHART_NAME.tar.gz chart/

COPY deployer/schema.yaml /tmp/schema.yaml

# Provide registry prefix and tag for default values for images.
ARG REGISTRY
ARG TAG

RUN cat /tmp/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /tmp/schema.yaml.new \
    && mv /tmp/schema.yaml.new /tmp/schema.yaml

COPY apptest/deployer/schema.yaml /tmp/apptest/schema.yaml
RUN cat /tmp/apptest/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /tmp/apptest/schema.yaml.new \
    && mv /tmp/apptest/schema.yaml.new /tmp/apptest/schema.yaml

FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm

ARG CHART_NAME

COPY --from=build /tmp/$CHART_NAME.tar.gz /data/chart/
COPY --from=build /tmp/test/$CHART_NAME.tar.gz /data-test/chart/
COPY --from=build /tmp/apptest/schema.yaml /data-test/
COPY --from=build /tmp/schema.yaml /data/