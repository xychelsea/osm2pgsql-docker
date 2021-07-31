# OpenStreetMap to PostgreSQL (osm2pgsql) Docker container
# Copyright (C) 2021  Chelsea E. Manning
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

FROM ubuntu:hirsute-20210723
LABEL description="OpenStreetMap to PostgreSQL (osm2pgsql) Docker Container"

# $ docker build --network=host -t xychelsea/osm2pgsql:latest -f Dockerfile .
# $ docker run --rm -it -v data:/usr/local/osm2pgsql xychelsea/osm2pgsql:latest osm2pgsql --help
# $ docker push xychelsea/osm2pgsql:latest

ARG OSM2PGSQL_CONTAINER="v0.1"
ARG OSM2PGSQL_OS="Linux"
ARG OSM2PGSQL_ARCH="x86_64"
ARG OSM2PGSQL_DISTRO="groovy"
ARG OSM2PGSQL_GID="100"
ARG OSM2PGSQL_USER="osm2pgsql"
ARG OSM2PGSQL_PATH="/usr/local/${OSM2PGSQL_USER}"
ARG OSM2PGSQL_UID="1000"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

ENV DEBIAN_FRONTEND=noninteractive

# Update packages
RUN apt-get update --fix-missing \
	&& apt-get -y upgrade \
	&& apt-get -y dist-upgrade

# Install prerequisites
RUN apt-get install -y --no-install-recommends \
	bzip2 \
	ca-certificates \
	curl \
	locales \
	sudo \
	osm2pgsql \
	wget

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

# Configure environment
ENV OSM2PGSQL_CONTAINER=${OSM2PGSQL_CONTAINER} \
    OSM2PGSQL_OS=${OSM2PGSQL_OS} \
    OSM2PGSQL_ARCH=${OSM2PGSQL_ARCH} \
    OSM2PGSQL_DISTRO=${OSM2PGSQL_DISTRO} \
    OSM2PGSQL_PATH=${OSM2PGSQL_PATH} \
    OSM2PGSQL_GID=${OSM2PGSQL_GID} \
    OSM2PGSQL_UID=${OSM2PGSQL_UID} \
    OSM2PGSQL_USER=${OSM2PGSQL_USER} \
    HOME=/home/${OSM2PGSQL_USER} \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    SHELL=/bin/bash

# Enable prompt color, generally
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

# Create default user wtih name "osm2pgsql"
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su \
	&& sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers \
	&& sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers \
	&& useradd -m -s /bin/bash -N -u ${OSM2PGSQL_UID} ${OSM2PGSQL_USER} \
	&& mkdir -p ${OSM2PGSQL_PATH} \
	&& chown -R ${OSM2PGSQL_USER}:${OSM2PGSQL_GID} ${OSM2PGSQL_PATH} \
	&& chmod g+w /etc/passwd

RUN apt-get --purge remove -y \
	curl \
	wget

# Switch to user "osm2pgsql"
USER ${OSM2PGSQL_UID}
WORKDIR ${HOME}
