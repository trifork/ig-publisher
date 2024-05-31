FROM openjdk:23-jdk-slim-bookworm
LABEL maintainer="Henning C. Nielsen"

LABEL org.opencontainers.image.description="FHIR Implementation Guide Publisher"
LABEL org.opencontainers.image.vendor="FUT Infrastructure"

# https://github.com/codacy/codacy-hadolint/blob/master/codacy-hadolint/docs/description/DL4006.md
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG user=publisher
# ARG group=publisher
# ARG uid=1000
# ARG gid=1000

ARG IG_PUB_VERSION=1.6.10

# https://github.com/nodesource/distributions?tab=readme-ov-file#debian-versions
# hadolint ignore=DL3008,DL3028,DL3016
RUN  apt-get update \
  && apt-get install --yes --no-install-recommends \
       build-essential \
       git \
       curl \
       ruby \
       ruby-dev \
       libfreetype6 \
  \
  && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install --yes --no-install-recommends nodejs \
  \
  && gem install \
       bundler \
       jekyll \
  \
  && npm install -g fsh-sushi \
  \
  && mkdir input-cache \
  && curl -fsSL https://github.com/HL7/fhir-ig-publisher/releases/download/${IG_PUB_VERSION}/publisher.jar -o input-cache/publisher.jar \
  \
  && apt-get autoremove --yes curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  \
  # && groupadd -g ${gid} ${group} \
  # && useradd -l -u ${uid} -g ${group} -m ${user} \
  && mkdir -p /home/${user}/fhir-package-cache
  # && chown ${uid} /home/${user}/fhir-package-cache

# Do not run the entrypoint as root. That is a security risk.
# .. but unfortunately GitHub workflows do not support running as non-root
# USER ${uid}:${gid}
WORKDIR /home/${user}

ENTRYPOINT [ "java", "-Xmx4g", "-jar", "/input-cache/publisher.jar"]
