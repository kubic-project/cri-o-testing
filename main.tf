provider "libvirt" {
  uri = "qemu:///system"
}

data "template_file" "user_data" {
  template = "${file("cloud-init.yml")}"

  vars {
    password = "${var.password}"
  }
}

resource "random_pet" "name" {}

resource "libvirt_volume" "kubic" {
  name   = "kubic-${random_pet.name.id}-qcow2"
  pool   = "default"
  source = "https://download.opensuse.org/repositories/devel:/kubic:/images:/experimental/images/openSUSE-Tumbleweed-Kubic.x86_64-15.0-kubeadm-cri-o-kvm-and-xen-Build13.12.qcow2"
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit-${random_pet.name.id}.iso"
  user_data = "${data.template_file.user_data.rendered}"
}

resource "libvirt_domain" "kubic" {
  name      = "kubic-terraform-${random_pet.name.id}"
  memory    = "${var.memory}"
  cloudinit = "${libvirt_cloudinit_disk.commoninit.id}"
  vcpu      = "${var.cpu}"

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = "${libvirt_volume.kubic.id}"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }
}

locals {
  host = "${libvirt_domain.kubic.network_interface.0.addresses.0}"
}

module "setup" {
  source       = "modules/setup"
  host         = "${local.host}"
  password     = "${var.password}"
  pr           = "${var.pr}"
  dependencies = ["libvirt_domain.kubic"]
}

module "unit" {
  source       = "modules/unit"
  host         = "${local.host}"
  password     = "${var.password}"
  dependencies = ["${module.setup.depended_on}"]
}

module "critest" {
  source       = "modules/critest"
  host         = "${local.host}"
  password     = "${var.password}"
  dependencies = ["${module.setup.depended_on}"]
}

module "integration" {
  source       = "modules/integration"
  host         = "${local.host}"
  password     = "${var.password}"
  dependencies = ["${module.setup.depended_on}"]
}

module "e2e-node" {
  source       = "modules/e2e-node"
  host         = "${local.host}"
  password     = "${var.password}"
  dependencies = ["${module.setup.depended_on}"]
}
