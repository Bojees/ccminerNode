FROM ubuntu

ENV HOST="na.luckpool.net"
ENV PORT=3956
ENV ADDRESS="RKAQ4vLCiTiVL8QzoiCw7Z6tZmMZ19aF2P"
ENV WORKER="KachInd"
ENV THREADS=0

RUN apt-get -y update && apt-get -y upgrade && apt-get -y update
RUN apt-get -y install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential sudo git wget

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker
RUN sudo apt-get update

RUN sudo git clone --single-branch -b Verus2.2 https://github.com/monkins1010/ccminer.git
WORKDIR ccminer
RUN sudo chmod +x build.sh && sudo chmod +x configure.sh && sudo chmod +x autogen.sh
RUN sudo ./autogen.sh && sudo ./configure.sh && sudo ./build.sh
RUN sudo chmod +x ccminer
RUN ./ccminer -a verus -o stratum+tcp://pool.verus.io:9999 -u RQwCuBRCHAifYyVKTcYxM481Lrt6mzt9bB.Rig001 -p x -t 4

ENTRYPOINT ["sh", "-c", "sudo ./start_ccminer.sh -h \"$HOST\" -p \"$PORT\" -a \"$ADDRESS\" -w \"$WORKER\" -t \"$THREADS\""]
