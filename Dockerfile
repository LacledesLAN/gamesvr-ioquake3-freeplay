# escape=`
FROM lacledeslan/steamcmd:linux as quake3-builder

ARG contentServer=content.lacledeslan.net

RUN echo "\nDownloading custom LL content from $contentServer" &&`
        mkdir --parents /output &&`
        cd /output/ &&`
        wget -rkpN -nH --no-verbose --cut-dirs=2 -R "*.htm*,*.ico" -e robots=off "http://"$contentServer"/fastDownloads/q3a/" &&`
    echo "removing cruft that may have slipped in" &&`
        rm ./logos -rf

#=======================================================================`
FROM lacledeslan/gamesvr-ioquake3

HEALTHCHECK NONE

ARG BUILDNODE=unspecified
ARG SOURCE_COMMIT=unspecified

# `RUN true` lines are work around for https://github.com/moby/moby/issues/36573
COPY --chown=Quake3:root --from=quake3-builder /output /app
RUN true

COPY --chown=Quake3:root /dist/app /app
RUN true

COPY --chown=Quake3:root /dist/linux /app

# UPDATE USERNAME & ensure permissions
RUN usermod -l Quake3Freeplay Quake3 &&`
    chmod -R ug+rw /app &&`
    chmod +x /app/ll-tests/*.sh && chmod +x /app/ioq3ded.x86_64 && chmod +x /app/;

USER Quake3Freeplay

WORKDIR /app/

CMD ["/bin/bash"]

ONBUILD USER root
