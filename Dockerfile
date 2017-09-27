FROM genee/gini:latest
MAINTAINER PiHiZi <pihizi@msn.com>

ADD oci/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm /tmp/oracle.rpm
RUN apt-get install -y alien libaio1
RUN alien -i /tmp/oracle.rpm

ADD oci/oci8.so /usr/lib/php5/20131226/oci8.so
RUN echo "extension=oci8.so" > /etc/php5/mods-available/oci8.ini
RUN php5enmod oci8

EXPOSE 9000

CMD ["/start"]
