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

# Network Resource
resource "docker_network" "app_network" {
  name = "app_network"
}

# Database Container (Implicit Dependency)
resource "docker_container" "db" {
  name  = "db_container"
  image = "postgres:latest" # Example database image
  networks_advanced {
    name = docker_network.app_network.name
  }
}

# Application Container (Explicit Dependency)
resource "docker_container" "app" {
  name  = "app_container"
  image = "my-app-image:latest" # Replace with your application image

  networks_advanced {
    name = docker_network.app_network.name
  }

  # Explicitly declare dependency on the db container
  depends_on = [
    docker_container.db
  ]
}
