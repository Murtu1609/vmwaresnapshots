provider "vsphere" {
  user           = var.vsphereuser
  password       = var.vspherepassword
  vsphere_server = var.vsphereserver

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

