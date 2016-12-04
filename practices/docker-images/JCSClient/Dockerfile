# LICENSE CDDL 1.0 + GPL 2.0
#
# Copyright (c) 2014-2015 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle WebLogic Server 12.2.1.2 Generic Distro
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) fmw_12.2.1.2.0_wls_Disk1_1of1.zip 
#     Download the Generic installer from http://www.oracle.com/technetwork/middleware/weblogic/downloads/wls-for-dev-1703574.html 
#
# (2) server-jre-8uXX-linux-x64.tar.gz
#     Download from http://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html 
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#      $ docker build -f Dockerfile.generic -t oracle/weblogic:12.2.1.2-generic . 
#
# IMPORTANT
# ---------
# The resulting image of this Dockerfile contains a WLS Empty Domain.
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
    chown oracle:oracle -R /u01/oracle

RUN su -c "git clone https://github.com/tomeliason/d98821.git" - oracle

RUN ln -s /u01/oracle/d98821/practices /practices && \
    chown oracle:oracle /practices

# Define default command to start script. 
CMD ["/bin/bash"]
