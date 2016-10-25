# This is the docker file for building gdal-2.1.1 with pyton bindings
FROM ubuntu:16.04
MAINTAINER Austin Chungath Vincent <austincv@gmail.com>
ENV GDAL_DOWNLOAD_URL http://download.osgeo.org/gdal/2.1.1/gdal-2.1.1.tar.gz
RUN buildDeps='gcc g++ libc6-dev python-dev curl make checkinstall' \
    && set -x \
    && apt-get update \
    && apt-get install -y python $buildDeps --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /usr/src/gdal \
    && curl -sSL "$GDAL_DOWNLOAD_URL" -o gdal.tar.gz \
    && tar -xzf gdal.tar.gz -C /usr/src/gdal --strip-components=1 \
    && rm gdal.tar.gz \
    && cd /usr/src/gdal \
    && ./configure --with-python \
    && make -j12 -C /usr/src/gdal \
    && make -j12 -C /usr/src/gdal install \
    && cd ~ \
    && rm -r /usr/src/gdal \
    && apt-get purge -y --auto-remove $buildDeps \
    && /sbin/ldconfig
ENTRYPOINT ["/bin/bash"]

