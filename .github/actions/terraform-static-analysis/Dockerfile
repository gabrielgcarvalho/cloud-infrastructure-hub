FROM alpine:3.14.10

# Install required packages
RUN apk update && apk add --no-cache \
    bash \
    git \
    unzip \
    curl \
    ca-certificates

# Install tflint
RUN curl -Lo /tmp/install_tflint.sh https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh \
    && chmod +x /tmp/install_tflint.sh \
    && /tmp/install_tflint.sh \
    && rm /tmp/install_tflint.sh

COPY entrypoint.sh /entrypoint.sh
COPY tflint-configs /tflint-configs
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]