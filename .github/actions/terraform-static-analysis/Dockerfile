FROM alpine:3.14.10

# Install required packages
RUN apk update && apk add --no-cache \
    bash \
    git \
    unzip

# Install Terraform
ENV TERRAFORM_VERSION=1.0.0
RUN wget -O terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && unzip terraform.zip -d /usr/local/bin \
    && rm terraform.zip

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]