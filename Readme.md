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

Running from the remote repo:

```bash
 docker run -v ./:/tmp/ig  ghcr.io/trifork/ig-publisher:latest -ig /tmp/ig
```

Running on macOS:
```bash
 docker run -v ./:/tmp/ig --platform linux/x86_64 ghcr.io/trifork/ig-publisher:latest -ig /tmp/ig
```
