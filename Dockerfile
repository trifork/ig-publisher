FROM openjdk:23-jdk-slim-bookworm
LABEL maintainer="Henning C. Nielsen"

LABEL org.opencontainers.image.description="FHIR Implementation Guide Publisher"
LABEL org.opencontainers.image.vendor="FUT Infrastructure"

# https://github.com/codacy/codacy-hadolint/blob/master/codacy-hadolint/docs/description/DL4006.md
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG user=publisher
ARG group=publisher
ARG uid=1000
ARG gid=1000

# https://github.com/nodesource/distributions?tab=readme-ov-file#debian-versions
# hadolint ignore=DL3008
RUN  apt-get update \
  && apt-get install --yes --no-install-recommends \
       build-essential=12.9 \
       curl=7.88.1-10+deb12u5 \
       ruby=1:3.1 \
       ruby-dev=1:3.1 \
       libfreetype6=2.12.1+dfsg-5 \
  \
  && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install --yes --no-install-recommends nodejs \
  \
  && gem install \
       bundler:2.5.11 \
       jekyll:4.3.3 \
  \
  && npm install -g npm@10.8.0 \
  && npm install -g fsh-sushi@3.10.0 \
  \
  && mkdir input-cache \
  && curl -fsSL https://github.com/HL7/fhir-ig-publisher/releases/download/1.6.10/publisher.jar -o input-cache/publisher.jar \
  \
  && apt-get autoremove --yes curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  \
  && groupadd -g ${gid} ${group} \
  && useradd -l -u ${uid} -g ${group} -m ${user} \
  && mkdir -p /home/${user}/fhir-package-cache \
  && chown ${uid}:127 /home/${user}/fhir-package-cache

# Do not run the entrypoint as root. That is a security risk.
USER ${uid}:${gid}
WORKDIR /home/${user}

ENTRYPOINT [ "java", "-Xmx4g", "-jar", "/input-cache/publisher.jar"]
