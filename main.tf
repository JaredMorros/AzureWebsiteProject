#Tells Terraform it will be talking with Azure with AzureRM.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    github = {
      source = "integrations/github"
      version = "~> 5.12.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

provider "github" {
  token = "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"
  owner = "JaredMorros"
}

data "github_repository" "repo" {
  name = "AzureWebsiteProject"
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
#TODO:
#- I have to figure out how to have this reference a Github repo as its source, much like how I did my S3 static website.
#I'm not sure if I can simply put a github URL as my source. It's possible I might need a module with a github URL, then reference the module?

#- I have to do the same from GitHub's end via Github actions, so whenever that updates, the website does too.
#I've done this before, should be easy enough to do it again.

#- I need content for the website on Github.
#This should be fairly easy, I'm just making something simple that proves the website is active and that I can push changes.
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
  name = "mainpagecode.js"
  storage_account_name = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type = "Block"
  content_type = "text/javascript"
  source = "mainpagecode.js"
}

resource "azurerm_storage_blob" "styleblob"{
  name = "mainpagelooks.css"
  storage_account_name = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type = "Block"
  content_type = "text/css"
  source = "mainpagelooks.css"
}