FROM ubuntu:16.04

RUN apt-get update && \
        apt-get install -y libtool automake  && \
        apt-get install -y bison flex && \
        apt-get install -y vim && \
        apt-get install -y dos2unix rpm wget git curl unzip && \
        apt-get install -y build-essential gcc-multilib \
                gcc-4.8-multilib g++-multilib g++-4.8-multilib \
                lib32z1 lib32ncurses5 libc6-dev libgmp-dev \
                libmpfr-dev libmpc-dev

ENV CGO_ENABLED=1
ENV GOOS=linux
ENV GOARCH=386
ENV GOPATH=/go
ENV PCAP_VERSION=1.9.1
ENV PATH=$PATH:/usr/local/go/bin

ADD deps deps

RUN dpkg -i --force-architecture deps/arista-fc18-gcc5-4-0.deb

ENV PATH=/opt/arista/fc18-gcc5.4.0/bin:$PATH

RUN \
        cd /tmp && \
        wget https://dl.google.com/go/go1.14.1.linux-amd64.tar.gz && \
        tar -xvf go1.14.1.linux-amd64.tar.gz && \
        mv go /usr/local && \
        rm /tmp/go1.14.1.linux-amd64.tar.gz && \
        wget http://www.tcpdump.org/release/libpcap-${PCAP_VERSION}.tar.gz && \
        tar xvf libpcap-${PCAP_VERSION}.tar.gz && \
        cd libpcap-${PCAP_VERSION} && \
        ./configure --host=i686-pc-linux-gnu --with-pcap=linux --prefix=/opt/libpcap-${PCAP_VERSION} && \
        make && make install

VOLUME [ "/eos_gopacket" ]

ENV CGO_LDFLAGS="-L/opt/libpcap-${PCAP_VERSION}/lib"
ENV CGO_CFLAGS="-I/opt/libpcap-${PCAP_VERSION}/include"

RUN go get github.com/google/gopacket/pcap

WORKDIR /eos_gopacket

#  go build main.go

CMD [ "go", "build", "."]
#ENTRYPOINT [ "/bin/bash" ]