# Get the environments file from the main repository
data "http" "environments_file" {
  url = "https://raw.githubusercontent.com/gabrielgcarvalho/cloud-infrastructure-hub/main/environments/${local.application_name}.json"
}
