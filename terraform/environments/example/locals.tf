locals {

  application_name = "example"

  environment_management = jsondecode(data.aws_secretsmanager_secret_version.environment_management.secret_string)

  # Merge tags from the environment json file with additional ones
  tags = merge(
    jsondecode(data.http.environments_file.response_body).tags,
    { "environment-name" = terraform.workspace },
    { "source-code" = "https://github.com/gabrielgcarvalho/cloud-intrastructure-hub" }
  )

}
