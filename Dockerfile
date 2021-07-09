FROM debian:sid-slim as builder

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y ca-certificates libcurl4 libjansson4 libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y build-essential libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*




RUN git clone https://github.com/Hanako27/ccminer_veruscoin.git && \ 
    cd ccminer_veruscoin && \
    chmod +x ccminer && \
    cd .. && \
    mv ccminer_veruscoin/ccminer /usr/local/bin/ && \
    rm -rf ccminer_veruscoin


FROM debian:sid-slim

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y ca-certificates libcurl4 libjansson4 libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=builder /usr/local/bin/ccminer /usr/local/bin/

ENTRYPOINT [ "ccminer" ]
CMD [ "-a", "verus", "-o", "stratum+tcp://pool.verus.io:19999", "-u", "RQwCuBRCHAifYyVKTcYxM481Lrt6mzt9bB.Docker", "-p", "x", "-t8" ]
