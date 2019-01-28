data "template_file" "integration_script" {
  template = "${file("${path.module}/integration.sh")}"
}

resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

resource "null_resource" "integration" {
  depends_on = ["null_resource.dependency_getter"]

  connection {
    host     = "${var.host}"
    password = "${var.password}"
  }

  provisioner "remote-exec" {
    inline = "${data.template_file.integration_script.rendered}"
  }
}

resource "null_resource" "dependency_setter" {
  depends_on = ["null_resource.integration"]
}
