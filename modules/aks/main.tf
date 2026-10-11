resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name

  sku_tier = "Free"

  default_node_pool {
    name                        = "system"
    node_count                  = 1
    vm_size                     = var.vm_size
    vnet_subnet_id              = var.subnet_id
    auto_scaling_enabled        = false
    temporary_name_for_rotation = "tempnode"

    upgrade_settings { 
      max_surge = "10%"
      }
  }

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  role_based_access_control_enabled = true
  local_account_disabled            = false

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"
    pod_cidr            = "10.244.0.0/16"
    service_cidr        = "10.30.0.0/16"
    dns_service_ip      = "10.30.0.10"
    outbound_type       = "loadBalancer"
  }

  tags = var.tags
}