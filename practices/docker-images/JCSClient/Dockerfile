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
# Download:
# - Java Development Kit (JDK)
# - Grinder
# - WebLogic Server Generic installation
# - OEPE
# - Python 3.5
# - visualgc
#
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

USER oracle
RUN mkdir -p /u01/app/oracle/middleware && \
    chmod a+xr -R /u01

# Install JDK
# File jdk.tar.gz exists in same directory as Dockerfile
# Download Linux X64 JDK from http://www.oracle.com/technetwork/java/javase/downloads/ and rename to jdk.tar.gz

ENV JAVA_PKG=jdk.tar.gz 

COPY $JAVA_PKG /u01/

RUN tar -xzf /u01/$JAVA_PKG -C /u01 \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/* \
    && rm -rf /u01/$JAVA_PKG \
    && mv /u01/jdk* /u01/jdk \
    && echo 'export PATH=/u01/jdk/bin:$PATH' >> /u01/oracle/.bash_profile \
    && echo 'export JAVA_HOME=/u01/jdk/bin' >> /u01/oracle/.bash_profile 

# Install Grinder
# File grinder.zip exists in same directory as Dockerfile
# Download from http://downloads.sourceforge.net/project/grinder/The%20Grinder%203/ and rename to grinder.zip

ENV GRINDER_PKG=jdk.tar.gz 

COPY $GRINDER_PKG /u01/

RUN cd /u01 \
    && unzip $GRINDER_PKG \
    && rm -rf /u01/$GRINDER_PKG \
    && mv /u01/grinder-* /u01/grinder 

# install WebLogic Server Generic installation
# File fmw_wls.jar exists in same directory as Dockerfile
# Download the Generic Installer from http://www.oracle.com/technetwork/middleware/weblogic/downloads/index.html, extract to fmw_wls.jar

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------

ENV JAVA_HOME=/u01/jdk \
    FMW_JAR=fmw_wls.jar \
    ORACLE_HOME=/u01/app/oracle/middleware \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    PATH=$PATH:/u01/jdk/bin:/u01/app/oracle/middleware/oracle_common/common/bin

# Copy packages
# -------------
COPY $FMW_JAR install.file oraInst.loc /u01/

# Go to /u01 as user 'oracle' to proceed with WLS installation
# ------------------------------------------------------------
RUN $JAVA_HOME/bin/java -jar /u01/$FMW_JAR -silent -responseFile /u01/install.file -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="WebLogic Server" && \
    rm /u01/$FMW_JAR /u01/oraInst.loc /u01/install.file

# install OEPE
# supplied as oepe.zip
# from

# install Python 3.5.X
# File Python.tar.xz exists in same directory as Dockerfile
# Download from http://www.python.org/downloads and rename to Python.tar.xz
ENV PY_PKG=Python.tar.xz
COPY $PY_PKG /u01/
RUN mkdir /u01/python3 \
    && tar -xf /u01/$PY_PKG -C /u01/python3 --strip-components=1 \
    && echo 'export PATH=/u01/python3/bin:$PATH' >> /u01/oracle/.bash_profile \
    && rm -rf /u01/$PY_PKG \
    && cd /u01/python3 \
    && ./configure --prefix=/u01/python3 \
    && make \
    && make install 

# install visualgc
# 
# from

# Define default command to start script.  
CMD ["/bin/bash"]
