terraform {
  required_version = ">= 1.0"
  required_providers {
    bitwarden-secrets = {
      source  = "bitwarden/bitwarden-secrets"
      version = "1.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.20.0"
    }
  }

  backend "pg" {
    schema_name = "cloudflare"
  }
}

provider "bitwarden-secrets" {
  api_url         = "https://api.bitwarden.com"
  identity_url    = "https://identity.bitwarden.com"
  access_token    = var.access_token
  organization_id = var.organization_id
}

provider "cloudflare" {
  api_token = yamldecode(data.bitwarden-secrets_secret.cloudflare.value).CLOUDFLARE_DNS_TOKEN
}
