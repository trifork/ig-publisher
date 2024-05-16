# Docker image for igpublisher

Builds docker image for igpublisher

## Use locally

Building the container

```bash
docker build . -t igpublisher:localbuild
```

Running on local implementation guild:
```bash
cd common-implementationguide
docker run -v ${PWD}/:/app/ igpublisher:localbuild  /app/ig.json
```