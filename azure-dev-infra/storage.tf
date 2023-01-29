resource "azurerm_resource_group" "centralus-jennasrunbookstf" {
  name     = "centralus-jennasrunbookstf"
  location = "Central US"
}

resource "azurerm_storage_account" "jennasrunbookstfstate" {
  name                            = "jennasrunbookstfstate"
  resource_group_name             = azurerm_resource_group.centralus-jennasrunbookstf.name
  location                        = azurerm_resource_group.centralus-jennasrunbookstf.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "jennasrunbookstf" {
  name                  = "jennasrunbookstf"
  storage_account_name  = azurerm_storage_account.jennasrunbookstfstate.name
  container_access_type = "blob"
}

data "azurerm_storage_account_sas" "jennasrunbookstfstate" {
  connection_string = azurerm_storage_account.jennasrunbookstfstate.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = false
    object    = false
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2022-08-28T00:00:00Z"
  expiry = "2022-12-31T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = false
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}

output "sas_url_query_string" {
  value     = data.azurerm_storage_account_sas.jennasrunbookstfstate.sas
  sensitive = true
}
