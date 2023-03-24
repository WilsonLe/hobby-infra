variable "region" {
  type = string
}

variable "db-allowed-ips" {
  type      = list(string)
  sensitive = true
}

variable "database-secrets" {
  type      = map(string)
  sensitive = true
}
