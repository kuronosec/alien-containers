# Monitor ALICE alien Jobs from a parallel container
# This script initiliazes all the needed alien environtment.

FROM centos:centos6
MAINTAINER Andres Gomez andres.gomez@cern.ch

# It can be substitute by something more 'unique'. No need for that atm.
LABEL container.label=alien-monitoring

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
    yum install -y perl-JSON                                                                                 && \
    yum install -y nc

ENV PATH="/cvmfs/alice.cern.ch/bin:$PATH"
ENV LANG=C

WORKDIR /var/lib/aliprod/.alien/tmp

