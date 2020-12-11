FROM genee/gini-alpine:latest
MAINTAINER PiHiZi <pihizi@msn.com>

# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/oci8/instantclient_12_1/
ENV LD_LIBRARY_PATH /opt/oci8/instantclient_12_1/

RUN apk add --update --no-cache \
    g++ \
    gcc \
    make \
    libc6-compat \
    libaio-dev \
    php7-dev \
    php7-soap \
    php7-pear

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --update libaio libnsl

RUN ln -s /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1

RUN mkdir -p /opt/oci8

COPY ./oci/instantclient-basic-linux.x64-12.1.0.2.0.zip /opt/oci8
COPY ./oci/instantclient-sdk-linux.x64-12.1.0.2.0.zip /opt/oci8
COPY ./oci/oci8-2.1.7.tgz /opt/oci8

RUN cd /opt/oci8 \
    && unzip instantclient-sdk-linux.x64-12.1.0.2.0.zip \
    && unzip instantclient-basic-linux.x64-12.1.0.2.0.zip \
    && cd instantclient_12_1/ \
    && ln -s libclntsh.so.12.1 libclntsh.so \
    && ln -s libocci.so.12.1 libocci.so \
    && cd ../ \
    && tar xzf oci8-2.1.7.tgz \
    && cd oci8-2.1.7 \
    && phpize \
    && ./configure --with-oci8=shared,instantclient,/opt/oci8/instantclient_12_1 \
    && make \
    && make install \
    && echo "extension=oci8.so" >> /etc/php7/conf.d/oci8.ini \
    && cd /opt/oci8 \
    && rm *.zip \
    && rm *.tgz

EXPOSE 9000

CMD ["/start"]
