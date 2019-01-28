data "template_file" "e2e_node_script" {
  template = "${file("${path.module}/e2e_node.sh")}"
}

resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

resource "null_resource" "e2e_node" {
  depends_on = ["null_resource.dependency_getter"]

  connection {
    host     = "${var.host}"
    password = "${var.password}"
  }

  provisioner "remote-exec" {
    inline = "${data.template_file.e2e_node_script.rendered}"
  }
}

resource "null_resource" "dependency_setter" {
  depends_on = ["null_resource.e2e_node"]
}
