############################
# Variables globales MSP
############################

variable "resource_group_name" {
  description = "Nom du groupe de ressources Azure"
  type        = string
  default     = "rg-MBailleul2024_cours-adminazure-projet"
}

variable "location" {
  description = "Localisation Azure (région)"
  type        = string
  default     = "France Central"
}

############################
# Azure Provider
############################

variable "subscription_id" {
  description = "Azure Subscription ID (évite de hardcoder dans 00_main.tf)"
  type        = string
  default     = "ca5c57dd-3aab-4628-a78c-978830d03bbd"
}

############################
# OVH Provider (DNS public)
# ⚠️ Idéalement: ne pas commit ces valeurs.
# Utilise plutôt un terraform.tfvars non versionné ou des variables d'environnement.
############################

variable "ovh_endpoint" {
  description = "Endpoint OVH (ex: ovh-eu)"
  type        = string
  default     = "ovh-eu"
}

variable "ovh_application_key" {
  description = "OVH application key"
  type        = string
  sensitive   = true
}

variable "ovh_application_secret" {
  description = "OVH application secret"
  type        = string
  sensitive   = true
}

variable "ovh_consumer_key" {
  description = "OVH consumer key"
  type        = string
  sensitive   = true
}

variable "ovh_zone" {
  description = "Zone DNS OVH (domaine)"
  type        = string
  default     = "formateur-devops.ovh"
}

variable "firewall_public_subdomain" {
  description = "Sous-domaine public du firewall (ex: firewall -> firewall.domaine.ovh)"
  type        = string
  default     = "firewall"
}

variable "bastion_public_subdomain" {
  description = "Sous-domaine public bastion (ex: bastion -> bastion.domaine.ovh)"
  type        = string
  default     = "bastion"
}

variable "wordpress_public_subdomain" {
  description = "Sous-domaine public wordpress (ex: wordpress -> wordpress.domaine.ovh)"
  type        = string
  default     = "wordpress"
}

############################
# DNS privé Azure
############################

variable "private_dns_zone_name" {
  description = "Zone DNS privée interne Azure (celle de P1-4_dns_private.tf)"
  type        = string
  default     = "correction.interne.azure"
}

############################
# VMs (si tu veux factoriser)
############################

variable "vm_admin_username" {
  description = "Compte admin Linux (Bastion / WordPress)"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Chemin local vers la clé publique SSH (ex: ~/.ssh/id_rsa.pub)"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

############################
# MySQL Flexible Server (si tu veux enlever le hardcode)
############################

variable "mysql_flexible_server_name" {
  description = "Nom du serveur MySQL flexible (doit être unique)"
  type        = string
  default     = "spoke-wordpressmb-msp"
}

variable "mysql_admin_login" {
  description = "Login admin MySQL flexible server"
  type        = string
  default     = "formateur"
}

variable "mysql_admin_password" {
  description = "Mot de passe admin MySQL flexible server"
  type        = string
  sensitive   = true
  default     = "Pa$$w0rd"
}
