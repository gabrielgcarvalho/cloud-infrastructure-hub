FROM golang:1.20-bullseye

RUN apt-get update && apt-get install -y git \
    curl \
    jq

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]