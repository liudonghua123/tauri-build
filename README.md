# Tauri Build - Multi-Platform Docker Images

[![GitHub License](https://img.shields.io/github/license/liudonghua123/tauri-build)](https://github.com/liudonghua123/tauri-build/blob/main/LICENSE)  
[![Docker Pulls](https://img.shields.io/docker/pulls/liudonghua123/tauri-build)](https://hub.docker.com/r/liudonghua123/tauri-build)

This repository provides multi-platform Docker images optimized for building [Tauri](https://tauri.app) applications. It simplifies the build process by offering pre-configured environments for various architectures, such as `x86_64`, `i386`, `arm64`, and `armv7` on Linux. These images are designed for developers who want to target multiple platforms with minimal configuration.

## Features

- **Multi-platform support**: Seamlessly build Tauri applications for `x86_64`, `i386`, `arm64`, and `armv7` platforms on Linux.
- **Consistent environment**: Ensure a stable, predictable build environment across different machines.
- **Pre-installed dependencies**: Includes all essential tools like Node.js, Rust, and the Tauri CLI, ready for building your applications.
- **Cross-platform compilation**: Build for one architecture from another with ease, allowing you to develop for multiple platforms from a single environment.

## Supported Architectures

The Docker images in this repository support the following Linux-based architectures:
- `linux/amd64` (x86_64)
- `linux/386` (i386)
- `linux/arm64` (arm64)
- `linux/arm` (armv7)

Additional architectures can be added based on community feedback and requirements.

## Docker Images

Docker images are published on [Docker Hub](https://hub.docker.com/r/liudonghua123/tauri-build). The following tags are available to pull images suited for your specific platform and project:

- `latest`: Multi-architecture support with the latest stable versions.
- `${tauri-cli-version}-rust-${rust-version}-node-${node-version}`: Specific versions of Tauri CLI, Rust, and Node.js.

### Example Pull Commands

For `amd64` architecture (x86_64):
```bash
docker pull --platform linux/amd64 liudonghua123/tauri-build:x86_64-latest
```

For `arm64` architecture:
```bash
docker pull --platform linux/arm64 liudonghua123/tauri-build:arm64-latest
```

For `i386` architecture:
```bash
docker pull --platform linux/386 liudonghua123/tauri-build:i386-latest
```

## Usage

These Docker images can be used as base images to streamline Tauri app builds. Below are guides for both local development and CI/CD integration.

### Local Development

1. Pull the appropriate Docker image:
   ```bash
   docker pull liudonghua123/tauri-build:latest
   ```

2. Run the container and mount your project directory:
   ```bash
   docker run -it --rm -v $(pwd):/app -w /app liudonghua123/tauri-build:latest /bin/bash
   ```

3. Inside the container, install dependencies and build your Tauri app:
   ```bash
   npm install
   npm run tauri build

   # OR
   cd src-tauri
   cargo tauri build
   ```

### CI/CD Pipeline Example (GitHub Actions)

Below is an example of how to use the Docker image within a GitHub Actions workflow for continuous integration:

```yaml
name: Build Tauri App

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1

      - name: Pull Tauri Build Docker Image
        run: docker pull liudonghua123/tauri-build:latest

      - name: Build Tauri App
        run: |
          docker run --rm -v $(pwd):/app -w /app liudonghua123/tauri-build:latest \
          bash -c "cd src-tauri && cargo tauri build"
```

## Cross-Platform Builds

To build your application for different architectures (e.g., build for `arm64` from an `x86_64` machine), you can use Docker Buildx, which simplifies cross-platform builds.

### Example Cross-Platform Build

1. Ensure Docker Buildx is installed.
2. Enable QEMU for cross-platform emulation:
   ```bash
   docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
   ```

3. Build for the target platform:
   ```bash
   docker buildx use default # Or create a new builder with docker buildx create --use
   docker buildx build --platform linux/arm64 -t your-username/tauri-app:arm64 .
   ```

## Customizing the Image

If your project requires additional dependencies or custom configurations, you can extend the base image:

```Dockerfile
FROM liudonghua123/tauri-build:latest

# Install extra packages or tools
RUN apt-get update && apt-get install -y your-package

# Add any custom build scripts or configurations here
```

### Example Docker Compose Configuration

You can also use Docker Compose to specify platform and other configurations:

```yaml
services:
  tauri-build:
    build: .
    platform: linux/amd64
    volumes:
      - ./:/app
```

## Contributing

Contributions are welcome! If you encounter any issues, have feature suggestions, or would like to request support for additional architectures, please open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](https://github.com/liudonghua123/tauri-build/blob/main/LICENSE).
