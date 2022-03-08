# Cisco MSO provider variables
variable "mso_url" {
  description = "URL for CISCO MSO/NDO"
}

variable "mso_username" {
  description = "This is the Cisco MSO/NDO username, which is required to authenticate with CISCO MSO/NDO"
  default     = "terraform"
}

variable "mso_password" {
  description = "Password of the user mentioned in username argument."
  sensitive   = true
}
