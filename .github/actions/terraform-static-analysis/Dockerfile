FROM golang:1.20-bullseye

# Install required packages
RUN apt-get update && apt-get install -y git \
    unzip \
    curl \
    ca-certificates \
    jq \
    python3 \
    python3-pip

# Install tflint
RUN curl -Lo /tmp/install_tflint.sh https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh \
    && chmod +x /tmp/install_tflint.sh \
    && /tmp/install_tflint.sh \
    && rm /tmp/install_tflint.sh

# Install Checkov
RUN pip3 install --upgrade pip && pip3 install --upgrade setuptools
RUN pip3 install checkov

COPY entrypoint.sh /entrypoint.sh
COPY tflint-configs /tflint-configs
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]