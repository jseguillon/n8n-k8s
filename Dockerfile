FROM n8nio/n8n

ARG KUBECTL_VERSION=v1.33.4
ARG JQ_VERSION=jq-1.8.0
ARG TARGETARCH=amd64

USER root

RUN set -eux; \
    apt-get update; apt-get install -y --no-install-recommends curl ca-certificates; rm -rf /var/lib/apt/lists/*; \
    # --- kubectl (official Kubernetes download) ---
    curl -fsSLo /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl"; \
    chmod +x /usr/local/bin/kubectl; \
    # --- jq (GitHub release) ---
    curl -fsSLo /tmp/jq "https://github.com/jqlang/jq/releases/download/${JQ_VERSION}/jq-linux-${TARGETARCH}"; \
    install -m 0755 /tmp/jq /usr/local/bin/jq; rm -f /tmp/jq; \
    # Sanity check
    kubectl version --client=true || true; jq --version

# n8n runs as node user in this base image
USER node