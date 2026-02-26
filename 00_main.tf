terraform {
  # Définir la version minimale requise de Terraform
  required_version = ">= 1.9.8"
  # Déclaration des providers requis
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.12" # Version 4.12 minimum, sans montées majeures
    }
    ovh = {
      source  = "ovh/ovh"
      version = "1.1.0"
    }
  }
  # Configuration du backend local pour stocker l'état
  backend "local" {
    path = "msp.tfstate"
  }
}
# Configuration du provider AzureRM
provider "azurerm" {
  features {} # Toutes les fonctionnalités par défaut
  use_cli         = true
  subscription_id = "ca5c57dd-3aab-4628-a78c-978830d03bbd" # ID récupéré depuis le portail Azure
}

provider "ovh" {
  application_key    = "65040be6a1726dee"
  application_secret = "9985d7b912b934c24930a67d649b3020"
  consumer_key       = "c81935e522b7ce50100b46d910e383a6"
  endpoint           = "ovh-eu"
}

data "azurerm_resource_group" "msp" {
  name = var.resource_group_name
}
