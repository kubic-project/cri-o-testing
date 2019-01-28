variable "dependencies" {
  type        = "list"
  description = "The list of dependencies needed for this module"
}

variable "host" {
  type        = "string"
  description = "The host IP of the machine"
}

variable "password" {
  type        = "string"
  description = "The root password of the machine"
}

variable "pr" {
  type        = "string"
  description = "The cri-o pull request number to test"
}
