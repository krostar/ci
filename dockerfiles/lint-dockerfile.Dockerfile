FROM hadolint/hadolint:v1.16.0-debian

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install --yes --no-install-recommends bash>=4.4 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app-lint
COPY scripts/common.sh .
COPY scripts/lint* ./

WORKDIR /app
ENTRYPOINT [ "/app-lint/lint.sh", "dockerfile" ]
