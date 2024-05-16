FROM ruby:3.3.0

# https://github.com/codacy/codacy-hadolint/blob/master/codacy-hadolint/docs/description/DL4006.md
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# https://github.com/nodesource/distributions?tab=readme-ov-file#debian-versions
RUN  curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get update \
  && apt-get install --yes --no-install-recommends \
       build-essential=12.9 \
       openjdk-17-jdk-headless=17.0.9+9-1~deb12u1 \
       nodejs=18.19.0-1nodesource1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  \
  && gem update --system 3.5.5 \
  && gem install \
       bundler:2.5.5 \
       jekyll:4.3.3 \
  \
  && npm install -g npm@10.4.0 \
  && npm install -g fsh-sushi@3.6.1 \
  \
  && mkdir input-cache \
  && curl -fsSL https://github.com/HL7/fhir-ig-publisher/releases/download/1.5.14/publisher.jar -o input-cache/publisher.jar

ENTRYPOINT [ "java", "-Xmx4g", "-jar", "input-cache/publisher.jar", "-ig"]
