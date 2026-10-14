
resource "azurerm_private_endpoint" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.private_endpoint.id

  custom_network_interface_name = var.network_interface_name

  private_service_connection {
    name                              = "${var.name}-connection"
    private_connection_resource_alias = var.private_link_service_alias
    is_manual_connection              = true
    request_message                   = "Private Link connection for CloudOps AI observability"
  }

  tags = var.tags
}
