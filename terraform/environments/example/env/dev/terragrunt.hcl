include "root" {
    path = find_in_parent_folders()
}

locals {
  webpage    = base64encode(templatefile(find_in_parent_folders("template/index.html"), { env = "dev" }))
  nginx_conf = filebase64(find_in_parent_folders("template/hello.conf"))
}

inputs = {
    user_data_base64 = base64encode(templatefile(find_in_parent_folders("scripts/user_data.sh"), { nginx_conf = local.nginx_conf, webpage = local.webpage }))
}
