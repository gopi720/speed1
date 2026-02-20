variable "vpccidr" {
    type = string
    default = "10.5.0.0/16"
  
}

variable "sunetcidr" {
    type = string
    default = "10.5.1.0/24"
}

variable "keypair" {
    type = string
    default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIaroIA9gSqu74pw1N7+aj2L5MxMSkG38nmqiTSciEfo ubuntu@DESKTOP-7O5R49E"
  
}
variable "instancetype" {
    type = string
    default = "t3.micro"
  
}