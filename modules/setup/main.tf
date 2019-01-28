data "template_file" "setup_script" {
  template = "${file("${path.module}/setup.sh")}"
}

data "template_file" "configure_script" {
  template = "${file("${path.module}/configure.sh")}"

  vars {
    pr = "${var.pr}"
  }
}

resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

resource "null_resource" "setup" {
  depends_on = ["null_resource.dependency_getter"]

  connection {
    host     = "${var.host}"
    password = "${var.password}"
  }

  provisioner "file" {
    source      = "${path.module}/assets/10-crio-bridge.conf"
    destination = "/etc/cni/net.d/10-crio-bridge.conf"
  }

  provisioner "file" {
    source      = "${path.module}/assets/crio.conf"
    destination = "/root/crio.conf"
  }

  provisioner "remote-exec" {
    inline = "${data.template_file.setup_script.rendered}"
  }
}

resource "null_resource" "configure" {
  depends_on = ["null_resource.setup"]

  connection {
    host     = "${var.host}"
    password = "${var.password}"
  }

  provisioner "remote-exec" {
    inline = "${data.template_file.configure_script.rendered}"
  }
}

resource "null_resource" "dependency_setter" {
  depends_on = ["null_resource.configure"]
}
