FROM ubuntu:latest 

# Installing dependencies and nano for live in-container troubleshooting and debugging.
RUN apt-get update && apt-get install -y \
    python3 \
    iputils-ping \
    iproute2 \
    nano \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/sentinel

COPY system_audit.sh network_scanner.py ./

RUN chmod +x system_audit.sh

CMD ["/bin/bash"]
