terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.16.0"
    }
  }
}

variable DIGITALOCEAN_ACCESS_TOKEN {}

provider "digitalocean" {
  token = var.DIGITALOCEAN_ACCESS_TOKEN
}

resource "digitalocean_kubernetes_cluster" "dokc" {
  name   = "dokc"
  region = "lon1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.21.5-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}
