terraform {
  required_version = ">= 1.0"
  required_providers {
    bitwarden-secrets = {
      source  = "bitwarden/bitwarden-secrets"
      version = "1.0.0"
    }
    unifi = {
      source  = "ubiquiti-community/unifi"
      version = "0.55.0"
    }
  }

  backend "pg" {
    schema_name = "unifi"
  }
}

provider "bitwarden-secrets" {
  api_url         = "https://api.bitwarden.com"
  identity_url    = "https://identity.bitwarden.com"
  access_token    = var.access_token
  organization_id = var.organization_id
}

provider "unifi" {
  api_url        = "https://192.168.0.1"
  api_key        = yamldecode(data.bitwarden-secrets_secret.unifi.value).UNIFI_API_KEY
  allow_insecure = true
}
