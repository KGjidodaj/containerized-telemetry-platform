FROM ubuntu:22.04

# Installing dependencies and nano for live in-container troubleshooting and debugging.
RUN apt-get update && apt-get install -y \
    python3 \
    iputils-ping \
    iproute2 \
    nano \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/sentinel

RUN mkdir logs

COPY system_audit.sh network_scanner.py ./

RUN chmod +x system_audit.sh

CMD ["/bin/bash"]
