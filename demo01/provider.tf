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
