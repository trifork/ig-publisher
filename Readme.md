# Docker image for FHIR Implementation Guide Publisher
-found at https://github.com/HL7/fhir-ig-publisher. Instructions on the actual publisher is found here: https://confluence.hl7.org/spaces/FHIR/pages/66938614/Implementation+Guide+Parameters

Builds docker image for ig-publisher

## Use locally

Building the container

```bash
docker build . -t igpublisher:localbuild
```

Running on local implementation build:

```bash
docker run -v ${PWD}/:/app/ igpublisher:localbuild -ig /app/ig.json
```

Running from the remote repo:

```bash
 docker run -v ./:/tmp/ig  ghcr.io/trifork/ig-publisher:latest -ig /tmp/ig
```

Running on macOS:
```bash
 docker run -v ./:/tmp/ig --platform linux/x86_64 ghcr.io/trifork/ig-publisher:latest -ig /tmp/ig
```
