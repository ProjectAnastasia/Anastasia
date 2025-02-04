# syntax=docker/dockerfile:1
FROM debian:bullseye-slim AS base

# Install a MariaDB development package for the shared library
FROM base AS mariadb_library
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    libmariadb-dev:i386 \
    && rm -rf /var/lib/apt/lists/*

# Build TGUI from the JavaScript code using Node
FROM --platform=linux/amd64 node:12-bullseye-slim AS tgui_build
COPY . /build
WORKDIR /build/tgui
RUN bin/tgui

# Render the NanoMap (station mini-map image) Icons
FROM --platform=linux/amd64 debian:bullseye-slim AS nanomap_build
COPY . /build
WORKDIR /build
RUN rm -v icons/_nanomaps/* \
    && tools/github-actions/nanomap-renderer-invoker.sh

# Build the BYOND .dmb and .rsc files for the game service
FROM tgstation/byond:514.1583 AS byond_build
WORKDIR /build
COPY . .
RUN rm -v icons/_nanomaps/*
COPY --from=nanomap_build /build/icons/_nanomaps /build/icons/_nanomaps
RUN DreamMaker anastasia.dme

# Create a container image for production deployment
FROM base AS service_image
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    libc6:i386 \
    libgnutls30:i386 \
    libssl1.1:i386 \
    zlib1g:i386 \
    libstdc++6:i386 \
    && rm -rf /var/lib/apt/lists/*
RUN useradd --uid 1002 --gid 1002 --create-home --shell /bin/bash ss13
COPY --chown=ss13:ss13 --from=byond_build /build/_maps /anastasia/_maps
COPY --chown=ss13:ss13 --from=byond_build /build/goon /anastasia/goon
COPY --chown=ss13:ss13 --from=byond_build /build/html /anastasia/html
COPY --chown=ss13:ss13 --from=byond_build /build/strings /anastasia/strings
COPY --chown=ss13:ss13 --from=byond_build /build/anastasia.dmb /anastasia/anastasia.dmb
COPY --chown=ss13:ss13 --from=byond_build /build/anastasia.rsc /anastasia/anastasia.rsc
COPY --chown=ss13:ss13 --from=byond_build /build/librust_g.so /anastasia/librust_g.so
COPY --chown=ss13:ss13 --from=byond_build /usr/local/byond /byond
COPY --chown=ss13:ss13 --from=mariadb_library /usr/lib/i386-linux-gnu/libmariadb.so /anastasia/libmariadb.so
COPY --chown=ss13:ss13 --from=tgui_build /build/tgui/packages/tgui/public /anastasia/tgui/packages/tgui/public
ENV LD_LIBRARY_PATH="/anastasia:/byond/bin"
ENV PATH="/byond/bin:${PATH}"
# EXPOSE 7777
# VOLUME [ "/anastasia/config", "/anastasia/data" ]
USER ss13
WORKDIR /anastasia
ENTRYPOINT [ "DreamDaemon", "anastasia.dmb", "-port", "7777", "-trusted", "-close", "-verbose" ]
