provider "azurerm" {
  subscription_id            = var.subscription_id
  tenant_id                  = var.tenant_id
  version                    = 2.46
  skip_provider_registration = true
  features {}
}
resource "azurerm_app_service_plan" "asp" {
  name                = "appsp-dr-001"
  location            = var.region
  resource_group_name = var.rg_name
  sku {
    tier = "free"
    size = "B3"
    capacity = 1
  }

tags = {
    environment = "${var.tag_environment}"
                bu          = "${var.tag_bu}"
                application = "${var.tag_application}"
                team        = "${var.tag_team}"
                security    = "${var.tag_security}"
                maintainer  = "${var.tag_maintainer}"
                country     = "${var.tag_country}"
                type        = "appsp"
                deployement = "${var.tag_deployement}"
    }

}

resource "azurerm_app_service" "apps" {
  count               = 3
  name                = "test-drf-webapp-00${count.index}"
  location            = var.region
  resource_group_name = var.rg_name
  app_service_plan_id = azurerm_app_service_plan.asp.id
  https_only = true

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "WEBSITE_DNS_SERVER" = "10.0.0.1"
    "WEBSITE_ALT_DNS_SERVER" = "10.10.10.1"
  }

    backup {
    name                     = "webapp_prd_bckp${count.index}"
    enabled                  = "true"
    storage_account_url      = "https://${azurerm_storage_account.storage.name}.blob.core.windows.net/${azurerm_storage_container.container.name}${data.azurerm_storage_account_sas.sas.sas}&sr=b"    

  schedule {
    frequency_interval            = "1"
    frequency_unit                = "Day"
    keep_at_least_one_backup      = "true"
    start_time                    = "2021-12-13T23:00:00.52+02:00"
    }
    }

  tags = {
    environment = "${var.tag_environment}"
                bu          = "${var.tag_bu}"
                application = "${var.tag_application}"
                team        = "${var.tag_team}"
                security    = "${var.tag_security}"
                maintainer  = "${var.tag_maintainer}"
                country     = "${var.tag_country}"
                type        = "webapp"
                deployement = "${var.tag_deployement}"
    }
}

resource "azurerm_sql_server" "sqlServer" {
  name                         = var.sqlServerName
  resource_group_name          = var.rg_name
  location                     = var.region
  version                      = "12.0"
  administrator_login          = var.adminLogin
  administrator_login_password = var.adminPWD

  tags = {
        environment = var.tag_environment
        bu          = var.tag_bu
        application = var.tag_application
        team        = var.tag_team
        security    = var.tag_security
        maintainer  = var.tag_maintainer
        country     = var.tag_country
        deployement = var.tag_deployement
  }

}

resource "azurerm_sql_database" "sqlDB" {
  name                = var.dbName
  resource_group_name = var.rg_name
  location            = var.region
  server_name         = azurerm_sql_server.sqlServer.name
  create_mode = "Default"
  max_size_bytes = "268435456000"
  edition = "Standard"
  requested_service_objective_name = "S0"
}

resource "azurerm_storage_account" "storage" {
  name                     = "accstordr001"
  resource_group_name      = var.rg_name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "GRS"

tags = {
    environment = "${var.tag_environment}"
                bu          = "${var.tag_bu}"
                application = "${var.tag_application}"
                team        = "${var.tag_team}"
                security    = "${var.tag_security}"
                maintainer  = "${var.tag_maintainer}"
                country     = "${var.tag_country}"
                type        = "storage"
                deployement = "${var.tag_deployement}"
    }
}

resource "azurerm_storage_container" "container" {
  name                  = "backups"
  storage_account_name  = "${azurerm_storage_account.storage.name}"
  container_access_type = "private"
}

data "azurerm_storage_account_sas" "sas" {
  connection_string = "${azurerm_storage_account.storage.primary_connection_string}"
  https_only        = true

  resource_types {
    service   = false
    container = false
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2021-12-13"
  expiry = "2031-12-13"

  permissions {
    read    = false
    write   = true
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
  }
}
