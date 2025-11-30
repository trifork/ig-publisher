FROM eclipse-temurin:25-jdk-jammy
LABEL maintainer="Henning C. Nielsen"

LABEL org.opencontainers.image.description="FHIR Implementation Guide Publisher"
LABEL org.opencontainers.image.vendor="Trifork"

ARG user=publisher
ARG group=publisher
ARG uid=1000
ARG gid=1000
# GitHub workflows hardcodes the HOME dir to /github/home
ARG HOME=/github/home

ARG IG_PUB_VERSION # Is set by the pipeline

# https://github.com/codacy/codacy-hadolint/blob/master/docs/description/DL4006.md
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# https://github.com/nodesource/distributions?tab=readme-ov-file#debian-versions
# hadolint ignore=DL3008,DL3028,DL3016
RUN if [ -f /etc/apt/sources.list.d/debian.sources ]; then \
       sed -i 's/^Components: main$/& contrib/' /etc/apt/sources.list.d/debian.sources; \
     fi \
  && apt-get update \
  && echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections \
  && apt-get install --yes --no-install-recommends \
       build-essential \
       jq \
       git \
       curl \
       ruby \
       ruby-dev \
       libfreetype6 \
       # Fixes Spring Boot FontConfiguration exceptions - https://coderanch.com/t/761996/frameworks/Docker-Spring-boot-giving-sun
       ttf-mscorefonts-installer \
       fontconfig \
  && arch="$(dpkg --print-architecture)" \
   && curl -fsSL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${arch}" -o /usr/local/bin/yq \
   && chmod +x /usr/local/bin/yq \
   && fc-cache -f -v \
  && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
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
  && groupadd -g ${gid} ${group} \
  && useradd -l -u ${uid} -g ${group} -m ${user} -d $HOME \
  && mkdir -p $HOME/fhir-package-cache \
  && chown -R ${uid} $HOME

# Do not run the entrypoint as root. That is a security risk.
# .. but unfortunately GitHub workflows do not support running as non-root
# https://github.com/actions/checkout/issues/1575
# USER ${uid}:${gid}
WORKDIR $HOME

ENTRYPOINT [ "java", "-jar", "/input-cache/publisher.jar"]
