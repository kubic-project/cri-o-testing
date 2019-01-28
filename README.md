# cri-o testing

This project aims to run all available
[cri-o](https://github.com/kubernetes-sigs/cri-o) test scenarios under openSUSE
Kubic.

## Dependencies

The following dependencies needs to be fulfilled to run this project:

- [terraform](https://github.com/hashicorp/terraform)
- [terraform-provider-libvirt](https://github.com/dmacvicar/terraform-provider-libvirt)

## Running the tests

Multiple targets are available for running the test scenarios:

- `make unit`: Run the unit tests.
- `make critest`: Run the critest integration tests.
- `make integration`: Run the cri-o integration tests with and without
  user-namespace support.
- `make e2e-node`: Run the Kubernetes node end-to-end tests.
- `make e2e`: Run the Kubeneretes end-to-end tests.

Every test does a complete local setup of a Kubic virtual machine and destroys
it afterwards. For hacking proposes the make target `make setup` can be used to
provision a base machine.
