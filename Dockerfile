FROM genee/gini:latest
MAINTAINER PiHiZi <pihizi@msn.com>

ADD oci/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm /tmp/oracle.rpm
RUN apt-get install -y alien libaio1
RUN alien -i /tmp/oracle.rpm

ADD oci/oci8.so /usr/lib/php5/20131226/oci8.so
RUN echo "extension=oci8.so" > /etc/php5/mods-available/oci8.ini
RUN php5enmod oci8

RUN apt-get install -yq npm && ln -sf /usr/bin/nodejs /usr/bin/node && npm install -g less less-plugin-clean-css uglify-js && npm cache clean -f && npm install -g n && n stable && ln -sf /usr/local/n/versions/node/11.8.0/bin/node /usr/bin/node

EXPOSE 9000

CMD ["/start"]
