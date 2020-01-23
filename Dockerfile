FROM alpine:3 as builder

# variable "VERSION" must be passed as docker environment variables during the image build
# docker build --no-cache --build-arg VERSION=2.12.0 -t alpine/helm:2.12.0 .

ARG HELM_VERSION 
ARG KUBECTL_VERSION 

# ENV BASE_URL="https://storage.googleapis.com/kubernetes-helm"
ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"

WORKDIR /tmp

RUN apk add --update --no-cache curl ca-certificates git wget && \
    curl -L ${BASE_URL}/${TAR_FILE} |tar xvz && \
    wget -nv -O /tmp/kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
    chmod +x /tmp/linux-amd64/helm /tmp/kubectl && \
    apk del curl wget && \
    rm -f /var/cache/apk/*

FROM busybox

COPY --from=builder /tmp/kubectl /usr/local/bin/kubectl
COPY --from=builder /tmp/linux-amd64/helm /usr/local/bin/helm


WORKDIR /

#ENTRYPOINT ["sh"]
#CMD ["-c"]
