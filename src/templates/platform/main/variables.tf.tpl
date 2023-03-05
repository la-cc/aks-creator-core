variable "name" {
  type    = string
}

variable "orchestrator_version" {

  type    = string
  default = "1.24.9"

}

variable "kubernetes_version" {
  type    = string
  default = "1.24.9"
}

variable "location" {
  type    = string
  default = "westeurope"

}

{% if cluster.azure_public_dns.enable %}
variable "azure_cloud_zone" {

  type    = string

}
{% endif %}

variable "vm_size" {

  type    = string
  default = "Standard_B4ms"

}

variable "max_pods_per_node" {
  type    = number
  default = 45
}

variable "node_pool_count" {

  type    = number
}

variable "lock_name" {
  type        = string
  description = "Specifies the name of the Management Lock. Changing this forces a new resource to be created."
  default     = "delete lock on resource-group-level"
}

variable "lock_level" {
  type        = string
  description = "Specifies the Level to be used for this Lock. Possible values are CanNotDelete and ReadOnly. Changing this forces a new resource to be created."
  default     = "CanNotDelete"
}

variable "notes" {
  type        = string
  description = "Specifies some notes about the lock. Maximum of 512 characters. Changing this forces a new resource to be created."
  default     = "Locked, if you want remove the resourcegroup or a resource in this group, you must delete the lock first"
}

variable "network_plugin" {

  type    = string
  default = "azure"

}

variable "network_policy" {

  type    = string
  default = "calico"
}

variable "enable_node_pools" {

  type        = bool
  default     = false
  description = "Allow you to enable node pools"

}


variable "node_pools" {
  type = map(object({
    name                   = string
    vm_size                = string
    zones                  = list(string)
    enable_auto_scaling    = bool
    enable_host_encryption = bool
    enable_node_public_ip  = bool
    max_pods               = number
    node_labels            = map(string)
    node_taints            = list(string)
    os_disk_size_gb        = string
    max_count              = number
    min_count              = number
    node_count             = number
  }))

  description = <<-EOT
    If the default node pool is a Virtual Machine Scale Set, you can define additional node pools by defining this variable.
    As of Terraform 1.0 it is not possible to mark particular attributes as optional. If you don't want to set one of the attributes, set it to null.
  EOT

  default = {}
}


variable "tags" {
  type = map(string)
  default = {
    TF-Managed  = "true"
    Maintainer  = "HPA"
    TF-Worfklow = ""
    Owner       = "HSA"
    PoC         = "AKS"
  }
}