terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

#resource "docker_image" "python" {
# name         = "python:3.9"
# keep_locally = false
# }

resource "docker_volume" "python_code" {
  name = "python_code_volume"
}

resource "docker_container" "python_dev" {
  image = docker_image.python.name
  name  = "python_dev_container"
  volumes {
    volume_name    = docker_volume.python_code.name
    container_path = "/app"
  }
  command = ["tail", "-f", "/dev/null"]
  ports {
    internal = 5000
    external = 5000
  }
}

