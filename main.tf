locals {
  app_name = "darkfire-realm"
  image_name = "registry.fly.io/${local.app_name}:latest"
}

resource "fly_app" "app" {
  name = local.app_name
  org  = "personal"
}

resource "fly_ip" "appIp" {
  app        = fly_app.app.name
  type       = "v4"
  depends_on = [fly_app.app]
}

resource "fly_ip" "appIpv6" {
  app        = fly_app.app.name
  type       = "v6"
  depends_on = [fly_app.app]
}

resource "docker_registry_image" "image" {
  name          = docker_image.image.name
  keep_remotely = true
  depends_on = [fly_app.app]
}

resource "docker_image" "image" {
  name = local.image_name
  build {
    context = "."
  }
}

resource "fly_machine" "machine" {
  app    = fly_app.app.name
  region = "ams"
  name   = local.app_name
  image  = local.image_name
  services = [
    {
      ports = [
        {
          port     = 443
          handlers = ["tls", "http"]
        },
        {
          port     = 80
          handlers = ["http"]
        }
      ]
      "protocol" : "tcp",
      "internal_port" : 80
    },
  ]
  cpus = 1
  memorymb = 256
  depends_on = [fly_app.app, docker_registry_image.image]
}
