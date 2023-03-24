variable "region" {
  type = string
}

variable "my-ip" {
  type      = string
  sensitive = true
}

variable "database-secrets" {
  type      = map(string)
  sensitive = true
}
