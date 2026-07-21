FROM lacledeslan/steamcmd:linux AS quake3-builder

ARG CONTENT_SERVER=content.lacledeslan.net

RUN echo "\nDownloading custom LL content from $CONTENT_SERVER" && \
        mkdir --parents /output && \
        cd /output/ && \
        wget -rkpN -nH --no-verbose --cut-dirs=2 -R "*.htm*,*.ico" -e robots=off "http://"$CONTENT_SERVER"/fastDownloads/q3a/" && \
    echo "removing cruft that may have slipped in" && \
        rm ./logos -rf


#---------------------------------
FROM lacledeslan/gamesvr-ioquake3

ARG BUILD_DATE=unspecified \
    BUILD_NODE=unspecified \
    GIT_REVISION=unspecified

HEALTHCHECK NONE

LABEL architecture="amd64" \
      com.lacledeslan.build-node="$BUILD_NODE" \
      maintainer="Laclede's LAN <contact@lacledeslan.com>" \
      org.opencontainers.image.created="$BUILD_DATE" \
      org.opencontainers.image.description="Laclede's LAN ioQuake3 Freeplay Dedicated Server" \
      org.opencontainers.image.revision="$GIT_REVISION" \
      org.opencontainers.image.source="https://github.com/LacledesLAN/gamesvr-ioquake3-freeplay" \
      org.opencontainers.image.vendor="Laclede's LAN"

COPY --chown=Quake3:root --from=quake3-builder /output /app

COPY --chown=Quake3:root /dist/app /app

COPY --chown=Quake3:root /dist/linux /app

# UPDATE USERNAME & ensure permissions
RUN usermod -l Quake3Freeplay Quake3 && \
    chmod -R ug+rw /app && \
    chmod +x /app/ll-tests/*.sh && chmod +x /app/ioq3ded.x86_64 && chmod +x /app/;

USER Quake3Freeplay

WORKDIR /app/

CMD ["/bin/bash"]
