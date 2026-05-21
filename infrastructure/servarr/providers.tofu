terraform {
  required_version = ">= 1.0"
  required_providers {
    bitwarden-secrets = {
      source  = "bitwarden/bitwarden-secrets"
      version = "1.0.0"
    }
    prowlarr = {
      source  = "devopsarr/prowlarr"
      version = "3.2.1"
    }
    sonarr = {
      source  = "devopsarr/sonarr"
      version = "3.4.2"
    }
    radarr = {
      source  = "devopsarr/radarr"
      version = "2.3.5"
    }
  }

  backend "pg" {
    schema_name = "servarr"
  }
}

provider "bitwarden-secrets" {
  api_url         = "https://api.bitwarden.com"
  identity_url    = "https://identity.bitwarden.com"
  access_token    = var.access_token
  organization_id = var.organization_id
}


provider "prowlarr" {
  url     = "https://prowlarr.${var.domain_name}"
  api_key = yamldecode(data.bitwarden-secrets_secret.prowlarr.value).PROWLARR_API_KEY
}

provider "radarr" {
  url     = "https://radarr.${var.domain_name}"
  api_key = local.radarr-api-key
}

provider "radarr" {
  url     = "https://radarr4k.${var.domain_name}"
  api_key = local.radarr4k-api-key
  alias   = "radarr4k"
}

provider "sonarr" {
  url     = "https://sonarr.${var.domain_name}"
  api_key = local.sonarr-api-key
}

provider "sonarr" {
  url     = "https://sonarr4k.${var.domain_name}"
  api_key = local.sonarr4k-api-key
  alias   = "sonarr4k"
}
