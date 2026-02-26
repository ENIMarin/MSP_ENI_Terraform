variable "resource_group_name" {
  description = "Nom du groupe de ressources Azure"
  type        = string
  default     = "rg-MAudoire2025_cours-adminazure-projet"
}

variable "location" {
  description = "Localisation Azure (région)"
  type        = string
  default     = "France Central"
}
