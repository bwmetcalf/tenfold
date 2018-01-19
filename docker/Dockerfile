FROM centos:6
MAINTAINER Brandon Metcalf "bwmetcalf@gmail.com"
 
ENV CONTAINER brandonmetcalf/udpserver

RUN yum install -y perl perl-JSON

ADD ./udpserver.pl /root/udpserver.pl

ENTRYPOINT ["perl"]
CMD ["/root/udpserver.pl"]
