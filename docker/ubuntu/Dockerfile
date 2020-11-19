FROM --platform=$TARGETPLATFORM ubuntu:bionic as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG CORES=1
ARG VER=master
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

# install dependencies
RUN apt-get update \
    && apt-get -y install wget curl git libz-dev \
    build-essential autoconf automake libtool pkg-config \
    libcurl4-openssl-dev libudev-dev libusb-1.0-0-dev libncurses5-dev \
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /opt \
  && git clone -b ${VER} https://github.com/kayuii/cgminer.git --depth=1 \
  && cd /opt/cgminer \
  && ./autogen.sh \
  && CFLAGS="-O2 -Wall -march=native" ./configure --host=${HOST} --target=arm-linux \
    --prefix=/usr/local/cgminer \
    --enable-icarus \
  && make -j${CORES} && make install \
  && strip /usr/local/cgminer/bin/arm-linux-cgminer

FROM --platform=$TARGETPLATFORM ubuntu:bionic

ARG OS

COPY --from=builder /usr/local/cgminer /usr/local/cgminer
COPY --from=builder /opt/cgminer/example.conf /etc/config/cgminer.conf
COPY --from=builder /opt/cgminer/docker/${OS}/docker-entrypoint.sh /entrypoint.sh

RUN apt-get update \
    && apt-get -y install libusb-1.0-0 libcurl4 gosu \
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# plugdev,dialout group for ttyUSB
RUN ln -s /usr/local/cgminer/bin/arm-linux-cgminer /bin/cgminer \
  && usermod -a -G plugdev nobody \
  && usermod -a -G dialout nobody 

WORKDIR /opt/

ENTRYPOINT ["/entrypoint.sh"]

CMD ["cgminer", "-c", "/etc/config/cgminer.conf"]
