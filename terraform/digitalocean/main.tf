/**
 * # DigitalOcean Project
 */
resource "digitalocean_project" "francrordriguezcom-infra" {
  name        = "francrodriguezcom-infra"
  description = "Infra para francrodriguez.com"
  purpose     = "web"
  environment = "production"
  resources = digitalocean_droplet.node.*.urn
}

data "digitalocean_ssh_key" "one" {
  name = "one"
}

/**
 * Create one or more droplets
 */

resource "digitalocean_droplet" "node" {
  count = var.node_count
  image  = "docker-20-04"
  name   = "node${count.index}"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  vpc_uuid    = "71bbce96-523f-4db9-b06e-f5fff6939df7"
  ssh_keys = [data.digitalocean_ssh_key.one.id]
}

/**
 * Useful to log in to the VM later
 */

output "nodes_ip" {
  value = digitalocean_droplet.node.0.ipv4_address
}

/**
* Update DNS Records
*/

# Add an A record to the domain for www.francrodriguez.com.
resource "digitalocean_record" "www" {
  domain = "francrodriguez.com"
  type   = "A"
  name   = "www"
  value  = digitalocean_droplet.node.0.ipv4_address
}
