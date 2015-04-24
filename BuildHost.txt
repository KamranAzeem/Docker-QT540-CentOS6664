Building  a docker container with (qtbase 540 on centos 66 64 bit) on Fedora:
Author: Kamran Azeem 
###############################


The Dockerfile is provided separately in this git repository.

[kamran@kworkhorse Qtbase-540_CENTOS-6664]$ sudo docker build -t qt540-centos6664 
. . . 
(after many minutes).
. . . 
 ---> d58a9b8520f4
Removing intermediate container fcce3421fba2
Successfully built d58a9b8520f4
[kamran@kworkhorse Qtbase-540_CENTOS-6664]$


[kamran@kworkhorse Qtbase-540_CENTOS-6664]$ sudo docker images
[sudo] password for kamran:
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
qt540-centos6664    latest              d58a9b8520f4        21 seconds ago      977.7 MB
centos              6                   b9aeeaeb5e17        40 hours ago        202.6 MB
centos              centos6             b9aeeaeb5e17        40 hours ago        202.6 MB
centos              centos7             fd44297e2ddb        40 hours ago        215.7 MB
centos              latest              fd44297e2ddb        40 hours ago        215.7 MB
centos              7                   fd44297e2ddb        40 hours ago        215.7 MB
[kamran@kworkhorse Qtbase-540_CENTOS-6664]$

Start the container and connect to it:

[kamran@kworkhorse Qtbase-540_CENTOS-6664]$ sudo docker run -i -t qt540-centos6664 /bin/bash

Here we are inside the container:

[root@4ffc2c8983b9 /]# df -hT
Filesystem           Type   Size  Used Avail Use% Mounted on
/dev/mapper/docker-253:0-1465401-4ffc2c8983b98903fecf810620c9c65b381488376285c6c799b0b0ce7c4ffa1a
                     ext4   9.8G  845M  8.4G   9% /
tmpfs                tmpfs  3.7G     0  3.7G   0% /dev
shm                  tmpfs   64M     0   64M   0% /dev/shm
/dev/mapper/fedora-root
                     ext4    50G   13G   35G  27% /etc/resolv.conf
/dev/mapper/fedora-root
                     ext4    50G   13G   35G  27% /etc/hostname
/dev/mapper/fedora-root
                     ext4    50G   13G   35G  27% /etc/hosts
tmpfs                tmpfs  3.7G     0  3.7G   0% /proc/kcore

Our prebuilt qtbase:

[root@4ffc2c8983b9 /]# ls /opt/qt/qtbase/
bin  doc  include  lib  mkspecs  plugins

[root@4ffc2c8983b9 /]# du -sh /opt/qt/qtbase/
61M    /opt/qt/qtbase/
[root@4ffc2c8983b9 /]#

It is already on the network:
[root@4ffc2c8983b9 /]# ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:1C  
          inet addr:172.17.0.28  Bcast:0.0.0.0  Mask:255.255.0.0
          inet6 addr: fe80::42:acff:fe11:1c/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:8 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:648 (648.0 b)  TX bytes:648 (648.0 b)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

[root@4ffc2c8983b9 /]#


SELINUX is already disabled:

[root@4ffc2c8983b9 /]# getenforce
Disabled
[root@4ffc2c8983b9 /]#

Actually there is no /etc/sysconfig/selinux file on the system. That is why we don’t need to disable it in Dockerfile. If we try it exits with an error code and we cannot build a container.

Once finished working with it, here is how you stop it. 

Disconnect / detach from this session using Ctrl+p, Ctrl+q. 

DO NOT press Ctrl+c . Here is how it looks when you disconnect properly:

[root@4ffc2c8983b9 /]# [kamran@kworkhorse Qtbase-540_CENTOS-6664]$ 

Check images:
[root@4ffc2c8983b9 /]# [kamran@kworkhorse Qtbase-540_CENTOS-6664]$ sudo docker images

[sudo] password for kamran:
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
qt540-centos6664    latest              d58a9b8520f4        14 minutes ago      977.7 MB
centos              6                   b9aeeaeb5e17        40 hours ago        202.6 MB
centos              centos6             b9aeeaeb5e17        40 hours ago        202.6 MB
centos              latest              fd44297e2ddb        40 hours ago        215.7 MB
centos              7                   fd44297e2ddb        40 hours ago        215.7 MB
centos              centos7             fd44297e2ddb        40 hours ago        215.7 MB

Check running containers:

[kamran@kworkhorse Qtbase-540_CENTOS-6664]$ sudo docker ps
CONTAINER ID        IMAGE                     COMMAND             CREATED             STATUS              PORTS               NAMES
4ffc2c8983b9        qt540-centos6664:latest   "/bin/bash"         5 minutes ago       Up 5 minutes                            fervent_bardeen          
4b93000791ed        centos:6                  "/bin/bash"         5 hours ago         Up 3 hours                              compassionate_mccarthy   
[kamran@kworkhorse Qtbase-540_CENTOS-6664]$ 

Stop running containers:

[kamran@kworkhorse Qtbase-540_CENTOS-6664]$ sudo docker stop fervent_bardeen
fervent_bardeen

[kamran@kworkhorse Qtbase-540_CENTOS-6664]$ sudo docker stop compassionate_mccarthy
compassionate_mccarthy

Check if there are any running containers:

[kamran@kworkhorse Qtbase-540_CENTOS-6664]$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

The images should still exist (of-course):

[kamran@kworkhorse Qtbase-540_CENTOS-6664]$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
qt540-centos6664    latest              d58a9b8520f4        15 minutes ago      977.7 MB
centos              6                   b9aeeaeb5e17        40 hours ago        202.6 MB
centos              centos6             b9aeeaeb5e17        40 hours ago        202.6 MB
centos              latest              fd44297e2ddb        40 hours ago        215.7 MB
centos              7                   fd44297e2ddb        40 hours ago        215.7 MB
centos              centos7             fd44297e2ddb        40 hours ago        215.7 MB
[kamran@kworkhorse Qtbase-540_CENTOS-6664]$


