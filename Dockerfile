FROM quay.io/brusdev/activemq-artemis-broker-kubernetes@sha256:661b86e5719ee974b170b067488dcb180a35b3384417fce13f4e801fef0d7106

USER root

ADD script /opt/amq-broker/script

ARG REMOTE_SOURCE_REF=0467611bb875f50fdee76431dfb9d34dc79b8a7f
ARG REMOTE_SOURCE_REP=https://github.com/artemiscloud/yacfg.git
ENV REMOTE_SOURCE_URL=$REMOTE_SOURCE_REP#$REMOTE_SOURCE_REF
### BEGIN REMOTE SOURCE
ARG REMOTE_SOURCE_DIR=/tmp/remote_source
RUN microdnf install -y git && microdnf clean all && rm -rf /var/cache/yum
RUN mkdir -p $REMOTE_SOURCE_DIR/app
RUN git clone $REMOTE_SOURCE_REP $REMOTE_SOURCE_DIR/app
RUN cd $REMOTE_SOURCE_DIR/app && git checkout $REMOTE_SOURCE_REF
### END REMOTE SOURCE
WORKDIR $REMOTE_SOURCE_DIR/app

RUN chmod g+rwx $REMOTE_SOURCE_DIR/app

RUN microdnf install -y python38 python38-jinja2 python38-pyyaml && \
    microdnf clean all && rm -rf /var/cache/yum

RUN python3 setup.py install

USER 185

LABEL name="artemiscloud/activemq-artemis-broker-init"
LABEL description="ActiveMQ Artemis broker init container image"
LABEL maintainer="Howard Gao <hgao@redhat.com>"
LABEL version="1.0.31"
