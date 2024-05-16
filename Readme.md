# Docker image for ig-publisher

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
