FROM almalinux:8.5 as builder

WORKDIR /root/kvrocks

RUN dnf install -y epel-release && dnf -y install 'dnf-command(config-manager)' && dnf -y config-manager --set-enabled powertools && dnf install -y git gcc gcc-c++ make snappy snappy-devel autoconf automake libtool which gtest gtest-devel redis

COPY . .

RUN make -j32

FROM almalinux:8.5

WORKDIR /data

RUN dnf install -y epel-release && dnf install -y redis ncurses
RUN mkdir /conf
COPY --from=builder /lib64/libsnappy.so.1 /lib64
COPY --from=builder /root/kvrocks/src/kvrocks /bin
COPY --from=builder /root/kvrocks/kvrocks.conf /conf/deafult.conf
ENTRYPOINT [ "kvrocks", "-c", "/conf/deafult.conf" ]

