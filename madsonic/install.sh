#!/bin/bash

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Configure user nobody to match unRAID's settings
usermod -u 99 nobody
usermod -g 100 nobody
usermod -d /home nobody
chown -R nobody:users /home

# Disable SSH
rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################

# Repositories
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse"
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse"
add-apt-repository ppa:webupd8team/java

# Accept JAVA license
echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 select true" | /usr/bin/debconf-set-selections

# Use mirrors
sed -i -e "s#http://[^\s]*archive.ubuntu[^\s]* #mirror://mirrors.ubuntu.com/mirrors.txt #g" /etc/apt/sources.list

# Install Dependencies
apt-get update -qq
apt-get install -qy unzip gzip oracle-java7-installer wget

#########################################
##             INSTALLATION            ##
#########################################

MADSONIC_LINK="http://madsonic.org/download/5.2/20141214_madsonic-5.2.5420-standalone.tar.gz"
TRANSCODE_LINK="http://madsonic.org/download/transcode/20141017_madsonic-transcode_latest_x64.zip"

# Install Madsonic
mkdir -p /opt/madsonic /opt/transcode
wget -qO - "${MADSONIC_LINK}" | tar -zx -C /opt/madsonic
wget -qO /tmp/transcode.zip "${TRANSCODE_LINK}"
unzip /tmp/transcode.zip -d /opt/transcode
rm -rf /tmp/transcode.zip /opt/transcode/windows /opt/transcode/mac /opt/transcode/licenses

# Clean APT install files
apt-get clean -y
rm -rf /var/lib/apt/lists/* /var/tmp/* /var/cache/*
