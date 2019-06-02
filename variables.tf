locals {
  common_tags = {
    namespace = var.namespace
    owner     = var.owner
    env       = var.env
  }
}

variable "region" {
  type = string
}

variable "namespace" {
  type = string
}

variable "owner" {
  type = string
}

variable "env" {
  type    = string
  default = "global"
}

variable "bucket_suffix" {
  type = string
}

variable "extra_tags" {
  description = "Mapping of any extra tags you want added to resources"
  type        = map(string)
  default     = {}
}

