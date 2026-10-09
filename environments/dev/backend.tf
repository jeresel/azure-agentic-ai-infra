terraform {
  backend "azurerm" {
    resource_group_name  = "rg-agentic-ai-tfstate"
    storage_account_name = "stagenticaitf094b1972"
    container_name       = "tfstate"
    key                  = "agentic-ai/dev/terraform.tfstate"

    use_azuread_auth = true
    use_cli          = true
  }
}
