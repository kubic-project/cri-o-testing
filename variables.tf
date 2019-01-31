variable "password" {
  type        = "string"
  default     = "linux"
  description = "The root password of the machine"
}

variable "memory" {
  type        = "string"
  default     = "4096"
  description = "The amount of RAM to be used"
}

variable "cpu" {
  type        = "string"
  default     = "4"
  description = "The amount of CPUs to be used"
}

variable "pr" {
  type        = "string"
  default     = ""
  description = "The cri-o pull request number to test"
}
