
# required plugins
packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
    vagrant = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

# variables
variable "ssh_username" {
  type      = string
  sensitive = false
}

variable "ssh_password" {
  type      = string
  sensitive = true
}

variable "ubuntu_iso_local" {
  type      = string
  sensitive = false
}

variable "ubuntu_iso_link" {
  type      = string
  sensitive = false
}

variable "ubuntu_iso_checksum" {
  type      = string
  sensitive = false
}

variable "vagrant_cloud_access_token" {
  type      = string
  sensitive = true
}

variable "vagrant_cloud_box_tag" {
  type      = string
  sensitive = false
}

variable "vagrant_cloud_version" {
  type      = string
  sensitive = false
}

variable "vagrant_cloud_version_description" {
  type      = string
  sensitive = false
}

# builder type and identifier of the source
source "virtualbox-iso" "ubuntu-server" {

  # iso file
  iso_urls = [
    var.ubuntu_iso_local,
    var.ubuntu_iso_link
  ]
  iso_checksum = var.ubuntu_iso_checksum

  # run without gui
  headless = false

  # virtualbox vm type
  guest_os_type  = "Ubuntu_64"

  # hardware
  cpus           = 3
  memory         = 2048
  sound          = null
  usb            = true
  nic_type       = "82545EM"
  gfx_controller = "vmsvga"
  gfx_vram_size  = 128

  # http dirctory to serve cloud init conf
  http_directory = "http"

  # communicator
  ssh_username           = var.ssh_username
  ssh_password           = var.ssh_password
  ssh_timeout            = "60m"
  ssh_handshake_attempts = 3600

  # IMPORTANT! replace .HTTPIP by actual IP of host machine in windows hosts

  # boot
  boot_wait = "5s"
  boot_command = [
    "c",
    "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
    "<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>"
  ]

  # export vm to single file
  format = "ova"

  # shutdown
  shutdown_command = "sudo -S shutdown -P now"
}

# build configuration
build {
  sources = [
    "sources.virtualbox-iso.ubuntu-server"
  ]

  post-processors {
    post-processor "vagrant" {
      provider_override = "virtualbox"
      output            = "output/packer_{{.BuildName}}_{{.Provider}}.box"
    }

    post-processor "vagrant-cloud" {
      access_token        = var.vagrant_cloud_access_token
      box_tag             = var.vagrant_cloud_box_tag
      version             = var.vagrant_cloud_version
      version_description = var.vagrant_cloud_version_description
    }
  }
}
