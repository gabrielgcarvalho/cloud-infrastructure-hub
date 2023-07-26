variable "ami" {
  type    = string
  default = "ami-0efbb9b523fbc6c53" # amazon linux 
}

variable "env" {
  type    = string
  default = "Dev"
}

variable "user_data_base64" {
  type    = string
  default = ""
}
