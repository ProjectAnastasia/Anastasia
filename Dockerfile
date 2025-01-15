# syntax=docker/dockerfile:1
FROM debian:buster-slim AS base

# Install a MariaDB development package for the shared library
FROM base AS mariadb_library
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    libmariadb-dev:i386 \
    && rm -rf /var/lib/apt/lists/*

# Build the BYOND .dmb and .rsc files for the game service
FROM tgstation/byond:513.1528 AS byond_build
WORKDIR /build
COPY . .
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
RUN useradd -ms /bin/bash ss13
COPY --chown=ss13:ss13 --from=byond_build /build/_maps /anastasia/_maps
COPY --chown=ss13:ss13 --from=byond_build /build/strings /anastasia/strings
COPY --chown=ss13:ss13 --from=byond_build /build/anastasia.dmb /anastasia/anastasia.dmb
COPY --chown=ss13:ss13 --from=byond_build /build/anastasia.rsc /anastasia/anastasia.rsc
COPY --chown=ss13:ss13 --from=byond_build /build/librust_g.so /anastasia/librust_g.so
COPY --chown=ss13:ss13 --from=byond_build /usr/local/byond /byond
COPY --chown=ss13:ss13 --from=mariadb_library /usr/lib/i386-linux-gnu/libmariadb.so /anastasia/libmariadb.so
ENV LD_LIBRARY_PATH="/anastasia:/byond/bin"
ENV PATH="/byond/bin:${PATH}"
# EXPOSE 7777
# VOLUME [ "/anastasia/config", "/anastasia/data" ]
USER ss13
WORKDIR /anastasia
ENTRYPOINT [ "DreamDaemon", "anastasia.dmb", "-port", "7777", "-trusted", "-close", "-verbose" ]
