ARG RUST_VERSION=1.81.0
ARG TAURI_CLI_VERSION=2.0.3
ARG NODE_VERSION=20.18.0

FROM rust:${RUST_VERSION}

ARG RUST_VERSION=1.81.0
ARG TAURI_CLI_VERSION
ARG NODE_VERSION

RUN apt update -y && apt install -y libwebkit2gtk-4.1-dev \
  build-essential \
  curl \
  wget \
  file \
  libxdo-dev \
  libssl-dev \
  libayatana-appindicator3-dev \
  librsvg2-dev

RUN cargo install tauri-cli@${TAURI_CLI_VERSION} && rm -rf ~/.cargo/{registry,.crates.toml,.crates2.json,.global-cache,.package-cache,.package-cache-mutate}

# install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
# patch nvm.sh for install 32-bit of node from source on linux, see also https://github.com/nodejs/node/issues/44822
ADD nvm.sh.patch .
RUN if file /bin/bash | grep -q "32-bit"; then patch ~/.nvm/nvm.sh < nvm.sh.patch; fi
# install the latest version of node via "nvm install node", or use "nvm install --lts" to install latest LTS.
RUN bash -c ". ~/.bashrc && nvm install ${NODE_VERSION} && nvm cache clear"

# configure cwd
RUN mkdir -p /app && cd /app
WORKDIR /app

CMD cargo tauri build