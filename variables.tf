variable "access_level" {
  description = "Access level user wants to provide to Cloudchipr."
  type        = string
  default     = "read_write" # "read" for Read Only access
}

variable "data" {
  description = "Takes as input the source Account ID and Unique Key as External ID for cross-account trust relationship"
  type        = string
}

variable "C8R_API_ENDPOINT" {
  description = "API Endpoint used to verify account setup process."
  type        = string
  default     = "https://api-bff.cloudchipr.com/providers/aws/account-attempts/"
}
