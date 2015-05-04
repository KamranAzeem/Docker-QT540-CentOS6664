FROM centos:6
MAINTAINER Kamran Azeem <kaz@praqma.net>


# Note: It is necessary to do "yum clean all" on each RUN command, because the RUN command makes a commit,
#       and because of that anything on the disk then becomes "locked" with that commit. 
#       It quickly starts to take a lot of disk space. So cleaning up each time we do something is important.


# SELINUX:
# --------
# SELINUX is already disabled in the base image used to build this container on.
# So there is no need to disable that in this file. It will actually result in an error if you try to do that,
# and the container image building will not be successfull.



# Packages:
# ---------
# Update the container packages:
RUN yum -y update && yum clean all

# Install some utils:
RUN yum -y install wget tar shadow-utils system-config-keyboard git && yum clean all

# Development tools will download about 107 MB of packages (111 packages in total)
RUN yum -y groupinstall "Development Tools" && yum clean all

# We do not need dbus-qt (because that will pull a lot of undesired qt* packages).
# That is why I am only selecting select few dbus packages
RUN yum -y install mesa-libGL* xorg-x11-xkb* xcb* libxcb* dbus dbus-c++* dbus-devel dbus-x11 && yum clean all

# SELINUX:
# --------
# SELINUX is already disabled in the base image used to build this container on.
# So there is no need to disable that in this file. It will actually result in an error if you try to do that,
# and the container image building will not be successfull.


# SSH server:
# -----------
# When SSH is enabled, you need to Forward the SSH traffic to the SSH service inside the container.
# SSH is necessary if this container needs to act as a Jenkins slave. Jenkins master will connect to the slave over SSH.
# If you need SSH service, enable the following two lines.
RUN yum -y install openssh-server && yum clean all 
EXPOSE 22 22

# Note: "chkconfig sshd on" will not help the service to come up, 
# as this is just a container not actually a VM or something. There is no init :( 


# Install Jenkins Slave:
# ----------------------
# A Jenkins slave needs Java and SSH credentials of a user on the Jenkins Slave machine.
# The Jenkins master will put a slave.jar file on the slave node and use it to launch jobs.
# RUN yum -y install java-*-openjdk && yum clean all
# SETUP JAVA_HOME in /etc/environment. 
# However, we do not know what version of Java got installed as a result of yum install command,
# and what is the exact path of it. For jenkins slave, there is a facility of setting JAVA_HOME
# for the slave node, when a node is added/created.
# Also, the home directory of the builduser (see below) can be used as workspace for Jenkins slave.
# So, /home/builduser needs to be mentioned as remote root directory in the Jenkins master ,
# where/when this node is defined.



# Build user for Jenkins:
# -----------------------
# We add a user named "builduser" ; and assign a password to it too. 
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues) (Thanks Henrik)
RUN groupadd -r builduser -g 1000 && useradd -u 1000 -r -g builduser -m -d /home/builduser -s /bin/bash -c "Build User" builduser && echo "builduser:testing" | chpasswd

# Note: the password for builduser is set to testing in the command above. Change it to whatever you need.


# QT base:
# --------
# There are two ways to do this. 
# a) Compile Qt base on the Docker Container/Image. 
#    This will take a long time when the Docker image is built the first time.
# b) Have a prebuild QT-base binaries tarball stored somewhere on the network, 
#    and the Docker images just pulls it at build time.

# The QT-base precompiled file:

# This file needs to exist on your (Docker) host system, on a specific path. That 
# The path to this file will need to be changed. The file is a precompiled qtbase-5.4.0 on CentOS 6.6 64 bit.
# The precompiled version is simply copied inside /opt/qt/qtbase . 
# If you actually compile qtbase, it may take upto 30 minutes on an intel i5 with 1 GB RAM.


# Create /opt/qt/qtbase , which will hold the qt-prebuilt libraries. 
RUN mkdir -p /opt/qt/qtbase

# The "dev-build" was built using -developer-build option in the qt-540 configure script.
# The following will extract the contents of the tarball directly to the specified location, 
# without saving the tarball in the container image.
RUN wget http://192.168.122.1/qtbase-540-dev-build_centos-6664.tar.gz  -O - | tar -xz -C /opt/qt/qtbase

# Setup a developer user:
# -----------------------
RUN groupadd -r developer -g 1001 && useradd -u 1001 -r -g developer -m -d /home/developer -s /bin/bash -c "Developer" developer && echo "developer:testing" | chpasswd
  
# We can use VOLUME to map a user's project directory on the host to the Projects directory inside the container.
# This can be done on the Docker container runtime for this command. 
RUN mkdir /home/developer/Projects 



# The IP of the container can be found out usint the inspect command, after the container is started. 
# sudo docker inspect <ContainerID> | grep IPAddress
# or
# docker inspect --format '{{ .NetworkSettings.IPAddress }}' <ContainerID>

