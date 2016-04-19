# Execute ALICE alien Jobs inside a container
# This script initlizes all the needed alien environtment.

FROM centos:centos6
MAINTAINER Andres Gomez andres.gomez@cern.ch

# It can be substitute by something more 'unique'. No need for that atm.
LABEL container.label=worker-node

# Installing prerequisites.
RUN yum update -y                                                                                            && \
    groupadd -g 355 aliprod                                                                                  && \
    useradd -g 355 -d /var/lib/aliprod -m aliprod                                                            && \
    yum install -y which                                                                                     && \
    yum install -y bzip2                                                                                     && \
    yum install -y tar                                                                                       && \
    yum install -y perl                                                                                      && \
    yum install -y redhat-lsb-core-4.0-7.el6.centos.x86_64                                                   && \
    yum install -y gcc-gfortran                                                                              && \
    yum install -y compat-libgfortran-41                                                                     && \
    yum install -y compat-libtermcap                                                                         && \
    yum install -y libXpm                                                                                    && \
    yum install -y tcl                                                                                       && \
    sed -i '$ a\export PATH="/cvmfs/alice.cern.ch/bin:$PATH"' /var/lib/aliprod/.bashrc                       && \
    sed -i '$ a\export LANG=C' /var/lib/aliprod/.bashrc

# Create the read only configuration files for
# AliEn services and Jobs.
COPY opt/.alien /var/lib/aliprod/.alien

# Create writable directories for the AliEn jobs
RUN mkdir /var/lib/aliprod/.alien/cache                                                                      && \
    mkdir /var/lib/aliprod/.alien/logs                                                                       && \
    mkdir /var/lib/aliprod/.alien/tmp

# Make aliprod the owner of these directories and files
RUN chown -R aliprod:aliprod /var/lib/aliprod/.alien

ENV HOME="/var/lib/aliprod"
ENV PATH="/cvmfs/alice.cern.ch/bin:$PATH"
ENV LANG=C

USER aliprod
WORKDIR /var/lib/aliprod/.alien/tmp

