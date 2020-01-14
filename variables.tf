

variable "bucket_suffix" {
  type = string
}

variable "region" {
  type = string
}

variable "tags" {
  description = "Mapping of any extra tags you want added to resources"
  type        = map(string)
  default     = {}
}
