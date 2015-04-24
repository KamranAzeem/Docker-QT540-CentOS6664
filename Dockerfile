FROM centos:6
MAINTAINER Kamran <kaz@praqma.net>
RUN yum -y update

# We believe network is already up, that is why yum will work. But what is the IP?
# How to we tell the IP to the user? Perhaps the user can attach to the container and find it out himself?

# Install some utils:
RUN yum -y install wget tar unzip pwgen system-config-keyboard  git
# Development tools download about 107 MB of packages (111 packages in total)
RUN yum -y groupinstall "Development Tools"
# We do not need dbus-qt that is why only selecting select few dbus packages
RUN yum -y install mesa-libGL* xorg-x11-xkb* xcb* libxcb* dbus dbus-c++* dbus-devel dbus-x11

## Disable SELINUX:
## RUN setenforce 0 && sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux

# SSH server:
# We may not need ssh server. The developer will probably use git to pull his source code into this machine,
# , using a local docker console, instead of a SSH session. Though SSH session can be useful.
# When SSH is enabled, you need to Forward the SSH traffic to the SSH service inside the container.
# If you need SSH service, enable the following two lines.
# RUN yum -y install openssh-server && chkconfig --add sshd && service sshd start 
# EXPOSE 22 22

# I don't understand that why docker recommends to execute this time wasting step to be done everytime we use yum
# I have put it below all yum install commands , only once.
RUN yum clean all

# Do we add a user? We can use root! What is the password of root? or is it managed by the base container?

# The path to this file will need to be changed. The file is a precompiled qtbase-5.4.0 on CentOS 6.6 64 bit.
# The precompiled version is simply copied inside /opt/qt/qtbase . 
# If you actually compile qtbase, it may take upto 30 minutes on an intel i5 with 1 GB RAM.
# First, download the precompiled qtbase file:
RUN wget http://192.168.122.1/qtbase-540_centos-6664.tar.gz -P /root/
# Then, unpack it to (/). 
# The tar file is built in a way that it contains all the paths to recreate.
# The following command will actually untar the contents into /opt/qt/qtbase,
# , so untar to the root (/) and it actually creates /opt/qt/qtbase and everything goes there.
RUN tar xzf /root/qtbase-540_centos-6664.tar.gz -C  /  

# May be we can use VOLUME command to map a user's project directory on the host to a directory inside the container?
# I don't like the idea though. Perhaps the user can simply clone his git repository inside the container and compile it.
# That should be more efficient and less moving parts. Also less confusion.

