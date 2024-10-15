FROM rust:latest

RUN apt update -y && apt install -y libwebkit2gtk-4.1-dev \
  build-essential \
  curl \
  wget \
  file \
  libxdo-dev \
  libssl-dev \
  libayatana-appindicator3-dev \
  librsvg2-dev

RUN cargo install tauri-cli

# install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
# patch nvm.sh for install 32-bit of node from source on linux, see also https://github.com/nodejs/node/issues/44822
ADD nvm.sh.patch .
RUN if file /bin/bash | grep -q "32-bit"; then patch ~/.nvm/nvm.sh < nvm.sh.patch; fi
# install the latest version of node via "nvm install node", or use "nvm install --lts" to install latest LTS.
RUN bash -c ". ~/.bashrc && nvm install --lts"

CMD cargo tauri build