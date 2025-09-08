#Tells Terraform it will be talking with Azure with AzureRM.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

#The resource group. Has a couple of tags, but more importantly the name and location variables will be referenced many, many times in future.
resource "azurerm_resource_group" "rg" {
  name     = "terraformed-resource-group-uksouth"
  location = "uksouth"
  #Tags aren't really necessary, but they're neat to stick onto stuff, right?
  tags = {
    Environment = "Testing"
    Owner       = "Jared"
  }
}


#Creates a storage account. This is just a simple blob storage. Access tier is hot as default, but I've put it here anyway.
#I have since modified this with the aim of hosting a static website. Right now, it does succeed at making a barebones proof of concept.
#
#My initial plan for this project was to create a CI/CD pipeline via GitHub Actions, but it seems like I can't do that on the Academy Azure subscription.
#I'm fairly sure I have created correct yaml and etc for it though, so I will just settle for deploying the website via Terraform and keep using the GitHub as just a repo.
#
#
resource "azurerm_storage_account" "storage" {
  name                     = "terraformedstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  static_website {
    index_document = "index.html"
  }
}



resource "azurerm_storage_blob" "indexblob"{
  name = "index.html"
  storage_account_name = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type = "Block"
  content_type = "text/html"
  source = "index.html"
}

resource "azurerm_storage_blob" "scriptblob"{
  name = "index.js"
  storage_account_name = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type = "Block"
  content_type = "text/javascript"
  source = "index.js"
}

resource "azurerm_storage_blob" "styleblob"{
  name = "mainpagelooks.css"
  storage_account_name = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type = "Block"
  content_type = "text/css"
  source = "mainpagelooks.css"
}
resource "azurerm_storage_blob" "musicblob"{
  name = "Jack-a-Dandy.mp3"
  storage_account_name = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type = "Block"
  source = "Jack-a-Dandy.mp3"
}