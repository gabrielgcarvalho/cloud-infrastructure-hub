locals {

  application_name = "example"

  # Merge tags from the environment json file with additional ones
  tags = merge(
    jsondecode(data.http.environments_file.response_body).tags,
    { "environment-name" = terraform.workspace },
    { "source-code" = "https://github.com/gabrielgcarvalho/cloud-intrastructure-hub" }
  )

  ami = "ami-0efbb9b523fbc6c53"
}
