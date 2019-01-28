data "template_file" "critest_script" {
  template = "${file("${path.module}/critest.sh")}"
}

resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

resource "null_resource" "critest" {
  depends_on = ["null_resource.dependency_getter"]

  connection {
    host     = "${var.host}"
    password = "${var.password}"
  }

  provisioner "remote-exec" {
    inline = "${data.template_file.critest_script.rendered}"
  }
}

resource "null_resource" "dependency_setter" {
  depends_on = ["null_resource.critest"]
}
