# LICENSE CDDL 1.0 + GPL 2.0
#
# Copyright (c) 2014-2015 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for d98821
# 
# HOW TO BUILD THIS IMAGE
# -----------------------
# Run: 
#      $ docker build -f Dockerfile.generic -t oracle/d98821
#
# Pull base image
# From the Oracle Registry
# -------------------------
FROM oraclelinux:latest

RUN yum install git -y

RUN mkdir /u01 && \
    chmod a+xr /u01 && \
    useradd -b /u01 -M -s /bin/bash oracle && \
    chown oracle:oracle -R /u01 && \
    echo oracle:oracle | chpasswd && \
    mkdir /u01/oracle && \
    chown oracle:oracle -R /u01/oracle && \
    su -c "git clone https://github.com/tomeliason/d98821.git" - oracle && \
    ln -s /u01/oracle/d98821/practices /practices && \
    chown oracle:oracle /practices

# Define default command to start script. 
CMD ["/bin/bash"]
