terraform {
  required_providers {
    mso = {
      source  = "CiscoDevNet/mso"
      version = ">= 0.4.1"
    }
  }
}

provider "mso" {
  username = var.mso_username
  password = var.mso_password
  url      = var.mso_url
  insecure = true
  platform = "nd"
  domain   = "dcmdr1"
}

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
