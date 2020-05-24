FROM dvillaj/hadoop-cluster-base
MAINTAINER dvillaj@gmail.com

WORKDIR /root

ADD scripts/bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh

CMD ["/etc/bootstrap.sh", "-d"]