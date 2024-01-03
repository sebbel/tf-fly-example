terraform {
  required_providers {
    fly = {
      source = "fly-apps/fly"
      version = "0.0.23"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "fly" {}
provider "docker" {
  registry_auth {
    address     = "registry.fly.io"
    config_file = pathexpand("~/.docker/config.json")
  }
}
