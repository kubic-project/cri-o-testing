variable "password" {
  type        = "string"
  default     = "linux"
  description = "The root password of the machine"
}

variable "memory" {
  type        = "string"
  default     = "2048"
  description = "The amount of RAM used"
}

variable "pr" {
  type        = "string"
  default     = ""
  description = "The cri-o pull request number to test"
}
